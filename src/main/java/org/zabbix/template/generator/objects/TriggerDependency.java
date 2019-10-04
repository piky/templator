package org.zabbix.template.generator.objects;

import java.util.Comparator;
import java.util.Objects;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(value = Include.NON_EMPTY)
public class TriggerDependency implements Comparable<TriggerDependency> {

	@JsonCreator
	public TriggerDependency(@JsonProperty("name") String name, @JsonProperty("expression") String expression,
			@JsonProperty("recoveryExpression") String recoveryExpression) {
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

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;
		TriggerDependency that = (TriggerDependency) o;
		return Objects.equals(name, that.name) && Objects.equals(expression, that.expression)
				&& Objects.equals(recoveryExpression, that.recoveryExpression);
	}

	@Override
	public int hashCode() {

		return Objects.hash(name, expression, recoveryExpression);
	}

	private static Comparator<String> nullSafeStringComparator = Comparator.nullsFirst(String::compareToIgnoreCase);

	@Override
	public int compareTo(TriggerDependency td) {
		return Comparator.comparing(TriggerDependency::getName, nullSafeStringComparator)
				.thenComparing(TriggerDependency::getExpression, nullSafeStringComparator)
				.thenComparing(TriggerDependency::getRecoveryExpression, nullSafeStringComparator).compare(this, td);
	}
}
