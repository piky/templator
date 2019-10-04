package org.zabbix.template.generator.objects;

import java.util.ArrayList;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(value = Include.NON_EMPTY)
public class Filter {

	@JsonAlias({ "evaltype", "eval_type" })
	private EvalType evalType;
	private String formula;
	private ArrayList<Condition> conditions = new ArrayList<Condition>(0);

	public enum EvalType implements ZabbixValue {

		AND_OR(0), AND(1), OR(2), FORMULA(3);

		private int zabbixValue;

		EvalType(int zabbixValue) {
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

	public EvalType getEvalType() {
		return evalType;
	}

	public void setEvalType(EvalType evalType) {
		this.evalType = evalType;
	}

	public String getFormula() {
		return formula;
	}

	public void setFormula(String formula) {
		this.formula = formula;
	}

	public ArrayList<Condition> getConditions() {
		return conditions;
	}

	public void setConditions(ArrayList<Condition> conditions) {
		this.conditions = conditions;
	}

	public static class Condition {

		private String macro;
		private String value;

		/*
		 * Condition operator. Possible values: 8 - (default) matches regular
		 * expression.
		 */
		private Operator operator = Operator.MATCHES_REGEX;

		public enum Operator implements ZabbixValue {

			MATCHES_REGEX(8), NOT_MATCHES_REGEX(9);

			private int zabbixValue;

			Operator(int zabbixValue) {
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

		private String formulaid;

		public String getMacro() {
			return macro;
		}

		public void setMacro(String macro) {
			this.macro = macro;
		}

		public String getValue() {
			return value;
		}

		public void setValue(String value) {
			this.value = value;
		}

		public Operator getOperator() {
			return operator;
		}

		public void setOperator(Operator operator) {

			this.operator = operator;
		}

		public String getFormulaid() {
			return formulaid;
		}

		public void setFormulaid(String formulaid) {
			this.formulaid = formulaid;
		}
	}

}
