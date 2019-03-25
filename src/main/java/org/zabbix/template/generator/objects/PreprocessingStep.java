package org.zabbix.template.generator.objects;

public class PreprocessingStep {

	enum PreprocessingType implements ZabbixValue {

// 		Possible values: 
// 1 - Custom multiplier; 
// 2 - Right trim; 
// 3 - Left trim; 
// 4 - Trim; 
// 5 - Regular expression matching; 
// 6 - Boolean to decimal; 
// 7 - Octal to decimal; 
// 8 - Hexadecimal to decimal; 
// 9 - Simple change; 
// 10 - Change per second; 
// 11 - XML XPath; 
// 12 - JSONPath; 
// 13 - In range; 
// 14 - Matches regular expression; 
// 15 - Does not match regular expression; 
// 16 - Check for error in JSON; 
// 17 - Check for error in XML; 
// 18 - Check for error in regular expression; 
// 19 - Discard unchanged; 
// 20 - Discard unchanged with heartbeat; 
// 21 - JavaScript; 
// 22 - Prometheus pattern; 
// 23 - Prometheus to JSON.
		MULTIPLIER(1),
		REGEX(5), 
		DELTA_PER_SECOND(10),
		XMLPATH(11),
		JSONPATH(12),
		JAVASCRIPT(21);
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
