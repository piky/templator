package org.zabbix.template.generator.objects;

public class UserMacro {
	private String macro;
	private String value;
	public String getMacro() {
		return macro;
	}
	public void setMacro(String macro) {
		this.macro = macro;
	}
	public String getValue() {
		return value;
	}
	public void setValue(String value) {
		this.value = value;
	}

	//used in Jackson
	public UserMacro () {
	}
	//used in Drools
	public UserMacro (String macro, String value) {
		this.macro = macro;
		this.value = value;
	}

}
