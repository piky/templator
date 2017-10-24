<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
				xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
				xpath-default-namespace="http://www.example.org/zbx_template_new/"
				xmlns="http://www.example.org/zbx_template_new/">
<xsl:output method="xml" indent="yes"/>


<xsl:template match="template/metrics/sensor.temp.value">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">Temperature</name>
			<name lang="RU">Температура</name>
			<group>Temperature</group>
			<description>Temperature readings of testpoint: <xsl:value-of select="alarmObject"/></description>
			<units>°C</units>
			<valueType><xsl:copy-of select="$valueTypeFloat"/></valueType>
			<update>
				<!-- TODO: make this feature global -->
				<xsl:call-template name="updateIntervalTemplate">
	         		<xsl:with-param name="updateMultiplier" select="updateMultiplier"/>
	         		<xsl:with-param name="default" select="$update3min"/>
	 			</xsl:call-template>
 			</update>
			<triggers>
				<trigger>
				    <documentation>Using recovery expression... Temperature has to drop 3 points less than threshold level ({$TEMP_WARN}-3)</documentation>
				    <id>tempWarn</id>
					<!-- if sensor.temp.status is defined and is within same discovery rule with system.temp.value then add it TO trigger:-->
					<xsl:variable name="expression">{TEMPLATE_NAME:METRIC.avg(5m)}&gt;{$TEMP_WARN:"<xsl:value-of select="alarmObjectType" />"}</xsl:variable>
					<xsl:variable name="recovery_expression">{TEMPLATE_NAME:METRIC.max(5m)}&lt;{$TEMP_WARN:"<xsl:value-of select="alarmObjectType" />"}-3</xsl:variable>
					<xsl:variable name="discoveryRule" select="discoveryRule"/>
					<!-- Careful, since recovery expression will work only if simple expression is ALSO FALSE. So no point to define STATUS in recovery. -->
					<xsl:choose>
						 <xsl:when test="
						 	(../sensor.temp.status[discoveryRule = $discoveryRule] or (../sensor.temp.status[not(discoveryRule)] and
						 	 not(discoveryRule))
						 	 )
						 	 and ../../macros/macro/macro[contains(text(),'TEMP_WARN_STATUS')]
						 	"><!-- if discoveryRules match or both doesn't have discoveryRule -->
						 <xsl:variable name="statusMetricKey"><xsl:value-of select="../sensor.temp.status/name()"/>[<xsl:value-of select="../sensor.temp.status/snmpObject"/>]</xsl:variable>

							<expression><xsl:value-of select="$expression"/>
