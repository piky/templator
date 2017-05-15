<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>


<xsl:variable name="historyDefault">30</xsl:variable>
<xsl:variable name="history30days">30</xsl:variable>
<xsl:variable name="history14days">14</xsl:variable>  
<xsl:variable name="history7days">7</xsl:variable>
<xsl:variable name="trendsDefault">365</xsl:variable>
<xsl:variable name="trends365days">365</xsl:variable> 
<xsl:variable name="trends0days">0</xsl:variable>
<xsl:variable name="updateDefault">300</xsl:variable> 
<xsl:variable name="update30s">30</xsl:variable>
<xsl:variable name="update1min">60</xsl:variable>
<xsl:variable name="update3min">180</xsl:variable>
<xsl:variable name="update5min">300</xsl:variable>
<xsl:variable name="update1hour">3600</xsl:variable>
<xsl:variable name="update4hours">14400</xsl:variable> 
<xsl:variable name="update1day">86400</xsl:variable>




<xsl:variable name="valueType">3</xsl:variable>
<xsl:variable name="valueTypeFloat">0</xsl:variable>
<xsl:variable name="valueTypeChar">1</xsl:variable>
<xsl:variable name="valueTypeLog">2</xsl:variable>
<xsl:variable name="valueTypeInt">3</xsl:variable>
<xsl:variable name="valueTypeText">4</xsl:variable>
	<!-- Type of information of the item. 
	Possible values: 
	0 - numeric float; 
	1 - character; 
	2 - log; 
	3 - numeric unsigned; 
	4 - text. -->

<!--  define macros with default values to add into template-->
    <xsl:variable name="MACROS" as="element()*">
        <Performance>
			<CPU_UTIL_MAX>
				<value>90</value>
			</CPU_UTIL_MAX>
			<MEMORY_UTIL_MAX><value>90</value></MEMORY_UTIL_MAX>
        </Performance>
        <Fault>
        	<TEMP_CRIT>
        		<value>75</value>
        		<context>CPU</context>
       		</TEMP_CRIT>
       		<TEMP_WARN>
        		<value>70</value>
        		<context>CPU</context>
       		</TEMP_WARN>
       		<TEMP_CRIT>
        		<value>35</value>
        		<context>Ambient</context>
       		</TEMP_CRIT>
       		<TEMP_WARN>
        		<value>30</value>
        		<context>Ambient</context>
       		</TEMP_WARN>
       		
        	<TEMP_CRIT><value>60</value></TEMP_CRIT>
        	<TEMP_WARN><value>50</value></TEMP_WARN>
        	<TEMP_CRIT_LOW><value>5</value></TEMP_CRIT_LOW>
        	<STORAGE_UTIL_CRIT><value>90</value></STORAGE_UTIL_CRIT>
        	<STORAGE_UTIL_WARN><value>80</value></STORAGE_UTIL_WARN>
        </Fault>
        <General>
        	<SNMP_TIMEOUT><value>10m</value></SNMP_TIMEOUT>
        </General>
    </xsl:variable>

<xsl:variable name="nowEN">now: {ITEM.LASTVALUE1}</xsl:variable>
<xsl:variable name="nowRU">сейчас: {ITEM.LASTVALUE1}</xsl:variable>





<xsl:template match="node()|@*">
   <xsl:copy>
            <xsl:apply-templates select="node()|@*"/>
   </xsl:copy>
</xsl:template>

<xsl:template match="value_maps">
	<value_maps>
		<xsl:copy-of copy-namespaces="no" select="node()|@*"></xsl:copy-of>
	</value_maps>
</xsl:template>


<!-- This template modifies update interval if needed -->
<xsl:template name="updateIntervalTemplate">
  <xsl:param name="updateMultiplier"/>
  <xsl:param name="default"/>
  <xsl:if test="$updateMultiplier">
      <xsl:value-of select="$updateMultiplier * $default" />
    </xsl:if>
    <xsl:if test="not($updateMultiplier)">
      <xsl:value-of select="$default" />
  </xsl:if>
</xsl:template>

<xsl:variable name="defaultAlarmObjectType">Device</xsl:variable>
<xsl:template name="tagAlarmObjectType">
  <xsl:param name="alarmObjectType"/>
  <xsl:param name="alarmObjectDefault"/>
  <xsl:if test="$alarmObjectType">
      <xsl:value-of select="$alarmObjectType" />
  </xsl:if>
  <xsl:if test="not($alarmObjectType)">
      <xsl:value-of select="$alarmObjectDefault" />
  </xsl:if>
</xsl:template>


<xsl:template match="/*/template">
     
	     <xsl:copy>
			<xsl:apply-templates select="node()|@*"/>
			<macros>
				<xsl:for-each select="./classes">
		     		<xsl:variable name="template_class" select="./class"/>
			         <!-- add extra contextual no checks. should be before default $MACROS!-->
					<xsl:copy-of copy-namespaces="no" select="../macros/macro"/>
						<xsl:for-each select="$MACROS">
							<xsl:choose>
								<xsl:when test="name(.) = $template_class">
									<xsl:for-each select="./*">
										<macro>
							        		<macro>{$<xsl:value-of select ="name(.)"/><xsl:if test="./context!=''">:"<xsl:value-of select="./context"/>"</xsl:if>}</macro>
							                <value><xsl:value-of select="./value"/></value>
										</macro>
									</xsl:for-each>
								</xsl:when>
							</xsl:choose>
			         	</xsl:for-each>
	         	</xsl:for-each>
    		</macros>
    	<!-- add template name with _SNMP_PLACEHOLDER at the end to make dependency dynamic -->
    	<templates>
    		<!-- copy from templates first -->
    		<xsl:copy-of copy-namespaces="no" select="templates/template"/>
    		<xsl:for-each select="./classes/*">
		     		<xsl:variable name="template_class" select="."/>
	   			<xsl:choose>
					<xsl:when test="$template_class = 'Performance'">
							<!-- monitor.virton specific
							<template>
				        		<name>Template Interfaces vZbx3_SNMP_PLACEHOLDER</name>
							</template>  -->
					</xsl:when>
					 <xsl:when test="$template_class = 'Fault'">
							<!-- temp include -->

					</xsl:when>
					<xsl:when test="$template_class = 'Inventory'">
							<template>
				        		<name>Template SNMP Generic_SNMP_PLACEHOLDER</name>
							</template>
							<template>
				        		<name>Template ICMP Ping</name>
							</template>	
					</xsl:when>
				</xsl:choose>
			</xsl:for-each>
    	
    	</templates>
      </xsl:copy>
      
      
</xsl:template>

<xsl:template match="macros"/><!-- leave it empty -->
<xsl:template match="template/templates"/><!-- leave it empty -->


