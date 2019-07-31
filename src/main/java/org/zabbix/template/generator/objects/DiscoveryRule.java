package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.annotation.JsonAlias;

import java.util.ArrayList;

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

	// Preprocessing
	private ArrayList<PreprocessingStep> preprocessing;

	@JsonAlias("master_item")
	private String masterItem;

	// if true, It means that only single discovery object is expected. Some
	// validation rules can be ignored.
	@JsonAlias("_singleton")
	private Boolean singleton = false;
	@JsonAlias("_zbx_ver")
	private Version zbxVer = new Version("3.0");

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
}
