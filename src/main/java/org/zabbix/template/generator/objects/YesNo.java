package org.zabbix.template.generator.objects;

public enum YesNo implements ZabbixValue {

    NO(0), YES(1);

    private int zabbixValue;

    YesNo(int zabbixValue) {
        this.setZabbixValue(zabbixValue);
    }


    @Override
    public int getZabbixValue() {
        return zabbixValue;
    }

    public void setZabbixValue(int zabbixValue) {
        this.zabbixValue = zabbixValue;
    }
}