package org.zabbix.template.generator.objects;

import java.util.ArrayList;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

@JsonDeserialize(using = TriggerDeserializer.class)
public class Trigger {

	private String id;
	private String documentation;
	private String prototype;
	private String name;
	private String expression;
	private String recoveryExpression;
	private int priority;
	private String description;
	private String url;
	private ManualClose manualClose = ManualClose.NO;
	private RecoveryMode recoveryMode;
	private ArrayList<String> dependsOn = new ArrayList<String>(0);
	public enum ManualClose implements ZabbixValue {

		YES(1),
		NO(0);
		private int zabbixValue;
		ManualClose(int zabbixValue){
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

		EXPRESSION(0),
		RECOVERY_EXPRESSION(1),
		NONE(2);
		private int zabbixValue;
		RecoveryMode(int zabbixValue){
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
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
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

}
