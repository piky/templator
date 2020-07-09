package org.zabbix.template.generator.objects;

import java.util.ArrayList;

import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(value = Include.NON_EMPTY)
public class Overrides {

    private String name;
    private String step;
    private Filter filter;
    private ArrayList<Operation> operations = new ArrayList<Operation>(0);

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getStep() {
		return step;
	}

	public void setStep(String step) {
		this.step = step;
	}

	public Filter getFilter() {
		return filter;
	}

	public void setFilter(Filter filter) {
		this.filter = filter;
	}

	public ArrayList<Operation> getOperations() {
		return operations;
	}

	public void setOperations(ArrayList<Operation> operations) {
		this.operations = operations;
	}

	public static class Operation {

		private Operationobject operationobject = Operationobject.TRIGGER_PROTOTYPE;
		public enum Operationobject {
			ITEM_PROTOTYPE,
			TRIGGER_PROTOTYPE,
			GRAPH_PROTOTYPE,
			HOST_PROTOTYPE
		};
		private Operator operator = Operator.LIKE;
		public enum Operator {
			LIKE,
			NOT_LIKE
		}
		private String value;
		private Status status = Status.ENABLED;
		public enum Status {
			ENABLED,
			DISABLED
		}
		private Discover discover = Discover.DISCOVER;
		public enum Discover {
			DISCOVER,
			NO_DISCOVER
		}
		

		public Operationobject getOperationobject() {
			return operationobject;
		}

		public void setOperationobject(Operationobject operationobject) {
			this.operationobject = operationobject;
		}

		public Operator getOperator() {
			return operator;
		}

		public void setOperator(Operator operator) {

			this.operator = operator;
		}

		public String getValue() {
			return value;
		}

		public void setValue(String value) {
			this.value = value;
		}
		
		public Status getStatus() {
			return status;
		}

		public void setStatus(Status status) {

			this.status = status;
		}

		public Discover getDiscover() {
			return discover;
		}

		public void setDiscover(Discover discover) {

			this.discover = discover;
		}
	}
}




