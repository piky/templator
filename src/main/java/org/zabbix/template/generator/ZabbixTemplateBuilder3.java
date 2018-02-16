package org.zabbix.template.generator;


import java.util.Arrays;

import org.apache.camel.Exchange;
import org.apache.camel.LoggingLevel;
import org.apache.camel.Processor;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.model.dataformat.JsonLibrary;
import org.kie.api.KieServices;
import org.kie.api.event.rule.AgendaEventListener;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.StatelessKieSession;
import org.springframework.stereotype.Component;
import org.zabbix.template.generator.objects.DiscoveryRule;
import org.zabbix.template.generator.objects.Metric;
import org.zabbix.template.generator.objects.Template;

@Component
public class ZabbixTemplateBuilder3 extends RouteBuilder {


	@Override
	public void configure() throws Exception {
		errorHandler(deadLetterChannel("direct:errors"));
		
		//Catch wrong metric prototypes spelling
		//TODO improve error handling
		onException(org.zabbix.template.generator.objects.MetricNotFoundException.class)
		.log(LoggingLevel.ERROR,"${file:name}: Please check metric prototype: ${exception.message}");
		//other errors
		from("direct:errors")
		.log(LoggingLevel.WARN,"General error:  ${file:name}: ${exception.message} ${exception.stacktrace}");


		from("file://src/main/resources/json_test_template?noop=true&delay=30000&idempotentKey=${file:name}-${file:modified}")
		.log("Loading file: ${in.headers.CamelFileNameOnly}")
		.unmarshal().json(JsonLibrary.Jackson,Template.class)
		.process(new Processor() {
			
			@Override
			public void process(Exchange exchange) throws Exception {
				//kie
		        KieServices ks = KieServices.Factory.get();
		        KieContainer kContainer = ks.getKieClasspathContainer();
				StatelessKieSession ksession = kContainer.newStatelessKieSession();
				
				AgendaEventListener agendaEventListener = new TrackingAgendaEventListener();
				ksession.addEventListener(agendaEventListener);
				
				
				
				Metric[] metrics = ((Template) exchange.getIn().getBody()).getMetrics();
				if (metrics != null) {
					ksession.execute(Arrays.asList(metrics));
				}
				
				DiscoveryRule[] drules = ((Template) exchange.getIn().getBody()).getDiscoveryRules();
				for (DiscoveryRule drule: drules) {
					ksession.setGlobal("discoveryRule", drule.getName());
					ksession.execute(Arrays.asList(drule.getMetrics()));
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
			//.log("${body}")
			.to("file:src/main/resources/ftl/out");;


	}
}
