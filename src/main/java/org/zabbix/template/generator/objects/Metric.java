package org.zabbix.template.generator.objects;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

@JsonDeserialize(using = MetricDeserializer.class)
public abstract class Metric {
	// use this field to match to class
	private String prototype;

	private String id;

	private String name;
	private String description;
	@JsonAlias("vendor_documentation") // TODO deprecate this
	private String vendorDocumentation;
	private String ref;
	@JsonAlias("vendor_description")
	private String vendorDescription;
	@JsonAlias("key")
	private String key;

	@JsonAlias("_zbx_ver")
	private Version zbxVer = new Version("3.0");

	@JsonAlias("expression_formula")
	private String expressionFormula;
	@JsonAlias("inventory_link")
	private InventoryLink inventoryLink = InventoryLink.NONE;

	public enum ValueType implements ZabbixValue {

		FLOAT(0), CHAR(1), LOG(2), INTEGER(3), TEXT(4);
		private int zabbixValue;

		ValueType(int zabbixValue) {
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
	@JsonAlias({ "itemType", "item_type" })
	private Type type;

	public enum Group {
		CPU, Memory, Status, Temperature, Network_interfaces, Internal_items, Inventory, Storage, General, Fans,
		Power_supply, Physical_disks, Virtual_disks, Disk_arrays, Filesystems, Wireless, Nginx, Apache// to be extended
	};

	private Group group;
	@JsonAlias("application_prototype")
	private String applicationPrototype;
	@JsonAlias("update")
	private String delay = "5m";
	private String history = "90d";
	private String trends = "365d";

	private String units;

	@JsonAlias({ "logformat", "log_format", "logFormat" })
	private String logtimefmt;

	// SNMP stuff:
	private String oid;
	// TODO snmpObject only used for SNMP keys generation(in LLD). Deprecate
	private String snmpObject;
	private String mib;

	// Translations arr
	private HashMap<String, Translation> translations = new HashMap<>(0);

	public HashMap<String, Translation> getTranslations() {
		return translations;
	}

	public void setTranslations(HashMap<String, Translation> translations) {
		this.translations = translations;
	}

	// Discovery stuff
	@JsonAlias("discovery_rule")
	private String discoveryRule;
	@JsonAlias("resource")
	private String resource;
	@JsonAlias("resource_type")
	private String resourceType;

	@JsonAlias("master_item")
	private String masterItem;

	// valuemap
	@JsonAlias("value_map")
	private String valueMap;

	// Preprocessing
	private ArrayList<PreprocessingStep> preprocessing = new ArrayList<PreprocessingStep>(0);

	// Triggers
	private ArrayList<Trigger> triggers = new ArrayList<Trigger>(0);
	// Graphs
	private ArrayList<Graph> graphs = new ArrayList<Graph>(0);

	// this array to store all metrics used apart from parent metric. To be used in
	// Drools(replace with metric keys)
	private HashSet<String> metricsUsed = new HashSet<>(0);

	// Generated down below
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

	public String getApplicationPrototype() {
		return applicationPrototype;
	}

	public void setApplicationPrototype(String applicationPrototype) {
		this.applicationPrototype = applicationPrototype;
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

	public String getResource() {
		return resource;
	}

	public void setResource(String resource) {
		this.resource = resource;
	}

	public String getResourceType() {
		return resourceType;
	}

	public void setResourceType(String resourceType) {
		this.resourceType = resourceType;
	}

	public String getMasterItem() {
		return masterItem;
	}

	public void setMasterItem(String masterItem) {
		this.masterItem = masterItem;
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

	/**
	 * @return the timeout
	 */
	public String getTimeout() {
		return timeout;
	}

	/**
	 * @param timeout the timeout to set
	 */
	public void setTimeout(String timeout) {
		this.timeout = timeout;
	}

	/**
	 * @return the url
	 */
	public String getUrl() {
		return url;
	}

	/**
	 * @param url the url to set
	 */
	public void setUrl(String url) {
		this.url = url;
	}

	/**
	 * @return the queryFields
	 */
	public String getQueryFields() {
		return queryFields;
	}

	/**
	 * @param queryFields the queryFields to set
	 */
	public void setQueryFields(String queryFields) {
		this.queryFields = queryFields;
	}

	/**
	 * @return the posts
	 */
	public String getPosts() {
		return posts;
	}

	/**
	 * @param posts the posts to set
	 */
	public void setPosts(String posts) {
		this.posts = posts;
	}

	/**
	 * @return the statusCodes
	 */
	public String getStatusCodes() {
		return statusCodes;
	}

	/**
	 * @param statusCodes the statusCodes to set
	 */
	public void setStatusCodes(String statusCodes) {
		this.statusCodes = statusCodes;
	}

	/**
	 * @return the followRedirects
	 */
	public String getFollowRedirects() {
		return followRedirects;
	}

	/**
	 * @param followRedirects the followRedirects to set
	 */
	public void setFollowRedirects(String followRedirects) {
		this.followRedirects = followRedirects;
	}

	/**
	 * @return the postType
	 */
	public String getPostType() {
		return postType;
	}

	/**
	 * @param postType the postType to set
	 */
	public void setPostType(String postType) {
		this.postType = postType;
	}

	/**
	 * @return the httpProxy
	 */
	public String getHttpProxy() {
		return httpProxy;
	}

	/**
	 * @param httpProxy the httpProxy to set
	 */
	public void setHttpProxy(String httpProxy) {
		this.httpProxy = httpProxy;
	}

	/**
	 * @return the headers
	 */
	public String getHeaders() {
		return headers;
	}

	/**
	 * @param headers the headers to set
	 */
	public void setHeaders(String headers) {
		this.headers = headers;
	}

	/**
	 * @return the retrieveMode
	 */
	public RetrieveMode getRetrieveMode() {
		return retrieveMode;
	}

	/**
	 * @param retrieveMode the retrieveMode to set
	 */
	public void setRetrieveMode(RetrieveMode retrieveMode) {
		this.retrieveMode = retrieveMode;
	}

	/**
	 * @return the retrieveMode
	 */
	public RequestMethod getRequestMethod() {
		return requestMethod;
	}

	/**
	 * @param retrieveMode the retrieveMode to set
	 */
	public void setRequestMethod(RequestMethod requestMethod) {
		this.requestMethod = requestMethod;
	}

	public enum RetrieveMode implements ZabbixValue {

		BODY(0), HEADERS(1), BODY_AND_HEADERS(2);
		private int zabbixValue;

		RetrieveMode(int zabbixValue) {
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

	public enum RequestMethod implements ZabbixValue {

		GET(0), POST(1), PUT(2), HEAD(3);
		private int zabbixValue;

		RequestMethod(int zabbixValue) {
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

	@JsonAlias("output_format")
	private OutputFormat outputFormat;

	public enum OutputFormat implements ZabbixValue {

		RAW(0), JSON(1);
		private int zabbixValue;

		OutputFormat(int zabbixValue) {
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

	// http 4.0 stuff
	private String timeout;
	private String url;

	@JsonAlias("query_fields")
	private String queryFields;

	@JsonAlias("posts")
	private String posts;

	@JsonAlias("status_codes")
	private String statusCodes;

	@JsonAlias("follow_redirects")
	private String followRedirects;

	@JsonAlias("post_type")
	private String postType;

	@JsonAlias("http_proxy")
	private String httpProxy;

	@JsonAlias("headers")
	private String headers;

	@JsonAlias("retrieve_mode")
	private RetrieveMode retrieveMode = RetrieveMode.BODY;

	@JsonAlias("request_method")
	private RequestMethod requestMethod = RequestMethod.GET;

	// TODO add others HTTP 4.0:
	// <allow_traps>0</allow_traps>
	// <ssl_cert_file/>
	// <ssl_key_file/>
	// <ssl_key_password/>
	// <verify_peer>0</verify_peer>
	// <verify_host>0</verify_host>

	/*
	 * used For expressionFormula
	 */
	public void constructMetricsUsed() {

		if (this.expressionFormula != null) {
			Matcher m = Pattern.compile("__(.+?)__").matcher(this.expressionFormula);
			while (m.find()) {
				this.metricsUsed.add(m.group(1));
			}
		}
	}

	public HashSet<String> getMetricsUsed() {
		return metricsUsed;
	}

	public void setMetrics(HashSet<String> metricsUsed) {
		this.metricsUsed = metricsUsed;
	}

}