<!-- This block describes basic metric structure. Call it from each metric below-->
<xsl:template name="defaultMetricBlock">
		<xsl:param name="metric"/>
		<xsl:variable name="metricKey">
		<xsl:choose>
			<xsl:when test="$metric/zabbixKey"><xsl:value-of select="$metric/zabbixKey"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="name()"/>[<xsl:value-of select="snmpObject"/>]</xsl:otherwise>
		</xsl:choose>
		</xsl:variable>
		
		<documentation><xsl:value-of select="documentation" /></documentation>
		<xsl:copy-of select="$metric/name"></xsl:copy-of>
		<xsl:copy-of select="$metric/group"></xsl:copy-of>
		<xsl:copy-of select="oid"/>
		<snmpObject><xsl:value-of select="$metricKey"/></snmpObject>
		<xsl:copy-of select="mib"/>
		<xsl:copy-of select="$metric/expressionFormula"></xsl:copy-of>
		<xsl:copy-of select="ref"></xsl:copy-of>
		<xsl:copy-of select="vendorDescription"></xsl:copy-of>
		<xsl:copy-of select="$metric/description"></xsl:copy-of>
		<xsl:copy-of select="$metric/logFormat"></xsl:copy-of>
		<xsl:choose>
			<xsl:when test="$metric/inventory_link and not(discoveryRule)">
				<inventory_link><xsl:value-of select="$metric/inventory_link"/></inventory_link>
			</xsl:when>
		</xsl:choose>
		
		
		

		<xsl:choose>
			<xsl:when test="$metric/history">
				<xsl:copy-of select="$metric/history"/>
			</xsl:when>
			<xsl:otherwise>
				<history><xsl:copy-of select="$historyDefault"/></history>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:choose>
			<xsl:when test="$metric/trends">
				<xsl:copy-of select="$metric/trends"/>
			</xsl:when>
			<xsl:otherwise>
				<trends><xsl:copy-of select="$trendsDefault"/></trends>
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:copy-of select="$metric/units"></xsl:copy-of>
		
		<xsl:choose>
			<xsl:when test="$metric/update">
				<xsl:copy-of select="$metric/update"/>
			</xsl:when>
			<xsl:otherwise>
				<update><xsl:copy-of select="$updateDefault" /></update>
			</xsl:otherwise>
		</xsl:choose> 
		
		<xsl:choose>
			<xsl:when test="$metric/valueType">
				<xsl:copy-of select="$metric/valueType"/>
			</xsl:when>
			<xsl:otherwise>
				<valueType><xsl:copy-of select="$valueType" /></valueType>
			</xsl:otherwise>
		</xsl:choose> 
		
		
		<valueMap><xsl:value-of select="valueMap" /></valueMap>
		<multiplier><xsl:value-of select="multiplier" /></multiplier>
		
		<xsl:choose>
			<xsl:when test="preprocessing">
				<xsl:copy-of select="preprocessing"/>
			</xsl:when>
			<xsl:otherwise>
				<preprocessing/> <!-- 3.4 -->
			</xsl:otherwise>
		</xsl:choose>
		
		<xsl:copy-of select="./discoveryRule"></xsl:copy-of>
		<xsl:if test="$metric/triggers/trigger">
			<triggers>
				<xsl:for-each select="$metric/triggers/*">

	    			<xsl:call-template name="defaultTriggerBlock">
						<xsl:with-param name="trigger" select="." />
						<xsl:with-param name="metricKey" select="$metricKey" />
		    		</xsl:call-template>            
				</xsl:for-each> 
				
			</triggers>
		</xsl:if>
		<!-- <xsl:copy-of select="$metric/triggers"></xsl:copy-of> -->

</xsl:template>

<!-- This block describes basic trigger structure. Call it from each trigger in metrics below-->
<xsl:template name="defaultTriggerBlock">
		<xsl:param name="trigger"/>
		<xsl:param name="metricKey"/>
			<trigger>
					<xsl:copy-of select="$trigger/id"></xsl:copy-of>
					<xsl:copy-of select="$trigger/documentation"></xsl:copy-of>
					<!-- <xsl:copy-of select="$trigger/expression"></xsl:copy-of> -->
					<expression><xsl:value-of select="replace($trigger/expression, 'METRIC', $metricKey)"/></expression>
					<recovery_expression><xsl:value-of select="replace($trigger/recovery_expression, 'METRIC', $metricKey)"/></recovery_expression>
		            <xsl:copy-of select="$trigger/recovery_mode"></xsl:copy-of>
		            <xsl:copy-of select="$trigger/manual_close"></xsl:copy-of>
					<xsl:copy-of select="$trigger/name"></xsl:copy-of>
					<xsl:copy-of select="$trigger/url"></xsl:copy-of>
					<xsl:copy-of select="$trigger/priority"></xsl:copy-of>
					<xsl:copy-of select="$trigger/description"></xsl:copy-of>
					<xsl:copy-of select="$trigger/dependsOn"></xsl:copy-of>
	                <tags>
	                	<xsl:copy-of select="$trigger/tags/tag"></xsl:copy-of>
		                <tag><tag>Host</tag><value>{HOST.HOST}</value></tag>
	                </tags>
			</trigger>

</xsl:template>

<!--  
<xsl:template match="template/metrics">
	 
	 <xsl:copy>
	 	<xsl:apply-templates select="child::node()"/>
	 </xsl:copy>

</xsl:template> -->
 
 
<xsl:template match="template/metrics/system.cpu.util">
	 
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN"><xsl:if test="alarmObject != ''">[<xsl:value-of select="alarmObject" />] </xsl:if>CPU utilization</name>
			<name lang="RU"><xsl:if test="alarmObject != ''">[<xsl:value-of select="alarmObject" />] </xsl:if>Загрузка процессора</name>
			<group>CPU</group>
			<description>CPU utilization in %</description>
			<units>%</units>
			<update><xsl:value-of select="$update3min"/></update>
			<triggers>
				<trigger>
					<documentation>If alarmObject is defined, it's added to trigger name.</documentation>
					<expression>{<xsl:value-of select="../../name"/>:METRIC.avg(5m)}>{$CPU_UTIL_MAX}</expression>
	                <name lang="EN"><xsl:if test="alarmObject != ''">[<xsl:value-of select="alarmObject" />] </xsl:if>High CPU utilization (<xsl:value-of select="$nowEN" />)</name>
	                <name lang="RU"><xsl:if test="alarmObject != ''">[<xsl:value-of select="alarmObject" />] </xsl:if>Загрузка ЦПУ слишком велика (<xsl:value-of select="$nowRU" />)</name>
	                <url />
	                <priority>3</priority>
	                <description />
	                <tags>
	                	<tag>
		                	<tag>Alarm.object.type</tag>
			                <value>
			             		<xsl:call-template name="tagAlarmObjectType">
						         		<xsl:with-param name="alarmObjectType" select="alarmObjectType" />
						         		<xsl:with-param name="alarmObjectDefault">CPU</xsl:with-param>
			 					</xsl:call-template>
			 				</value>
	 					</tag>
						<tag>
		                	<tag>Alarm.type</tag>
			                <value>CPU_UTIL_HIGH</value>
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


