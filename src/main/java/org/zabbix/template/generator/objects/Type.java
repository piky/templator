package org.zabbix.template.generator.objects;

public enum Type implements ZabbixValue {

	ZABBIX_AGENT(0), SNMP_V1(1), ZABBIX_TRAPPER(2), SIMPLE_CHECK(3), SNMP_V2(4), SNMP(4), // !!!!not official
																							// mapping
	ZABBIX_INTERNAL(5), SNMP_V3(6), ZABBIX_AGENT_ACTIVE(7), ZABBIX_AGGREGATE(8), WEB_ITEM(9), EXTERNAL_CHECK(10),
	DATABASE_MONITOR(11), IPMI_AGENT(12), SSH_AGENT(13), TELNET_AGENT(14), CALCULATED(15), JMX_AGENT(16), SNMP_TRAP(17),
	DEPENDENT_ITEM(18), HTTP_AGENT(19);

	private int zabbixValue;

	Type(int zabbixValue) {
		this.setZabbixValue(zabbixValue);
	}

	@Override
	public int getZabbixValue() {
		return zabbixValue;
	}

	public void setZabbixValue(int zabbixValue) {
		this.zabbixValue = zabbixValue;
	}
};