package org.zabbix.template.generator;

import java.io.File;
import java.util.LinkedHashMap;

import org.apache.camel.Exchange;
import org.apache.camel.Processor;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.model.dataformat.JsonLibrary;
import org.springframework.stereotype.Component;
import org.zabbix.template.generator.objects.CPUTemperatureMetric;
import org.zabbix.template.generator.objects.Metric;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.jayway.jsonpath.JsonPath;

@Component
public class ZabbixTemplateBuilder2 extends RouteBuilder {

    
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

	    .marshal().json(JsonLibrary.Jackson,true)
	    .log("${body}");

  }
}
