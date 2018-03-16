package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;

@JsonDeserialize(using=TemplateDeserializer.None.class)
public class TemplateDefault extends Template {


}
