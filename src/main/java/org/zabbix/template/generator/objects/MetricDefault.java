package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

@JsonDeserialize(using=MetricDeserializer.None.class)
public class MetricDefault extends Metric {

}
