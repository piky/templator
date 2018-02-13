package org.zabbix.template.generator.objects;

public class MetricNotFoundException extends RuntimeException {

	public MetricNotFoundException(String m,Throwable t) {
		super(m, t);
	}

}
