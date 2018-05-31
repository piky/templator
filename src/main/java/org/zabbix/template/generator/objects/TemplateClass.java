package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;

public enum TemplateClass {
	
	//used in macros
	PERFORMANCE,
	FAULT,
	GENERAL,
	IF_MIB,
	IF_MIB_SIMPLE,
	ICMP,
	//end
	
	//used in template attachments:
	@JsonProperty("Interfaces EtherLike Extension")
	INTERFACES_ETHERLIKE_EXTENSION,
	OS,
	SERVER,
	NETWORK,
	MODULE,
	INTERFACES_SIMPLE,
	INTERFACES,
	SNMP_DEVICE,
	@JsonProperty("SNMPv1")
	SNMP_V1,
	@JsonProperty("SNMPv2")
	SNMP_V2,
	@JsonProperty("SNMPv3")
	SNMP_V3;
}
