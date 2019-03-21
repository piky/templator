package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

@JsonDeserialize(using = TriggerDeserializer.None.class)
public class TriggerDefault extends Trigger {

}
