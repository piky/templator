<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xpath-default-namespace="http://www.example.org/zbx_template_new/"
				xmlns="http://www.example.org/zbx_template_new/">

<xsl:output method="xml" indent="yes"/>


<xsl:template match="template/metrics/net.tcp.service">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>Service status</name>
			<group>Status</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<triggers>
				<trigger>
					<expression>{TEMPLATE_NAME:METRIC.max(#3)}=0</expression>
	                <name lang="EN">Service unavailable</name>
	                <name lang="RU">Сервис не отвечает</name>
	                <description>Last three attempts returned timeout. Please check remote service connectivity.</description>
	                <priority>3</priority>
				</trigger>
			</triggers>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric"/>
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

	<xsl:template match="template/metrics/net.udp.service">
		<xsl:variable name="metric" as="element()*">
			<metric>
				<name>Service status</name>
				<group>Status</group>
				<history><xsl:copy-of select="$history7days"/></history>
				<trends><xsl:copy-of select="$trends0days"/></trends>
				<update><xsl:copy-of select="$update1min"/></update>
				<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
				<triggers>
					<trigger>
						<expression>{TEMPLATE_NAME:METRIC.max(#3)}=0</expression>
						<name lang="EN">Service unavailable</name>
						<name lang="RU">Сервис не отвечает</name>
						<description>Last three attempts returned timeout. Please check remote service connectivity.</description>
						<priority>3</priority>
					</trigger>
				</triggers>
			</metric>
		</xsl:variable>

		<xsl:copy>
			<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric"/>
			</xsl:call-template>
		</xsl:copy>
	</xsl:template>


</xsl:stylesheet>

