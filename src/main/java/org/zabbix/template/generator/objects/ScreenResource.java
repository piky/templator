package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;

public class ScreenResource {

    @JsonAlias("key")
    private String name;
    private String host;

    @JsonCreator
    public ScreenResource(@JsonProperty("name") String name, @JsonProperty("host") String host) {
        this.name = name;
        this.host = host;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getHost() {
        return host;
    }

    public void setHost(String host) {
        this.host = host;
    }
}