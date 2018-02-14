package org.zabbix.template.generator.objects;

public class PreprocessingStep {
	
	enum PreprocessingType {
		MULTIPLIER
	}
	private PreprocessingType type;
	private String params;
	public PreprocessingType getType() {
		return type;
	}
	public void setType(PreprocessingType type) {
		this.type = type;
	}
	public String getParams() {
		return params;
	}
	public void setParams(String params) {
		this.params = params;
	}
}
