package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

@JsonIgnoreProperties(value = { "prototype" })
public abstract class Metric {
	//use this field to match to class
	private String prototype;
	
	private String name;
	private String key;
	enum type {
		SNMP, ZabbixAgent, SimpleCheck,//to be extended
	};
	
	enum group {
		CPU,Memory,Status //to be extended	
	};
	private  Integer delay = 300;
	private  Integer history = 90;
	private  Integer trends = 365;
	
	private  String units;
	
	
	//SNMP stuff:
	private String oid;
	private String snmpObject;
	private String mib;
	
	
	
	
	
	
	public String getPrototype() {
		return prototype;
	}
	public void setPrototype(String prototype) {
		this.prototype = prototype;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public Integer getDelay() {
		return delay;
	}
	public void setDelay(Integer delay) {
		this.delay = delay;
	}
	public Integer getHistory() {
		return history;
	}
	public void setHistory(Integer history) {
		this.history = history;
	}
	public Integer getTrends() {
		return trends;
	}
	public void setTrends(Integer trends) {
		this.trends = trends;
	}
	public String getUnits() {
		return units;
	}
	public void setUnits(String units) {
		this.units = units;
	}
	public String getOid() {
		return oid;
	}
	public void setOid(String oid) {
		this.oid = oid;
	}
	public String getSnmpObject() {
		return snmpObject;
	}
	public void setSnmpObject(String snmpObject) {
		this.snmpObject = snmpObject;
	}
	public String getMib() {
		return mib;
	}
	public void setMib(String mib) {
		this.mib = mib;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((key == null) ? 0 : key.hashCode());
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		result = prime * result + ((prototype == null) ? 0 : prototype.hashCode());
		return result;
	}
	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		Metric other = (Metric) obj;
		if (key == null) {
			if (other.key != null)
				return false;
		} else if (!key.equals(other.key))
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		if (prototype == null) {
			if (other.prototype != null)
				return false;
		} else if (!prototype.equals(other.prototype))
			return false;
		return true;
	}
	
}
