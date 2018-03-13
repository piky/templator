package org.zabbix.template.generator.objects;

public enum TemplateClass {
	
	//used in macros
	PERFORMANCE,
	FAULT,
	GENERAL,
	IF_MIB,
	IF_MIB_SIMPLE,
	ICMP,
	//end
	
	
	OS,
	SERVER,
	NETWORK,
	MODULE,
	INTERFACES_SIMPLE,
	INTERFACES,
	SNMP_DEVICE,
	SNMP_V1,
	SNMP_V2,
	SNMP_V3;
}
