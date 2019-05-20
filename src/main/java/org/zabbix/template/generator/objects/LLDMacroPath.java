package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.annotation.JsonAlias;

public class LLDMacroPath {
    @JsonAlias("lld_macro")
    private String lldMacro;
    private String path;


    public String getPath() {
        return path;
    }

    public void setPath(String path) {
        this.path = path;
    }

    public String getLldMacro() {
        return lldMacro;
    }

    public void setLldMacro(String lldMacro) {
        this.lldMacro = lldMacro;
    }

}