<xsl:if test="../../macros/macro/macro[contains(text(),'TEMP_WARN_STATUS')]">
or
{<xsl:value-of select="../../name"/>:<xsl:value-of select="$statusMetricKey"/>.last(0)}={$TEMP_WARN_STATUS}</xsl:if></expression>
							<recovery_expression>
							<xsl:value-of select="$recovery_expression"/>
							<!-- AND
							{<xsl:value-of select="../../name"/>:<xsl:value-of select="$statusMetricKey"/>.last(0)}={$TEMP_CRIT_STATUS} -->
							</recovery_expression>
							<name lang="EN">Temperature is above warning threshold: >{$TEMP_WARN:"<xsl:value-of select="alarmObjectType" />"}</name>
	                		<name lang="RU">Температура выше нормы: >{$TEMP_WARN:"<xsl:value-of select="alarmObjectType" />"}</name>
														
						</xsl:when>
						<xsl:otherwise><expression><xsl:value-of select="$expression"/></expression>
						<recovery_expression><xsl:value-of select="$recovery_expression"/></recovery_expression>
						<name lang="EN">Temperature is above warning threshold: >{$TEMP_WARN:"<xsl:value-of select="alarmObjectType" />"}</name>
	                	<name lang="RU">Температура выше нормы: >{$TEMP_WARN:"<xsl:value-of select="alarmObjectType" />"}</name>
						</xsl:otherwise>
					</xsl:choose>
	                <url/>
	                <priority>2</priority>
	                <description>This trigger uses temperature sensor values as well as temperature sensor status if available</description>
	                <dependsOn>
	                	<dependency>tempCrit</dependency>
	               	</dependsOn>
	               	<tags>	                
	               		<tag>
		                	<tag>Alarm.object.type</tag>
			                <value>
			             		<xsl:call-template name="tagAlarmObjectType">
						         		<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
						         		<xsl:with-param name="alarmObjectDefault" select="$defaultAlarmObjectType"/>	 					
			 					</xsl:call-template>
			 				</value>
						</tag>
		               	<tag>
		               		<tag>Alarm.type</tag>
		               		<value>OVERHEAT</value>
	               		</tag>
               		</tags>
				</trigger>
				<trigger>
					<documentation>Using recovery expression... Temperature has to drop 3 points less than threshold level  ({$TEMP_WARN}-3)</documentation>
					<id>tempCrit</id>
					
					<!-- if sensor.temp.status is defined and is within same discovery rule with system.temp.value then add it TO trigger:-->
					<xsl:variable name="expression">{TEMPLATE_NAME:METRIC.avg(5m)}>{$TEMP_CRIT:"<xsl:value-of select="alarmObjectType"/>"}</xsl:variable>
					<xsl:variable name="recovery_expression">{TEMPLATE_NAME:METRIC.max(5m)}&lt;{$TEMP_CRIT:"<xsl:value-of select="alarmObjectType" />"}-3</xsl:variable>
					<xsl:variable name="discoveryRule" select="discoveryRule"/>
					<!-- Careful, since recovery expression will work only if simple expression is ALSO FALSE. So no point to define STATUS in recovery. -->
					
					<xsl:choose>
						 <xsl:when test="
						 	(../sensor.temp.status[discoveryRule = $discoveryRule] or (../sensor.temp.status[not(discoveryRule)] and
						 	 not(discoveryRule))
						 	 )
						 	 and (
						 	 ../../macros/macro/macro[contains(text(),'TEMP_CRIT_STATUS')] or
						 	 ../../macros/macro/macro[contains(text(),'TEMP_DISASTER_STATUS')])
						 "><!-- if discoveryRules match or both doesn't have discoveryRule -->
						 <xsl:variable name="statusMetricKey"><xsl:value-of select="../sensor.temp.status/name()"/>[<xsl:value-of select="../sensor.temp.status/snmpObject"/>]</xsl:variable>
							
							<expression><xsl:value-of select="$expression"/>
