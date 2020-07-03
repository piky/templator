package org.zabbix.template.generator.objects;

import java.util.ArrayList;
import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(value = Include.NON_EMPTY)
public class DiscoveryRule {
	private String name;

	@JsonAlias("snmp_oid")
	private String oid;
	private String key;

	private Type type;
	@JsonAlias("update")
	private String delay = "1h";
	private String lifetime = "30d";
	private String description;

	private Filter filter;
	@JsonAlias("lld_macro_paths")
	private ArrayList<LLDMacroPath> lldMacroPaths = new ArrayList<>(0);

	@JsonAlias("items")
	private ArrayList<Metric> metrics = new ArrayList<>(0);

	@JsonAlias("host_prototypes")
	private ArrayList<HostPrototype> hostPrototypes = new ArrayList<>(0);

	// Preprocessing
	private ArrayList<PreprocessingStep> preprocessing = new ArrayList<PreprocessingStep>(0);

	@JsonAlias("master_item")
	private String masterItem;

	public enum ValueType implements ZabbixValue {

		FLOAT(0), CHAR(1), LOG(2), UNSIGNED(3), TEXT(4);

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
	private ValueType valueType = ValueType.UNSIGNED;
	
	// http 4.0 stuff
	private String timeout;
	private String url;

	// @JsonAlias("query_fields")
	// private String queryFields;

	@JsonAlias("posts")
	private String posts;

	@JsonAlias("status_codes")
	private String statusCodes;

	@JsonAlias("follow_redirects")
	private YesNo followRedirects = YesNo.YES;

	@JsonAlias("post_type")
	private String postType;

	@JsonAlias("http_proxy")
	private String httpProxy;

	// Query_fields
	private ArrayList<Query_field> query_fields = new ArrayList<Query_field>(0);
	// Headers
	private ArrayList<Header> headers = new ArrayList<Header>(0);

	@JsonAlias("retrieve_mode")
	private RetrieveMode retrieveMode = RetrieveMode.BODY;

	@JsonAlias({ "authtype", "auth_type" })
	private AuthType authType = AuthType.NONE;

	private String username;
	private String password;

	@JsonAlias("jmx_endpoint")
	private String jmxEndpoint;

	@JsonAlias("request_method")
	private RequestMethod requestMethod = RequestMethod.GET;

	// TODO add others HTTP 4.0:
	// <allow_traps>0</allow_traps>
	// <ssl_cert_file/>
	// <ssl_key_file/>
	// <ssl_key_password/>
	// <verify_peer>0</verify_peer>
	// <verify_host>0</verify_host>

	// if true, It means that only single discovery object is expected. Some
	// validation rules can be ignored.
	@JsonAlias("_singleton")
	private Boolean singleton = false;
	@JsonAlias("_zbx_ver")
	private Version zbxVer = new Version("3.0");
	@JsonAlias("header")
	private String header;

	@JsonAlias({ "_expression_formula", "expression_formula", "params" })
	private String expressionFormula;
	
	private ArrayList<Overrides> overrides = new ArrayList<Overrides>(0);
	
	/**
	 * @return the header
	 */
	public String getHeader() {
		return header;
	}

	/**
	 * @param header the header to set
	 */
	public void setHeader(String header) {
		this.header = header;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getOid() {
		return oid;
	}

	public void setOid(String oid) {
		this.oid = oid;
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

	public String getDelay() {
		return delay;
	}

	public void setDelay(String delay) {
		this.delay = delay;
	}

	public String getLifetime() {
		return lifetime;
	}

	public void setLifetime(String lifetime) {
		this.lifetime = lifetime;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public ArrayList<Metric> getMetrics() {
		return metrics;
	}

	public void setMetrics(ArrayList<Metric> metrics) {
		this.metrics = metrics;
	}

	public ArrayList<HostPrototype> getHostPrototypes() {
		return hostPrototypes;
	}

	public void setHostPrototypes(ArrayList<HostPrototype> hostPrototypes) {
		this.hostPrototypes = hostPrototypes;
	}

	public ValueType getValueType() {
		return valueType;
	}

	public void setValueType(ValueType valueType) {
		this.valueType = valueType;
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

	public String getMasterItem() {
		return masterItem;
	}

	public void setMasterItem(String masterItem) {
		this.masterItem = masterItem;
	}

	public String getExpressionFormula() {
		return expressionFormula;
	}

	public void setExpressionFormula(String expressionFormula) {
		this.expressionFormula = expressionFormula;
	}

	public Filter getFilter() {
		return filter;
	}

	public void setFilter(Filter filter) {
		this.filter = filter;
	}

	public ArrayList<LLDMacroPath> getLldMacroPaths() {
		return lldMacroPaths;
	}

	public void setLldMacroPaths(ArrayList<LLDMacroPath> lldMacroPaths) {
		this.lldMacroPaths = lldMacroPaths;
	}

	public Boolean getSingleton() {
		return singleton;
	}

	public void setSingleton(Boolean singleton) {
		this.singleton = singleton;
	}

	public Version getZbxVer() {
		return zbxVer;
	}

	public void setZbxVer(Version zbxVer) {
		this.zbxVer = zbxVer;
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
	// public String getQueryFields() {
	// 	return queryFields;
	// }

	/**
	 * @param queryFields the queryFields to set
	 */
	// public void setQueryFields(String queryFields) {
	// 	this.queryFields = queryFields;
	// }

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

	public YesNo getFollowRedirects() {
		return followRedirects;
	}

	public void setFollowRedirects(YesNo followRedirects) {
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
	public ArrayList<Header> getHeaders() {
		return headers;
	}

	/**
	 * @param headers the headers to set
	 */
	public void setHeaders(ArrayList<Header> headers) {
		this.headers = headers;
	}

	/**
	 * @return the query_fields
	 */
	public ArrayList<Query_field> getQuery_fields() {
		return query_fields;
	}

	/**
	 * @param query_fields the query_fields to set
	 */
	public void setQuery_fields(ArrayList<Query_field> query_fields) {
		this.query_fields = query_fields;
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
	 * @return the authType
	 */
	public AuthType getAuthType() {
		return authType;
	}

	/**
	 * @param authType the authType to set
	 */
	public void setAuthType(AuthType authType) {
		this.authType = authType;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getJmxEndpoint() {
		return jmxEndpoint;
	}

	public void setJmxEndpoint(String jmxEndpoint) {
		this.jmxEndpoint = jmxEndpoint;
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

		BODY(0), HEADERS(1), BOTH(2);

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

	public enum AuthType implements ZabbixValue {

		// HTTP:
		NONE(0), BASIC(1), NTLM(2), KERBEROS(3),
		// SSH
		PASSWORD(0), PUBLIC_KEY(1);

		private int zabbixValue;

		AuthType(int zabbixValue) {
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

	public ArrayList<Overrides> getOverrides() {
		return overrides;
	}

	public void setOverrides(ArrayList<Overrides> overrides) {
		this.overrides = overrides;
	}
	
}
