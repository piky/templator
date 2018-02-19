package org.zabbix.template.generator.objects;

public class ValueMap {

	private String name;
	private Mapping[] mappings;
	
	public static class Mapping {
		private String value;
		private String newValue;
		public String getValue() {
			return value;
		}
		public void setValue(String value) {
			this.value = value;
		}
		public String getNewValue() {
			return newValue;
		}
		public void setNewValue(String newValue) {
			this.newValue = newValue;
		}
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Mapping[] getMappings() {
		return mappings;
	}

	public void setMappings(Mapping[] mappings) {
		this.mappings = mappings;
	}
	

}
