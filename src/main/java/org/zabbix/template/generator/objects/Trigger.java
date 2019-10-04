package org.zabbix.template.generator.objects;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(value = Include.NON_EMPTY)
@JsonDeserialize(using = TriggerDeserializer.class)
public class Trigger {
	@JsonProperty(value = "_id")
	private String id;
	@JsonAlias("_documentation")
	private String documentation;
	@JsonProperty(value = "_prototype")
	private String prototype;
	private String name;
	private String expression;
	@JsonAlias({ "recovery_expression" })
	private String recoveryExpression;
	private Priority priority = Priority.NOT_CLASSIFIED;
	private String description;

	// 4.4
	@JsonProperty(value = "opdata")
	private String operationalData;

	private String url;
	@JsonAlias({ "manual_close" })
	private ManualClose manualClose = ManualClose.NO;
	@JsonAlias({ "recovery_mode" })
	private RecoveryMode recoveryMode;
	// dependsOn - populate with trigger ids
	@JsonAlias({ "_depends_on" })
	private ArrayList<String> dependsOn = new ArrayList<String>(0);
	// dependencies - objects to be put onto zabbix_export output
	private TreeSet<TriggerDependency> dependencies = new TreeSet<TriggerDependency>();

	// this array to store all metrics used apart from parent metric. To be used in
	// Drools(replace with metric keys)
	@JsonIgnore
	private HashSet<String> metricsUsed = new HashSet<>(0);

	// Translations arr
	@JsonAlias("_translations")
	private HashMap<String, Translation> translations = new HashMap<>(0);

	public HashMap<String, Translation> getTranslations() {
		return translations;
	}

	public void setTranslations(HashMap<String, Translation> translations) {
		this.translations = translations;
	}

	public void constructMetricsUsed() {

		Matcher m = Pattern.compile(":__(.+?)__").matcher(this.expression);
		while (m.find()) {
			this.metricsUsed.add(m.group(1));
		}

		if (this.recoveryExpression != null) {
			m = Pattern.compile(":__(.+?)__").matcher(this.recoveryExpression);
			while (m.find()) {
				this.metricsUsed.add(m.group(1));
			}
		}
	}

	public enum ManualClose implements ZabbixValue {

		YES(1), NO(0);

		private int zabbixValue;

		ManualClose(int zabbixValue) {
			this.setZabbixValue(zabbixValue);
		}

		@Override
		public int getZabbixValue() {
			return zabbixValue;
		}



		public void setZabbixValue(int zabbixValue) {
			this.zabbixValue = zabbixValue;
		}

	};

	public enum Priority implements ZabbixValue {

		NOT_CLASSIFIED(0), INFO(1), WARNING(2), AVERAGE(3), HIGH(4), DISASTER(5);

		private int zabbixValue;

		Priority(int zabbixValue) {
			this.setZabbixValue(zabbixValue);
		}

		@Override
		public int getZabbixValue() {
			return zabbixValue;
		}



		public void setZabbixValue(int zabbixValue) {
			this.zabbixValue = zabbixValue;
		}

	};

	public enum RecoveryMode implements ZabbixValue {

		EXPRESSION(0), RECOVERY_EXPRESSION(1), NONE(2);

		private int zabbixValue;

		RecoveryMode(int zabbixValue) {
			this.setZabbixValue(zabbixValue);
		}

		@Override
		public int getZabbixValue() {
			return zabbixValue;
		}



		public void setZabbixValue(int zabbixValue) {
			this.zabbixValue = zabbixValue;
		}

	};

	/**
	 * @return the id
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id the id to set
	 */
	public void setId(String id) {
		this.id = id;
	}

	public String getDocumentation() {
		return documentation;
	}

	public void setDocumentation(String documentation) {
		this.documentation = documentation;
	}

	/**
	 * @return the prototype
	 */
	public String getPrototype() {
		return prototype;
	}

	/**
	 * @param prototype the prototype to set
	 */
	public void setPrototype(String prototype) {
		this.prototype = prototype;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getExpression() {
		return expression;
	}

	public void setExpression(String expression) {
		this.expression = expression;
	}

	public String getRecoveryExpression() {
		return recoveryExpression;
	}

	public void setRecoveryExpression(String recoveryExpression) {
		this.recoveryExpression = recoveryExpression;
	}

	public Priority getPriority() {
		return priority;
	}

	public void setPriority(Priority priority) {
		this.priority = priority;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	/**
	 * @return the manualClose
	 */
	public ManualClose getManualClose() {
		return manualClose;
	}

	/**
	 * @param manualClose the manualClose to set
	 */
	public void setManualClose(ManualClose manualClose) {
		this.manualClose = manualClose;
	}

	/**
	 * @return the recoveryMode
	 */
	public RecoveryMode getRecoveryMode() {
		return recoveryMode;
	}

	/**
	 * @param recoveryMode the recoveryMode to set
	 */
	public void setRecoveryMode(RecoveryMode recoveryMode) {
		this.recoveryMode = recoveryMode;
	}

	public ArrayList<String> getDependsOn() {
		return dependsOn;
	}

	public void setDependsOn(ArrayList<String> dependsOn) {
		this.dependsOn = dependsOn;
	}

	public TreeSet<TriggerDependency> getDependencies() {
		return dependencies;
	}

	public void setDependencies(TreeSet<TriggerDependency> dependencies) {
		this.dependencies = dependencies;
	}

	public HashSet<String> getMetricsUsed() {
		return metricsUsed;
	}

	public void setMetrics(HashSet<String> metricsUsed) {
		this.metricsUsed = metricsUsed;
	}

	public String getOperationalData() {
		return operationalData;
	}

	public void setOperationalData(String operationalData) {
		this.operationalData = operationalData;
	}

}
