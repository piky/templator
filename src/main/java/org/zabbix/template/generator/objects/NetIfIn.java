package org.zabbix.template.generator.objects;

import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
//TODO: JsonDeserialize is required in every new non-abstract calss. Can this be somehow fixed?
@JsonDeserialize(using=MetricDeserializer.None.class)
public class NetIfIn extends Metric {

	
	public NetIfIn() {
		this.setName("Bits received");
		this.setGroup(Group.Network_Interfaces);
		this.setType(Type.SNMP);
		this.setOid("1.3.6.1.2.1.2.2.1.10.{#SNMPINDEX}");
		this.setSnmpObject("ifInOctets.{#SNMPINDEX}");
		this.setMib("IF-MIB");
		/*<update><xsl:value-of select="$update3min"/></update>*/
		/*<valueType><xsl:value-of select="$valueTypeFloat"/></valueType>*/
		
	}

}
