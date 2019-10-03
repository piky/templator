package org.zabbix.template.generator.objects;

public enum YesNo implements ZabbixValue {

    NO(0), YES(1);

    private int zabbixValue;

    YesNo(int zabbixValue) {
        this.setZabbixValue(zabbixValue);
    }

    public String getZabbixValue(String version) {
        if (new Version(version).compareTo(new Version("4.4")) >= 0) {
            return this.toString();
        } else {
            return new Integer(zabbixValue).toString();
        }
    }

    @Override
    public int getZabbixValue() {
        return zabbixValue;
    }

    public void setZabbixValue(int zabbixValue) {
        this.zabbixValue = zabbixValue;
    }
}