<xsl:template match="template/metrics/cpuUtil">
	<xsl:copy>
		<name>CPU Util</name>
		<group>CPU</group>
		<xsl:copy-of select="oid"></xsl:copy-of>
		<xsl:copy-of select="snmpObject"></xsl:copy-of>
		<xsl:copy-of select="mib"></xsl:copy-of>
		<xsl:copy-of select="./expressionFormula"></xsl:copy-of>
		<xsl:copy-of select="ref"></xsl:copy-of>
		<xsl:copy-of select="vendorDescription"></xsl:copy-of>
		<history><xsl:copy-of select="$historyDefault"/></history>
		<trends><xsl:copy-of select="$trendsDefault"/></trends>
		<units></units>
		<update><xsl:copy-of select="$updateDefault"/></update>
		<valueType><xsl:copy-of select="$valueType"/></valueType>
		<valueMap><xsl:value-of select="valueMap"/></valueMap>
		<multiplier><xsl:value-of select="multiplier"/></multiplier>
		<xsl:copy-of select="./discoveryRule"></xsl:copy-of>
	</xsl:copy>
</xsl:template>


<!-- memory -->
<xsl:template match="template/metrics/vm.memory.units">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>Memory units</name>
			<group>Internal Items</group>
			<update><xsl:value-of select="$update3min"/></update>
			<trends><xsl:value-of select="$trends0days"/></trends>
			<history><xsl:value-of select="$history7days"/></history>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

<xsl:template match="template/metrics/vm.memory.units.used">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>Used memory in units</name>
			<group>Internal Items</group>
			<units>units</units>
			<update><xsl:value-of select="$update3min"/></update>
			<trends><xsl:value-of select="$trends0days"/></trends>
			<history><xsl:value-of select="$history7days"/></history>
			<description>Used memory in units</description>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

<xsl:template match="template/metrics/vm.memory.units.total">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>Total memory in units</name>
			<group>Internal Items</group>
			<update><xsl:value-of select="$update3min"/></update>
			<trends><xsl:value-of select="$trends0days"/></trends>
			<history><xsl:value-of select="$history7days"/></history>
			<units>units</units>
			<description>Total memory in units</description>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>	



<xsl:template match="template/metrics/vm.memory.used">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:if test="alarmObject != ''">[<xsl:value-of select="alarmObject"/>] </xsl:if>Used memory</name>
			<group>Memory</group>
			<units>B</units>
			<description>Used memory in Bytes</description>
			<update><xsl:value-of select="$update3min"/></update>
			<xsl:choose>
				<xsl:when test="./calculated = 'true'">
						<xsl:choose>
							<xsl:when test="../vm.memory.units.used and  ../vm.memory.units">
								<expressionFormula>(last(vm.memory.units.used[<xsl:value-of select="../vm.memory.units.used/snmpObject"/>])*last(vm.memory.units[<xsl:value-of select="../vm.memory.units/snmpObject"/>]))</expressionFormula>
							</xsl:when>
						</xsl:choose>				
				</xsl:when>
			</xsl:choose>			
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

<xsl:template match="template/metrics/vm.memory.free">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:if test="alarmObject != ''">[<xsl:value-of select="alarmObject"/>] </xsl:if>Available memory</name> <!--  Available as in zabbix agent templates -->
			<group>Memory</group>
			<update><xsl:value-of select="$update3min"/></update>
			<units>B</units>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>
</xsl:template>





<xsl:template match="template/metrics/vm.memory.total">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:if test="alarmObject != ''">[<xsl:value-of select="alarmObject"/>] </xsl:if>Total memory</name>
			<group>Memory</group>
			<description>Total memory in Bytes</description>
			<units>B</units>
			<update><xsl:value-of select="$update3min"/></update>
			<xsl:choose>
				<xsl:when test="./calculated = 'true'">
					<xsl:choose>
						<xsl:when test="../vm.memory.units.total and  ../vm.memory.units">
							<expressionFormula>(last(vm.memory.units.total[<xsl:value-of select="../vm.memory.units.total/snmpObject"/>])*last(vm.memory.units[<xsl:value-of select="../vm.memory.units/snmpObject"/>]))</expressionFormula>
						</xsl:when>
					</xsl:choose>				
				</xsl:when>
			</xsl:choose>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>
</xsl:template>


<xsl:template match="template/metrics/vm.memory.pused">
	
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:if test="alarmObject != ''">[<xsl:value-of select="alarmObject"/>] </xsl:if>Memory utilization</name>
			<group>Memory</group>
			<description>Memory utilization in %</description>
			<units>%</units>
			<update><xsl:value-of select="$update3min"/></update>
			<xsl:choose>
				<xsl:when test="./calculated = 'true'">
						<xsl:choose>
							<xsl:when test="../vm.memory.units.total and  ../vm.memory.units.used">
								<expressionFormula>(last(vm.memory.units.used[<xsl:value-of select="../vm.memory.units.used/snmpObject"/>])/last(vm.memory.units.total[<xsl:value-of select="../vm.memory.units.total/snmpObject"/>]))*100</expressionFormula>
							</xsl:when>
							<xsl:when test="../vm.memory.total and  ../vm.memory.used">
								<expressionFormula>(last(vm.memory.used[<xsl:value-of select="../vm.memory.used/snmpObject"/>])/last(vm.memory.total[<xsl:value-of select="../vm.memory.total/snmpObject"/>]))*100</expressionFormula>
							</xsl:when>
							<xsl:when test="../vm.memory.total and  ../vm.memory.free">
								<expressionFormula>((last(vm.memory.total[<xsl:value-of select="../vm.memory.total/snmpObject"/>])-last(vm.memory.free[<xsl:value-of select="../vm.memory.free/snmpObject"/>]))/last(vm.memory.total[<xsl:value-of select="../vm.memory.total/snmpObject"/>]))*100</expressionFormula>
							</xsl:when>
							<xsl:otherwise>
								<expressionFormula>(last(vm.memory.used[<xsl:value-of select="../vm.memory.used/snmpObject"/>])/(last(vm.memory.free[<xsl:value-of select="../vm.memory.free/snmpObject"/>])+last(vm.memory.used[<xsl:value-of select="../vm.memory.used/snmpObject"/>])))*100</expressionFormula>
							</xsl:otherwise>
						</xsl:choose>				
				</xsl:when>
			</xsl:choose>
			<valueType><xsl:copy-of select="$valueTypeFloat"/></valueType>
			<triggers>
				<trigger>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.avg(5m)}>{$MEMORY_UTIL_MAX}</expression>
	                <name lang="EN"><xsl:if test="alarmObject != ''">[<xsl:value-of select="alarmObject"/>] </xsl:if>High memory utilization (<xsl:value-of select="$nowEN" />)</name>
	                <name lang="RU"><xsl:if test="alarmObject != ''">[<xsl:value-of select="alarmObject"/>] </xsl:if>Мало свободной памяти ОЗУ (<xsl:value-of select="$nowRU" />)</name>
	                <url/>
	                <priority>3</priority>
	                <description/>
	                <tags>	
	                	<tag>
		                	<tag>Alarm.object.type</tag>
			                <value>
			             		<xsl:call-template name="tagAlarmObjectType">
						         		
						         		<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
						         		<xsl:with-param name="alarmObjectDefault">Memory</xsl:with-param>	 					
			 					</xsl:call-template>
			 				</value>
						</tag>
						<tag>
		                	<tag>Alarm.type</tag>
			                <value>MEMORY_UTIL_HIGH</value>
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



