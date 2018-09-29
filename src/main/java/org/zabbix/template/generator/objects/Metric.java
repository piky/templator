package org.zabbix.template.generator.objects;


import java.util.ArrayList;
import java.util.HashMap;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

@JsonDeserialize(using = MetricDeserializer.class)
public abstract class Metric {
	//use this field to match to class
	private String prototype;


	private String id;

	private String name;
	private String description;
	@JsonAlias("vendor_documentation")
	private String vendorDocumentation;
	private String ref;
	@JsonAlias("vendor_description")
	private String vendorDescription;
	@JsonAlias("zabbixKey")
	private String key;


    @JsonAlias("zbx_ver")
	private Version zbxVer = new Version("3.0");

	@JsonAlias("expression_formula")
	private String expressionFormula;
	@JsonAlias("inventory_link")
	private InventoryLink inventoryLink = InventoryLink.NONE;



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

	@JsonAlias("value_type")
	private ValueType valueType = ValueType.INTEGER;
	@JsonAlias({"itemType","item_type"})
	private Type type; 

	public enum Group {
		CPU,Memory,Status,Temperature,Network_interfaces,Internal_items,Inventory,Storage,General,Fans,Power_supply,Physical_disks,Virtual_disks,Disk_arrays,
		Wireless//to be extended
	};
	private Group group;
	@JsonAlias("update")
	private  String delay = "5m";
	private  String history = "7d";
	private  String trends = "365d";

	private  String units;
	
	@JsonAlias({"logformat","log_format","logFormat"})
	private String logtimefmt;

	//SNMP stuff:
	private String oid;
	private String snmpObject;
	private String mib;




	//Translations arr
	private HashMap<String,Translation> translations = new HashMap<>(0);
	public HashMap<String, Translation> getTranslations() {
		return translations;
	}

	public void setTranslations(HashMap<String, Translation> translations) {
		this.translations = translations;
	}

	//Discovery stuff
	@JsonAlias("discovery_rule")
	private String discoveryRule;
	@JsonAlias("alarm_object")
	private String alarmObject;
	@JsonAlias("alarm_object_type")
	private String alarmObjectType;

	//valuemap
	@JsonAlias("value_map")
	private String valueMap;


	//Preprocessing
	private ArrayList<PreprocessingStep> preprocessing;
	
	//Triggers
	private ArrayList<Trigger> triggers =  new ArrayList<Trigger>(0);
	//Graphs
	private ArrayList<Graph> graphs =  new ArrayList<Graph>(0);

	//Generated down below
	public String getPrototype() {
		return prototype;
	}
	public void setPrototype(String prototype) {
		this.prototype = prototype;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
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
	public String getExpressionFormula() {
		return expressionFormula;
	}
	public void setExpressionFormula(String expressionFormula) {
		this.expressionFormula = expressionFormula;
	}
	public InventoryLink getInventoryLink() {
		return inventoryLink;
	}
	public void setInventoryLink(InventoryLink inventoryLink) {
		this.inventoryLink = inventoryLink;
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
	public String getDelay() {
		return delay;
	}
	public void setDelay(String delay) {
		this.delay = delay;
	}
	public String getHistory() {
		return history;
	}
	public void setHistory(String history) {
		this.history = history;
	}
	public String getTrends() {
		return trends;
	}
	public void setTrends(String trends) {
		this.trends = trends;
	}
	public String getUnits() {
		return units;
	}
	public void setUnits(String units) {
		this.units = units;
	}
	
	public String getLogtimefmt() {
		return logtimefmt;
	}
	public void SetLogtimefmt(String logtimefmt) {
		this.logtimefmt = logtimefmt;
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
	public String getValueMap() {
		return valueMap;
	}
	public void setValueMap(String valueMap) {
		this.valueMap = valueMap;
	}
    public Version getZbxVer() {
        return zbxVer;
    }

    public void setZbxVer(Version zbxVer) {
        this.zbxVer = zbxVer;
    }
	/**
	 * @return the preprocessing
	 */
	public ArrayList<PreprocessingStep> getPreprocessing() {
		return preprocessing;
	}
	/**
	 * @param preprocessing the preprocessing to set
	 */
	public void setPreprocessing(ArrayList<PreprocessingStep> preprocessing) {
		this.preprocessing = preprocessing;
	}
	/**
	 * @return the triggers
	 */
	public ArrayList<Trigger> getTriggers() {
		return triggers;
	}
	/**
	 * @param triggers the triggers to set
	 */
	public void setTriggers(ArrayList<Trigger> triggers) {
		this.triggers = triggers;
	}
	public ArrayList<Graph> getGraphs() {
		return graphs;
	}
	public void setGraphs(ArrayList<Graph> graphs) {
		this.graphs = graphs;
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
