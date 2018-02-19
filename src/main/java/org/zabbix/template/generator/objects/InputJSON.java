package org.zabbix.template.generator.objects;

public class InputJSON {

	private Template[] templates;
	private ValueMap[] valueMaps;
	

	public Template[] getTemplates() {
		return templates;
	}

	public void setTemplates(Template[] templates) {
		this.templates = templates;
	}

	public ValueMap[] getValueMaps() {
		return valueMaps;
	}

	public void setValueMaps(ValueMap[] valueMaps) {
		this.valueMaps = valueMaps;
	}
}
