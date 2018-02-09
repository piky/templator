package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(value = { "prototype" })
public abstract class Metric {
	private String prototype;
	
	public String name;
	public String key;
	enum type {
		SNMP, ZabbixAgent, SimpleCheck,//to be extended
	};
	
	enum group {
		CPU,Memory,Status //to be extended	
	};
	public  Integer delay = 300;
	public  Integer history = 90;
	public  Integer trends = 365;
	
	public  String units;
	
	
	//SNMP stuff:
	public String oid;
	public String snmpObject;
	public String mib;
	
	public String getPrototype() {
		return prototype;
	}
	public void setPrototype(String prototype) {
		this.prototype = prototype;
	}
	
}
