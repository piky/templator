
package org.zabbix.template.generator.objects;

import java.util.ArrayList;

import com.fasterxml.jackson.annotation.JsonProperty;

public class TemplateDocumentation {
	private String overview;
	private ArrayList<Issue> issues = new ArrayList<Issue>(0);

	@JsonProperty(value = "device_setup")
	private String deviceSetup;

	@JsonProperty(value = "known_devices")
	private ArrayList<Device> knownDevices = new ArrayList<Device>(0);

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

	public String getDeviceSetup() {
		return deviceSetup;
	}

	public void setDeviceSetup(String deviceSetup) {
		this.deviceSetup = deviceSetup;
	}

	public ArrayList<Device> getKnownDevices() {
		return knownDevices;
	}

	public void setKnownDevices(ArrayList<Device> knownDevices) {
		this.knownDevices = knownDevices;
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

	public static class Device {
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