<xsl:if test="../../macros/macro/macro[contains(text(),'TEMP_CRIT_STATUS')]">
or
{<xsl:value-of select="../../name"/>:<xsl:value-of select="$statusMetricKey"/>.last(0)}={$TEMP_CRIT_STATUS}</xsl:if>
<xsl:if test="../../macros/macro/macro[contains(text(),'TEMP_DISASTER_STATUS')]">
or
{<xsl:value-of select="../../name"/>:<xsl:value-of select="$statusMetricKey"/>.last(0)}={$TEMP_DISASTER_STATUS}</xsl:if></expression>
							
							<recovery_expression>
							<xsl:value-of select="$recovery_expression"/>
							<!-- AND
							{<xsl:value-of select="../../name"/>:<xsl:value-of select="$statusMetricKey"/>.last(0)}={$TEMP_CRIT_STATUS} -->
							</recovery_expression>
							<name lang="EN">Temperature is above critical threshold: >{$TEMP_CRIT:"<xsl:value-of select="alarmObjectType"/>"}</name>
	                		<name lang="RU">Температура очень высокая: >{$TEMP_CRIT:"<xsl:value-of select="alarmObjectType"/>"}</name>
						</xsl:when>
						<xsl:otherwise><expression><xsl:value-of select="$expression"/></expression>
						<recovery_expression><xsl:value-of select="$recovery_expression"/></recovery_expression>
						<name lang="EN">Temperature is above critical threshold: >{$TEMP_CRIT:"<xsl:value-of select="alarmObjectType"/>"}</name>
	                	<name lang="RU">Температура очень высокая: >{$TEMP_CRIT:"<xsl:value-of select="alarmObjectType"/>"}</name>
						</xsl:otherwise>
					</xsl:choose>
					
					
	                
	                <url/>
	                <priority>4</priority>
	                <description>This trigger uses temperature sensor values as well as temperature sensor status if available</description>
	                <tags>
		                <tag>
		                	<tag>Alarm.object.type</tag>
			                <value>
			             		<xsl:call-template name="tagAlarmObjectType">
						         		<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
						         		<xsl:with-param name="alarmObjectDefault" select="$defaultAlarmObjectType"/>	 					
			 					</xsl:call-template>
			 				</value>
						</tag>
   		               	<tag>
		               		<tag>Alarm.type</tag>
		               		<value>OVERHEAT</value>
	               		</tag>
	                </tags>
				</trigger>
				<trigger>
				    <documentation>Using recovery expression... Temperature has to be 3 points more than threshold level  ({$TEMP_CRIT_LOW}+3)</documentation>
				    <id>tempLow</id>
					<expression>{TEMPLATE_NAME:METRIC.avg(5m)}&lt;{$TEMP_CRIT_LOW:"<xsl:value-of select="alarmObjectType" />"}</expression>
					<recovery_expression>{TEMPLATE_NAME:METRIC.min(5m)}&gt;{$TEMP_CRIT_LOW:"<xsl:value-of select="alarmObjectType" />"}+3</recovery_expression>
	                <name lang="EN">Temperature is too low: &lt;{$TEMP_CRIT_LOW:"<xsl:value-of select="alarmObjectType" />"}</name>
	                <name lang="RU">Температура слишком низкая: &lt;{$TEMP_CRIT_LOW:"<xsl:value-of select="alarmObjectType" />"}</name>
	                <url/>
	                <priority>3</priority>
	                <description/>
	               	<tags>	                
	               		<tag>
		                	<tag>Alarm.object.type</tag>
			                <value>
			             		<xsl:call-template name="tagAlarmObjectType">
						         		<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
						         		<xsl:with-param name="alarmObjectDefault" select="$defaultAlarmObjectType"/>	 					
			 					</xsl:call-template>
			 				</value>
						</tag>
		               	<tag>
		               		<tag>Alarm.type</tag>
		               		<value>TEMP_LOW</value>
	               		</tag>
               		</tags>
				</trigger>				
			</triggers>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>
</xsl:template>


<xsl:template match="template/metrics/sensor.temp.status">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>Temperature status</name>
			<group>Temperature</group>
			<update><xsl:value-of select="$update3min"/></update>
			<history><xsl:value-of select="$history14days"/></history>
			<trends><xsl:value-of select="$trends0days"/></trends>
			<description>Temperature status of testpoint: <xsl:value-of select="alarmObject"/></description>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>
</xsl:template>


<xsl:template match="template/metrics/sensor.temp.locale">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>Temperature sensor location</name>
			<group>Temperature</group>
			<description>Temperature location of testpoint: <xsl:value-of select="alarmObject"/></description>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1hour"/></update>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>
</xsl:template>



<xsl:template match="template/metrics/sensor.psu.status">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">Power supply status</name>
			<name lang="RU">Статус блока питания</name>
			<group>Power Supply</group>
			<update><xsl:copy-of select="$update3min"/></update>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<triggers>
				<xsl:if test="not(../../macros/macro/macro[contains(text(),'PSU_CRIT_STATUS')]) and not(../../macros/macro/macro[contains(text(),'PSU_OK_STATUS')])