<!-- storage(same as memory) -->

<xsl:template match="template/metrics/vfs.fs.units">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>[<xsl:value-of select="alarmObject"/>] Storage units</name>
			<group>Internal Items</group>
			<history><xsl:value-of select="$history7days"/></history>
			<trends><xsl:value-of select="$trends0days"/></trends>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

<xsl:template match="template/metrics/vfs.fs.units.used">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>[<xsl:value-of select="alarmObject"/>] Used storage in units</name>
			<group>Internal Items</group>
			<description>Used storage in units</description>
			<units>units</units>
			<history><xsl:value-of select="$history7days"/></history>
			<trends><xsl:value-of select="$trends0days"/></trends>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>


<xsl:template match="template/metrics/vfs.fs.units.total">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>[<xsl:value-of select="alarmObject"/>] Total space in units</name>
			<group>Internal Items</group>
			<description>Total space in units</description>
			<history><xsl:value-of select="$history7days"/></history>
			<trends><xsl:value-of select="$trends0days"/></trends>
			<units>units</units>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>		
</xsl:template>


<xsl:template match="template/metrics/vfs.fs.used">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>[<xsl:value-of select="alarmObject"/>] Used space</name>
			<group>Storage</group>
			<description>Used storage in Bytes</description>
			<xsl:choose>
				<xsl:when test="./calculated = 'true'">
						<xsl:choose>
							<xsl:when test="../vfs.fs.units.used and  ../vfs.fs.units">
								<expressionFormula>(last(vfs.fs.units.used[<xsl:value-of select="../vfs.fs.units.used/snmpObject"/>])*last(vfs.fs.units[<xsl:value-of select="../vfs.fs.units/snmpObject"/>]))</expressionFormula>
							</xsl:when>
						</xsl:choose>				
				</xsl:when>
			</xsl:choose>
			<units>B</units>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>		
</xsl:template>

<xsl:template match="template/metrics/vfs.fs.free">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>[<xsl:value-of select="alarmObject"/>] Free space</name>
			<group>Storage</group>
			<units>B</units>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>



<xsl:template match="template/metrics/vfs.fs.total">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>[<xsl:value-of select="alarmObject"/>] Total space</name>
			<group>Storage</group>
			<description>Total space in Bytes</description>			
			<xsl:choose>
				<xsl:when test="./calculated = 'true'">
						<xsl:choose>
							<xsl:when test="../vfs.fs.units.total and  ../vfs.fs.units">
								<expressionFormula>(last(vfs.fs.units.total[<xsl:value-of select="../vfs.fs.units.total/snmpObject"/>])*last(vfs.fs.units[<xsl:value-of select="../vfs.fs.units/snmpObject"/>]))</expressionFormula>
							</xsl:when>
						</xsl:choose>				
				</xsl:when>
			</xsl:choose>
			<units>B</units>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>


<xsl:template match="template/metrics/vfs.fs.pused">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>[<xsl:value-of select="alarmObject"/>] Storage utilization</name>
			<group>Storage</group>
			<description>Storage utilization in % for <xsl:value-of select="alarmObject"/></description>			
			<xsl:choose>
				<xsl:when test="./calculated = 'true'">
						<xsl:choose>
							<xsl:when test="../vfs.fs.units.total and  ../vfs.fs.units.used">
								<expressionFormula>(last(vfs.fs.units.used[<xsl:value-of select="../vfs.fs.units.used/snmpObject"/>])/last(vfs.fs.units.total[<xsl:value-of select="../vfs.fs.units.total/snmpObject"/>]))*100</expressionFormula>
							</xsl:when>
							<xsl:when test="../vfs.fs.total and  ../vfs.fs.used">
								<expressionFormula>(last(vfs.fs.used[<xsl:value-of select="../vfs.fs.used/snmpObject"/>])/last(vfs.fs.total[<xsl:value-of select="../vfs.fs.total/snmpObject"/>]))*100</expressionFormula>
							</xsl:when>
							<xsl:when test="../vfs.fs.total and  ../vfs.fs.free">
								<expressionFormula>((last(vfs.fs.total[<xsl:value-of select="../vfs.fs.total/snmpObject"/>])-last(vfs.fs.free[<xsl:value-of select="../vfs.fs.free/snmpObject"/>]))/last(vfs.fs.total[<xsl:value-of select="../vfs.fs.total/snmpObject"/>]))*100</expressionFormula>
							</xsl:when>
							<xsl:otherwise>
								<expressionFormula>(last(vfs.fs.used[<xsl:value-of select="../vfs.fs.used/snmpObject"/>])/(last(vfs.fs.free[<xsl:value-of select="../vfs.fs.free/snmpObject"/>])+last(vfs.fs.used[<xsl:value-of select="../vfs.fs.used/snmpObject"/>])))*100</expressionFormula>
							</xsl:otherwise>
						</xsl:choose>				
				</xsl:when>
			</xsl:choose>	
			<valueType><xsl:copy-of select="$valueTypeFloat"/></valueType>
			<units>%</units>
			<triggers>
					<trigger>
						<id>storageCrit</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.avg(5m)}>{$STORAGE_UTIL_CRIT}</expression>
		                <name lang="EN">[<xsl:value-of select="alarmObject"/>] Free disk space is low (utilized by {ITEM.VALUE1})</name>
		                <name lang="RU">[<xsl:value-of select="alarmObject"/>] Мало свободного места (использовано: {ITEM.VALUE1})</name>
		                <url/>
		                <priority>3</priority>
		                <description/>
		                <tags>
			                <tag>
			                	<tag>Alarm.object.type</tag>
				                <value>
				             		<xsl:call-template name="tagAlarmObjectType">
							         		<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
							         		<xsl:with-param name="alarmObjectDefault">Storage</xsl:with-param>	 					
				 					</xsl:call-template>
				 				</value>
							</tag>
							<tag>
			                	<tag>Alarm.type</tag>
				                <value>STORAGE_UTIL_HIGH</value>
							</tag>
						</tags>
					</trigger>
					
					<trigger>
						<id>storageWarn</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.avg(5m)}>{$STORAGE_UTIL_WARN}</expression>
		                <name lang="EN">[<xsl:value-of select="alarmObject"/>] Free disk space is low (utilized by {ITEM.VALUE1})</name>
		                <name lang="RU">[<xsl:value-of select="alarmObject"/>] Мало свободного места (использовано: {ITEM.VALUE1})</name>
		                <url/>
		                <priority>2</priority>
		                <description/>
						<dependsOn>
		                	<dependency>storageCrit</dependency>
		               	</dependsOn>
		               	<tags>
			               	<tag>
			                	<tag>Alarm.object.type</tag>
				                <value>
				             		<xsl:call-template name="tagAlarmObjectType">
							         		<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
							         		<xsl:with-param name="alarmObjectDefault">Storage</xsl:with-param>	 					
				 					</xsl:call-template>
				 				</value>
							</tag>
							<tag>
			                	<tag>Alarm.type</tag>
				                <value>STORAGE_UTIL_HIGH</value>
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

