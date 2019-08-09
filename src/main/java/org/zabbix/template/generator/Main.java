package org.zabbix.template.generator;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.ComponentScan;

@SpringBootApplication
@ComponentScan( {"org.zabbix.api", "org.zabbix.template"})
public class Main {

    public static void main(String[] args) {
        @SuppressWarnings("unused")
        ApplicationContext ctx = SpringApplication.run(Main.class, args);
    }
}
