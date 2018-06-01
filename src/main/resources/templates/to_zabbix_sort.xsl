<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xpath-default-namespace="http://www.example.org/zbx_template_new/"
				xmlns="http://www.example.org/zbx_template_new/">

	<xsl:output method="xml" indent="yes"/>



	<xsl:template match="node()|@*">
		<xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
		</xsl:copy>
	</xsl:template>



	<xsl:template match="macros">
		<xsl:copy>
			<xsl:apply-templates select="macro">
				<xsl:sort select="./macro"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="templates/*/templates">
		<xsl:copy>
			<xsl:apply-templates select="template">
				<xsl:sort select="./name"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="groups">
		<xsl:copy>
			<xsl:apply-templates select="group">
				<xsl:sort select="./name"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="applications">
		<xsl:copy>
			<xsl:apply-templates select="application">
				<xsl:sort select="./name"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="dependencies">
		<xsl:copy>
			<xsl:apply-templates select="dependency">
				<xsl:sort select="./name"/>
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
