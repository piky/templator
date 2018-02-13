package org.zabbix.template.generator;


import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.model.dataformat.JsonLibrary;
import org.springframework.stereotype.Component;
import org.zabbix.template.generator.objects.Template;

@Component
public class ZabbixTemplateBuilder3 extends RouteBuilder {


	@Override
	public void configure() throws Exception {


		from("file://src/main/resources/json_test_template?noop=true&delay=30000&idempotentKey=${file:name}-${file:modified}")
		.log("Loading file: ${in.headers.CamelFileNameOnly}")
		.unmarshal().json(JsonLibrary.Jackson,Template.class)
		/*		.process(new Processor() {

			@Override
			public void process(Exchange exchange) throws Exception {
				JsonNode json= (JsonNode) exchange.getIn().getBody();
				ObjectMapper mapper = new ObjectMapper();
				Template  t = (Template) mapper.convertValue( exchange.getIn().getBody(), Template.class );
				exchange.getIn().setBody(t);
			}
		})*/
		.marshal().json(JsonLibrary.Jackson,true)
		.log("${body}");


		//TODO 
		//Here should be validation: check that if type snmp than snmpobject defined, for example
		//Naming restrictions can also be checked for custom metrics

	}
}
