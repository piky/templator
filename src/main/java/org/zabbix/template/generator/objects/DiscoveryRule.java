package org.zabbix.template.generator.objects;

public class DiscoveryRule {
	private String name;
	private String oid;
	private String key;
	private String description;
	private Metric metrics[] = new Metric[0];
	private Filter filter;

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

	public Metric[] getMetrics() {
		return metrics;
	}

	public void setMetrics(Metric metrics[]) {
		this.metrics = metrics;
	}

	public Filter getFilter() {
		return filter;
	}

	public void setFilter(Filter filter) {
		this.filter = filter;
	}
}
