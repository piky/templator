<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xpath-default-namespace="http://www.example.org/zbx_template_new/"
				xmlns="http://www.example.org/zbx_template_new/">

<xsl:output method="xml" indent="yes"/>

<xsl:param name="template_suffix" select="undef"/>
<xsl:param name="template_ver" select="undef"/>


<xsl:template match="node()|@*">
   <xsl:copy>
	   <xsl:apply-templates select="node()|@*"/>
   </xsl:copy>
</xsl:template>



<xsl:template match="/*/template/name">
	<xsl:copy> <!--  hardcode for non SNMP templates (currently only ICMP) ancestor:: -->
		<xsl:copy-of select="if (ancestor::*/classes/class[text()='SNMPv2' or text()='SNMPv1' or text()='SNMPv3']) then concat(.,'_SNMPvX') else (./text())"/>
	</xsl:copy>
</xsl:template>


<xsl:template match="/*/template/description">
	<xsl:copy>
		<xsl:copy-of  select="concat(.,' version: ',$template_ver)"/>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>
