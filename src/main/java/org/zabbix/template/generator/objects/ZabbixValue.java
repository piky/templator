package org.zabbix.template.generator.objects;

public interface ZabbixValue {

	// all enums here should implement this method in order to return integer zabbix
	// value
	int getZabbixValue();

	String getZabbixValue(String version);

}
