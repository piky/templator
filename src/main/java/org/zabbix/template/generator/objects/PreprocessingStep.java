package org.zabbix.template.generator.objects;

import java.util.Objects;
import java.util.Comparator;

public class PreprocessingStep implements Comparable<PreprocessingStep> {
//TODO add error handler:
// <error_handler>0</error_handler>
// <error_handler_params/>

	private PreprocessingStepType type;
	private String params;

	public PreprocessingStepType getType() {
		return type;
	}

	public void setType(PreprocessingStepType type) {
		this.type = type;
	}

	public String getParams() {
		return params;
	}

	public void setParams(String params) {
		this.params = params;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;
		PreprocessingStep that = (PreprocessingStep) o;
		return Objects.equals(type, that.type) && Objects.equals(params, that.params);
	}

	@Override
	public int hashCode() {
		return Objects.hash(type, params);
	}

	private static Comparator<String> nullSafeStringComparator = Comparator.nullsFirst(String::compareToIgnoreCase);

	@Override
	public int compareTo(PreprocessingStep ps) {
		return Comparator
				.comparing(PreprocessingStep::getType)
				.thenComparing(PreprocessingStep::getParams, nullSafeStringComparator)
				.compare(this, ps);
	}
}
