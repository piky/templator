
package org.zabbix.template.generator.objects;

import java.util.ArrayList;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonAlias;

public class TemplateDocumentation {

	@JsonAlias("_overview")
	private String overview;

	@JsonAlias("_issues")
	private ArrayList<Issue> issues = new ArrayList<Issue>(0);

	// provide setup instructions here
	@JsonProperty(value = "_setup")
	private String setup;

	// provide zabbix configuration instructions
	@JsonProperty(value = "_zabbix_config")
	private String zabbixConfig;

	@JsonProperty(value = "_tested_on")
	private ArrayList<Resource> testedOn = new ArrayList<Resource>(0);

	public String getOverview() {
		return overview;
	}

	public void setOverview(String overview) {
		this.overview = overview;
	}

	public ArrayList<Issue> getIssues() {
		return issues;
	}

	public void setIssues(ArrayList<Issue> issues) {
		this.issues = issues;
	}

	public String getSetup() {
		return setup;
	}

	public void setSetup(String setup) {
		this.setup = setup;
	}

	public String getZabbixConfig() {
		return zabbixConfig;
	}

	public void setZabbixConfig(String zabbixConfig) {
		this.zabbixConfig = zabbixConfig;
	}

	public ArrayList<Resource> getTestedOn() {
		return testedOn;
	}

	public void setTestedOn(ArrayList<Resource> testedOn) {
		this.testedOn = testedOn;
	}

	public static class Issue {
		private String description;
		private String version;
		private String device;

		public String getDescription() {
			return description;
		}

		public void setDescription(String description) {
			this.description = description;
		}

		public String getVersion() {
			return version;
		}

		public void setVersion(String version) {
			this.version = version;
		}

		public String getDevice() {
			return device;
		}

		public void setDevice(String device) {
			this.device = device;
		}

	}

	public static class Resource {
		private String name;
		private String version;
		private String oid;

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getVersion() {
			return version;
		}

		public void setVersion(String version) {
			this.version = version;
		}

		public String getOid() {
			return oid;
		}

		public void setOid(String oid) {
			this.oid = oid;
		}

	}
}
