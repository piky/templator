package org.zabbix.template.generator;


import org.apache.camel.Exchange;
import org.apache.camel.Processor;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.model.dataformat.JsonLibrary;
import org.kie.api.event.rule.AgendaEventListener;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.StatelessKieSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.zabbix.template.generator.objects.Metric;

import com.company.license.Applicant;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

@Component
public class ZabbixTemplateBuilder2 extends RouteBuilder {

     
  @Autowired
  private KieContainer kContainer;	
  @Override
  public void configure() throws Exception {
	  
	

	from("file://src/main/resources/json_test?noop=true&delay=30000&idempotentKey=${file:name}-${file:modified}")
	    .log("Loading file: ${in.headers.CamelFileNameOnly}")
	    .unmarshal().json(JsonLibrary.Jackson,JsonNode.class)
	    .process(new Processor() {
			
			@Override
			public void process(Exchange exchange) throws Exception {
				ObjectMapper mapper = new ObjectMapper();

				//get prototype name from json 
				String protoName = ((JsonNode) exchange.getIn().getBody()).get("prototype").textValue();
				//get class
				Class<?> c = ClassChooser.getMetricClass(protoName);
				//convert from jsonnode to class c
				Metric out = (Metric) mapper.convertValue( exchange.getIn().getBody(), c );
				exchange.getIn().setBody(out);
				
			}
		})
	    //TODO drools. move it
	    .process(new Processor() {
			 
			@Override
			public void process(Exchange exchange) throws Exception {
		        /*KieServices ks = KieServices.Factory.get();
		        KieContainer kContainer = ks.getKieClasspathContainer();*/
				StatelessKieSession ksession = kContainer.newStatelessKieSession();
				
				AgendaEventListener agendaEventListener = new TrackingAgendaEventListener();
				ksession.addEventListener(agendaEventListener);
				/*ksession.addEventListener( new DebugAgendaEventListener() );
		        ksession.addEventListener( new DebugRuleRuntimeEventListener() );*/
				Applicant applicant = new Applicant( "Mr John Smith", 16 );
				System.out.println(applicant.isValid());
//				System.out.println("Rule found:" + ksession.getKieBase().getRule("drl","Is of valid age"));
				ksession.execute( applicant );
				//ksession.execute( Arrays.asList(new Object[] {applicant}));
				System.out.println(applicant.isValid());
			}

	    
	    })

	    .marshal().json(JsonLibrary.Jackson,true)
	    .log("${body}");
	
	
	//TODO 
	//Here should be validation: check that if type snmp than snmpobject defined, for example
	//Naming restrictions can also be checked for custom metrics

  }
}
