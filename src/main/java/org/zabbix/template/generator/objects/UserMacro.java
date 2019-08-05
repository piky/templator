package org.zabbix.template.generator.objects;

import java.util.Objects;

import com.fasterxml.jackson.annotation.JsonAlias;

public class UserMacro implements Comparable<UserMacro> {
	private String macro;
	private String value;

	@JsonAlias("_description")
	private String description;

	public String extractMacroName() {
		// ^\{\$[A-Z0-9_]+(:".+")?\}$
		// returns macro name without {$:"context"}
		return this.macro.replaceFirst("^\\{\\$([A-Z0-9_]+)(:\".+\")?\\}$", "$1");
	}

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

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	// used in Jackson
	public UserMacro() {
	}

	// used in Drools
	public UserMacro(String macro, String value) {
		this.macro = macro;
		this.value = value;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;
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