and not(imported[contains(text(),'true')])">
					<xsl:message terminate="yes">Error: provide at least macro for PSU_CRIT_STATUS or PSU_OK_STATUS</xsl:message>
				</xsl:if>
				<xsl:if test="../../macros/macro/macro[contains(text(),'PSU_CRIT_STATUS')]">
					<trigger>
						<id>psu.crit</id>
						<expression>
							<xsl:call-template name="proto_t_simple_status_e">
								<xsl:with-param name="macro">PSU_CRIT_STATUS</xsl:with-param>
							</xsl:call-template>
						</expression>
						<name lang="EN">Power supply is in critical state</name>
						<name lang="RU">Статус блока питания: авария</name>
						<priority>3</priority>
						<description lang="EN">Please check the power supply unit for errors</description>
						<description lang="RU">Проверьте блок питания</description>
						<tags>
							<tag>
								<tag>Alarm.object.type</tag>
								<value>
									<xsl:call-template name="tagAlarmObjectType">
											<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
											<xsl:with-param name="alarmObjectDefault">PSU</xsl:with-param>
									</xsl:call-template>
								</value>
								</tag>
								<tag>
									<tag>Alarm.type</tag>
									<value>PSU_FAIL</value>
								</tag>
						</tags>
					</trigger>
				</xsl:if>
				<xsl:if test="../../macros/macro/macro[contains(text(),'PSU_WARN_STATUS')]">
					<trigger>
						<id>psu.warn</id>
						<expression>
							<xsl:call-template name="proto_t_simple_status_e">
								<xsl:with-param name="macro">PSU_WARN_STATUS</xsl:with-param>
							</xsl:call-template>
						</expression>
						<name lang="EN">Power supply is in warning state</name>
						<name lang="RU">Статус блока питания: предупреждение</name>
						<priority>2</priority>
						<description lang="EN">Please check the power supply unit for errors</description>
						<description lang="RU">Проверьте блок питания</description>
						<dependsOn>
							<dependency>psu.crit</dependency>
						</dependsOn>
						<tags>
							<tag>
								<tag>Alarm.object.type</tag>
								<value>
									<xsl:call-template name="tagAlarmObjectType">
										<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
										<xsl:with-param name="alarmObjectDefault">PSU</xsl:with-param>
									</xsl:call-template>
								</value>
							</tag>
							<tag>
								<tag>Alarm.type</tag>
								<value>PSU_WARN</value>
							</tag>
						</tags>
					</trigger>
				</xsl:if>
				<xsl:if test="../../macros/macro/macro[contains(text(),'PSU_OK_STATUS')]">
					<trigger>
						<id>psu.notok</id>
						<expression>
							<xsl:call-template name="proto_t_simple_status_notok_e">
								<xsl:with-param name="macro">PSU_OK_STATUS</xsl:with-param>
							</xsl:call-template>
						</expression>
						<name lang="EN">Power supply is not in normal state</name>
						<name lang="RU">Статус блока питания: не норма</name>
						<priority>1</priority>
						<description lang="EN">Please check the power supply unit for errors</description>
						<description lang="RU">Проверьте блок питания</description>
						<dependsOn>
							<xsl:if test="../../macros/macro/macro[contains(text(),'PSU_CRIT_STATUS')]"><dependency>psu.crit</dependency></xsl:if>
							<xsl:if test="../../macros/macro/macro[contains(text(),'PSU_WARN_STATUS')]"><dependency>psu.warn</dependency></xsl:if>
						</dependsOn>
						<tags>
							<tag>
								<tag>Alarm.object.type</tag>
								<value>
									<xsl:call-template name="tagAlarmObjectType">
										<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
										<xsl:with-param name="alarmObjectDefault">PSU</xsl:with-param>
									</xsl:call-template>
								</value>
							</tag>
							<tag>
								<tag>Alarm.type</tag>
								<value>PSU_NOTOK</value>
							</tag>
						</tags>
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



<xsl:template match="template/metrics/sensor.fan.status">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">Fan status</name>
			<name lang="RU">Статус вентилятора</name>
			<group>Fans</group>
			<update><xsl:copy-of select="$update3min"/></update>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<triggers>
				<!-- there should be at least FAN_CRIT or FAN_OK status -->
				<xsl:if test="not(../../macros/macro/macro[contains(text(),'FAN_CRIT_STATUS')]) and not(../../macros/macro/macro[contains(text(),'FAN_OK_STATUS')])
