package org.zabbix.template.generator.objects;

import java.util.ArrayList;

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
}
