<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>


<xsl:template match="template/metrics/net.if.status">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifOperStatus</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<triggers>
				<trigger>
				    <documentation>This trigger expression work as follows:
1. Can be triggered from linkDown trap
2. Can be triggered if ifOperStatus = 2
3. TRIGGER.VALUE wrappers and avg(1s) are used to make sure that only metrics with actual values are used to determine proper  trigger's condition.
4. {$IFCONTROL:"{#IFNAME}"}=1 - user can redefine Context macro to value - 0. That marks this interface as not important. No new trigger will be fired if this interface is down.
if IFNAME not available - use SNMPINDEX (IFINDEX))
5. {TEMPLATE_NAME:METRIC.diff()}=1) - trigger fires only ifOperStatus ever was up(1) before. (do not fire ethernal off interfaces.)
6. if ifAdminStatus is not up. then the trigger will not fire. 
WARNING. if closed manually - won't fire again on next poll. because of .diff
</documentation>
				    <id>if.down</id>
					<!-- will not expand MACRO in SNMPINDEX inside str function in 3.2, only in 3.4-->
					<expression>{$IFCONTROL:"{#IFNAME}"}=1 and ({TRIGGER.VALUE}=0 and (
({TEMPLATE_NAME:METRIC.avg(1s)}=2 and {TEMPLATE_NAME:METRIC.diff()}=1) or
({TEMPLATE_NAME:snmptrap[".1.3.6.1.6.3.1.1.4.1.0         type=6  value=OID: .1.3.6.1.6.3.1.1.5.[3-4]"].str("  .1.3.6.1.2.1.2.2.1.1           type=2  value=INTEGER: {#SNMPINDEX}",1s)}=1 and
{TEMPLATE_NAME:snmptrap[".1.3.6.1.6.3.1.1.4.1.0         type=6  value=OID: .1.3.6.1.6.3.1.1.5.[3-4]"].str(".1.3.6.1.6.3.1.1.5.3",1s)}=1)))</expression>
					<recovery_expression>{$IFCONTROL:"{#IFNAME}"}=0 or ({TRIGGER.VALUE}=1 and (
{TEMPLATE_NAME:METRIC.avg(1s)}=1 or
({TEMPLATE_NAME:snmptrap[".1.3.6.1.6.3.1.1.4.1.0         type=6  value=OID: .1.3.6.1.6.3.1.1.5.[3-4]"].str("  .1.3.6.1.2.1.2.2.1.1           type=2  value=INTEGER: {#SNMPINDEX}",1s)}=1 and
{TEMPLATE_NAME:snmptrap[".1.3.6.1.6.3.1.1.4.1.0         type=6  value=OID: .1.3.6.1.6.3.1.1.5.[3-4]"].str(".1.3.6.1.6.3.1.1.5.4",1s)}=1)))</recovery_expression>
					<manual_close>0</manual_close>
	                <name lang="EN"><xsl:value-of select="alarmObject"/> is down</name>1
	                <name lang="RU"><xsl:value-of select="alarmObject"/> недоступен</name>
	                <url/>
	                <priority>3</priority>
	                <description lang="EN">linkDown</description>
	                <description lang="RU">интерфейс недоступен</description>
              	    <tags>
	                	<tag>
			 				<tag>Alarm.type</tag>
			                <value>LINK_DOWN</value>
						</tag>
					</tags>
				</trigger>
			</triggers>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

<xsl:template match="template/metrics/net.if.in">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifOctetsIn</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$historyDefault"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update1min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<units>bps</units>
			<triggers>
				<trigger>
				    <documentation>
