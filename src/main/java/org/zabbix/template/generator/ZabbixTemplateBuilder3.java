package org.zabbix.template.generator;



import java.util.ArrayList;

import org.apache.camel.Exchange;
import org.apache.camel.LoggingLevel;
import org.apache.camel.Processor;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.jackson.JacksonDataFormat;


import org.kie.api.KieServices;
import org.kie.api.event.rule.AgendaEventListener;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;
import org.kie.api.runtime.rule.Agenda;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;
import org.zabbix.template.generator.objects.DiscoveryRule;
import org.zabbix.template.generator.objects.InputJSON;
import org.zabbix.template.generator.objects.Metric;
import org.zabbix.template.generator.objects.Template;
import org.zabbix.template.generator.objects.ValueMap;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;



@Component
public class ZabbixTemplateBuilder3 extends RouteBuilder {

	private static final Logger logger = LoggerFactory.getLogger(Main.class);

	 
	

	@Override
	public void configure() throws Exception {
		errorHandler(deadLetterChannel("direct:errors"));
		
		//generate jackson mapper
		ObjectMapper mapper = new ObjectMapper(new YAMLFactory());
		JacksonDataFormat yamlJackson = new JacksonDataFormat(mapper,InputJSON.class);
		//Catch wrong metric prototypes spelling
		onException(org.zabbix.template.generator.objects.MetricPrototypeNotFoundException.class)
		.log(LoggingLevel.ERROR,"${file:name}: Please check metric prototype: ${exception.message}");
		
		//other errors
		from("direct:errors")
		.log(LoggingLevel.WARN,"General error:  ${file:name}: ${exception.message} ${exception.stacktrace}");


		from("file:bin/in/json?noop=true&delay=10&idempotentKey=${file:name}-${file:modified}")
		.setHeader("template_ver", simple("{{version}}",String.class))
		.setHeader("lang", simple("EN",String.class))
				
		
		.log("======================================Loading file: ${in.headers.CamelFileNameOnly}======================================")
		.unmarshal(yamlJackson)
/*		.marshal().json(JsonLibrary.Jackson,true)
		.log("${body}");
		
		from("direct:stub")*/
		
		//.unmarshal().json(JsonLibrary.Jackson,InputJSON.class)
		.process(new Processor() {

			@Override
			public void process(Exchange exchange) throws Exception {
				//kie
				KieServices ks = KieServices.Factory.get();
				KieContainer kContainer = ks.getKieClasspathContainer();
				KieSession ksession = kContainer.newKieSession();
				ksession.setGlobal("logger", logger);

				AgendaEventListener agendaEventListener = new TrackingAgendaEventListener();
				ksession.addEventListener(agendaEventListener);


				ArrayList<ValueMap> valueMaps = ((InputJSON) exchange.getIn().getBody()).getValueMaps();
				
				ksession.insert((InputJSON) exchange.getIn().getBody());
				//insert valueMaps into Drools
				
				//valueMaps.forEach((vm)->ksession.insert(vm));

				ArrayList<Template> templates = ((InputJSON) exchange.getIn().getBody()).getTemplates();
				for (Template t: templates) {
					Metric[] metrics = t.getMetrics();
					ksession.insert(t);
					if (metrics != null) {
						for (Metric m: metrics) {
							ksession.insert(m);
						}
					}

					DiscoveryRule[] drules = t.getDiscoveryRules();
					for (DiscoveryRule drule: drules) {
						for (Metric m: drule.getMetrics()) {
							
							m.setDiscoveryRule(drule.getName());
							ksession.insert(m);

						}
					}
					Agenda agenda = ksession.getAgenda();
					//last agendaGroup will evaluate first...
					agenda.getAgendaGroup( "validate" ).setFocus();
					//should go after trigger names, expressions, recovery are ready
					agenda.getAgendaGroup( "populate.trigger.dependencies" ).setFocus();
					agenda.getAgendaGroup( "populate" ).setFocus();
					

					//put all metrics into registry. TODO, REFACTOR
					t.constructMetricsRegistry();
					ksession.fireAllRules();
					ksession.dispose();

				}




			}
		})
		.to("direct:multicaster");

		from("direct:multicaster")
		.to("log:result?level=DEBUG").multicast().parallelProcessing().
		to(
				"direct:snmpv1",
				"direct:snmpv2"
				//"direct:icmp",
				//"direct:remote_service"
				);
	    from("direct:snmpv1")
	    	 //.filter().xpath("//z:classes[z:class='SNMPv1']",ns)
				.setHeader("snmp_item_type", simple("1", String.class))
				.setHeader("template_suffix", simple("SNMPv1", String.class))
			 	.log("Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ${in.headers.template_suffix}")
	    	 	.to("direct:zabbix_export");


	    from("direct:snmpv2")
			//.filter().xpath("//z:classes[z:class='SNMPv2']",ns)
			.setHeader("snmp_item_type", simple("4", String.class))
		    .setHeader("template_suffix", simple("SNMPv2", String.class))
			.log("Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ${in.headers.template_suffix}")
			.to("direct:zabbix_export");		
		
		//.marshal().json(JsonLibrary.Jackson,true)
		//.marshal().jacksonxml(true)
		//.log("${body}")
		//.to("file:src/main/resources/json_test_template/out");

		//TODO 
		//Here should be validation: check that if type snmp than snmpobject defined, for example
		//Naming restrictions can also be checked for custom metrics

		//final part convert to zabbix XML		
		from("direct:zabbix_export")
		.to("freemarker:ftl/to_zabbix_template.ftl?contentCache=false")
		.to("xslt:templates/indent.xsl?saxon=true") //proper indentation for XML file
		.setBody(body().regexReplaceAll("SNMPvX", simple("${in.headers.template_suffix}"))) //replace SNMPvX with SNMPv2 or SNMPv1 lang
		
		.setHeader("CamelOverruleFileName",
                simple("${in.headers.subfolder}/${in.headers.CamelFileName.replace('.yaml','')}_${in.headers.template_suffix}_${in.headers.lang}.xml"))
		
		.to("file:src/main/resources/ftl/out");


	}
}
