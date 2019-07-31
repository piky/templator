
package org.zabbix.template.generator.objects;

import java.util.*;
import java.util.function.Predicate;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

/*
 * 
 *	This is a Class that defines model for Zabbix template
 */
@JsonDeserialize(using = TemplateDeserializer.class)
public class Template {

	private String name;
	private String description;

	@JsonAlias("_zbx_ver")
	private Version zbxVer = new Version("3.0");

	private ArrayList<TemplateClass> classes = new ArrayList<TemplateClass>(0);

	@JsonIgnore
	private ArrayList<String> groups = new ArrayList<String>(0);// groups would be populated in Drools

	private ArrayList<DiscoveryRule> discoveryRules = new ArrayList<DiscoveryRule>(0);

	private ArrayList<Metric> metrics = new ArrayList<>(0);

	private ArrayList<Metric> metricsRegistry = new ArrayList<Metric>(0); // overall list, regardless discovery or not
	// private ArrayList<Trigger> triggersRegistry = new ArrayList<Trigger>(0);
	// //overall list, regardless discovery or not
	private TemplateDocumentation documentation;

	private TreeSet<UserMacro> macros = new TreeSet<>();
	private TreeSet<String> templates = new TreeSet<>();

	// this method return a list of all unique mibs met in the template.
	// This is required for FreeMarker generation of template description
	public HashSet<String> getUniqueMibs(Metric[] metrics) {

		HashSet<String> set = new HashSet<String>(0);
		String mib;
		for (Metric m : metrics) {
			if ((mib = m.getMib()) != null) {
				set.add(mib);
			}
		}
		return set;
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

	public Version getZbxVer() {
		return zbxVer;
	}

	public void setZbxVer(Version zbxVer) {
		this.zbxVer = zbxVer;
	}

	/**
	 * @return the classes
	 */
	public ArrayList<TemplateClass> getClasses() {
		return classes;
	}

	/**
	 * @param classes the classes to set
	 */
	public void setClasses(ArrayList<TemplateClass> classes) {
		this.classes = classes;
	}

	public ArrayList<String> getGroups() {
		return groups;
	}

	public void setGroups(ArrayList<String> groups) {
		this.groups = groups;
	}

	/**
	 * @return the classes
	 */
	public ArrayList<DiscoveryRule> getDiscoveryRules() {
		return discoveryRules;
	}

	/**
	 * @param classes the classes to set
	 */
	public void setDiscoveryRules(ArrayList<DiscoveryRule> discoveryRules) {
		this.discoveryRules = discoveryRules;
	}

	public TreeSet<UserMacro> getMacros() {
		return macros;
	}

	public void setMacros(TreeSet<UserMacro> macros) {
		this.macros = macros;
	}

	/**
	 * @return the templates
	 */
	public TreeSet<String> getTemplates() {
		return templates;
	}

	/**
	 * @param templates the templates to set
	 */
	public void setTemplates(TreeSet<String> templates) {
		this.templates = templates;
	}

	public ArrayList<Metric> getMetrics() {
		return metrics;
	}

	public void setMetrics(ArrayList<Metric> metrics) {
		this.metrics = metrics;
	}

	public ArrayList<Metric> getMetricsRegistry() {
		return metricsRegistry;
	}

	public void setMetricsRegistry(ArrayList<Metric> metricsRegistry) {
		this.metricsRegistry = metricsRegistry;
	}

	/**
	 * @return the documentation
	 */
	public TemplateDocumentation getDocumentation() {
		return documentation;
	}

	/**
	 * @param documentation the documentation to set
	 */
	public void setDocumentation(TemplateDocumentation documentation) {
		this.documentation = documentation;
	}

	public void constructMetricsRegistry() {
		this.metricsRegistry.clear();
		try {
			this.metricsRegistry.addAll(metrics);
		} catch (NullPointerException npe) {
		}

		for (DiscoveryRule d : this.discoveryRules) {
			try {
				this.metricsRegistry.addAll(d.getMetrics());
			} catch (NullPointerException npe) {
			}
		}
	}

	public ArrayList<Metric> getMetricsByDiscovery(Metric[] metrics, String discoveryName) {
		Predicate<Metric> metricPredicate = m -> m.getDiscoveryRule() == discoveryName;
		return getMetrics((ArrayList<Metric>) Arrays.asList(metrics), metricPredicate);
	}

	public ArrayList<Metric> getMetricsByZbxVer(Metric[] metrics, String zbxVer) {
		Predicate<Metric> filter_by_min_version = m -> (m.getZbxVer().compareTo(new Version(zbxVer)) <= 0);
		return getMetrics(Arrays.asList(metrics), filter_by_min_version);
	}

	public ArrayList<DiscoveryRule> getDiscoveryRulesByZbxVer(DiscoveryRule[] drules, String zbxVer) {
		Predicate<DiscoveryRule> filter_by_min_version = dr -> (dr.getZbxVer().compareTo(new Version(zbxVer)) <= 0);
		return getDiscoveryRules(Arrays.asList(drules), filter_by_min_version);
	}

	public ArrayList<Metric> getMetrics(List<Metric> metrics, Predicate<Metric> metricPredicate) {

		ArrayList<Metric> toReturn = new ArrayList<>();
		for (Metric m : metrics.stream().filter(metricPredicate).toArray(Metric[]::new)) {
			toReturn.add(m);
		}
		return toReturn;
	}

	public ArrayList<DiscoveryRule> getDiscoveryRules(List<DiscoveryRule> drules, Predicate<DiscoveryRule> dPredicate) {

		ArrayList<DiscoveryRule> toReturn = new ArrayList<>();
		for (DiscoveryRule dr : drules.stream().filter(dPredicate).toArray(DiscoveryRule[]::new)) {
			toReturn.add(dr);
		}
		return toReturn;
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
