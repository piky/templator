package org.zabbix.template.generator;


import java.text.Format;
import java.util.ArrayList;

import org.apache.camel.Exchange;
import org.apache.camel.LoggingLevel;
import org.apache.camel.Processor;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.jackson.JacksonDataFormat;

import org.apache.camel.model.dataformat.JsonLibrary;
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
		//TODO improve error handling
		onException(org.zabbix.template.generator.objects.MetricNotFoundException.class)
		.log(LoggingLevel.ERROR,"${file:name}: Please check metric prototype: ${exception.message}");
		//other errors
		from("direct:errors")
		.log(LoggingLevel.WARN,"General error:  ${file:name}: ${exception.message} ${exception.stacktrace}");


		from("file:bin/in/json?noop=true&delay=300&idempotentKey=${file:name}-${file:modified}")
		.log("Loading file: ${in.headers.CamelFileNameOnly}")
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
					agenda.getAgendaGroup( "populate" ).setFocus();

					//put all metrics into registry. TODO, REFACTOR
					t.constructMetricsRegistry();
					ksession.fireAllRules();
					ksession.dispose();					

				}




			}
		})
		.to("direct:zabbix");

		//.marshal().json(JsonLibrary.Jackson,true)
		//.marshal().jacksonxml(true)
		//.log("${body}")
		//.to("file:src/main/resources/json_test_template/out");

		//TODO 
		//Here should be validation: check that if type snmp than snmpobject defined, for example
		//Naming restrictions can also be checked for custom metrics

		//final part convert to zabbix XML		
		from("direct:zabbix")
		.to("freemarker:ftl/to_zabbix_template.ftl?contentCache=false")
		.to("xslt:templates/indent.xsl?saxon=true")
		
		.to("file:src/main/resources/ftl/out");;


	}
}
