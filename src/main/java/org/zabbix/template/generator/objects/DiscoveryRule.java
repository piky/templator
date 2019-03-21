package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.annotation.JsonAlias;

import java.util.ArrayList;

public class DiscoveryRule {
	private String name;
	@JsonAlias("snmp_oid")
	private String oid;
	private String key;
	private String description;
	private Filter filter;
	private ArrayList<Metric> metrics = new ArrayList<>(0);

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

	public Filter getFilter() {
		return filter;
	}

	public void setFilter(Filter filter) {
		this.filter = filter;
	}
}
