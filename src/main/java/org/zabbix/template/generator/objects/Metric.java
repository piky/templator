package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

//@JsonIgnoreProperties(value = { "prototype" })
@JsonDeserialize(using = MetricDeserializer.class)
public abstract class Metric {
	//use this field to match to class
	private String prototype;
	
	private String name;
	private String description;
	private String vendorDocumentation;
	private String ref;
	private String vendorDescription;
	private String key;
	
	
	
	public enum Type implements ZabbixValue{
	    
		ZABBIX_AGENT(0),
	    SNMP_V1(1),
	    ZABBIX_TRAPPER(2),
	    SIMPLE_CHECK(3),
	    SNMP_V2(4),
	    SNMP(4), //!!!!not official mapping 
	    ZABBIX_INTERNAL(5),
	    SNMP_V3(6),
	    ZABBIX_AGENT_ACTIVE(7),
	    ZABBIX_AGGREGATE(8),
	    WEB_ITEM(9),
	    EXTERNAL_CHECK(10),
	    DATABASE_MONITOR(11),
	    IPMI_AGENT(12),
	    SSH_AGENT(13),
	    TELNET_AGENT(14),
	    CALCULATED(15),
	    JMX_AGENT(16),
	    SNMP_TRAP(17),
		DEPENDENT_ITEM(18);
		
		private int zabbixValue;
		Type(int zabbixValue){
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



	
	public enum ValueType implements ZabbixValue {
		
		FLOAT(0),
		CHAR(1),
		LOG(2),
		INTEGER(3),
		TEXT(4);
		private int zabbixValue;
		ValueType(int zabbixValue){
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
	

	private ValueType valueType = ValueType.INTEGER;
	private Type type; 
	
	public enum Group {
		CPU,Memory,Status,Temperature,Network_Interfaces //to be extended	
	};
	private Group group;
	private  Integer delay = 300;
	private  Integer history = 90;
	private  Integer trends = 365;
	
	private  String units;
	
	
	//SNMP stuff:
	private String oid;
	private String snmpObject;
	private String mib;
	
	
	//Discovery stuff
	private String discoveryRule;
	private String alarmObject;
	private String alarmObjectType;
	
	
	//Preprocessing
	private PreprocessingStep[] preprocessing = new PreprocessingStep[0];
	
	//Generated down below
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
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getVendorDocumentation() {
		return vendorDocumentation;
	}
	public void setVendorDocumentation(String vendorDocumentation) {
		this.vendorDocumentation = vendorDocumentation;
	}
	public String getRef() {
		return ref;
	}
	public void setRef(String ref) {
		this.ref = ref;
	}
	public String getVendorDescription() {
		return vendorDescription;
	}
	public void setVendorDescription(String vendorDescription) {
		this.vendorDescription = vendorDescription;
	}
	public String getKey() {
		return key;
	}
	public void setKey(String key) {
		this.key = key;
	}
	public Type getType() {
		return type;
	}
	public void setType(Type type) {
		this.type = type;
	}
	public ValueType getValueType() {
		return valueType;
	}
	public void setValueType(ValueType valueType) {
		this.valueType = valueType;
	}
	public Group getGroup() {
		return group;
	}
	public void setGroup(Group group) {
		this.group = group;
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

	public String getDiscoveryRule() {
		return discoveryRule;
	}
	public void setDiscoveryRule(String discoveryRule) {
		this.discoveryRule = discoveryRule;
	}
	public String getAlarmObject() {
		return alarmObject;
	}
	public void setAlarmObject(String alarmObject) {
		this.alarmObject = alarmObject;
	}
	public String getAlarmObjectType() {
		return alarmObjectType;
	}
	public void setAlarmObjectType(String alarmObjectType) {
		this.alarmObjectType = alarmObjectType;
	}
	public PreprocessingStep[] getPreprocessing() {
		return preprocessing;
	}
	public void setPreprocessing(PreprocessingStep[] preprocessing) {
		this.preprocessing = preprocessing;
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
