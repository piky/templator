package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
//TODO: JsonDeserialize is required in every new non-abstract calss. Can this be somehow fixed?
@JsonDeserialize(using=MetricDeserializer.None.class)
public class CPUTemperatureMetric extends TemperatureMetric {

	
	public CPUTemperatureMetric() {
		this.setName("CPU temperature");
		
	}

}
