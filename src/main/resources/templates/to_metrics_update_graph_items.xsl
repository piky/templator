<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<xsl:variable name="graph_drawtype"> <!-- preprocessing step types, replace with zabbix ints -->
  <entry key="line">0</entry>
  <entry key="filled_region">1</entry>
  <entry key="bold_line">2</entry>
  <entry key="dot">3</entry>
  <entry key="dashed_line">4</entry>
  <entry key="gradient">5</entry>  
</xsl:variable>

<xsl:variable name="graph_yaxisside"> <!-- preprocessing step types, replace with zabbix ints -->
  <entry key="left">0</entry>
  <entry key="right">1</entry>
</xsl:variable>

<xsl:template match="node()|@*">
   <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
   </xsl:copy>
</xsl:template>


<xsl:template match="//graph_item/drawtype">
	<xsl:variable name="drawtype" select="."></xsl:variable>
	<xsl:copy>
		<xsl:value-of select="$graph_drawtype/entry[@key=$drawtype]"/>
	</xsl:copy>
</xsl:template>

<xsl:template match="//graph_item/yaxisside">
	<xsl:variable name="yaxisside" select="."></xsl:variable>
	<xsl:copy>
		<xsl:value-of select="$graph_yaxisside/entry[@key=$yaxisside]"/>
	</xsl:copy>
</xsl:template>


<xsl:template match="//graph_item/item/key">
	<xsl:variable name="key" select="."/>
	<xsl:choose>
		<xsl:when test="ancestor::template/metrics/*[name()=$key]/snmpObject">
			<xsl:copy>
				<xsl:value-of select="ancestor::template/metrics/*[name()=$key]/snmpObject"/>
			</xsl:copy>
		</xsl:when>
		<xsl:otherwise><xsl:message>Please check key used for graph</xsl:message></xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="//graph_item/item/host">
	<xsl:copy>
		<xsl:value-of select="ancestor::template/name"/>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>
