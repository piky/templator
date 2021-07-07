package org.zabbix.template.generator.objects;

public class HostPrototypeInterface implements Comparable<HostPrototypeInterface> {
	private String ip;
	private String port;

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getPort() {
		return port;
	}

	public void setPort(String port) {
		this.port = port;
	}


	// used in Jackson
	public HostPrototypeInterface() {
	}

	// used in Drools
	public HostPrototypeInterface(String ip, String port) {
		this.ip = ip;
		this.port = port;
	}

	@Override
	public int compareTo(HostPrototypeInterface o) {
		return this.getIp().compareTo(o.getIp());
	}

}
