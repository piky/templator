package org.zabbix.template.generator;

import org.kie.api.KieServices;
import org.kie.api.runtime.KieContainer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

//@Configuration
public class KieServiceConfiguration {
    //private static final String drlFile = "drl/rule-test.drl";
 
    @Bean
    public KieContainer kieContainer() {
        /*KieServices kieServices = KieServices.Factory.get();
 
        KieFileSystem kieFileSystem = kieServices.newKieFileSystem();
        kieFileSystem.write(ResourceFactory.newClassPathResource(drlFile));
        KieBuilder kieBuilder = kieServices.newKieBuilder(kieFileSystem);
        kieBuilder.buildAll();
        KieModule kieModule = kieBuilder.getKieModule();
        */
        
        KieServices ks = KieServices.Factory.get();
        return ks.getKieClasspathContainer();
        //return kieServices.newKieContainer(kieModule.getReleaseId());
    }
}