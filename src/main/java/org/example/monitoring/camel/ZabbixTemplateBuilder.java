package org.example.monitoring.camel;

import org.apache.camel.Exchange;
import org.apache.camel.LoggingLevel;
import org.apache.camel.Processor;
import org.apache.camel.builder.RouteBuilder;
import org.apache.camel.builder.xml.Namespaces;
import org.springframework.stereotype.Component;

@Component
public class ZabbixTemplateBuilder extends RouteBuilder {

  @Override
  public void configure() throws Exception {
	errorHandler(deadLetterChannel("direct:errors"));

	  Namespaces ns = new Namespaces("z", "http://www.example.org/zbx_template_new/");

	  //catch XSLT terminations
	onException(net.sf.saxon.expr.instruct.TerminationException.class)
		  .process(new Processor() {
			  @Override
			  public void process(Exchange exchange) throws Exception {

				  Exception error = exchange.getProperty(Exchange.XSLT_ERROR, Exception.class);
				  exchange.getOut().setHeader("XSLT_ERROR",error.getMessage().toString());
			  }
		  })
		  .log(LoggingLevel.WARN,"Error:  ${file:name}: ${header.XSLT_ERROR}");

	//other errors
	from("direct:errors")
			.log(LoggingLevel.WARN,"Error:  ${file:name}: ${exception.message} ${exception.stacktrace}");



	from("file:bin/in?noop=true&delay=30000&idempotentKey=${file:name}-${file:modified}")
	    .log("Loading file: ${in.headers.CamelFileNameOnly}")
	    .multicast().parallelProcessing().to("direct:zbx3.2", "direct:zbx3.4");

    from("direct:zbx3.2")
    		//.filter().xpath("//node()[@zbx_ver = 3.4]") //if there are nodes with zbx_ver flags
    	//	.log("Going to do 3.2 template")
    		//strip metrics marked with zbx_ver not 3.2
	    	.setHeader("zbx_ver", simple("3.2", Double.class)).to("xslt:templates/to_metrics_zbx_ver.xsl?saxon=true")
	    	.to("direct:merge");

    from("direct:zbx3.4")
    	//.filter().xpath("//node()[@zbx_ver ='3.4']") // only if there are attributes zbx_ver=3.4
    	//.log("Going to do 3.4 template")
    	.setHeader("zbx_ver", simple("3.4", Double.class)).to("xslt:templates/to_metrics_zbx_ver.xsl?saxon=true")
		.to("direct:merge");

    from("direct:merge")
    	.setHeader("template_ver", simple("{{version}}",String.class))
    	.to("xslt:templates/to_metrics_add_name_placeholder.xsl?saxon=true") //will add _SNMP_PLACEHOLDER and generator ver
	    .to("xslt:templates/to_metrics.xsl?saxon=true")
	    .to("xslt:templates/to_metrics_add_trigger_desc.xsl?saxon=true") // adds Default trigger description. See inside
	    .to("xslt:templates/to_metrics_update_graph_items.xsl?saxon=true")
		.to("xslt:templates/to_metrics_strip_whitespace.xsl?saxon=true")// trim whitespace on some multiline nodes
	    .to("file:bin/merged")
	    .to("validator:templates/metrics.xsd")
	    .to("xslt:templates/to_metrics_strip_imported_metrics.xsl?saxon=true")
		.multicast().parallelProcessing().
			to(
			"direct:RU",
			"direct:docs",
			"direct:EN"
			);

    from("direct:RU")
	    //.filter().xpath("//node()[@lang='RU']")
	    //.log("Going to do Russian template")
		.setHeader("lang", simple("RU", String.class)).to("xslt:templates/to_metrics_lang.xsl?saxon=true").to("direct:multicaster");


    from("direct:EN")
		.setHeader("lang", simple("EN", String.class)).to("xslt:templates/to_metrics_lang.xsl?saxon=true").to("direct:multicaster");

	from("direct:multicaster")
			.to("log:result?level=DEBUG").multicast().parallelProcessing().
			to(
					"direct:snmpv1",
					"direct:snmpv2",
					"direct:icmp",
					"direct:remote_service"
					);

    //zabbix types: 4- snmpv2, 1-snmpv2 <xsl:variable name="snmp_item_type">4</xsl:variable>
    from("direct:snmpv1")
    	 .filter().xpath("//z:classes[z:class='SNMPv1']",ns)
			.setHeader("snmp_item_type", simple("1", String.class))
			.setHeader("template_suffix", simple("SNMPv1", String.class))
		 	.log("Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ${in.headers.template_suffix}")
    	 	.to("direct:zabbix_export");


    from("direct:snmpv2")
		.filter().xpath("//z:classes[z:class='SNMPv2']",ns)
		.setHeader("snmp_item_type", simple("4", String.class))
	    .setHeader("template_suffix", simple("SNMPv2", String.class))
		.log("Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ${in.headers.template_suffix}")
		.to("direct:zabbix_export");

	  from("direct:icmp")
			  .filter().xpath("//z:classes[z:class='ICMP']",ns)
/*
			  .setHeader("snmp_item_type", simple("4", String.class))*/
/*			  .setHeader("template_suffix", simple("ICMP", String.class))*/
			  .log("Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for ICMP")
			  .to("direct:zabbix_export");

	  from("direct:remote_service")
			  .filter().xpath("//z:classes[z:class='Remote Service']",ns)
			  .log("Going to do ${in.headers.lang} ${in.headers.zbx_ver} template for Remote Service")
			  .to("direct:zabbix_export");

    from("direct:zabbix_export")
		.to("xslt:templates/to_zabbix_export.xsl?saxon=true")
		.to("xslt:templates/to_zabbix_export_create_groups.xsl?saxon=true")
    //with lang.setBody(body().regexReplaceAll("_SNMPvX", simple(" ${in.headers.template_suffix} ${in.headers.lang}")))

		.setBody(body().regexReplaceAll("_SNMPvX", simple(" ${in.headers.template_suffix}"))) //w/o lang
		.setBody(body().regexReplaceAll(" xmlns=\".+\"", simple(""))) //remove xmlns="" declaration

		.setHeader("subfolder",simple("${in.headers.CamelFileName.split('_')[1]}",String.class))


		.setHeader("CamelOverruleFileName",simple("${in.headers.subfolder}/${in.headers.zbx_ver}/${in.headers.CamelFileName.replace('.xml','')}_${in.headers.template_suffix}_${in.headers.lang}.xml"))		.to("file:bin/out/")

		.choice()
		    .when(header("zbx_ver").isEqualTo("3.4"))
		    	.to("validator:templates/zabbix_export_3.4.xsd")
			.when(header("zbx_ver").isEqualTo("3.2"))
				.to("validator:templates/zabbix_export_3.2.xsd")
			.otherwise()
			    .log("Unknown zbx_ver provided")
	    .end()
		.multicast().parallelProcessing()
	    .to(
	    		"direct:local_tmon",
				"direct:svn",
	    		"direct:docs")
	    ;

	    from("direct:docs")
	    	.to("direct:html")
	    	//.to("direct:csv")
	    	//.to("direct:docuwiki")
	    ;


	    from("direct:html")
	    	.to("xslt:templates/doc_templates/to_html_from_merged.xsl")
	    	.setHeader("CamelOverruleFileName",simple("${in.headers.subfolder}/${in.headers.CamelFileName.replace('.xml','')}_${in.headers.template_suffix}.html"))
	    	.to("file:bin/out/docs")
	    ;


	  //svn
	  from("direct:svn")
			  .choice().when(simple("${in.header.zbx_ver} == '3.4' && ${in.header.lang} == 'EN'"))
                .setHeader("CamelOverruleFileName",
                        simple("${in.headers.subfolder}/${in.headers.CamelFileName.replace('.xml','')}_${in.headers.template_suffix}_${in.headers.lang}.xml"))
			    .to("file:C:/Temp/repos/tmon_deploy/zabbix/zbx_template_pack/svn")
			  .end()
	  ;





        //local only
        from("direct:local_tmon")
            .setBody(body().regexReplaceAll("_SNMP_PLACEHOLDER", simple(" ${in.headers.template_suffix}"))) //w/o lang
            .setBody(body().regexReplaceAll("<delay>([0-9a-zA-Z]+)</delay>", "<delay>90</delay>")) //replace delay
            .choice()
                .when(header("zbx_ver").isEqualTo("3.4"))
                    .setHeader("CamelOverruleFileName",
                        simple("${in.headers.subfolder}/${in.headers.CamelFileName.replace('.xml','')}_${in.headers.template_suffix}_${in.headers.lang}.xml"))
                .when(header("zbx_ver").isEqualTo("3.2"))
                .setHeader("CamelOverruleFileName",
                        simple("${in.headers.subfolder}/${in.headers.CamelFileName.replace('.xml','')}_${in.headers.template_suffix}_${in.headers.lang}_${in.headers.zbx_ver}.xml"))
                .otherwise()
                    .log("Unknown zbx_ver provided")
                .end()


            .to("file:C:/Temp/repos/tmon_deploy/zabbix/zbx_template_pack/");
  }
}
