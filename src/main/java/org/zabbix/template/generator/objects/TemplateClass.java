package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;

public enum TemplateClass {

	// for template classification:
	PERFORMANCE, FAULT, GENERAL, INVENTORY,

	IF_MIB, ICMP,
	// end

	// used in template attachments:
	@JsonProperty("Interfaces EtherLike Extension")
	INTERFACES_ETHERLIKE_EXTENSION, OS, SERVER, NETWORK, MODULE, APP, INTERFACES_SIMPLE, INTERFACES, SNMP_DEVICE,
	@JsonProperty("SNMPv1")
	SNMP_V1, @JsonProperty("SNMPv2")
	SNMP_V2, @JsonProperty("SNMPv3")
	SNMP_V3;
}
