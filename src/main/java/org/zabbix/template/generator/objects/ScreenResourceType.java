package org.zabbix.template.generator.objects;

public enum ScreenResourceType implements ZabbixValue {

    GRAPH(0),
    SIMPLE_GRAPH(1),
    MAP(2),
    PLAIN_TEXT(3),
    HOSTS_INFO(4),
    TRIGGERS_INFO(5),
    SYSTEM_INFORMATION(6),
    CLOCK(7),
    SCREEN(8),
    TRIGGERS_OVERVIEW(9),
    DATA_OVERVIEW(10),
    URL(11),
    HISTORY_OF_ACTIONS(12),
    HISTORY_OF_EVENTS(13),
    LATEST_HOST_GROUP_ISSUES(14),
    PROBLEMS_BY_SEVERITY(15),
    LATEST_HOST_ISSUES(16),
    SIMPLE_GRAPH_PROTOTYPE(19),
    GRAPH_PROTOTYPE(20);



    private int zabbixValue;

    ScreenResourceType(int zabbixValue) {
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
