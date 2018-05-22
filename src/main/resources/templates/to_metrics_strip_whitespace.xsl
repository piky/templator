<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>


	<xsl:template match="description|expression|recovery_expression|name">
		<xsl:copy>
			<xsl:copy-of select="@*|b/@*"/> <!-- copy all attributes, including lang -->
			<xsl:value-of select="replace(., '^\s+|\s+$', '')"/>
		</xsl:copy>
	</xsl:template>
</xsl:stylesheet>
