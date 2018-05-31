package org.zabbix.template.generator;



import java.util.ArrayList;
import java.util.HashSet;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParser;
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
import org.zabbix.template.generator.objects.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;



@Component
public class ZabbixTemplateBuilder3 extends RouteBuilder {

	private static final Logger logger = LoggerFactory.getLogger(Main.class);

	 
	

	@Override
	public void configure() throws Exception {
		//errorHandler(deadLetterChannel("direct:errors"));



		//generate jackson mapper

		//create factorey to enable comments for json
		JsonFactory f = new JsonFactory();
		f.enable(JsonParser.Feature.ALLOW_COMMENTS);

		ObjectMapper yamlMapper = new ObjectMapper(new YAMLFactory());
		ObjectMapper jsonMapper = new ObjectMapper(f);
		JacksonDataFormat yamlJackson = new JacksonDataFormat(yamlMapper,InputJSON.class);
		JacksonDataFormat jsonJackson = new JacksonDataFormat(jsonMapper,InputJSON.class);
		//Catch wrong metric prototypes spelling
		onException(org.zabbix.template.generator.objects.MetricPrototypeNotFoundException.class)
			.log(LoggingLevel.ERROR,"${file:name}: Please check metric prototype: ${exception.message}");
		
		onException(Exception.class)
			.log(LoggingLevel.ERROR,"${file:name}: ${exception.message} ${exception.stacktrace}")
			.handled(true);
		
		//other errors
	/*	from("direct:errors")
			.log(LoggingLevel.WARN,"General error:  ${file:name}: ${exception.message} ${exception.stacktrace}");
*/

		from("file:bin/in/json?noop=true&delay=10&idempotentKey=${file:name}-${file:modified}")
		.setHeader("template_ver", simple("{{version}}",String.class))
		.setHeader("lang", simple("EN",String.class))
		.setHeader("zbx_ver", simple("3.4", Double.class))
				

		.log("======================================Loading file: ${in.headers.CamelFileNameOnly}======================================")
		
		//JSON - YAML Chooser //TODO add by extention .json / .yaml
		.choice()
			.when(simple("${file:ext} == 'yaml'"))
				//.log("Try YAML....")
				.unmarshal(yamlJackson)
				.to("direct:create_template")
			.when(simple("${file:ext} == 'json'"))
				//.log("Try JSON....")
				.unmarshal(jsonJackson)
				.to("direct:create_template")
        .end();

		from("direct:create_template")
		.process(new Processor() {

			@Override
			public void process(Exchange exchange) throws Exception {


				//AgendaEventListener agendaEventListener = new TrackingAgendaEventListener();
				//ksession.addEventListener(agendaEventListener);


				ArrayList<ValueMap> valueMaps = ((InputJSON) exchange.getIn().getBody()).getValueMaps();
				//kie
				KieServices ks = KieServices.Factory.get();
				KieContainer kContainer = ks.getKieClasspathContainer();
				KieSession ksession = kContainer.newKieSession();
				ksession.setGlobal("logger", logger);
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
					agenda.getAgendaGroup( "postvalidate" ).setFocus();
					
					agenda.getAgendaGroup( "populate.graph.keys" ).setFocus();
					
					//should go after trigger names, expressions, recovery are ready
					agenda.getAgendaGroup( "populate.trigger.dependencies" ).setFocus();
					agenda.getAgendaGroup( "populate" ).setFocus();
					agenda.getAgendaGroup( "prevalidate" ).setFocus();
					
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
				"direct:snmpv2",
				"direct:icmp"
				//"direct:remote_service"
				);
		from("direct:snmpv1")
			.filter(exchange -> ((InputJSON)exchange.getIn().getBody()).getUniqueTemplateClasses().contains(TemplateClass.SNMP_V1))
			.setHeader("snmp_item_type", simple("1", String.class))
			.setHeader("template_suffix", simple("SNMPv1", String.class))
			.log("Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ${in.headers.template_suffix}")
			.to("direct:zabbix_export");


	    from("direct:snmpv2")
			.filter(exchange -> ((InputJSON)exchange.getIn().getBody()).getUniqueTemplateClasses().contains(TemplateClass.SNMP_V2))
			.setHeader("snmp_item_type", simple("4", String.class))
		    .setHeader("template_suffix", simple("SNMPv2", String.class))
			.log("Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ${in.headers.template_suffix}")
			.to("direct:zabbix_export");

		from("direct:icmp")
			.filter(exchange -> ((InputJSON)exchange.getIn().getBody()).getUniqueTemplateClasses().contains(TemplateClass.ICMP))
			.setHeader("snmp_item_type", simple("1", String.class))
			.setHeader("template_suffix", simple("", String.class))
			.log("Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ICMP")
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
		.to("xslt:templates/to_metrics_strip_whitespace.xsl?saxon=true")// trim whitespace on some multiline nodes //REFACTOR with DEV-827 below
        //https://support.zabbix.com/browse/DEV-827
        .to("xslt:templates/to_zabbix_add_carriage_return.xsl?saxon=true")
        .setBody(body().regexReplaceAll("&#xD;", simple("&#13;")))

		.setBody(body().regexReplaceAll("SNMPvX", simple("${in.headers.template_suffix}"))) //replace SNMPvX with SNMPv2 or SNMPv1 lang

		.setHeader("subfolder",simple("${in.headers.CamelFileName.split('_')[1]}",String.class))
		.setHeader("CamelOverruleFileName",simple("${in.headers.subfolder}/${in.headers.zbx_ver}/${file:onlyname.noext}_${in.headers.template_suffix}_${in.headers.lang}.xml"))
		.to("file:bin/out");


	}
}
