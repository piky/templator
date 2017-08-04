<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xpath-default-namespace="http://www.example.org/zbx_template_new/"
				xmlns="http://www.example.org/zbx_template_new/">
<xsl:output method="xml" indent="yes"/>
<xsl:strip-space elements="*"/>

<xsl:template match="node()|@*">
	<xsl:copy>
		<xsl:apply-templates select="node()|@*"/>
	</xsl:copy>
</xsl:template>


<!-- This transformation will add zabbix_export/groups-->
<xsl:template match="zabbix_export/groups">
	<xsl:copy >
		<xsl:for-each-group select="/zabbix_export/templates/template/groups/group" group-by="name">
			<xsl:sequence select="."/>
		</xsl:for-each-group>
	</xsl:copy>
</xsl:template>

</xsl:stylesheet>
