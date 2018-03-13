package org.zabbix.template.generator.objects;

public class TriggerDependency {
	public TriggerDependency(String name, String expression, String recoveryExpression) {
		super();
		this.name = name;
		this.expression = expression;
		this.recoveryExpression = recoveryExpression;
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
	private String name;
	private String expression;
	private String recoveryExpression;
}	

