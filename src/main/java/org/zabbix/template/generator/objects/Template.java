
package org.zabbix.template.generator.objects;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.LinkedHashSet;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

/*
 * 
 *	This is a Class that defines model for Zabbix template
 */
@JsonDeserialize(using = TemplateDeserializer.class)
public class Template {
	
	private String name;
	private String description;
	private ArrayList<TemplateClass> classes = new ArrayList<TemplateClass>(0);
	
	@JsonIgnore
	private ArrayList<String> groups =  new ArrayList<String>(0);//groups would be populated in Drools
	
	private DiscoveryRule discoveryRules[] = new DiscoveryRule[0];
	private Metric metrics[] = new Metric[0];
	private ArrayList<Metric> metricsRegistry = new ArrayList<Metric>(0); //overall list, regardless discovery or not
	//private ArrayList<Trigger> triggersRegistry = new ArrayList<Trigger>(0); //overall list, regardless discovery or not
	private TemplateDocumentation documentation;
	
	private LinkedHashSet<UserMacro> macros = new LinkedHashSet<UserMacro>(0);
	private ArrayList<String> templates = new ArrayList<String>(0);
	
	
	//this method return a  list of all unique mibs met in the template. This is required for FreeMarker generation of template description 
	public HashSet<String> getUniqueMibs(){
		
		HashSet<String> set = new HashSet<String>(0); 
		String mib;
		for (Metric m: this.metricsRegistry) {
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
	public DiscoveryRule[] getDiscoveryRules() {
		return discoveryRules;
	}
	public void setDiscoveryRules(DiscoveryRule discoveryRules[]) {
		this.discoveryRules = discoveryRules;
	}
	public LinkedHashSet<UserMacro> getMacros() {
		return macros;
	}
	public void setMacros(LinkedHashSet<UserMacro> macros) {
		this.macros = macros;
	}
	/**
	 * @return the templates
	 */
	public ArrayList<String> getTemplates() {
		return templates;
	}
	/**
	 * @param templates the templates to set
	 */
	public void setTemplates(ArrayList<String> templates) {
		this.templates = templates;
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