<xsl:template match="template/metrics/sensor.temp.value">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN"><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>Temperature</name>
			<name lang="RU"><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>Температура</name>
			<group>Temperature</group>
			<description>Temperature readings of testpoint: <xsl:value-of select="alarmObject"/></description>
			<units>°С</units>
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
				    <!-- <documentation>Using recovery expression... Temperature has to drop 5 points less than threshold level  ({$TEMP_WARN}-5)</documentation>  -->
				    <id>tempWarn</id>

					<!-- if sensor.temp.status is defined and is within same discovery rule with system.temp.value then add it TO trigger:-->
					<xsl:variable name="expression">{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.avg(5m)}&gt;{$TEMP_WARN:"<xsl:value-of select="alarmObjectType" />"}</xsl:variable>
					<xsl:variable name="recovery_expression">{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.max(5m)}&lt;{$TEMP_WARN:"<xsl:value-of select="alarmObjectType" />"}-5</xsl:variable>
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
							{<xsl:value-of select="../../name"/>:<xsl:value-of select="$statusMetricKey"/>.last(0)}={$TEMP_WARN_STATUS}
							</xsl:if></expression>
							
							<recovery_expression>
							<xsl:value-of select="$recovery_expression"/>
							<!-- AND
							{<xsl:value-of select="../../name"/>:<xsl:value-of select="$statusMetricKey"/>.last(0)}={$TEMP_CRIT_STATUS} -->
							</recovery_expression>
							<name lang="EN"><xsl:value-of select="alarmObject" /> temperature is above warning threshold: >{$TEMP_WARN:"<xsl:value-of select="alarmObjectType" />"} (<xsl:value-of select="$nowEN" />)({ITEM.VALUE2})</name>
	                		<name lang="RU">[<xsl:value-of select="alarmObject" />] Температура выше нормы: >{$TEMP_WARN:"<xsl:value-of select="alarmObjectType" />"} (<xsl:value-of select="$nowRU" />)({ITEM.VALUE2})</name>
														
						</xsl:when>
						<xsl:otherwise><expression><xsl:value-of select="$expression"/></expression>
						<recovery_expression><xsl:value-of select="$recovery_expression"/></recovery_expression>
						<name lang="EN"><xsl:value-of select="alarmObject" /> temperature is above warning threshold: >{$TEMP_WARN:"<xsl:value-of select="alarmObjectType" />"} (<xsl:value-of select="$nowEN" />)</name>
	                	<name lang="RU">[<xsl:value-of select="alarmObject" />] Температура выше нормы: >{$TEMP_WARN:"<xsl:value-of select="alarmObjectType" />"} (<xsl:value-of select="$nowRU" />)</name>
						</xsl:otherwise>
					</xsl:choose>	                
	                
	                
	                <url />
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
					<!-- <documentation>Using recovery expression... Temperature has to drop 5 points less than threshold level  ({$TEMP_WARN}-5)</documentation>  -->
					<id>tempCrit</id>
					
					<!-- if sensor.temp.status is defined and is within same discovery rule with system.temp.value then add it TO trigger:-->
					<xsl:variable name="expression">{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.avg(5m)}>{$TEMP_CRIT:"<xsl:value-of select="alarmObjectType"/>"}</xsl:variable>
					<xsl:variable name="recovery_expression">{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.max(5m)}&lt;{$TEMP_CRIT:"<xsl:value-of select="alarmObjectType" />"}-5</xsl:variable>
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
							{<xsl:value-of select="../../name"/>:<xsl:value-of select="$statusMetricKey"/>.last(0)}={$TEMP_CRIT_STATUS}
							</xsl:if>
							<xsl:if test="../../macros/macro/macro[contains(text(),'TEMP_DISASTER_STATUS')]">
								or
								{<xsl:value-of select="../../name"/>:<xsl:value-of select="$statusMetricKey"/>.last(0)}={$TEMP_DISASTER_STATUS}
							</xsl:if></expression>
							
							<recovery_expression>
							<xsl:value-of select="$recovery_expression"/>
							<!-- AND
							{<xsl:value-of select="../../name"/>:<xsl:value-of select="$statusMetricKey"/>.last(0)}={$TEMP_CRIT_STATUS} -->
							</recovery_expression>
							<name lang="EN"><xsl:value-of select="alarmObject"/> temperature is above critical threshold: >{$TEMP_CRIT:"<xsl:value-of select="alarmObjectType"/>"} (<xsl:value-of select="$nowEN" />)({ITEM.VALUE2})</name>
	                		<name lang="RU">[<xsl:value-of select="alarmObject"/>] Температура очень высокая: >{$TEMP_CRIT:"<xsl:value-of select="alarmObjectType"/>"} (<xsl:value-of select="$nowRU" />)({ITEM.VALUE2})</name>
						</xsl:when>
						<xsl:otherwise><expression><xsl:value-of select="$expression"/></expression>
						<recovery_expression><xsl:value-of select="$recovery_expression"/></recovery_expression>
						<name lang="EN"><xsl:value-of select="alarmObject"/> temperature is above critical threshold: >{$TEMP_CRIT:"<xsl:value-of select="alarmObjectType"/>"} (<xsl:value-of select="$nowEN" />)</name>
	                	<name lang="RU">[<xsl:value-of select="alarmObject"/>] Температура очень высокая: >{$TEMP_CRIT:"<xsl:value-of select="alarmObjectType"/>"} (<xsl:value-of select="$nowRU" />)</name>						
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
				    <!-- <documentation>Using recovery expression... Temperature has to be 5 points more than threshold level  ({$TEMP_CRIT_LOW}+5)</documentation>  -->
				    <id>tempLow</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.avg(5m)}&lt;{$TEMP_CRIT_LOW:"<xsl:value-of select="alarmObjectType" />"}</expression>
					<recovery_expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.min(5m)}&gt;{$TEMP_CRIT_LOW:"<xsl:value-of select="alarmObjectType" />"}+5</recovery_expression>
	                <name lang="EN"><xsl:value-of select="alarmObject" /> temperature is too low: &lt;{$TEMP_CRIT_LOW:"<xsl:value-of select="alarmObjectType" />"} (<xsl:value-of select="$nowEN" />)</name>
	                <name lang="RU">[<xsl:value-of select="alarmObject" />] Температура слишком низкая: &lt;{$TEMP_CRIT_LOW:"<xsl:value-of select="alarmObjectType" />"} (<xsl:value-of select="$nowRU" />)</name>
	                <url />
	                <priority>3</priority>
	                <description />
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
			<name>[<xsl:value-of select="alarmObject"/>] Temperature status</name>
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
			<name>[<xsl:value-of select="alarmObject"/>] Temperature sensor location</name>
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
					<xsl:if test="../../macros/macro/macro[contains(text(),'HEALTH_DISASTER_STATUS')]">
						<trigger>
						    <id>health.disaster</id>
							<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$HEALTH_DISASTER_STATUS}</expression>
			                <name lang="EN">System is in unrecoverable state! (<xsl:value-of select="$nowEN"/>)</name>
			                <name lang="RU">Статус системы: сбой (<xsl:value-of select="$nowRU"/>)</name>
			                <priority>4</priority>
			                <description lang="EN">Please check the device for faults</description>
			                <description lang="RU">Проверьте устройство</description>
			                <tags><tag>
				 				<tag>Alarm.type</tag>
				                <value>HEALTH_FAIL</value>
							</tag></tags>
						</trigger>
					</xsl:if>
					<xsl:if test="../../macros/macro/macro[contains(text(),'HEALTH_CRIT_STATUS')]">
					<trigger>
						<id>health.critical</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$HEALTH_CRIT_STATUS}</expression>
		                <name lang="EN">System status is in critical state (<xsl:value-of select="$nowEN"/>)</name>
		                <name lang="RU">Статус системы: авария (<xsl:value-of select="$nowRU"/>)</name>
		                <priority>4</priority>
		                <description lang="EN">Please check the device for errors</description>
		                <description lang="RU">Проверьте устройство</description>
		                <dependsOn>
		                	<xsl:if test="../../macros/macro/macro[contains(text(),'HEALTH_DISASTER_STATUS')]">
		                		<dependency>health.disaster</dependency>
		                	</xsl:if>
		               	</dependsOn>
		               	<tags><tag>
			 				<tag>Alarm.type</tag>
			                <value>HEALTH_FAIL</value>
						</tag></tags>
					</trigger>
					</xsl:if>
					<xsl:if test="../../macros/macro/macro[contains(text(),'HEALTH_WARN_STATUS')]">
					<trigger>
					    <id>health.warning</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$HEALTH_WARN_STATUS}</expression>
		                <name lang="EN">System status is in warning state (<xsl:value-of select="$nowEN"/>)</name>
		                <name lang="RU">Статус системы: предупреждение (<xsl:value-of select="$nowRU"/>)</name>
		                <priority>2</priority>
		                <description lang="EN">Please check the device for warnings</description>
		                <description lang="RU">Проверьте устройство</description>
		                <dependsOn>
		                	<xsl:if test="../../macros/macro/macro[contains(text(),'HEALTH_CRIT_STATUS')]">
		                		<dependency>health.critical</dependency>
		                	</xsl:if>
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



