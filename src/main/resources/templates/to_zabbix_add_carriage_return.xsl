<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

	<xsl:output method="xml" indent="yes"/>



	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>



	<!-- item, discovery, trigger, template -->
	<xsl:template match="//description">
		<description>
			<xsl:copy-of select="@*|b/@*"/> <!-- copy all attributes, including lang -->
			<xsl:value-of select='replace(., "&#xA;", "&#xD;&#xA;" )'/>
		</description>
	</xsl:template>
	
		<!-- item, discovery, trigger, template -->
	<xsl:template match="//expression">
		<expression>
			<xsl:copy-of select="@*|b/@*"/> <!-- copy all attributes, including lang -->
			<xsl:value-of select='replace(., "&#xA;", "&#xD;&#xA;" )'/>
		</expression>
	</xsl:template>
	
	<xsl:template match="//recovery_expression">
		<recovery_expression>
			<xsl:copy-of select="@*|b/@*"/> <!-- copy all attributes, including lang -->
			<xsl:value-of select='replace(., "&#xA;", "&#xD;&#xA;" )'/>
		</recovery_expression>
	</xsl:template>

</xsl:stylesheet>
