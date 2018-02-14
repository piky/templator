package org.zabbix.template.generator;


import org.apache.camel.Exchange;
import org.apache.camel.LoggingLevel;
import org.apache.camel.Processor;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.model.dataformat.JsonLibrary;
import org.springframework.stereotype.Component;
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
		.marshal().json(JsonLibrary.Jackson,true)
		//.log("${body}")
		.to("file:src/main/resources/json_test_template/out");
		


		//TODO 
		//Here should be validation: check that if type snmp than snmpobject defined, for example
		//Naming restrictions can also be checked for custom metrics

	}
}