<xsl:template match="template/metrics/sensor.psu.status">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">[<xsl:value-of select="alarmObject"/>] Power supply status</name>
			<name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус блока питания</name>
			<group>Power Supply</group>
			<update><xsl:copy-of select="$update3min"/></update>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<triggers>
				<trigger>
					<id>psu.critical</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$PSU_CRIT_STATUS}</expression>
	                <name lang="EN">[<xsl:value-of select="alarmObject"/>] Power supply is in critical state (<xsl:value-of select="$nowEN" />)</name>
	                <name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус блока питания: авария (<xsl:value-of select="$nowRU" />)</name>
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
<!-- 				<trigger>
					<id>psu.notok</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}&lt;&gt;{$PSU_OK_STATUS}</expression>
	                <name lang="EN">[<xsl:value-of select="alarmObject"/>] Power supply status: (<xsl:value-of select="$nowEN" />)</name>
	                <name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус блока питания: (<xsl:value-of select="$nowRU" />)</name>
	                <priority>1</priority>
	                <description lang="EN">Please check the power supply unit</description>
	                <description lang="RU">Проверьте блок питания</description>
	                <dependsOn>
	                	<dependency>psu.critical</dependency>
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
	               	</tags>
				</trigger>	 -->			
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
			<name lang="EN">[<xsl:value-of select="alarmObject"/>] Fan status</name>
			<name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус вентилятора</name>
			<group>Fans</group>
			<update><xsl:copy-of select="$update3min"/></update>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<triggers>
				<trigger>
					<id>fan.critical</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$FAN_CRIT_STATUS}</expression>
	                <name lang="EN"><xsl:value-of select="alarmObject"/> fan is in critical state (<xsl:value-of select="$nowEN" />)</name>
	                <name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус вентилятора: сбой (<xsl:value-of select="$nowRU" />)</name>
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
<!-- 				<trigger>
					<id>fan.notok</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}&lt;&gt;{$FAN_OK_STATUS}</expression>
	                <name lang="EN">[<xsl:value-of select="alarmObject"/>] Fan status: (<xsl:value-of select="$nowEN" />)</name>
	                <name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус вентилятора: (<xsl:value-of select="$nowRU" />)</name>
	                <priority>1</priority>
	                <description lang="EN">Please check the fan unit</description>
	                <description lang="RU">Проверьте вентилятор</description>
	                <dependsOn>
	                	<dependency>fan.critical</dependency>
	               	</dependsOn>
	               	<tags>
						<tag>
		                	<tag>Alarm.object.type</tag>
			                <value>
			             		<xsl:call-template name="tagAlarmObjectType">
						         		<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
						         		<xsl:with-param name="alarmObjectDefault">FAN</xsl:with-param>
			 					</xsl:call-template>
			 				</value>
						</tag>
	               	</tags>
				</trigger>	 -->
			</triggers>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>
</xsl:template>




<xsl:template match="template/metrics/sensor.fan.speed">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">[<xsl:value-of select="alarmObject"/>] Fan speed</name>
			<name lang="RU">[<xsl:value-of select="alarmObject"/>] Скорость вращения вентилятора</name>
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



<xsl:template match="template/metrics/system.hw.diskarray.status">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">[<xsl:value-of select="alarmObject"/>] Disk array controller status</name>
			<name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус контроллера дискового массива</name>
			<group>Disk Arrays</group>
			<history><xsl:copy-of select="$history7days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<triggers>
				<trigger>
				    <id>disk_array.disaster</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$DISK_ARRAY_DISASTER_STATUS}</expression>
	                <name lang="EN">[<xsl:value-of select="alarmObject"/>] Disk array controller is in unrecoverable state!</name>
	                <name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус контроллера дискового массива: сбой</name>
	                <url/>
	                <priority>5</priority>
	                <description lang="EN">Please check the device for faults</description>
	                <description lang="RU">Проверьте устройство</description>
	                <tags>
						<tag>
		                	<tag>Alarm.object.type</tag>
			                <value>
			             		<xsl:call-template name="tagAlarmObjectType">
						         		
						         		<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
						         		<xsl:with-param name="alarmObjectDefault">Disk</xsl:with-param>
			 					</xsl:call-template>
			 				</value>
						</tag>
	                </tags>
				</trigger>
				<trigger>
				    <id>disk_array.warning</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$DISK_ARRAY_WARN_STATUS}</expression>
	                <name lang="EN">[<xsl:value-of select="alarmObject"/>] Disk array controller is in warning state</name>
	                <name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус контроллера дискового массива: предупреждение</name>
	                <url/>
	                <priority>2</priority>
	                <description lang="EN">Please check the device for warnings</description>
	                <description lang="RU">Проверьте устройство</description>
	                <dependsOn>
	                	<dependency>disk_array.critical</dependency>
	               	</dependsOn>
	               	<tags>
             			<tag>
		                	<tag>Alarm.object.type</tag>
			                <value>
			             		<xsl:call-template name="tagAlarmObjectType">
						         		
						         		<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
						         		<xsl:with-param name="alarmObjectDefault">Disk</xsl:with-param>
			 					</xsl:call-template>
			 				</value>
						</tag>
               		</tags>
				</trigger>
				<trigger>
					<id>disk_array.critical</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$DISK_ARRAY_CRIT_STATUS}</expression>
	                <name lang="EN">[<xsl:value-of select="alarmObject"/>] Disk array controller is in critical state</name>
	                <name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус контроллера дискового массива: авария</name>
	                <url/>
	                <priority>4</priority>
	                <description lang="EN">Please check the device for errors</description>
	                <description lang="RU">Проверьте устройство</description>
	                <dependsOn>
	                	<dependency>disk_array.disaster</dependency>
	               	</dependsOn>
	               	<tags>
						<tag>
		                	<tag>Alarm.object.type</tag>
			                <value>
			             		<xsl:call-template name="tagAlarmObjectType">
						         		
						         		<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
						         		<xsl:with-param name="alarmObjectDefault">Disk</xsl:with-param>
			 					</xsl:call-template>
			 				</value>
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

