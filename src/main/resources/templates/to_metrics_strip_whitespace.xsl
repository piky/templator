<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xpath-default-namespace="http://www.example.org/zbx_template_new/"
				xmlns="http://www.example.org/zbx_template_new/">

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="description|expression|recovery_expression|name">
		<xsl:copy>
			<xsl:copy-of select="@*|b/@*"/> <!-- copy all attributes, including lang -->
			<xsl:value-of select="replace(.,'^[ \t]+','','m')"/> <!--trim all leading whitespace -->
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
