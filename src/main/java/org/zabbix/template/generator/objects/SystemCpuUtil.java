package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
//TODO: JsonDeserialize is required in every new non-abstract calss. Can this be somehow fixed?
@JsonDeserialize(using=MetricDeserializer.None.class)
public class SystemCpuUtil extends PercentageUtilizationMetric {

	
	public SystemCpuUtil() {
		this.setName("CPU utilization");
		this.setGroup(Group.CPU);
		this.setDescription("CPU utilization in %");
		this.setUnits("%");
		this.setValueType(ValueType.FLOAT);
		/*<update><xsl:value-of select="$update3min"/></update>*/
		/*<valueType><xsl:value-of select="$valueTypeFloat"/></valueType>*/
		
	}

}
