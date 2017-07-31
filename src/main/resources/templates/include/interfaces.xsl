<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xpath-default-namespace="http://www.example.org/zbx_template_new/"
				xmlns="http://www.example.org/zbx_template_new/">

<xsl:output method="xml" indent="yes"/>


<xsl:template match="template/metrics/net.if.status">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">Interface operational status</name>
			<name lang="RU">Текущий статус интерфейса</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<triggers>
				<trigger>
				    <documentation>This trigger expression works as follows:
1. Can be triggered if ifOperStatus = 2
2. {$IFCONTROL:"{#IFNAME}"}=1 - user can redefine Context macro to value - 0. That marks this interface as not important. No new trigger will be fired if this interface is down.
if IFNAME not available - use SNMPINDEX (IFINDEX))
3. {TEMPLATE_NAME:METRIC.diff()}=1) - trigger fires only ifOperStatus ever was up(1) before. (do not fire ethernal off interfaces.)
WARNING. if closed manually - won't fire again on next poll. because of .diff. Thats why manually closing it is disabled.
</documentation>
				    <id>if.down</id>
					<expression>{$IFCONTROL:"{#IFNAME}"}=1 and ({TEMPLATE_NAME:METRIC.last()}=2 and {TEMPLATE_NAME:METRIC.diff()}=1)</expression>
					<manual_close>0</manual_close>
	                <name lang="EN">Interface is down</name>
	                <name lang="RU">Интерфейс недоступен</name>
	                <url/>
	                <priority>3</priority>
	                <description lang="EN">Interface is down</description>
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
	 <xsl:variable name="discoveryRule" select="discoveryRule"/>
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">Bits in</name>
			<name lang="RU">Трафик входящий</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$historyDefault"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update3min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<units>bps</units>
			<triggers>
				<xsl:choose>
					<xsl:when test="(ancestor::metrics/net.if.speed[discoveryRule=$discoveryRule] or (ancestor::metrics/net.if.speed[not(discoveryRule)] and not(discoveryRule)))
					and (ancestor::metrics/net.if.out[discoveryRule=$discoveryRule] or (ancestor::metrics/net.if.out[not(discoveryRule)] and not(discoveryRule)))">
					<xsl:variable name="speedMetricKey"><xsl:value-of select="ancestor::metrics/net.if.speed/name()"/>[<xsl:value-of select="ancestor::metrics/net.if.speed/snmpObject"/>]</xsl:variable>
					<xsl:variable name="outMetricKey"><xsl:value-of select="ancestor::metrics/net.if.out/name()"/>[<xsl:value-of select="ancestor::metrics/net.if.out/snmpObject"/>]</xsl:variable>
					<trigger>
					    <documentation/>
					    <id>if.util_high</id>
						<expression>{TEMPLATE_NAME:METRIC.avg(5m)}>({$IF_UTIL_MAX:"{#IFNAME}"}/100)*{TEMPLATE_NAME:<xsl:value-of select="$speedMetricKey"/>.last()} or
{TEMPLATE_NAME:<xsl:value-of select="$outMetricKey"/>.avg(5m)}>({$IF_UTIL_MAX:"{#IFNAME}"}/100)*{TEMPLATE_NAME:<xsl:value-of select="$speedMetricKey"/>.last()}</expression>
						<recovery_expression/>
						<manual_close>1</manual_close>
		                <name lang="EN">Interface high bandwidth usage >{$IF_UTIL_MAX:"{#IFNAME}"}%</name>
		                <name lang="RU">Интерфейс сильно загружен >{$IF_UTIL_MAX:"{#IFNAME}"}%</name>
		                <url/>
		                <priority>2</priority>
		                <description lang="EN"></description>
		                <description lang="RU"></description>
		               	<dependsOn>
	                		<dependency>if.down</dependency>
	               		</dependsOn>
	              	    <tags>
		                	<tag>
				 				<tag>Alarm.type</tag>
				                <value>IF_UTIL_HIGH</value>
							</tag>
						</tags>
					</trigger>
					</xsl:when>
					<xsl:otherwise><xsl:message terminate="yes">Please check net.if.speed and net.if.out</xsl:message></xsl:otherwise>
				</xsl:choose>
			</triggers>
			<graphs>
				<graph>
					<name>Interface traffic</name>
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
	 <xsl:variable name="discoveryRule" select="discoveryRule"/>
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">Bits out</name>
			<name lang="RU">Трафик исходящий</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$historyDefault"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update3min"/></update>
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
	<xsl:variable name="discoveryRule" select="discoveryRule"/>
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">Errors in</name>
			<name lang="RU">Ошибки входящие</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update5min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<triggers>
				<xsl:choose>
					<xsl:when test="ancestor::metrics/net.if.out.errors[discoveryRule=$discoveryRule] or (ancestor::metrics/net.if.out.errors[not(discoveryRule)] and not(discoveryRule))">
						<xsl:variable name="outErrorsMetricKey"><xsl:value-of select="ancestor::metrics/net.if.out.errors/name()"/>[<xsl:value-of select="ancestor::metrics/net.if.out.errors/snmpObject"/>]</xsl:variable>
						<trigger>
						<documentation/>
					    <id>if.errors</id>
						<expression>{TEMPLATE_NAME:METRIC.avg(5m)}>{$IF_ERRORS_WARN:"{#IFNAME}"}
