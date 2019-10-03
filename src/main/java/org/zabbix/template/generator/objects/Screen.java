package org.zabbix.template.generator.objects;

import java.util.ArrayList;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(value = Include.NON_EMPTY)
public class Screen {

	private String name;
	private int hsize;
	private int vsize;

	@JsonProperty("screen_items")
	private ArrayList<ScreenItem> screenItems = new ArrayList<ScreenItem>(0);

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public int getHsize() {
		return hsize;
	}

	public void setHsize(int hsize) {
		this.hsize = hsize;
	}

	public int getVsize() {
		return vsize;
	}

	public void setVsize(int vsize) {
		this.vsize = vsize;
	}

	public ArrayList<ScreenItem> getScreenItems() {
		return screenItems;
	}

	public void setScreenItems(ArrayList<ScreenItem> screenItems) {
		this.screenItems = screenItems;
	}

	
}
