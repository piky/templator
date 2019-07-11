package org.zabbix.template.generator.objects;

import java.util.ArrayList;
import java.util.Arrays;
import com.fasterxml.jackson.annotation.JsonAlias;

public class GraphItem {
	@JsonAlias({ "sortorder" })
	private int sortOrder;

	@JsonAlias({ "drawtype" })
	private DrawType drawType = DrawType.LINE;

	// change to Color enum
	@JsonAlias({ "colour" })
	private String color;

	@JsonAlias({ "yaxisside" })
	private YAxisSide yAxisSide = YAxisSide.LEFT;

	@JsonAlias({ "calc_fnc" })
	private CalcFnc calcFnc = CalcFnc.AVG;

	@JsonAlias({ "type" })
	private GraphItemType type = GraphItemType.SIMPLE;

	// store item key here
	@JsonAlias({ "metric_key", "name" })
	private String metricKey;

	public enum DrawType implements ZabbixValue {

		LINE(0), FILLED_REGION(1), BOLD_LINE(2), DOT(3), DASHED_LINE(4), GRADIENT_LINE(5);
		private int zabbixValue;

		DrawType(int zabbixValue) {
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

	private ArrayList<String> graphColors = new ArrayList<String>(
			Arrays.asList("1A7C11", "2774A4", "F63100", "A54F10", "FC6EA3", "6C59DC", "AC8C14", "611F27", "F230E0"));

	public enum YAxisSide implements ZabbixValue {

		LEFT(0), RIGHT(1);

		private int zabbixValue;

		YAxisSide(int zabbixValue) {
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

	public enum CalcFnc implements ZabbixValue {

		MIN(1), AVG(2), MAX(4), ALL(7), LAST(9);

		private int zabbixValue;

		CalcFnc(int zabbixValue) {
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

	// for Graph item object
	public enum GraphItemType implements ZabbixValue {

		SIMPLE(0), GRAPH_SUM(2);

		private int zabbixValue;

		GraphItemType(int zabbixValue) {
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

	public int getSortOrder() {
		return sortOrder;
	}

	public void setSortOrder(int sortOrder) {
		this.sortOrder = sortOrder;
	}

	public DrawType getDrawType() {
		return drawType;
	}

	public void setDrawType(DrawType drawType) {
		this.drawType = drawType;
	}

	public String getColor() {
		return color;
	}

	public void setColor(String color) {
		this.color = color;
	}

	public YAxisSide getyAxisSide() {
		return yAxisSide;
	}

	public void setyAxisSide(YAxisSide yAxisSide) {
		this.yAxisSide = yAxisSide;
	}

	public CalcFnc getCalcFnc() {
		return calcFnc;
	}

	public void setCalcFnc(CalcFnc calcFnc) {
		this.calcFnc = calcFnc;
	}

	public GraphItemType getType() {
		return type;
	}

	public void setType(GraphItemType type) {
		this.type = type;
	}

	public String getMetricKey() {
		return metricKey;
	}

	public void setMetricKey(String metricKey) {
		this.metricKey = metricKey;
	}

	public ArrayList<String> getGraphColors() {
		return graphColors;
	}

	public void setGraphColors(ArrayList<String> graphColors) {
		this.graphColors = graphColors;
	};

}
