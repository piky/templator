<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<xsl:variable name="historyDefault">30</xsl:variable>
<xsl:variable name="trendsDefault">365</xsl:variable>
<xsl:variable name="updateDefault">30</xsl:variable>
<xsl:variable name="valueType">3</xsl:variable>
	<!-- Type of information of the item. 
	Possible values: 
	0 - numeric float; 
	1 - character; 
	2 - log; 
	3 - numeric unsigned; 
	4 - text. -->


<xsl:template match="node()|@*">
   <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
   </xsl:copy>
</xsl:template>


<xsl:template match="template/metrics/cpuLoad">
	<xsl:copy>
		<name>Cpu Load</name>
		<group>Cpu</group>
		<xsl:copy-of select="oid"></xsl:copy-of>
		<xsl:copy-of select="snmpObject"></xsl:copy-of>
		<xsl:copy-of select="mib"></xsl:copy-of>
		<xsl:copy-of select="./expressionFormula"></xsl:copy-of>
		<xsl:copy-of select="ref"></xsl:copy-of>
		<xsl:copy-of select="vendorDescription"></xsl:copy-of>
		<description>Cpu load in %</description>
		<history><xsl:copy-of select="$historyDefault"/></history>
		<trends><xsl:copy-of select="$trendsDefault"/></trends>
		<units>%</units>
		<update><xsl:copy-of select="$updateDefault"/></update>
		<valueType><xsl:copy-of select="$valueType"/></valueType>
		<xsl:copy-of select="./discoveryRule"></xsl:copy-of>
		<triggers>
			<trigger>
				<expression>{<xsl:value-of select="../../name"></xsl:value-of>:<xsl:value-of select="snmpObject"></xsl:value-of>.avg(300)}>90</expression>
                <name>CPU load is too high</name>
                <url/>
                <priority>3</priority>
                <description/>
			</trigger>
		</triggers>
	</xsl:copy>
</xsl:template>


<xsl:template match="template/metrics/cpuUtil">
	<xsl:copy>
		<name>Cpu Util</name>
		<group>Cpu</group>
		<xsl:copy-of select="oid"></xsl:copy-of>
		<xsl:copy-of select="snmpObject"></xsl:copy-of>
		<xsl:copy-of select="mib"></xsl:copy-of>
		<xsl:copy-of select="./expressionFormula"></xsl:copy-of>
		<xsl:copy-of select="ref"></xsl:copy-of>
		<xsl:copy-of select="vendorDescription"></xsl:copy-of>
		<history><xsl:copy-of select="$historyDefault"/></history>
		<trends><xsl:copy-of select="$trendsDefault"/></trends>
		<units></units>
		<update><xsl:copy-of select="$updateDefault"/></update>
		<valueType><xsl:copy-of select="$valueType"/></valueType>
		<xsl:copy-of select="./discoveryRule"></xsl:copy-of>
	</xsl:copy>
</xsl:template>

<xsl:template match="template/metrics/memoryFree">
	<xsl:copy>
		<name>Free memory</name>
		<group>Memory</group>
		<xsl:copy-of select="oid"></xsl:copy-of>
		<xsl:copy-of select="snmpObject"></xsl:copy-of>
		<xsl:copy-of select="mib"></xsl:copy-of>
		<xsl:copy-of select="./expressionFormula"></xsl:copy-of>
		<xsl:copy-of select="ref"></xsl:copy-of>
		<xsl:copy-of select="vendorDescription"></xsl:copy-of>
		<history><xsl:copy-of select="$historyDefault"/></history>
		<trends><xsl:copy-of select="$trendsDefault"/></trends>
		<units>B</units>
		<update><xsl:copy-of select="$updateDefault"/></update>
		<valueType><xsl:copy-of select="$valueType"/></valueType>
		<xsl:copy-of select="./discoveryRule"></xsl:copy-of>
	</xsl:copy>
</xsl:template>


<xsl:template match="template/metrics/memoryUsed">
	<xsl:copy>
		<name>Used memory</name>
		<group>Memory</group>
		<xsl:copy-of select="oid"></xsl:copy-of>
		<xsl:copy-of select="snmpObject"></xsl:copy-of>
		<xsl:copy-of select="mib"></xsl:copy-of>
		<xsl:copy-of select="./expressionFormula"></xsl:copy-of>
		<xsl:copy-of select="ref"></xsl:copy-of>
		<xsl:copy-of select="vendorDescription"></xsl:copy-of>
		<description>Used memory in bytes</description>
		<history><xsl:copy-of select="$historyDefault"/></history>
		<trends><xsl:copy-of select="$trendsDefault"/></trends>
		<units>B</units>
		<update><xsl:copy-of select="$updateDefault"/></update>
		<valueType><xsl:copy-of select="$valueType"/></valueType>
		<xsl:copy-of select="./discoveryRule"></xsl:copy-of>
	</xsl:copy>
</xsl:template>


<xsl:template match="template/metrics/memoryUsedPercentage">
	<xsl:copy>
		<name>Memory utilization</name>
		<group>Memory</group>
		<xsl:copy-of select="oid"></xsl:copy-of>
		<xsl:copy-of select="snmpObject"></xsl:copy-of>
		<xsl:copy-of select="mib"></xsl:copy-of>
		<xsl:choose>
			<xsl:when test="./calculated = 'true'">
				<expressionFormula>last(<xsl:value-of select="../memoryUsed/snmpObject"/>)/(last(<xsl:value-of select="../memoryFree/snmpObject"/>)+last(<xsl:value-of select="../memoryUsed/snmpObject"/>))</expressionFormula>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>
		<xsl:copy-of select="ref"></xsl:copy-of>
		<xsl:copy-of select="vendorDescription"></xsl:copy-of>
		<description>Memory utilization in %</description>
		<history><xsl:copy-of select="$historyDefault"/></history>
		<trends><xsl:copy-of select="$trendsDefault"/></trends>
		<units>%</units>
		<update><xsl:copy-of select="$updateDefault"/></update>
		<valueType><xsl:copy-of select="$valueType"/></valueType>
		<xsl:copy-of select="./discoveryRule"></xsl:copy-of>
		<triggers>
			<trigger>
				<expression>{<xsl:value-of select="../../name"></xsl:value-of>:<xsl:value-of select="snmpObject"></xsl:value-of>.avg(300)}>90</expression>
                <name>Memory utilization is too high</name>
                <url/>
                <priority>3</priority>
                <description/>
			</trigger>
		</triggers>
	</xsl:copy>
</xsl:template>
</xsl:stylesheet>