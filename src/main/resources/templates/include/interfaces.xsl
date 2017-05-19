<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>


<xsl:template match="template/metrics/net.if.status">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifOperStatus</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update1min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<triggers/>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

<xsl:template match="template/metrics/net.if.in">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifOctetsIn</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update1min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<units>bps</units>
			<triggers/>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>


<xsl:template match="template/metrics/net.if.out">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifOctetsOut</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update1min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<units>bps</units>
			<triggers/>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>


<xsl:template match="template/metrics/net.if.in.errors">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifErrorsIn</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update1min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<triggers/>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

<xsl:template match="template/metrics/net.if.out.errors">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>ifErrorsOut</name>
			<group>Interfaces</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trendsDefault"/></trends>
			<update><xsl:copy-of select="$update1min"/></update>
			<valueType><xsl:copy-of select="$valueTypeInt"/></valueType>
			<triggers/>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

</xsl:stylesheet>

