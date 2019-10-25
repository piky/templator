package org.zabbix.template.generator;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;

import org.apache.camel.LoggingLevel;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.jackson.JacksonDataFormat;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.Marker;
import org.apache.logging.log4j.MarkerManager;
import org.springframework.stereotype.Component;
import org.zabbix.template.generator.kie.RuleChecker;
import org.zabbix.template.generator.objects.*;

@Component
public class ZabbixTemplateBuilder extends RouteBuilder {

	private static final Logger logger = LogManager.getLogger(ZabbixTemplateBuilder.class.getName());
	private static final Marker TEMPLATE_GEN = MarkerManager.getMarker("TEMPLATE_GEN");

	@Override
	public void configure() throws Exception {
		// errorHandler(deadLetterChannel("direct:errors"));

		// generate jackson mapper

		// create factory to enable comments for json
		JsonFactory f = new JsonFactory();
		f.enable(JsonParser.Feature.ALLOW_COMMENTS);
		f.enable(JsonParser.Feature.ALLOW_TRAILING_COMMA);

		ObjectMapper yamlMapper = new ObjectMapper(new YAMLFactory());
		ObjectMapper jsonMapper = new ObjectMapper(f);
		JacksonDataFormat yamlJackson = new JacksonDataFormat(yamlMapper, InputJSON.class);
		JacksonDataFormat jsonJackson = new JacksonDataFormat(jsonMapper, InputJSON.class);

		// processor to run all drools checks
		RuleChecker ruleChecker = new RuleChecker();

		// Catch wrong metric prototypes spelling
		onException(org.zabbix.template.generator.objects.MetricPrototypeNotFoundException.class)
				.log(LoggingLevel.ERROR, "${file:name}: Please check metric prototype: ${exception.message}").handled(true);

		onException(Exception.class)
				.log(LoggingLevel.ERROR, "${file:name}: ${exception.message} ${exception.stacktrace}").handled(true);

		// other errors
		/*
		 * from("direct:errors") .log(LoggingLevel.
		 * WARN,"General error:  ${file:name}: ${exception.message} ${exception.stacktrace}"
		 * );
		 */

		/* STEP 1: LOAD INPUT FILE */
		from("file:{{dir.in}}?noop=true&include={{filter}}&readLock=none&recursive=true&delay=1000&idempotentKey=${file:name}-${file:modified}&backoffErrorThreshold=1&backoffMultiplier=60")
				.setHeader("template_ver", simple("{{version}}", String.class))

				.log("======================================Loading file: ${in.headers.CamelFileNameOnly}======================================")
				.to("direct:lang");

		/* STEP 2: MULTICAST TO ENGLISH and RUSSIAN */
		from("direct:lang").multicast().parallelProcessing()
				.to(
					"direct:EN"
				   //,"direct:RU"
				);

		from("direct:RU").setHeader("lang", simple("RU", String.class))
			// .stop(); // RU is stopped as objects are not deep-cloned
			.to("direct:create_template");

		from("direct:EN").setHeader("lang", simple("EN", String.class))
			.to("direct:create_template");

		/*
		 * STEP 3: CREATE INPUTJSON object from yaml or json merging between prototype
		 * and input is happening here
		 */
		from("direct:create_template")
				// JSON - YAML Chooser
				.choice().when(simple("${file:ext} == 'yaml'"))
					// .log("Try YAML....")
					.unmarshal(yamlJackson).to("direct:drools")
				.when(simple("${file:ext} == 'json'"))
					// .log("Try JSON....")
					.unmarshal(jsonJackson).to("direct:drools");

		/*
		 * STEP 4: evaluate drools rules. note that drools rules come in different
		 * agenda groups. See RuleChecker
		 */
		from("direct:drools").process(ruleChecker).choice().when(body().method("isFailed"))
				.log(LoggingLevel.ERROR, "STOPPING").stop().otherwise().to("direct:multicaster_version");

		/* STEP 5: multicast to different zabbix versions (3.2, 3.4, 4.0, 4.2, 4.4) */
		from("direct:multicaster_version").multicast()
		// .onPrepare(new Processor() {

		// 	@Override
		// 	public void process(Exchange exchange) throws Exception {
		// 		InputJSON ij = ((InputJSON) exchange.getIn().getBody());
		// 		ObjectMapper objectMapper = new ObjectMapper();
		// 		log.warn(objectMapper.writeValueAsString(ij));
		// 		InputJSON ijDeepClone = objectMapper.readValue(objectMapper.writeValueAsString(ij), InputJSON.class);
		// 		exchange.getIn().setBody(ijDeepClone);
		// 		log.error(objectMapper.writeValueAsString(ijDeepClone));

		// 	}
		// })
		.to("direct:zbx3.2", "direct:zbx3.4", "direct:zbx4.0", "direct:zbx4.2", "direct:zbx4.4");

		from("direct:zbx3.2")
				.filter(exchange -> ((InputJSON) exchange.getIn().getBody()).getTemplates().stream()
						.anyMatch((t) -> (t.getZbxVer().compareTo(new Version("3.2")) <= 0)))
				.setHeader("zbx_ver", simple("3.2", String.class)).to("direct:multicaster_snmp");

		from("direct:zbx3.4")
				.filter(exchange -> ((InputJSON) exchange.getIn().getBody()).getTemplates().stream()
						.anyMatch((t) -> (t.getZbxVer().compareTo(new Version("3.4")) <= 0)))
				.setHeader("zbx_ver", simple("3.4", String.class)).to("direct:multicaster_snmp");

		from("direct:zbx4.0")
				.filter(exchange -> ((InputJSON) exchange.getIn().getBody()).getTemplates().stream()
						.anyMatch((t) -> (t.getZbxVer().compareTo(new Version("4.0")) <= 0)))
				.setHeader("zbx_ver", simple("4.0", String.class)).to("direct:multicaster_snmp");

		from("direct:zbx4.2")
				.filter(exchange -> ((InputJSON) exchange.getIn().getBody()).getTemplates().stream()
						.anyMatch((t) -> (t.getZbxVer().compareTo(new Version("4.2")) <= 0)))
				.setHeader("zbx_ver", simple("4.2", String.class)).to("direct:multicaster_snmp");

		from("direct:zbx4.4")
				.filter(exchange -> ((InputJSON) exchange.getIn().getBody()).getTemplates().stream()
						.anyMatch((t) -> (t.getZbxVer().compareTo(new Version("4.4")) <= 0)))
				.setHeader("zbx_ver", simple("4.4", String.class)).to("direct:multicaster_snmp");
		/* STEP 6: multicast to different SNMP versions (and ICMP) */
		from("direct:multicaster_snmp").to("log:result?level=DEBUG").multicast().parallelProcessing()
				.to("direct:snmpv1", "direct:snmpv2", "direct:other", "direct:zabbix_active"
				// "direct:remote_service"
				);
		from("direct:snmpv1")
				.filter(exchange -> ((InputJSON) exchange.getIn().getBody()).getUniqueTemplateClasses()
						.contains(TemplateClass.SNMPV1))
				.choice()
					.when(header("zbx_ver").isEqualTo("4.4"))	
						.setHeader("default_item_type", simple("SNMPV1", String.class))
					.otherwise()
						.setHeader("default_item_type", simple("1", String.class))
				.end()
				.setHeader("template_suffix", simple("SNMPv1", String.class))
				.setHeader("template_type", simple("SNMP", String.class))
				.log(LoggingLevel.DEBUG,
						"Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ${in.headers.template_suffix}")
				.to("direct:multicaster_export");

		from("direct:snmpv2")
				.filter(exchange -> ((InputJSON) exchange.getIn().getBody()).getUniqueTemplateClasses()
						.contains(TemplateClass.SNMPV2))
				.choice()
						.when(header("zbx_ver").isEqualTo("4.4"))	
								.setHeader("default_item_type", simple("SNMPV2", String.class))
						.otherwise()
								.setHeader("default_item_type", simple("4", String.class))
				.end()
				.setHeader("template_suffix", simple("SNMPv2", String.class))
				.setHeader("template_type", simple("SNMP", String.class))
				.log(LoggingLevel.DEBUG,
						"Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ${in.headers.template_suffix}")
				.to("direct:multicaster_export");

		from("direct:other").filter(exchange -> ( // only non SNMP templates here
		(InputJSON) exchange.getIn().getBody()).getUniqueTemplateClasses().stream()
				.anyMatch((a) -> a.equals(TemplateClass.SNMPV1) || a.equals(TemplateClass.SNMPV2)
						|| a.equals(TemplateClass.SNMPV3)) == false)
				.choice()
					.when(header("zbx_ver").isEqualTo("4.4"))	
							.setHeader("default_item_type", simple("ZABBIX_PASSIVE", String.class))
					.otherwise()
							.setHeader("default_item_type", simple("0", String.class))
				.end()
				.setHeader("template_suffix", simple("", String.class))
				.setHeader("template_type", simple("OTHER", String.class))
				.log(LoggingLevel.DEBUG, "Going to do ${in.headers.lang} ${in.headers.zbx_ver} template")
				.to("direct:multicaster_export");

		from("direct:zabbix_active")
				.filter(exchange -> ((InputJSON) exchange.getIn().getBody()).getUniqueTemplateClasses()
						.contains(TemplateClass.ZABBIX_ACTIVE))
				.choice()
					.when(header("zbx_ver").isEqualTo("4.4"))	
						.setHeader("default_item_type", simple("ZABBIX_ACTIVE", String.class))
					.otherwise()
						.setHeader("default_item_type", simple("7", String.class))
				.end()
				.setHeader("template_suffix", simple("active", String.class))
				.setHeader("template_type", simple("ZABBIX_ACTIVE", String.class))
				.log(LoggingLevel.DEBUG,
						"Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ${in.headers.template_suffix}")
				.to("direct:multicaster_export");

		from("direct:multicaster_export").to("log:result?level=DEBUG").multicast().parallelProcessing()
				.to("direct:zabbix_export", "direct:generate_docs"
				// "direct:remote_service"
				);
		// .marshal().json(JsonLibrary.Jackson,true)
		// .marshal().jacksonxml(true)
		// .log("${body}")
		// .to("file:src/main/resources/json_test_template/out");

		// TODO
		// Here should be validation: check that if type snmp than snmpobject defined,
		// for example
		// Naming restrictions can also be checked for custom metrics
		/* STEP 7(FINAL): export to XML, using freemarker */
		from("direct:zabbix_export")
				.choice()
					.when(header("zbx_ver").isEqualTo("4.4"))	
						.to("freemarker:ftl/to_zabbix_template_4.4.ftl?contentCache=false")
					.otherwise()
						.to("freemarker:ftl/to_zabbix_template.ftl?contentCache=false")
				.end()
				.to("xslt:templates/indent.xsl?saxon=true") // TODO proper indentation for XML file
				.to("xslt:templates/to_metrics_strip_whitespace.xsl?saxon=true")// trim whitespace on some multiline
																				// nodes //REFACTOR with DEV-827 below
				// https://support.zabbix.com/browse/DEV-827
				.to("xslt:templates/to_zabbix_add_carriage_return.xsl?saxon=true")
				.transform(body().regexReplaceAll("&#xD;", simple("&#13;")))

				.transform(body().regexReplaceAll("SNMPvX", simple("${in.headers.template_suffix}"))) // replace SNMPvX
																										// with SNMPv2
																										// or
																										// SNMPv1 lang
				.choice().when(header("template_type").isEqualTo("ZABBIX_ACTIVE"))
				.transform(body().regexReplaceAll("by Zabbix agent",
						simple("by Zabbix agent ${in.headers.template_suffix}")))
				.transform(body().regexReplaceAll("Template Module Zabbix agent",
						simple("Template Module Zabbix agent active")))
				.end()
				.setHeader("subfolder", simple("${in.headers.CamelFileNameOnly.split('_')[1]}", String.class))
				.choice()
				.when(header("template_suffix").isEqualTo(""))
					.setHeader("CamelOverruleFileName", simple(
						"${in.headers.zbx_ver}/${in.headers.lang}/${in.headers.subfolder}/${file:onlyname.noext}_${in.headers.lang}.xml"))
				.otherwise()
				.setHeader("CamelOverruleFileName", simple(
						"${in.headers.zbx_ver}/${in.headers.lang}/${in.headers.subfolder}/${file:onlyname.noext}_${in.headers.template_suffix}_${in.headers.lang}.xml"))
				.end()
				.to("file:{{dir.out}}");


		/* STEP 8(FINAL): generate README.md , using freemarker */
		from("direct:generate_docs").to("freemarker:ftl/to_readme.ftl?contentCache=false").choice()
				.when(header("template_type").isEqualTo("ZABBIX_ACTIVE"))
				.transform(body().regexReplaceAll("by Zabbix agent",
						simple("by Zabbix agent ${in.headers.template_suffix}")))
				.transform(
						body().regexReplaceAll("Template Module Zabbix agent", simple("Template Module Zabbix agent")))
				.transform(body().regexReplaceAll("ZABBIX_PASSIVE", simple("ZABBIX_ACTIVE"))).end()

				.transform(body().regexReplaceAll("SNMPvX", simple("${in.headers.template_suffix}"))) // replace SNMPvX
				.setHeader("subfolder", simple("${in.headers.CamelFileNameOnly.split('_')[1]}", String.class)).choice()
				.when(header("template_suffix").isEqualTo(""))
				.setHeader("CamelOverruleFileName", simple(
						"${in.headers.zbx_ver}/${in.headers.lang}/${in.headers.subfolder}/${file:onlyname.noext}_${in.headers.lang}.md"))
				.otherwise()
				.setHeader("CamelOverruleFileName", simple(
						"${in.headers.zbx_ver}/${in.headers.lang}/${in.headers.subfolder}/${file:onlyname.noext}_${in.headers.template_suffix}_${in.headers.lang}.md"))
				.end().to("file:{{dir.out}}");

	}
}
