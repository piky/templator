package org.zabbix.template.generator.objects;

public class PreprocessingStep {

	enum PreprocessingType implements ZabbixValue {
		MULTIPLIER(1), REGEX(5), DELTA_PER_SECOND(10);
		private int zabbixValue;

		PreprocessingType(int zabbixValue) {
			this.setZabbixValue(zabbixValue);
		}

		@Override
		public int getZabbixValue() {
			return zabbixValue;
		}

		public void setZabbixValue(int zabbixValue) {
			this.zabbixValue = zabbixValue;
		}

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
