package org.zabbix.template.generator.objects;

import java.util.ArrayList;


import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

//@JsonDeserialize(using = TriggerDeserializer.class)
public class Graph {

	private String prototype;
	private String name;
	private int width = 900;
	private int height = 200;

	@JsonAlias({"graphtype"})
	private GraphType graphType = GraphType.NORMAL;


	@JsonAlias({"percent_left"})
	private float percentLeft = 0;
	@JsonAlias({"percent_right"})
	private float percentRight = 0;
	@JsonAlias({"show_3d"})
	private int show3d = 0;
	@JsonAlias({"show_legend"})
	private int showLegend = 1;
	@JsonAlias({"show_triggers"})
	private int showTriggers = 1;
	@JsonAlias({"show_work_period"})
	private int showWorkPeriod = 1;

	@JsonAlias({"yaxismax"})
	private float yAxisMax = 100;

	@JsonAlias({"yaxismin"})
	private float yAxisMin = 0;

	@JsonAlias({"ymax_type"})
	private YType yMaxType = YType.CALCULATED;

	@JsonAlias({"ymin_type"})
	private YType yMinType = YType.CALCULATED;

	@JsonAlias({"gitems","graph_items"})
	private ArrayList<GraphItem> graphItems = new ArrayList<GraphItem>(0);








	//for Graph item object


	public enum GraphType implements ZabbixValue {

		NORMAL(0),
		STACKED(1),
		PIE(2),
		EXPLODED(3);
		private int zabbixValue;

		GraphType(int zabbixValue){
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

	//for ymax_type,ymin_type
	public enum YType implements ZabbixValue {

		CALCULATED(0),
		FIXED(1),
		ITEM(3);
		private int zabbixValue;

		YType(int zabbixValue){
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

	public String getPrototype() {
		return prototype;
	}

	public void setPrototype(String prototype) {
		this.prototype = prototype;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getWidth() {
		return width;
	}

	public void setWidth(int width) {
		this.width = width;
	}

	public int getHeight() {
		return height;
	}

	public void setHeight(int height) {
		this.height = height;
	}

	public GraphType getGraphType() {
		return graphType;
	}

	public void setGraphType(GraphType graphType) {
		this.graphType = graphType;
	}

	public float getPercentLeft() {
		return percentLeft;
	}

	public void setPercentLeft(float percentLeft) {
		this.percentLeft = percentLeft;
	}

	public float getPercentRight() {
		return percentRight;
	}

	public void setPercentRight(float percentRight) {
		this.percentRight = percentRight;
	}

	public int getShow3d() {
		return show3d;
	}

	public void setShow3d(int show3d) {
		this.show3d = show3d;
	}

	public int getShowLegend() {
		return showLegend;
	}

	public void setShowLegend(int showLegend) {
		this.showLegend = showLegend;
	}

	public int getShowTriggers() {
		return showTriggers;
	}

	public void setShowTriggers(int showTriggers) {
		this.showTriggers = showTriggers;
	}

	public int getShowWorkPeriod() {
		return showWorkPeriod;
	}

	public void setShowWorkPeriod(int showWorkPeriod) {
		this.showWorkPeriod = showWorkPeriod;
	}

	public float getyAxisMax() {
		return yAxisMax;
	}

	public void setyAxisMax(float yAxisMax) {
		this.yMaxType = YType.FIXED;
		this.yAxisMax = yAxisMax;
	}

	public float getyAxisMin() {
		return yAxisMin;
	}

	public void setyAxisMin(float yAxisMin) {
		this.yMinType = YType.FIXED;
		this.yAxisMin = yAxisMin;
	}

	public YType getyMaxType() {
		return yMaxType;
	}

	public void setyMaxType(YType yMaxType) {
		this.yMaxType = yMaxType;
	}

	public YType getyMinType() {
		return yMinType;
	}

	public void setyMinType(YType yMinType) {
		this.yMinType = yMinType;
	}

	public ArrayList<GraphItem> getGraphItems() {
		return graphItems;
	}

	public void setGraphItems(ArrayList<GraphItem> graphItems) {
		this.graphItems = graphItems;
	};		




}
