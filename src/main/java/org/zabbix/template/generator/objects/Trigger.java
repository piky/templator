package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

@JsonDeserialize(using = TriggerDeserializer.class)
public class Trigger {

	private String prototype;
	private String name;
	private String expression;
	private String recoveryExpression;
	private int priority;
	private String description;
	private String url;
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
	
}
