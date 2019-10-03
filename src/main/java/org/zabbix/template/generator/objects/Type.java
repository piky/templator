package org.zabbix.template.generator.objects;

public enum Type implements ZabbixValue {

	ZABBIX_PASSIVE(0), SNMPV1(1), TRAP(2), SIMPLE(3), SNMPV2(4), SNMP(4), // !!!!not official// mapping
	INTERNAL(5), SNMPV3(6), ZABBIX_ACTIVE(7), AGGREGATE(8), EXTERNAL(10), ODBC(11), IPMI(12), SSH(13), TELNET(14),
	CALCULATED(15), JMX(16), SNMP_TRAP(17), DEPENDENT(18), HTTP_AGENT(19);

	private int zabbixValue;

	Type(int zabbixValue) {
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
};