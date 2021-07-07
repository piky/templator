package org.zabbix.template.generator.objects;

import java.util.ArrayList;
import java.util.TreeSet;

import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(value = Include.NON_EMPTY)
public class HostPrototype {

    public enum Status implements ZabbixValue {

		ENABLED(0), DISABLED(1);

		private int zabbixValue;

		Status(int zabbixValue) {
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

	public enum Discover implements ZabbixValue {

		DISCOVER(0), NOT_DISCOVER(1);

		private int zabbixValue;

		Discover(int zabbixValue) {
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

    private String host;
    private String name;
    private Status status = Status.ENABLED;
    private Discover discover = Discover.DISCOVER;
    private ArrayList<TemplateClass> groups = new ArrayList<TemplateClass>(0);
    private TreeSet<UserMacro> macros = new TreeSet<>();

    @JsonAlias("group_prototypes")
    private ArrayList<String> groupPrototypes = new ArrayList<String>();
    private ArrayList<String> templates = new ArrayList<String>();

	@JsonAlias("custom_interfaces")
	private String customInterfaces;

    private TreeSet<HostPrototypeInterface> interfaces = new TreeSet<>();

    public ArrayList<TemplateClass> getGroups() {
		return groups;
	}

	public void setGroups(ArrayList<TemplateClass> groups) {
		this.groups = groups;
	}

    public TreeSet<UserMacro> getMacros() {
		return macros;
	}

	public void setMacros(TreeSet<UserMacro> macros) {
		this.macros = macros;
    }

    public ArrayList<String> getGroupPrototypes() {
		return groupPrototypes;
	}

	public void setGroupPrototypes(ArrayList<String> groupPrototypes) {
		this.groupPrototypes = groupPrototypes;
    }

    public ArrayList<String> getTemplates() {
		return templates;
	}

	public void setTemplates(ArrayList<String> templates) {
		this.templates = templates;
	}

    public Status getStatus() {
		return status;
	}

	public void setStatus(Status status) {
		this.status = status;
	}

	public String getHost() {
		return host;
	}

	public void setHost(String host) {
		this.host = host;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Discover getDiscover() {
		return discover;
	}

	public void setDiscover(Discover discover) {
		this.discover = discover;
	}

	public String getCustomInterfaces() {
		return customInterfaces;
	}

	public void setCustomInterfaces(String customInterfaces) {
		this.customInterfaces = customInterfaces;
	}

    public TreeSet<HostPrototypeInterface> getInterfaces() {
		return interfaces;
	}

	public void setInterfaces(TreeSet<HostPrototypeInterface> interfaces) {
		this.interfaces = interfaces;
    }

}
