package org.zabbix.template.generator.objects;

import java.util.ArrayList;
import java.util.HashSet;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(value = Include.NON_EMPTY)
public class InputJSON {

	// this attribute is used to stop templates from further processing if set to
	// true (from Drools rule for example)
	@JsonIgnore
	private boolean failed = false;

	public boolean isFailed() {
		return failed;
	}

	public void setFailed(boolean failed) {
		this.failed = failed;
	}

	private ArrayList<Template> templates = new ArrayList<Template>(0);
	@JsonAlias("value_maps")
	private ArrayList<ValueMap> valueMaps = new ArrayList<ValueMap>(0);

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

	// this method return a list of all unique groups met in the templates. This is
	// required for FreeMarker generation of zabbix_export.groups
	@JsonIgnore
	public HashSet<TemplateClass> getUniqueTemplateClasses() {

		HashSet<TemplateClass> set = new HashSet<TemplateClass>(0);
		for (Template t : this.templates) {
			try {
				set.addAll(t.getClasses());
			} catch (NullPointerException npe) {
				// just ignore
			}
		}
		return set;
	}

}
