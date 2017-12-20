<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xpath-default-namespace="http://www.example.org/zbx_template_new/"
				xmlns="http://www.example.org/zbx_template_new/">

	<!-- metric of hw servers fault -->
	<xsl:template match="template/metrics/system.status">
		<xsl:variable name="metric" as="element()*">
			<metric>
				<name lang="EN">Overall system health status</name>
				<name lang="RU">Общий статус системы</name>
				<group>Status</group>
				<update><xsl:copy-of select="$update30s"/></update>
				<history><xsl:copy-of select="$history14days"/></history>
				<trends><xsl:copy-of select="$trends0days"/></trends>
				<triggers>
					<xsl:if test="not(../../macros/macro/macro[contains(text(),'$HEALTH_DISASTER_STATUS')])
				and not(../../macros/macro/macro[contains(text(),'$HEALTH_CRIT_STATUS')])
and not(imported[contains(text(),'true')])">">
						<xsl:message terminate="yes">Error: provide at least macro for HEALTH_DISASTER_STATUS or HEALTH_CRIT_STATUS</xsl:message>
					</xsl:if>
					<xsl:if test="../../macros/macro/macro[contains(text(),'$HEALTH_DISASTER_STATUS')]">
						<trigger>
							<id>health.disaster</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$HEALTH_DISASTER_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
							<name lang="EN">System is in unrecoverable state!</name>
							<name lang="RU">Статус системы: сбой</name>
							<priority>4</priority>
							<description lang="EN">Please check the device for faults</description>
							<description lang="RU">Проверьте устройство</description>
							<tags><tag>
								<tag>Alarm.type</tag>
								<value>HEALTH_FAIL</value>
							</tag></tags>
						</trigger>
					</xsl:if>
					<xsl:if test="../../macros/macro/macro[contains(text(),'$HEALTH_CRIT_STATUS')]">
						<trigger>
							<id>health.critical</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$HEALTH_CRIT_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
							<name lang="EN">System status is in critical state</name>
							<name lang="RU">Статус системы: авария</name>
							<priority>4</priority>
							<description lang="EN">Please check the device for errors</description>
							<description lang="RU">Проверьте устройство</description>
							<dependsOn>
								<xsl:if test="../../macros/macro/macro[contains(text(),'$HEALTH_DISASTER_STATUS')]">
									<dependency>health.disaster</dependency>
								</xsl:if>
							</dependsOn>
							<tags><tag>
								<tag>Alarm.type</tag>
								<value>HEALTH_FAIL</value>
							</tag></tags>
						</trigger>
					</xsl:if>
					<xsl:if test="../../macros/macro/macro[contains(text(),'$HEALTH_WARN_STATUS')]">
						<trigger>
							<id>health.warning</id>
							<expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$HEALTH_WARN_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
							<name lang="EN">System status is in warning state</name>
							<name lang="RU">Статус системы: предупреждение</name>
							<priority>2</priority>
							<description lang="EN">Please check the device for warnings</description>
							<description lang="RU">Проверьте устройство</description>
							<dependsOn>
								<xsl:if test="../../macros/macro/macro[contains(text(),'$HEALTH_CRIT_STATUS')]"><dependency>health.critical</dependency></xsl:if>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$HEALTH_DISASTER_STATUS')]"><dependency>health.disaster</dependency></xsl:if>
							</dependsOn>
							<tags><tag>
								<tag>Alarm.type</tag>
								<value>HEALTH_FAIL</value>
							</tag></tags>
						</trigger>
					</xsl:if>
				</triggers>
			</metric>
		</xsl:variable>

		<xsl:copy>
			<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
			</xsl:call-template>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>

