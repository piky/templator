package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

@JsonDeserialize(using=MetricDeserializer.None.class)
public class SensorTempValue extends TemperatureMetric {

	
	public SensorTempValue() {
		this.setName("Temperature");
		this.setDescription("Temperature readings of testpoint: <xsl:value-of select=\"alarmObject\"/>");
		this.setValueType(ValueType.FLOAT);
		this.setGroup(Group.Temperature);
		
	}
}
