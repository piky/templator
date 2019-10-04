package org.zabbix.template.generator.objects;

import java.util.Objects;
import java.util.Comparator;
import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(value = Include.NON_EMPTY)
public class PreprocessingStep implements Comparable<PreprocessingStep> {

	private PreprocessingStepType type;
	private String params;

	@JsonAlias({ "error_handler" })
	private PreprocessingStepErrorHandler errorHandler = PreprocessingStepErrorHandler.ORIGINAL_ERROR;

	@JsonAlias({ "error_handler_params" })
	private String errorHandlerParams;

	public enum PreprocessingStepErrorHandler implements ZabbixValue {

		ORIGINAL_ERROR(0), DISCARD_VALUE(1), CUSTOM_VALUE(2), CUSTOM_ERROR(3);

		private int zabbixValue;

		PreprocessingStepErrorHandler(int zabbixValue) {
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

	public PreprocessingStepErrorHandler getErrorHandler() {
		return errorHandler;
	}

	public void setErrorHandler(PreprocessingStepErrorHandler errorHandler) {
		this.errorHandler = errorHandler;
	}

	public String getErrorHandlerParams() {
		return errorHandlerParams;
	}

	public void setErrorHandlerParams(String errorHandlerParams) {
		this.errorHandlerParams = errorHandlerParams;
	}

	@Override
	public boolean equals(Object o) {
		if (this == o)
			return true;
		if (o == null || getClass() != o.getClass())
			return false;
		PreprocessingStep that = (PreprocessingStep) o;
		return Objects.equals(type, that.type);
	}

	@Override
	public int hashCode() {
		return Objects.hash(type, params);
	}

	private static Comparator<String> nullSafeStringComparator = Comparator.nullsFirst(String::compareToIgnoreCase);

	@Override
	public int compareTo(PreprocessingStep ps) {
		return Comparator.comparing(PreprocessingStep::getType)
				.thenComparing(PreprocessingStep::getParams, nullSafeStringComparator).compare(this, ps);
	}
}
