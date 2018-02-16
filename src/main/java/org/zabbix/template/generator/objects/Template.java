
package org.zabbix.template.generator.objects;

import java.util.ArrayList;
import java.util.Arrays;

/*
 * 
 *	This is a Class that defines model for Zabbix template
 */
public class Template {
	
	private String name;
	private String description;
	private Metric metrics[] = new Metric[0];
	private ArrayList<Metric> metricsRegistry = new ArrayList<Metric>(0); //overall list, regardless discovery or not
	private DiscoveryRule discoveryRules[] = new DiscoveryRule[0];;
	
	
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

	public ArrayList<Metric> getMetricsRegistry() {
		return metricsRegistry;
	}
	public void setMetricsRegistry(ArrayList<Metric> metricsRegistry) {
		this.metricsRegistry = metricsRegistry;
	}
	
	//error prone. Refactor
	public void constructMetricsRegistry() {
		//this.metricsRegistry = null;
		try {
			this.metricsRegistry.addAll(Arrays.asList(this.metrics));
		}
		catch (NullPointerException npe) {}
		
		for (DiscoveryRule d: this.discoveryRules) {
			try {
				this.metricsRegistry.addAll(Arrays.asList(d.getMetrics()));
			}
			catch (NullPointerException npe) {}
		}
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
