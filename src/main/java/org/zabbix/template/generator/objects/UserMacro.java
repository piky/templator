package org.zabbix.template.generator.objects;

import java.util.Objects;

public class UserMacro implements Comparable<UserMacro>{
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

	@Override
	public boolean equals(Object o) {
		if (this == o) return true;
		if (o == null || getClass() != o.getClass()) return false;
		UserMacro userMacro = (UserMacro) o;
		return Objects.equals(macro, userMacro.macro);
	}

	@Override
	public int hashCode() {

		return Objects.hash(macro);
	}


	@Override
	public int compareTo(UserMacro o) {
		return this.getMacro().compareTo(o.getMacro());
	}
}
