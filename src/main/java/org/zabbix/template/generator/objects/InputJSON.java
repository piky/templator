package org.zabbix.template.generator.objects;

import java.util.ArrayList;
import java.util.HashSet;

public class InputJSON {

	private ArrayList<Template> templates;
	private ArrayList<ValueMap> valueMaps;
	

	public ArrayList<Template> getTemplates() {
		return templates;
	}

	public void setTemplates(ArrayList<Template> templates) {
		this.templates = templates;
	}

	public ArrayList<ValueMap> getValueMaps() {
		return valueMaps;
	}

	public void setValueMaps(ArrayList<ValueMap> valueMaps) {
		this.valueMaps = valueMaps;
	}
	
	//this method return a  list of all unique groups met in the templates. This is required for FreeMarker generation of zabbix_export.groups 
	public HashSet<TemplateClass> getUniqueTemplateClasses(){
		
		HashSet<TemplateClass> set = new HashSet<TemplateClass>(0); 
		for (Template t: this.templates) {
			try {
				set.addAll(t.getClasses());
			}
			catch (NullPointerException npe) {
				//just ignore
			}
		}
		return set;
	}
}
