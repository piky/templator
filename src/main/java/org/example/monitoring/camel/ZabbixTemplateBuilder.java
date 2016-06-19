package org.example.monitoring.camel;

import org.apache.camel.builder.RouteBuilder;
import org.springframework.stereotype.Component;

@Component
public class ZabbixTemplateBuilder extends RouteBuilder {
 
  @Override
  public void configure() throws Exception {
    from("file:src/data/in?noop=true&delay=30000")
    .log("Loading file: ${in.headers.CamelFileNameOnly}")
    .setHeader("template_suffix", simple("SNMPv1", String.class))
	.to("xslt:templates/to_metrics_add_name_placeholder.xsl?saxon=true") //will add _SNMP_PLACEHOLDER
    .to("xslt:templates/to_metrics.xsl?saxon=true")
    .to("file:src/data/result_step1")
    .to("validator:templates/metrics.xsd")
    .to("log:result?level=DEBUG").multicast().parallelProcessing().to("direct:snmpv1", "direct:snmpv2");

    
    //zabbix types: 4- snmpv2, 1-snmpv2 <xsl:variable name="snmp_item_type">4</xsl:variable>
    from("direct:snmpv1")
    	.setHeader("snmp_item_type", simple("1", String.class))
    	.to("xslt:templates/to_zabbix_export.xsl?saxon=true")
    	.setBody(body().regexReplaceAll("_SNMP_PLACEHOLDER", " SNMPv1"))
	    .setHeader("CamelOverruleFileName",simple("${in.headers.CamelFileName}_SNMP_v1.xml"))
	    .to("file:src/data/out")
	    .to("validator:templates/zabbix_export.xsd");
    
    
    from("direct:snmpv2")
	    .setHeader("snmp_item_type", simple("4", String.class))
		.to("xslt:templates/to_zabbix_export.xsl?saxon=true")
		.setBody(body().regexReplaceAll("_SNMP_PLACEHOLDER", " SNMPv2"))
	    .setHeader("CamelOverruleFileName",simple("${in.headers.CamelFileName}_SNMP_v2.xml"))
		.to("file:src/data/out")
	    .to("validator:templates/zabbix_export.xsd");
  } 
}