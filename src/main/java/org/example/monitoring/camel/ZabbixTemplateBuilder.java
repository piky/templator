package org.example.monitoring.camel;

import org.apache.camel.builder.RouteBuilder;
import org.springframework.stereotype.Component;

@Component
public class ZabbixTemplateBuilder extends RouteBuilder {
 
  @Override
  public void configure() throws Exception {
    from("file:src/data/in?noop=true")
    .log("Loading file: ${in.headers.CamelFileNameOnly}")
    .to("xslt:templates/to_metrics.xsl?saxon=true")
    .to("file:src/data/result_step1")
    .to("validator:templates/metrics.xsd")
    .to("log:result?level=DEBUG")
    .to("xslt:templates/to_zabbix_export.xsl?saxon=true")
    .to("file:src/data/out")
    .to("validator:templates/zabbix_export.xsd");
  } 
}