<xsl:template match="template/metrics/system.hw.diskarray.model">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">[<xsl:value-of select="alarmObject"/>] Disk array controller model</name>
			<name lang="RU">[<xsl:value-of select="alarmObject"/>] Модель контроллера дискового массива</name>
			<group>Disk Arrays</group>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1day"/></update>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>
</xsl:template>

<xsl:template match="template/metrics/system.hw.physicaldisk.status">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">[<xsl:value-of select="alarmObject"/>] Physical Disk Status</name>
			<name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус физического диска</name>
			<group>Disks</group>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<triggers>
					<trigger>
					    <id>disk.notok</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.str({$DISK_OK_STATUS})}=0 and 
						{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.str("")}=0</expression>
		                <name lang="EN">[<xsl:value-of select="alarmObject"/>] Physical disk is not in OK state</name>
		                <name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус физического диска не норма</name>
		                <url/>
		                <priority>2</priority>
		                <description lang="EN">Please check physical disk for warnings or errors</description>
		                <description lang="RU">Проверьте диск</description>
		                <dependsOn>
		                	<dependency>disk.fail</dependency>
		                	<dependency>disk.warning</dependency>
		               	</dependsOn>
		               	<tags>
		                <tag>
		                	<tag>Alarm.object.type</tag>
			                <value>
			             		<xsl:call-template name="tagAlarmObjectType">
						         		<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
						         		<xsl:with-param name="alarmObjectDefault">Disk</xsl:with-param>	 					
			 					</xsl:call-template>
			 				</value>
						</tag>
		               		
		               	</tags>
					</trigger>
		
					<trigger>
					    <id>disk.warning</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$DISK_WARN_STATUS}</expression>
		                <name lang="EN">[<xsl:value-of select="alarmObject"/>] Physical disk is in warning state</name>
		                <name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус физического диска: предупреждение</name>
		                <url/>
		                <priority>2</priority>
		                <description lang="EN">Please check physical disk for warnings or errors</description>
		                <description lang="RU">Проверьте диск</description><dependsOn>
		                	<dependency>disk.fail</dependency>
		               	</dependsOn>
		               	<tags>			                
		               		<tag>
			                	<tag>Alarm.object.type</tag>
				                <value>
				             		<xsl:call-template name="tagAlarmObjectType">
							         		
							         		<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
							         		<xsl:with-param name="alarmObjectDefault">Disk</xsl:with-param>
				 					</xsl:call-template>
				 				</value>
							</tag>
						</tags>
					</trigger>
					<trigger>
						<id>disk.fail</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$DISK_FAIL_STATUS}</expression>
		                <name lang="EN">[<xsl:value-of select="alarmObject"/>] Physical disk failed</name>
		                <name lang="RU">[<xsl:value-of select="alarmObject"/>] Статус физического диска: сбой</name>
		                <url/>
		                <priority>4</priority>
						<description lang="EN">Please check physical disk for warnings or errors</description>
		                <description lang="RU">Проверьте диск</description>
		                <tags>
			                <tag>
			                	<tag>Alarm.object.type</tag>
				                <value>
				             		<xsl:call-template name="tagAlarmObjectType">
							         		<xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
							         		<xsl:with-param name="alarmObjectDefault">Disk</xsl:with-param>
				 					</xsl:call-template>
				 				</value>
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


<xsl:template match="template/metrics/system.hw.physicaldisk.serialnumber">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">[<xsl:value-of select="alarmObject"/>] Physical Disk Serial Number</name>
			<name lang="RU">[<xsl:value-of select="alarmObject"/>] Серийный номер физического диска</name>
			<group>Disks</group>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1day"/></update>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>
</xsl:template>


<!-- generic template metrics -->


<xsl:template match="template/metrics/system.uptime">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>Device uptime</name>
			<group>General</group>
			<description>The time since the network management portion of the system was last re-initialized.<xsl:value-of select="alarmObject"/></description>
			<units>uptime</units>
			<zabbixKey>system.uptime</zabbixKey>
			<update><xsl:copy-of select="$update30s"/></update>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<triggers>
				<trigger>
				    <id>uptime.restarted</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}&lt;10m or {<xsl:value-of select="../../name"/>:snmptrap.fallback.str(coldStart)}=1</expression><!-- TODO proper multiitem triggers shall be invented -->
					<recovery_expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}&gt;10m or {<xsl:value-of select="../../name"></xsl:value-of>:METRIC.nodata(30m)}=1</recovery_expression>
					<manual_close>1</manual_close>
	                <name lang="EN"><xsl:value-of select="alarmObject"/> The {HOST.NAME} has just been  restarted</name>
	                <name lang="RU"><xsl:value-of select="alarmObject"/>{HOST.NAME} был только что перезагружен</name>
	                <url/>
	                <priority>2</priority>
	                <description lang="EN">The device uptime is less then 10 minutes or SNMP trap(coldStart) received</description>
	                <description lang="RU">Аптайм устройства менее 10 минут или был получен SNMP trap(coldStart)</description>
	                <dependsOn>
	                	<dependency>uptime.nodata</dependency>
	               	</dependsOn>
              	    <tags>
	                	<tag>
			 				<tag>Alarm.type</tag>
			                <value>RESTARTED</value>
						</tag>
					</tags>
				</trigger>
				<trigger>
					<id>uptime.nodata</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.nodata({$SNMP_TIMEOUT})}=1</expression>
	                <name lang="EN"><xsl:value-of select="alarmObject"/> No SNMP data collection</name>
	                <name lang="RU"><xsl:value-of select="alarmObject"/> Нет сбора данных по SNMP</name>
	                <url/>
	                <priority>2</priority>
	                <description lang="EN">SNMP object sysUptime.0 is not available for polling. Please check device connectivity and SNMP settings.</description>
	                <description lang="RU">Не удается опросить sysUptime.0. Проверьте доступность устройства и настройки SNMP.</description>
	                <tags>
	                	<tag>
			 				<tag>Alarm.type</tag>
			                <value>NO_DATA</value>
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


