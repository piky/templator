package org.example.monitoring.camel;

import org.apache.camel.builder.RouteBuilder;
import org.springframework.stereotype.Component;

@Component
public class ZabbixTemplateBuilder extends RouteBuilder {
 
  @Override
  public void configure() throws Exception {
    from("file:src/data/zabbix?noop=true").to("xslt:templates/zbx_template_add_names.xsl?saxon=true")
    .to("file:src/data/result_step1")
    .to("validator:templates/zbx_template_new.xsd")
    .to("log:result?level=DEBUG")
    .to("xslt:templates/to_zabbix_export.xsl?saxon=true")
    .to("file:src/data/result")
    .to("validator:templates/zabbix_template.xsd");
    
  }
  
  /*        <route id="_route1">
            <from id="_from1" uri="file:src/data/zabbix?noop=true"/>
            <to id="to_xslt" uri="xslt:templates/zbx_template_add_names.xsl?saxon=true"/>
            <to id="_to11" uri="file:src/data/result_step1"/>
            <to id="_to2" uri="validator:templates/zbx_template_new.xsd"/>
            <to id="_to3" uri="log:result"/>
            <to id="to_xslt" uri="xslt:templates/to_zabbix_export.xsl?saxon=true"/>
            <to id="_to4" uri="log:result"/>
            <to id="_to1" uri="file:src/data/result"/>
            <to id="_to2" uri="validator:templates/zabbix_template.xsd"/>*/
 
}