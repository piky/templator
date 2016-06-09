<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<xsl:variable name="historyDefault">30</xsl:variable>
<xsl:variable name="trendsDefault">365</xsl:variable>
<xsl:variable name="updateDefault">30</xsl:variable>

<xsl:variable name="valueType">3</xsl:variable>
<xsl:variable name="valueTypeFloat">0</xsl:variable>
<xsl:variable name="valueTypeChar">1</xsl:variable>
<xsl:variable name="valueTypeLog">2</xsl:variable>
<xsl:variable name="valueTypeInt">3</xsl:variable>
<xsl:variable name="valueTypeText">4</xsl:variable>
	<!-- Type of information of the item. 
	Possible values: 
	0 - numeric float; 
	1 - character; 
	2 - log; 
	3 - numeric unsigned; 
	4 - text. -->

<!--  define macros with default values to add into template-->
    <xsl:variable name="MACROS" as="element()*">
        <TEMP_CRIT>60</TEMP_CRIT>
        <TEMP_WARN>50</TEMP_WARN>
    </xsl:variable>


<xsl:template match="node()|@*">
   <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
   </xsl:copy>
</xsl:template>

<xsl:template match="value_maps">
	<value_maps>
		<xsl:copy-of copy-namespaces="no" select="node()|@*"></xsl:copy-of>
	</value_maps>
</xsl:template>

<xsl:template match="template">
     <xsl:copy>
		<xsl:apply-templates select="node()|@*"/>
		<macros>
		<xsl:for-each select="$MACROS">
			<macro>
        		<macro>{$<xsl:value-of select ="name(.)"/>}</macro>
                <value><xsl:value-of select="."/></value>
			</macro>
         </xsl:for-each>
    	</macros>
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
		<valueMap><xsl:value-of select="valueMap"/></valueMap>
		<multiplier><xsl:value-of select="multiplier"/></multiplier>
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
		<valueMap><xsl:value-of select="valueMap"/></valueMap>
		<multiplier><xsl:value-of select="multiplier"/></multiplier>
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
		<valueMap><xsl:value-of select="valueMap"/></valueMap>
		<multiplier><xsl:value-of select="multiplier"/></multiplier>
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
		<valueMap><xsl:value-of select="valueMap"/></valueMap>
		<multiplier><xsl:value-of select="multiplier"/></multiplier>
		<xsl:copy-of select="./discoveryRule"></xsl:copy-of>
	</xsl:copy>
</xsl:template>



<xsl:template match="template/metrics/memoryTotal">
	<xsl:copy>
		<name>Total memory</name>
		<group>Memory</group>
		<xsl:copy-of select="oid"></xsl:copy-of>
		<xsl:copy-of select="snmpObject"></xsl:copy-of>
		<xsl:copy-of select="mib"></xsl:copy-of>
		<xsl:copy-of select="./expressionFormula"></xsl:copy-of>
		<xsl:copy-of select="ref"></xsl:copy-of>
		<xsl:copy-of select="vendorDescription"></xsl:copy-of>
		<description>Total memory in bytes</description>
		<history><xsl:copy-of select="$historyDefault"/></history>
		<trends><xsl:copy-of select="$trendsDefault"/></trends>
		<units>B</units>
		<update><xsl:copy-of select="$updateDefault"/></update>
		<valueType><xsl:copy-of select="$valueType"/></valueType>
		<valueMap><xsl:value-of select="valueMap"/></valueMap>
		<multiplier><xsl:value-of select="multiplier"/></multiplier>
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
					<xsl:choose>
						<xsl:when test="../memoryTotal and  ../memoryUsed">
							<expressionFormula>last(<xsl:value-of select="../memoryUsed/snmpObject"/>)/(last(<xsl:value-of select="../memoryTotal/snmpObject"/>))</expressionFormula>
						</xsl:when>
						<xsl:otherwise>
							<expressionFormula>last(<xsl:value-of select="../memoryUsed/snmpObject"/>)/(last(<xsl:value-of select="../memoryFree/snmpObject"/>)+last(<xsl:value-of select="../memoryUsed/snmpObject"/>))</expressionFormula>
						</xsl:otherwise>
					</xsl:choose>				
			</xsl:when>
		</xsl:choose>
		<xsl:copy-of select="ref"></xsl:copy-of>
		<xsl:copy-of select="vendorDescription"></xsl:copy-of>
		<description>Memory utilization in %</description>
		<history><xsl:copy-of select="$historyDefault"/></history>
		<trends><xsl:copy-of select="$trendsDefault"/></trends>
		<units>%</units>
		<update><xsl:copy-of select="$updateDefault"/></update>
		<valueType><xsl:copy-of select="$valueType"/></valueType>
		<valueMap><xsl:value-of select="valueMap"/></valueMap>
		<multiplier><xsl:value-of select="multiplier"/></multiplier>
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


