
package org.zabbix.template.generator.objects;
/*
 * 
 *	This is a Class that defines model for Zabbix template
 */
public class Template {
	
	private String name;
	private String description;
	private Metric metrics[];
	private DiscoveryRule discoveryRules[];
	
	
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
	
	public DiscoveryRule[] getDiscoveryRules() {
		return discoveryRules;
	}
	public void setDiscoveryRules(DiscoveryRule discoveryRules[]) {
		this.discoveryRules = discoveryRules;
	}
	public Metric[] getMetrics() {
		return metrics;
	}
	public void setMetrics(Metric metrics[]) {
		this.metrics = metrics;
	}
	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((name == null) ? 0 : name.hashCode());
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
		Template other = (Template) obj;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}

}