</documentation>
				    <id>if.high_usage</id>
					<expression>{<xsl:value-of select="../../name"/>:METRIC.avg(5m)}>({$IF_UTIL_MAX:"{#IFNAME}"}/100)*IFSPEED
					{$IF_UTIL_MAX:"{#IFNAME}"}=1 and ({TRIGGER.VALUE}=0 and (
({TEMPLATE_NAME:METRIC.avg(1s)}=2 and {TEMPLATE_NAME:METRIC.diff()}=1) or
({TEMPLATE_NAME:snmptrap[".1.3.6.1.6.3.1.1.4.1.0         type=6  value=OID: .1.3.6.1.6.3.1.1.5.[3-4]"].str("  .1.3.6.1.2.1.2.2.1.1           type=2  value=INTEGER: {#SNMPINDEX}",1s)}=1 and
{TEMPLATE_NAME:snmptrap[".1.3.6.1.6.3.1.1.4.1.0         type=6  value=OID: .1.3.6.1.6.3.1.1.5.[3-4]"].str(".1.3.6.1.6.3.1.1.5.3",1s)}=1)))</expression>
					<recovery_expression>{$IFCONTROL:"{#IFNAME}"}=0 or ({TRIGGER.VALUE}=1 and (
{TEMPLATE_NAME:METRIC.avg(1s)}=1 or
({TEMPLATE_NAME:snmptrap[".1.3.6.1.6.3.1.1.4.1.0         type=6  value=OID: .1.3.6.1.6.3.1.1.5.[3-4]"].str("  .1.3.6.1.2.1.2.2.1.1           type=2  value=INTEGER: {#SNMPINDEX}",1s)}=1 and
{TEMPLATE_NAME:snmptrap[".1.3.6.1.6.3.1.1.4.1.0         type=6  value=OID: .1.3.6.1.6.3.1.1.5.[3-4]"].str(".1.3.6.1.6.3.1.1.5.4",1s)}=1)))</recovery_expression>
					<manual_close>0</manual_close>
	                <name lang="EN"><xsl:value-of select="alarmObject"/> high bandwidth</name>
	                <name lang="RU"><xsl:value-of select="alarmObject"/> загружен</name>
	                <url/>
	                <priority>3</priority>
	                <description lang="EN"></description>
	                <description lang="RU"></description>
              	    <tags>
	                	<tag>
			 				<tag>Alarm.type</tag>
			                <value>LINK_DOWN</value>
						</tag>
					</tags>
				</trigger>
			</triggers>			
			<graphs>
				<graph>
					<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>traffic</name>
					<graphItems>
						<item>
							<drawtype>gradient</drawtype>
							<name>net.if.in</name>
							<yaxisside>left</yaxisside>
						</item>
						<item>
							<drawtype>bold_line</drawtype>
							<name>net.if.out</name>
							<yaxisside>left</yaxisside>
						</item>
						<item>
							<drawtype>line</drawtype>
							<name>net.if.out.errors</name>
							<yaxisside>right</yaxisside>
						</item>
						<item>
							<drawtype>line</drawtype>
							<name>net.if.in.errors</name>
							<yaxisside>right</yaxisside>
						</item>
						<item>
							<drawtype>line</drawtype>
							<name>net.if.out.discards</name>
							<yaxisside>right</yaxisside>
						</item>
						<item>
							<drawtype>line</drawtype>
							<name>net.if.in.discards</name>
							<yaxisside>right</yaxisside>
						</item>
					</graphItems>
				</graph>
			</graphs>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>


<xsl:template match="template/metrics/net.if.out">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifOctetsOut</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$historyDefault"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update1min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<units>bps</units>
			<triggers/>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>


<xsl:template match="template/metrics/net.if.in.errors">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifErrorsIn</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update5min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<triggers/>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

<xsl:template match="template/metrics/net.if.out.errors">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifErrorsOut</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update5min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<triggers/>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>


<xsl:template match="template/metrics/net.if.traps">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>SNMP traps (interfaces)</name>
			<group>Interfaces</group>
			<logFormat>hh:mm:sszyyyy/MM/dd</logFormat>
			<description>Item is used to collect all SNMP traps matched for interfaces</description>
			<zabbixKey>snmptrap[".1.3.6.1.6.3.1.1.4.1.0         type=6  value=OID: .1.3.6.1.6.3.1.1.5.[3-4]"]</zabbixKey><!-- link up or linkdown -->
			<vendorDescription>Catching linkDown and linkUp traps</vendorDescription>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<valueType><xsl:copy-of select="$valueTypeLog"/></valueType>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>
</xsl:template>



<xsl:template match="template/metrics/net.if.in.discards">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifDiscardsIn</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update5min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<triggers/>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

<xsl:template match="template/metrics/net.if.out.discards">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifDiscardsOut</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update5min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<triggers/>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>


<xsl:template match="template/metrics/net.if.speed">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifSpeed</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1hour"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<units>bps</units>
			<triggers/>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

<xsl:template match="template/metrics/net.if.type">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifType</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1hour"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<triggers/>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>


<xsl:template match="template/metrics/net.if.duplex">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifDuplexStatus</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update5min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<triggers>
					<trigger>
					    <documentation/>
					    <id>if.halfduplex</id>
						<expression>{TEMPLATE_NAME:METRIC.last()}=2</expression>
						<recovery_expression/>
						<manual_close>1</manual_close>
		                <name lang="EN"><xsl:value-of select="alarmObject"/> in half-duplex mode</name>
		                <name lang="RU"><xsl:value-of select="alarmObject"/> в режиме half-duplex</name>
		                <url/>
		                <priority>2</priority>
		                <description>Please check autonegotiation settings and cabling</description>
		               	<dependsOn/>
	              	    <tags>
		                	<tag>
				 				<tag>Alarm.type</tag>
				                <value>IF_HALF_DUPLEX</value>
							</tag>
						</tags>
					</trigger>
			</triggers>	
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>


</xsl:stylesheet>