<xsl:template match="template/metrics/temperatureValue">
	<xsl:copy>
		<name>Temperature[<xsl:value-of select="metricLocation"/>]</name>
		<group>Temperature</group>
		<xsl:copy-of select="oid"></xsl:copy-of>
		<xsl:copy-of select="snmpObject"></xsl:copy-of>
		<xsl:copy-of select="mib"></xsl:copy-of>
<!-- <xsl:choose>
			<xsl:when test="./calculated = 'true'">
				<expressionFormula>last(<xsl:value-of select="../memoryUsed/snmpObject"/>)/(last(<xsl:value-of select="../memoryFree/snmpObject"/>)+last(<xsl:value-of select="../memoryUsed/snmpObject"/>))</expressionFormula>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>  -->
		<xsl:copy-of select="ref"></xsl:copy-of>
		<xsl:copy-of select="vendorDescription"></xsl:copy-of>
		<description>Temperature readings of testpoint: <xsl:value-of select="metricLocation"/></description>
		<history><xsl:copy-of select="$historyDefault"/></history>
		<trends><xsl:copy-of select="$trendsDefault"/></trends>
		<units>C</units>
		<update><xsl:copy-of select="$updateDefault"/></update>
		<valueType><xsl:copy-of select="$valueTypeFloat"/></valueType>
		<valueMap><xsl:value-of select="valueMap"/></valueMap>
		<multiplier><xsl:value-of select="multiplier"/></multiplier>
		<xsl:copy-of select="./discoveryRule"></xsl:copy-of>
		<triggers>
			<trigger>
			    <id>tempWarn</id>
				<expression>{<xsl:value-of select="../../name"></xsl:value-of>:<xsl:value-of select="snmpObject"></xsl:value-of>.avg(300)}>{$TEMP_WARN:"<xsl:value-of select="metricLocation"/>"}</expression>
                <name><xsl:value-of select="metricLocation"/> temperature is above warning threshold</name>
                <url/>
                <priority>2</priority>
                <description/>
                <dependsOn>
                	<dependency>tempCrit</dependency>
               	</dependsOn>
			</trigger>
			<trigger>
				<id>tempCrit</id>
				<expression>{<xsl:value-of select="../../name"></xsl:value-of>:<xsl:value-of select="snmpObject"></xsl:value-of>.avg(300)}>{$TEMP_CRIT:"<xsl:value-of select="metricLocation"/>"}</expression>
                <name><xsl:value-of select="metricLocation"/> temperature is above critical threshold</name>
                <url/>
                <priority>4</priority>
                <description/>
			</trigger>
		</triggers>
	</xsl:copy>
</xsl:template>


<xsl:template match="template/metrics/temperatureStatus">
	<xsl:copy>
		<name>Temperature status[<xsl:value-of select="metricLocation"/>]</name>
		<group>Temperature</group>
		<xsl:copy-of select="oid"></xsl:copy-of>
		<xsl:copy-of select="snmpObject"></xsl:copy-of>
		<xsl:copy-of select="mib"></xsl:copy-of>
<!-- <xsl:choose>
			<xsl:when test="./calculated = 'true'">
				<expressionFormula>last(<xsl:value-of select="../memoryUsed/snmpObject"/>)/(last(<xsl:value-of select="../memoryFree/snmpObject"/>)+last(<xsl:value-of select="../memoryUsed/snmpObject"/>))</expressionFormula>
			</xsl:when>
			<xsl:otherwise></xsl:otherwise>
		</xsl:choose>  -->
		<xsl:copy-of select="ref"></xsl:copy-of>
		<xsl:copy-of select="vendorDescription"></xsl:copy-of>
		<description>Temperature status of testpoint: <xsl:value-of select="metricLocation"/></description>
		<history><xsl:copy-of select="$historyDefault"/></history>
		<trends><xsl:copy-of select="$trendsDefault"/></trends>
		<units></units>
		<update><xsl:copy-of select="$updateDefault"/></update>
		<valueType><xsl:copy-of select="$valueType"/></valueType>
		<valueMap><xsl:value-of select="valueMap"/></valueMap>
		<multiplier><xsl:value-of select="multiplier"/></multiplier>
		<xsl:copy-of select="./discoveryRule"></xsl:copy-of>
	</xsl:copy>
</xsl:template>
</xsl:stylesheet>