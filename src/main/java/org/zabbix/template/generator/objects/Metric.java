package org.zabbix.template.generator.objects;


import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

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

	private String expressionFormula;

	private InventoryLink inventoryLink = InventoryLink.NONE;


	public enum InventoryLink implements ZabbixValue{

		NONE(0), 
		ALIAS(4),
		ASSET_TAG(11),
		CHASSIS(28),
		CONTACT_STRING(23),
		CONTRACT_NUMBER(32),
		DATE_HW_DECOMM(47),
		DATE_HW_EXPIRY(46),
		DATE_HW_INSTALL(45),
		DATE_HW_PURCHASE(44),
		DEPLOYMENT_STATUS(34),
		HARDWARE(14),
		HARDWARE_FULL(15),
		HOST_NETMASK(39),
		HOST_NETWORKS(38),
		HOST_ROUTER(40),
		HW_ARCH(30),
		INSTALLER_NAME(33),
		LOCATION(24),
		LOCATION_LAT(25),
		LOCATION_LON(26),
		MACADDRESS_A(12),
		MACADDRESS_B(13),
		MODEL(29),
		NAME(3),
		NOTES(27),
		OOB_IP(41),
		OOB_NETMASK(42),
		OOB_ROUTER(43),
		OS(5),
		OS_FULL(6),
		OS_SHORT(7),
		POC_1_CELL(61),
		POC_1_EMAIL(58),
		POC_1_NAME(57),
		POC_1_NOTES(63),
		POC_1_PHONE_A(59),
		POC_1_PHONE_B(60),
		POC_1_SCREEN(62),
		POC_2_CELL(68),
		POC_2_EMAIL(65),
		POC_2_NAME(64),
		POC_2_NOTES(70),
		POC_2_PHONE_A(66),
		POC_2_PHONE_B(67),
		POC_2_SCREEN(69),
		SERIALNO_A(8),
		SERIALNO_B(9),
		SITE_ADDRESS_A(48),
		SITE_ADDRESS_B(49),
		SITE_ADDRESS_C(50),
		SITE_CITY(51),
		SITE_COUNTRY(53),
		SITE_NOTES(56),
		SITE_RACK(55),
		SITE_STATE(52),
		SITE_ZIP(54),
		SOFTWARE(16),
		SOFTWARE_APP_A(18),
		SOFTWARE_APP_B(19),
		SOFTWARE_APP_C(20),
		SOFTWARE_APP_D(21),
		SOFTWARE_APP_E(22),
		SOFTWARE_FULL(17),
		TAG(10),
		TYPE(1),
		TYPE_FULL(2),
		URL_A(35),
		URL_B(36),
		URL_C(37),
		VENDOR(31);

		private int zabbixValue;
		InventoryLink(int zabbixValue){
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
		CPU,Memory,Status,Temperature,Network_Interfaces,Internal_Items,Inventory //to be extended	
	};
	private Group group;
	private  String delay = "5m";
	private  String history = "7d";
	private  String trends = "365d";

	private  String units;


	//SNMP stuff:
	private String oid;
	private String snmpObject;
	private String mib;


	//Discovery stuff
	private String discoveryRule;
	private String alarmObject;
	private String alarmObjectType;

	//valuemap
	private String valueMap;


	//Preprocessing
	private PreprocessingStep[] preprocessing;

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
