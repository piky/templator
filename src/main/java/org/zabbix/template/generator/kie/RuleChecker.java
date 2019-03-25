package org.zabbix.template.generator.kie;

import java.util.ArrayList;

import org.apache.camel.Exchange;
import org.apache.camel.Processor;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.Marker;
import org.apache.logging.log4j.MarkerManager;
import org.kie.api.KieServices;
import org.kie.api.runtime.KieContainer;
import org.kie.api.runtime.KieSession;
import org.kie.api.runtime.rule.Agenda;
import org.zabbix.template.generator.objects.InputJSON;
import org.zabbix.template.generator.objects.DiscoveryRule;
import org.zabbix.template.generator.objects.Metric;
import org.zabbix.template.generator.objects.Template;
import org.zabbix.template.generator.objects.Trigger;
import org.zabbix.template.generator.objects.ValueMap;

public class RuleChecker implements Processor {

	private static final Logger logger = LogManager.getLogger(RuleChecker.class.getName());
	private static final Marker TEMPLATE_GEN = MarkerManager.getMarker("RuleChecker");


    @Override
    public void process(Exchange exchange) throws Exception {

        String lang = exchange.getIn().getHeader("lang").toString();
        // AgendaEventListener agendaEventListener = new TrackingAgendaEventListener();
        // ksession.addEventListener(agendaEventListener);

        ArrayList<ValueMap> valueMaps = ((InputJSON) exchange.getIn().getBody()).getValueMaps();
        // kie
        KieServices ks = KieServices.Factory.get();
        KieContainer kContainer = ks.getKieClasspathContainer();

        // insert valueMaps into Drools

        // valueMaps.forEach((vm)->ksession.insert(vm));

        ArrayList<Template> templates = ((InputJSON) exchange.getIn().getBody()).getTemplates();

        for (Template t : templates) {

            Marker DROOLS_MARKER = MarkerManager.getMarker("DROOLS_" + t.getName() + "_" + lang)
                    .setParents(TEMPLATE_GEN);

            KieSession ksession = kContainer.newKieSession();
            ksession.setGlobal("logger", logger);
            ksession.setGlobal("marker", DROOLS_MARKER);
            ksession.setGlobal("lang", lang);
            ksession.insert((InputJSON) exchange.getIn().getBody());
            ksession.insert(t);

            if (t.getMetrics() != null) {
                for (Metric m : t.getMetrics()) {
                    ksession.insert(m);
                    for (Trigger tr : m.getTriggers()) {
                        ksession.insert(tr);
                    }
                }
            }

            DiscoveryRule[] drules = t.getDiscoveryRules();
            for (DiscoveryRule drule : drules) {
                for (Metric m : drule.getMetrics()) {

                    m.setDiscoveryRule(drule.getName());
                    ksession.insert(m);
                    for (Trigger tr : m.getTriggers()) {
                        ksession.insert(tr);
                    }

                }
            }
            Agenda agenda = ksession.getAgenda();
            // last agendaGroup will evaluate first...
            agenda.getAgendaGroup("baseline").setFocus();
            agenda.getAgendaGroup("postvalidate").setFocus();

            agenda.getAgendaGroup("populate.graph.keys").setFocus();
            agenda.getAgendaGroup("populate.masteritem.keys").setFocus();

            // should go after trigger names, expressions, recovery are ready
            agenda.getAgendaGroup("populate.trigger.dependencies").setFocus();
            agenda.getAgendaGroup("populate").setFocus();
            agenda.getAgendaGroup("prevalidate").setFocus();
            agenda.getAgendaGroup("language").setFocus();

            ksession.fireAllRules();
            ksession.dispose();

        }

    }
}