or {TEMPLATE_NAME:<xsl:value-of select="$outErrorsMetricKey"/>.avg(5m)}>{$IF_ERRORS_WARN:"{#IFNAME}"}</expression>
						<recovery_expression>{TEMPLATE_NAME:METRIC.avg(5m)}&lt;{$IF_ERRORS_WARN:"{#IFNAME}"}-2
and {TEMPLATE_NAME:<xsl:value-of select="$outErrorsMetricKey"/>.avg(5m)}&lt;{$IF_ERRORS_WARN:"{#IFNAME}"}-2</recovery_expression>
						<manual_close>1</manual_close>
		                <name lang="EN">Interface high error rate</name>
		                <name lang="RU">Большое количество ошибок интерфейса</name>
		                <url/>
		                <priority>2</priority>
		                <description lang="EN"></description>
		                <description lang="RU"></description>
		               	<dependsOn>
	                		<dependency>if.down</dependency>
	               		</dependsOn>
	              	    <tags>
		                	<tag>
				 				<tag>Alarm.type</tag>
				                <value>IF_ERRORS_HIGH</value>
							</tag>
						</tags>
						</trigger>
					</xsl:when>
					<xsl:otherwise><xsl:message terminate="yes">Please check net.if.out.errors</xsl:message></xsl:otherwise>
				</xsl:choose>
			</triggers>
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
			<name lang="EN">Errors out</name>
			<name lang="RU">Ошибки исходящие</name>
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
			<name lang="EN">SNMP traps (interfaces)</name>
			<name lang="RU">SNMP traps (интерфейсы)</name>
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
			<name lang="EN">Packets discarded in</name>
			<name lang="RU">Пакетов отброшено (входящих)</name>
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
			<name lang="EN">Packets discarded out</name>
			<name lang="RU">Пакетов отброшено (исходящих)</name>
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
	 <xsl:variable name="discoveryRule" select="discoveryRule"/>
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">Speed</name>
			<name lang="RU">Скорость</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update5min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<units>bps</units>
			<triggers>
				<xsl:choose>
					<xsl:when test="ancestor::metrics/net.if.type[discoveryRule=$discoveryRule] or (ancestor::metrics/net.if.type[not(discoveryRule)] and not(discoveryRule))">
						<xsl:variable name="typeMetricKey"><xsl:value-of select="ancestor::metrics/net.if.type/name()"/>[<xsl:value-of select="ancestor::metrics/net.if.type/snmpObject"/>]</xsl:variable>
						<trigger>
							<documentation>Might be problems with Mikrotik</documentation>
						    <id>if.speed.not_max</id>
							<expression>{TEMPLATE_NAME:METRIC.change()}&lt;0 and {TEMPLATE_NAME:METRIC.last()}&gt;0
and (
{TEMPLATE_NAME:<xsl:value-of select="$typeMetricKey"/>.last()}=6 or
{TEMPLATE_NAME:<xsl:value-of select="$typeMetricKey"/>.last()}=7 or
{TEMPLATE_NAME:<xsl:value-of select="$typeMetricKey"/>.last()}=11 or
{TEMPLATE_NAME:<xsl:value-of select="$typeMetricKey"/>.last()}=62 or
{TEMPLATE_NAME:<xsl:value-of select="$typeMetricKey"/>.last()}=69 or
{TEMPLATE_NAME:<xsl:value-of select="$typeMetricKey"/>.last()}=117
)
</expression>
							<recovery_expression>{TEMPLATE_NAME:METRIC.change()}&gt;0 and {TEMPLATE_NAME:METRIC.prev()}&gt;0</recovery_expression>>
							<manual_close>1</manual_close>
			                <name lang="EN">Interface of type Ethernet has changed to lower speed than it was before</name>
			                <name lang="RU">Интерфейс перешел на более низкую скорость, чем был ранее</name>
			                <url/>
			                <priority>1</priority>
			                <description>This Ethernet connection has transitioned down from its known maximum speed. This might be a sign of autonegotiation issues. Ack to close.</description>
			               	<dependsOn>
			               		<dependency>if.down</dependency>
			              		</dependsOn>
			             	    <tags>
			                	<tag>
					 				<tag>Alarm.type</tag>
					                <value>IF_SPEED_NOT_MAX</value>
								</tag>
							</tags>
						</trigger>
					</xsl:when>
					<xsl:otherwise><xsl:message>Please check the availability of net.if.type</xsl:message></xsl:otherwise>
				</xsl:choose>
			</triggers>
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
			<name lang="EN">Interface type</name>
			<name lang="RU">Тип интерфейса</name>
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
			<name lang="EN">Interface duplex status</name>
			<name lang="RU">Duplex статус интерфейса</name>
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
		                <name lang="EN">Interface is in half-duplex mode</name>
		                <name lang="RU">Интерфейс в режиме half-duplex</name>
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