and not(imported[contains(text(),'true')])">
					<xsl:message terminate="yes">Error: provide at least macro for FAN_CRIT_STATUS or FAN_OK_STATUS</xsl:message>
				</xsl:if>
				<xsl:if test="../../macros/macro/macro[contains(text(),'FAN_CRIT_STATUS')]">
					<trigger>
						<id>fan.crit</id>
						<expression>
							<xsl:call-template name="proto_t_simple_status_e">
								<xsl:with-param name="macro">FAN_CRIT_STATUS</xsl:with-param>
							</xsl:call-template>
						</expression>
						<name lang="EN">Fan is in critical state</name>
						<name lang="RU">Статус вентилятора: сбой</name>
						<priority>3</priority>
						<description lang="EN">Please check the fan unit</description>
						<description lang="RU">Проверьте вентилятор</description>
						<tags>
							<tag>
								<tag>Alarm.object.type</tag>
								<value>
									<xsl:call-template name="tagAlarmObjectType">
											<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
											<xsl:with-param name="alarmObjectDefault">Fan</xsl:with-param>
									</xsl:call-template>
								</value>
							</tag>
							<tag>
									<tag>Alarm.type</tag>
									<value>FAN_FAIL</value>
							</tag>
						</tags>
					</trigger>
				</xsl:if>
				<xsl:if test="../../macros/macro/macro[contains(text(),'FAN_WARN_STATUS')]">
					<trigger>
						<id>fan.warn</id>
						<expression>
							<xsl:call-template name="proto_t_simple_status_e">
								<xsl:with-param name="macro">FAN_WARN_STATUS</xsl:with-param>
							</xsl:call-template>
						</expression>
						<name lang="EN">Fan is in warning state</name>
						<name lang="RU">Статус вентилятора: предупреждение</name>
						<priority>2</priority>
						<description lang="EN">Please check the fan unit</description>
						<description lang="RU">Проверьте вентилятор</description>
						<dependsOn>
							<dependency>fan.crit</dependency>
						</dependsOn>
						<tags>
							<tag>
								<tag>Alarm.object.type</tag>
								<value>
									<xsl:call-template name="tagAlarmObjectType">
										<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
										<xsl:with-param name="alarmObjectDefault">Fan</xsl:with-param>
									</xsl:call-template>
								</value>
							</tag>
							<tag>
								<tag>Alarm.type</tag>
								<value>FAN_WARN</value>
							</tag>
						</tags>
					</trigger>
				</xsl:if>
				<xsl:if test="../../macros/macro/macro[contains(text(),'FAN_OK_STATUS')]">
					<trigger>
							<id>fan.notok</id>
							<expression>
								<xsl:call-template name="proto_t_simple_status_notok_e">
									<xsl:with-param name="macro">FAN_OK_STATUS</xsl:with-param>
								</xsl:call-template>
							</expression>
							<name lang="EN">Fan is not in normal state</name>
							<name lang="RU">Статус вентилятора: не норма</name>
							<priority>1</priority>
							<description lang="EN">Please check the fan unit</description>
							<description lang="RU">Проверьте вентилятор</description>
							<dependsOn>
								<xsl:if test="../../macros/macro/macro[contains(text(),'FAN_CRIT_STATUS')]"><dependency>fan.crit</dependency></xsl:if>
								<xsl:if test="../../macros/macro/macro[contains(text(),'FAN_WARN_STATUS')]"><dependency>fan.warn</dependency></xsl:if>
							</dependsOn>
							<tags>
								<tag>
									<tag>Alarm.object.type</tag>
									<value>
										<xsl:call-template name="tagAlarmObjectType">
											<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
											<xsl:with-param name="alarmObjectDefault">Fan</xsl:with-param>
										</xsl:call-template>
									</value>
								</tag>
								<tag>
									<tag>Alarm.type</tag>
									<value>FAN_NOTOK</value>
								</tag>
							</tags>
					</trigger>
				</xsl:if>
			</triggers>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric"/>
	    </xsl:call-template>
    </xsl:copy>
</xsl:template>

<xsl:template match="template/metrics/sensor.fan.speed.percentage">
	<xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">Fan speed, %</name>
			<name lang="RU">Скорость вращения вентилятора, %</name>
			<group>Fans</group>
			<units>%</units>
			<triggers/>
		</metric>
	</xsl:variable>

	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
			<xsl:with-param name="metric" select="$metric"/>
		</xsl:call-template>
	</xsl:copy>
</xsl:template>


<xsl:template match="template/metrics/sensor.fan.speed">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">Fan speed</name>
			<name lang="RU">Скорость вращения вентилятора</name>
			<group>Fans</group>
			<units>rpm</units>
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

