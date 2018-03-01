package org.zabbix.template.generator.objects;
//TODO add enums for evaltype and ooperator.
public class Filter {
	
	private EvalType evalType;
	private String formula;
	private Condition[] conditions;

	public enum EvalType implements ZabbixValue{
	    
		AND_OR(0),
	    AND(1),
	    OR(2),
	    CUSTOM_EXPRESSION(3);
	
		private int zabbixValue;
		EvalType(int zabbixValue){
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

	public Condition[] getConditions() {
		return conditions;
	}

	public void setConditions(Condition[] conditions) {
		this.conditions = conditions;
	}


	public static class Condition {

		private String macro;
		private String value;

		/*		Condition operator. 
		Possible values: 
		8 - (default) matches regular expression.
*/
		private int operator = 8;
		
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
		public int getOperator() {
			return operator;
		}
		public void setOperator(int operator) {
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
