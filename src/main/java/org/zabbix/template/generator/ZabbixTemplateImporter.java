package org.zabbix.template.generator;

import org.apache.camel.builder.RouteBuilder;

import org.springframework.stereotype.Component;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.zabbix.api.ZabbixService;

@ConditionalOnProperty(value = "zabbix.enabled")
@Component
public class ZabbixTemplateImporter extends RouteBuilder {

	@Autowired(required = true)
	private ZabbixService zabbixService;

	@Override
	public void configure() throws Exception {

		/* ASYNC LOAD TEMPLATES TO ZABBIX(experimental feature) */
		from("file:{{dir.out}}?noop=true&include={{filter}}&readLock=markerFile&recursive=true&initialDelay={{zabbix.delay}}&delay=1000&idempotentKey=${file:name}-${file:modified}&backoffErrorThreshold=1&backoffMultiplier=60")
				.routeId("Import XML")
				.filter().simple("${file:name.ext} == 'xml'").filter()
				.simple("${file:parent} contains '{{zabbix.template_language}}'").filter()
				.simple("${file:parent} contains '{{zabbix.version}}'")
				.log("Loading template into Zabbix: ${in.headers.CamelFileNameOnly}")
				.bean(zabbixService, "importTemplate")
				.to("direct:export_template_to_yaml");

		from("direct:export_template_to_yaml")
				.routeId("Export YAML")
				.setHeader("yamlFilePath", simple("${headers.CamelFileName.replaceFirst('\\.xml','.yaml')}"))
				.setHeader("zbx_ver",simple("{{zabbix.version}}"))
				.choice()
					.when(header("zbx_ver").isEqualTo("5.4"))
						.log("Unloading template from Zabbix to file: ${headers.yamlFilePath}")
						.bean(zabbixService, "exportTemplate")
						.to("file:{{dir.out}}?fileName=${headers.yamlFilePath}")
				.end();
	}
}