<xsl:template match="template/metrics/snmptrap.fallback">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>SNMP traps (fallback)</name>
			<group>General</group>
			<logFormat>%H:%M:%S %Y/%m/%d</logFormat>
			<description>Item is used to collect all SNMP traps unmatched by other snmptrap items</description>
			<zabbixKey>snmptrap.fallback</zabbixKey>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<valueType><xsl:copy-of select="$valueTypeLog"/></valueType>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>
</xsl:template>



<xsl:template match="template/metrics/system.contact">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>Device contact details</name>
			<group>General</group>
			<description>The textual identification of the contact person for this managed node, together with information on how to contact this person.  If no contact information is known, the value is the zero-length string.</description>
			<zabbixKey>system.contact</zabbixKey>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1hour"/></update>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<inventory_link>23</inventory_link>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>


<xsl:template match="template/metrics/system.location">
	 <xsl:variable name="metric" as="element()*">
		<metric>
		<name>Device location</name>
		<group>General</group>
		<zabbixKey>system.location</zabbixKey>
		<history><xsl:copy-of select="$history14days"/></history>
		<trends><xsl:copy-of select="$trends0days"/></trends>
		<update><xsl:copy-of select="$update1hour"/></update>
		<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
		<inventory_link>24</inventory_link>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

<xsl:template match="template/metrics/system.objectid">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>System object ID</name>
			<group>General</group>
			<zabbixKey>system.objectid</zabbixKey>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1hour"/></update>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>		
</xsl:template>


<xsl:template match="template/metrics/system.name">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>Device name</name>
			<group>General</group>
			<zabbixKey>system.name</zabbixKey>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1hour"/></update>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<inventory_link>3</inventory_link>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>



<xsl:template match="template/metrics/system.descr">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>Device description</name>
			<group>General</group>
			<zabbixKey>system.descr</zabbixKey>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1hour"/></update>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<inventory_link>14</inventory_link>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

<!-- inventory -->

<xsl:template match="template/metrics/system.sw.os">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>Operating system</name>
			<group>Inventory</group>
			<xsl:if test="not(alarmObject)">
				<zabbixKey>system.sw.os</zabbixKey>
			</xsl:if>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1hour"/></update>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<inventory_link>5</inventory_link>
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>


<xsl:template match="template/metrics/system.hw.model">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">Hardware model name</name>
			<name lang="RU">Модель</name>
			<group>Inventory</group>
			<xsl:if test="not(alarmObject)">
				<zabbixKey>system.hw.model</zabbixKey>
			</xsl:if>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1hour"/></update>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<inventory_link>29</inventory_link> <!-- model -->
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>


<xsl:template match="template/metrics/system.hw.serialnumber">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN"><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>Hardware serial number</name>
			<name lang="RU"><xsl:value-of select="if (alarmObject!='') then concat('[',concat(alarmObject,'] ')) else ()"/>Серийный номер</name>
			<group>Inventory</group>
			<xsl:if test="not(alarmObject)">
				<zabbixKey>system.hw.serialnumber</zabbixKey>
			</xsl:if>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1hour"/></update>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<inventory_link>8</inventory_link> <!-- serial_noa-->
			<triggers>
				<trigger>
				    <id>sn.changed</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.diff()}=1 and {<xsl:value-of select="../../name"></xsl:value-of>:METRIC.strlen()}&gt;0</expression>
					<recovery_mode>2</recovery_mode>
					<manual_close>1</manual_close>
	                <name lang="EN"><xsl:value-of select="if (alarmObject!='') then alarmObject else $defaultAlarmObjectType" /> might have been replaced (new serial number:{ITEM.VALUE1})</name>
	                <name lang="RU">Возможно замена <xsl:value-of select="if (alarmObject!='') then alarmObject else 'устройства'" /> (новый серийный номер:{ITEM.VALUE1})</name>
	                <url/>
	                <priority>1</priority>
	                <description lang="EN"><xsl:value-of select="if (alarmObject!='') then alarmObject else $defaultAlarmObjectType" /> serial number has changed. Ack to close</description>
	                <description lang="RU">Изменился серийный номер <xsl:value-of select="if (alarmObject!='') then alarmObject else 'устройства'" />. Подтвердите и закройте.</description>
	                <tags>
	                	<tag>
			 				<tag>Alarm.type</tag>
			                <value>SN_CHANGE</value>
						</tag>
						<tag>
		                	<tag>Alarm.object.type</tag>
			                <value>
			             		<xsl:call-template name="tagAlarmObjectType">
						         		<xsl:with-param name="alarmObjectType" select="alarmObjectType" />
						         		<xsl:with-param name="alarmObjectDefault">Device</xsl:with-param>
			 					</xsl:call-template>
			 				</value>
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

<xsl:template match="template/metrics/system.hw.firmware">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">Firmware version</name>
			<name lang="RU">Версия прошивки</name>
			<group>Inventory</group>
			<xsl:if test="not(alarmObject)">
				<zabbixKey>system.hw.firmware</zabbixKey>
			</xsl:if>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1hour"/></update>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<triggers>
				<trigger>
				    <id>firmware.changed</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.diff()}=1 and {<xsl:value-of select="../../name"></xsl:value-of>:METRIC.strlen()}&gt;0</expression>
					<recovery_mode>2</recovery_mode>
					<manual_close>1</manual_close>
	                <name lang="EN">Firmware has changed: (new:{ITEM.VALUE1})</name>
	                <name lang="RU">Версия прошивки изменилась: (сейчас:{ITEM.VALUE1})</name>
	                <url/>
	                <priority>1</priority>
	                <description lang="EN">Firmware version has changed. Ack to close</description>
	                <description lang="RU">Версия прошивки изменилась. Подтвердите и закройте.</description>
	                <!-- <dependsOn>
		                	<dependency>sn.changed</dependency>
		            </dependsOn> -->
                    <tags>
	                	<tag>
			 				<tag>Alarm.type</tag>
			                <value>FIRMWARE_CHANGE</value>
						</tag>
						<tag>
		                	<tag>Alarm.object.type</tag>
			                <value>
			             		<xsl:call-template name="tagAlarmObjectType">
						         		<xsl:with-param name="alarmObjectType" select="alarmObjectType" />
						         		<xsl:with-param name="alarmObjectDefault">Device</xsl:with-param>
			 					</xsl:call-template>
			 				</value>
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



<xsl:template match="template/metrics/system.hw.version">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">Hardware version(revision)</name>
			<name lang="RU">Версия ревизии</name>
			<group>Inventory</group>
			<xsl:if test="not(alarmObject)">
				<zabbixKey>system.hw.version</zabbixKey>
			</xsl:if>
			<history><xsl:copy-of select="$history14days"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1hour"/></update>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>		
		</metric>
    </xsl:variable>
				
	<xsl:copy>
		<xsl:call-template name="defaultMetricBlock">
				<xsl:with-param name="metric" select="$metric" />
	    </xsl:call-template>
    </xsl:copy>	
</xsl:template>

</xsl:stylesheet>

