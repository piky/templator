package org.zabbix.template.generator;



import java.util.ArrayList;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParser;
import org.apache.camel.Exchange;
import org.apache.camel.LoggingLevel;
import org.apache.camel.Processor;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.component.jackson.JacksonDataFormat;



import org.apache.logging.log4j.Marker;
import org.apache.logging.log4j.MarkerManager;
import org.kie.api.KieServices;
import org.kie.api.event.rule.AgendaEventListener;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;
import org.kie.api.runtime.rule.Agenda;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;
import org.springframework.stereotype.Component;
import org.zabbix.template.generator.objects.*;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;



@Component
public class ZabbixTemplateBuilder3 extends RouteBuilder {

	private static final Logger logger = LogManager.getLogger(PrototypesService.class.getName());
	private static final Marker TEMPLATE_GEN = MarkerManager.getMarker("TEMPLATE_GEN");



	@Override
	public void configure() throws Exception {
		//errorHandler(deadLetterChannel("direct:errors"));



		//generate jackson mapper

		//create factorey to enable comments for json
		JsonFactory f = new JsonFactory();
		f.enable(JsonParser.Feature.ALLOW_COMMENTS);

		ObjectMapper yamlMapper = new ObjectMapper(new YAMLFactory());
		ObjectMapper jsonMapper = new ObjectMapper(f);
		JacksonDataFormat yamlJackson = new JacksonDataFormat(yamlMapper,InputJSON.class);
		JacksonDataFormat jsonJackson = new JacksonDataFormat(jsonMapper,InputJSON.class);
		//Catch wrong metric prototypes spelling
		onException(org.zabbix.template.generator.objects.MetricPrototypeNotFoundException.class)
			.log(LoggingLevel.ERROR,"${file:name}: Please check metric prototype: ${exception.message}");
		
		onException(Exception.class)
			.log(LoggingLevel.ERROR,"${file:name}: ${exception.message} ${exception.stacktrace}")
			.handled(true);
		
		//other errors
	/*	from("direct:errors")
			.log(LoggingLevel.WARN,"General error:  ${file:name}: ${exception.message} ${exception.stacktrace}");
*/

		from("file:bin/in/json?noop=true&delay=10&idempotentKey=${file:name}-${file:modified}")
		.setHeader("template_ver", simple("{{version}}",String.class))

				

		.log("======================================Loading file: ${in.headers.CamelFileNameOnly}======================================")
		.to("direct:lang");


		from("direct:lang")
				.multicast()
				.to("direct:EN", "direct:RU");

		from("direct:RU")
				.setHeader("lang", simple("RU",String.class))
				.to("direct:create_template");

		from("direct:EN")
				.setHeader("lang", simple("EN",String.class))
				.to("direct:create_template");


		from("direct:create_template")
				//JSON - YAML Chooser
				.choice()
					.when(simple("${file:ext} == 'yaml'"))
						//.log("Try YAML....")
						.unmarshal(yamlJackson)
						.to("direct:drools")
					.when(simple("${file:ext} == 'json'"))
						//.log("Try JSON....")
						.unmarshal(jsonJackson)
						.to("direct:drools")
				.end();

		from("direct:drools")
			.process(new Processor() {

			@Override
			public void process(Exchange exchange) throws Exception {

                String lang = exchange.getIn().getHeader("lang").toString();
				//AgendaEventListener agendaEventListener = new TrackingAgendaEventListener();
				//ksession.addEventListener(agendaEventListener);


				ArrayList<ValueMap> valueMaps = ((InputJSON) exchange.getIn().getBody()).getValueMaps();
				//kie
				KieServices ks = KieServices.Factory.get();
				KieContainer kContainer = ks.getKieClasspathContainer();

				//insert valueMaps into Drools
				
				//valueMaps.forEach((vm)->ksession.insert(vm));

				ArrayList<Template> templates = ((InputJSON) exchange.getIn().getBody()).getTemplates();

				for (Template t: templates) {

				    Marker DROOLS_MARKER = MarkerManager.getMarker("DROOLS_"+t.getName()+"_"+lang).setParents(TEMPLATE_GEN);

                    KieSession ksession = kContainer.newKieSession();
                    ksession.setGlobal("logger", logger);
                    ksession.setGlobal("marker", DROOLS_MARKER);
					ksession.setGlobal("lang", lang);
                    ksession.insert((InputJSON) exchange.getIn().getBody());
                    ksession.insert(t);

					if (t.getMetrics() != null) {
						for (Metric m: t.getMetrics()) {
							ksession.insert(m);
							for (Trigger tr: m.getTriggers()) {
								ksession.insert(tr);
							}
						}
					}

					DiscoveryRule[] drules = t.getDiscoveryRules();
					for (DiscoveryRule drule: drules) {
						for (Metric m: drule.getMetrics()) {
							
							m.setDiscoveryRule(drule.getName());
							ksession.insert(m);
							for (Trigger tr: m.getTriggers()) {
								ksession.insert(tr);
							}

						}
					}
					Agenda agenda = ksession.getAgenda();
					//last agendaGroup will evaluate first...
					agenda.getAgendaGroup( "postvalidate" ).setFocus();
					
					agenda.getAgendaGroup( "populate.graph.keys" ).setFocus();
					
					//should go after trigger names, expressions, recovery are ready
					agenda.getAgendaGroup( "populate.trigger.dependencies" ).setFocus();
					agenda.getAgendaGroup( "populate" ).setFocus();
					agenda.getAgendaGroup( "prevalidate" ).setFocus();
					agenda.getAgendaGroup( "language" ).setFocus();
					
					ksession.fireAllRules();
					ksession.dispose();

				}

			}
		})
		.to("direct:multicaster_version");

		from("direct:multicaster_version")
			    .multicast().parallelProcessing()
                .to("direct:zbx3.2", "direct:zbx3.4");

        from("direct:zbx3.2")
                //.stop();
                    .setHeader("zbx_ver", simple("3.2", String.class))
                    .to("direct:multicaster_snmp");

        from("direct:zbx3.4")
                .setHeader("zbx_ver", simple("3.4", String.class))
                .to("direct:multicaster_snmp");


		from("direct:multicaster_snmp")
		.to("log:result?level=DEBUG").multicast().parallelProcessing().
		to(
				"direct:snmpv1",
				"direct:snmpv2",
				"direct:icmp"
				//"direct:remote_service"
				);
		from("direct:snmpv1")
			.filter(exchange -> ((InputJSON)exchange.getIn().getBody()).getUniqueTemplateClasses().contains(TemplateClass.SNMP_V1))
			.setHeader("snmp_item_type", simple("1", String.class))
			.setHeader("template_suffix", simple("SNMPv1", String.class))
			.log("Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ${in.headers.template_suffix}")
			.to("direct:zabbix_export");


	    from("direct:snmpv2")
			.filter(exchange -> ((InputJSON)exchange.getIn().getBody()).getUniqueTemplateClasses().contains(TemplateClass.SNMP_V2))
			.setHeader("snmp_item_type", simple("4", String.class))
		    .setHeader("template_suffix", simple("SNMPv2", String.class))
			.log("Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ${in.headers.template_suffix}")
			.to("direct:zabbix_export");

		from("direct:icmp")
			.filter(exchange -> ((InputJSON)exchange.getIn().getBody()).getUniqueTemplateClasses().contains(TemplateClass.ICMP))
			.setHeader("snmp_item_type", simple("1", String.class))
			.setHeader("template_suffix", simple("", String.class))
			.log("Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ICMP")
			.to("direct:zabbix_export");
		
		//.marshal().json(JsonLibrary.Jackson,true)
		//.marshal().jacksonxml(true)
		//.log("${body}")
		//.to("file:src/main/resources/json_test_template/out");

		//TODO 
		//Here should be validation: check that if type snmp than snmpobject defined, for example
		//Naming restrictions can also be checked for custom metrics

		//final part convert to zabbix XML		
		from("direct:zabbix_export")
		.to("freemarker:ftl/to_zabbix_template.ftl?contentCache=false")
		.to("xslt:templates/indent.xsl?saxon=true") //proper indentation for XML file
		.to("xslt:templates/to_metrics_strip_whitespace.xsl?saxon=true")// trim whitespace on some multiline nodes //REFACTOR with DEV-827 below
        //https://support.zabbix.com/browse/DEV-827
        .to("xslt:templates/to_zabbix_add_carriage_return.xsl?saxon=true")
        .setBody(body().regexReplaceAll("&#xD;", simple("&#13;")))

		.setBody(body().regexReplaceAll("SNMPvX", simple("${in.headers.template_suffix}"))) //replace SNMPvX with SNMPv2 or SNMPv1 lang

		.setHeader("subfolder",simple("${in.headers.CamelFileName.split('_')[1]}",String.class))
		.setHeader("CamelOverruleFileName",simple("${in.headers.subfolder}/${in.headers.zbx_ver}/${in.headers.lang}/${file:onlyname.noext}_${in.headers.template_suffix}_${in.headers.lang}.xml"))
		.to("file:bin/out")

		.choice()
            .when(header("zbx_ver").isEqualTo("3.4"))
            .to("validator:templates/zabbix_export_3.4.xsd")
            .when(header("zbx_ver").isEqualTo("3.2"))
            .to("validator:templates/zabbix_export_3.2.xsd")
            .otherwise()
            .log("Unknown zbx_ver provided")
		.end();


	}
}
