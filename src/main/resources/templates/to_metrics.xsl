<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:output method="xml" indent="yes"/>

<!-- 
<xsl:variable name="historyDefault">3</xsl:variable> 
<xsl:variable name="history1week">7</xsl:variable>
<xsl:variable name="trendsDefault">7</xsl:variable> 
<xsl:variable name="trends0days">0</xsl:variable>
<xsl:variable name="updateDefault">30</xsl:variable> 
<xsl:variable name="update1min">60</xsl:variable>
<xsl:variable name="update5min">300</xsl:variable>
<xsl:variable name="update1hour">60</xsl:variable> 
<xsl:variable name="update1day">300</xsl:variable>
for output: -->
<xsl:variable name="historyDefault">30</xsl:variable>  
<xsl:variable name="history1week">7</xsl:variable>
<xsl:variable name="trendsDefault">365</xsl:variable> 
<xsl:variable name="trends0days">0</xsl:variable>
<xsl:variable name="updateDefault">300</xsl:variable> 
<xsl:variable name="update1min">60</xsl:variable>
<xsl:variable name="update5min">300</xsl:variable>
<xsl:variable name="update1hour">3600</xsl:variable> 
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
			<CPU_LOAD_MAX>90</CPU_LOAD_MAX>
        </Performance>
        <Fault>
        	<TEMP_CRIT>60</TEMP_CRIT>
        	<TEMP_WARN>50</TEMP_WARN>        
        </Fault>
        <General>
        	<SNMP_TIMEOUT>600</SNMP_TIMEOUT>
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

<xsl:variable name="defaultLocationType">Device</xsl:variable>
<xsl:template name="tagLocationType">
  <xsl:param name="locationType"/>
  <xsl:param name="locationAddress"/>
  <xsl:param name="locationDefault"/>
  <xsl:if test="$locationType">
      <xsl:value-of select="$locationType" />
  </xsl:if>
  <xsl:if test="not($locationType)">
  	<xsl:if test="$locationAddress">
      <xsl:value-of select="$locationAddress" />
  	</xsl:if>
    <xsl:if test="not($locationAddress)">
      <xsl:value-of select="$locationDefault" />
    </xsl:if>
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
					        		<macro>{$<xsl:value-of select ="name(.)"/>}</macro>
					                <value><xsl:value-of select="."/></value>
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
		<xsl:copy-of select="$metric/inventory_link"></xsl:copy-of>
		

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
 
 
<xsl:template match="template/metrics/system.cpu.load">
	 
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN"><xsl:if test="locationAddress != ''">[<xsl:value-of select="locationAddress" />] </xsl:if>CPU Load</name>
			<name lang="RU"><xsl:if test="locationAddress != ''">[<xsl:value-of select="locationAddress" />] </xsl:if>Загрузка процессора</name>
			<group>CPU</group>
			<description>CPU load in %</description>
			<units>%</units>
			<triggers>
				<trigger>
					<documentation>If locationAddress is defined, it's added to trigger name.</documentation>
					<!-- {<xsl:value-of select="../../name"></xsl:value-of>:123 -->
					<expression>{<xsl:value-of select="../../name"/>:METRIC.avg(300)}>{$CPU_LOAD_MAX}</expression>
	                <name lang="EN"><xsl:if test="locationAddress != ''">[<xsl:value-of select="locationAddress" />] </xsl:if>CPU load is too high (<xsl:value-of select="$nowEN" />)</name>
	                <name lang="RU"><xsl:if test="locationAddress != ''">[<xsl:value-of select="locationAddress" />] </xsl:if>Загрузка ЦПУ слишком велика (<xsl:value-of select="$nowRU" />)</name>
	                <url />
	                <priority>3</priority>
	                <description />
	                <tags>
	                	<tag>
		                	<tag>Location.type</tag>
			                <value>
			             		<xsl:call-template name="tagLocationType">
						         		<xsl:with-param name="locationAddress" select="locationAddress" />
						         		<xsl:with-param name="locationType" select="locationType" />
						         		<xsl:with-param name="locationDefault">CPU</xsl:with-param>
			 					</xsl:call-template>
			 				</value>
	 					</tag>
		                <tag><tag>Performance</tag><value></value></tag>
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
			<name><xsl:if test="locationAddress != ''">[<xsl:value-of select="locationAddress"/>] </xsl:if>Used memory</name>
			<group>Memory</group>
			<units>B</units>
			<description>Used memory in Bytes</description>
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
			<name><xsl:if test="locationAddress != ''">[<xsl:value-of select="locationAddress"/>] </xsl:if>Available memory</name> <!--  Available as in zabbix agent templates -->
			<group>Memory</group>
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
			<name><xsl:if test="locationAddress != ''">[<xsl:value-of select="locationAddress"/>] </xsl:if>Total memory</name>
			<group>Memory</group>
			<description>Total memory in Bytes</description>
			<units>B</units>
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


<xsl:template match="template/metrics/vm.memory.used.percentage">
	
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name><xsl:if test="locationAddress != ''">[<xsl:value-of select="locationAddress"/>] </xsl:if>Memory utilization</name>
			<group>Memory</group>
			<description>Memory utilization in %</description>
			<units>%</units>
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
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.avg(300)}>90</expression>
	                <name lang="EN"><xsl:if test="locationAddress != ''">[<xsl:value-of select="locationAddress"/>] </xsl:if>Memory utilization is too high (<xsl:value-of select="$nowEN" />)</name>
	                <name lang="RU"><xsl:if test="locationAddress != ''">[<xsl:value-of select="locationAddress"/>] </xsl:if>Мало свободной памяти ОЗУ (<xsl:value-of select="$nowRU" />)</name>
	                <url/>
	                <priority>3</priority>
	                <description/>
	                <tags>
	                	<tag>
		                	<tag>Location.type</tag>
			                <value>
			             		<xsl:call-template name="tagLocationType">
						         		<xsl:with-param name="locationAddress" select="locationAddress"/>
						         		<xsl:with-param name="locationType" select="locationType"/>
						         		<xsl:with-param name="locationDefault">Memory</xsl:with-param>	 					
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



<!-- storage(same as memory) -->

<xsl:template match="template/metrics/vfs.fs.units">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>[<xsl:value-of select="locationAddress"/>] Storage units</name>
			<group>Internal Items</group>
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
			<name>[<xsl:value-of select="locationAddress"/>] Used storage in units</name>
			<group>Internal Items</group>
			<description>Used storage in units</description>
			<units>units</units>
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
			<name>[<xsl:value-of select="locationAddress"/>] Total storage in units</name>
			<group>Internal Items</group>
			<description>Total storage in units</description>
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
			<name>[<xsl:value-of select="locationAddress"/>] Used space</name>
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
			<name>[<xsl:value-of select="locationAddress"/>] Free space</name>
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
			<name>[<xsl:value-of select="locationAddress"/>] Total storage</name>
			<group>Storage</group>
			<description>Total storage in Bytes</description>			
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


<xsl:template match="template/metrics/vfs.fs.used.percentage">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name>[<xsl:value-of select="locationAddress"/>] Storage utilization</name>
			<group>Storage</group>
			<description>Storage utilization in % for <xsl:value-of select="locationAddress"/></description>			
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
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.avg(300)}>90</expression>
		                <name lang="EN">[<xsl:value-of select="locationAddress"/>] Free disk space is less than 10%</name>
		                <name lang="RU">[<xsl:value-of select="locationAddress"/>] Свободного места <xsl:value-of select="locationAddress"/> меньше 10%</name>
		                <url/>
		                <priority>3</priority>
		                <description/>
					</trigger>
					
					<trigger>
						<id>storageWarn</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.avg(300)}>80</expression>
		                <name lang="EN">[<xsl:value-of select="locationAddress"/>] Free disk space is less than 20%</name>
		                <name lang="RU">[<xsl:value-of select="locationAddress"/>] Свободного места <xsl:value-of select="locationAddress"/> меньше 20%</name>
		                <url/>
		                <priority>2</priority>
		                <description/>
						<dependsOn>
		                	<dependency>storageCrit</dependency>
		               	</dependsOn>
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
			<name lang="EN">[<xsl:value-of select="locationAddress"/>] Temperature</name>
			<name lang="RU">[<xsl:value-of select="locationAddress"/>] Температура</name>
			<group>Temperature</group>
			<description>Temperature readings of testpoint: <xsl:value-of select="locationAddress"/></description>
			<units>C</units>
			<valueType><xsl:copy-of select="$valueTypeFloat"/></valueType>
			<update>
				<!-- TODO: make this feature global -->
				<xsl:call-template name="updateIntervalTemplate">
	         		<xsl:with-param name="updateMultiplier" select="updateMultiplier"/>
	         		<xsl:with-param name="default" select="$updateDefault"/>
	 			</xsl:call-template>
 			</update>
			<triggers>
				<trigger>
				    <id>tempWarn</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.avg(300)}>{$TEMP_WARN:"<xsl:value-of select="locationType" />"}</expression>
	                <name lang="EN"><xsl:value-of select="locationAddress" /> temperature is above warning threshold: >{$TEMP_WARN:"<xsl:value-of select="locationType" />"} (<xsl:value-of select="$nowEN" />)</name>
	                <name lang="RU">[<xsl:value-of select="locationAddress" />] Температура выше нормы: >{$TEMP_WARN:"<xsl:value-of select="locationType" />"} (<xsl:value-of select="$nowRU" />)</name>
	                <url />
	                <priority>2</priority>
	                <description />
	                <dependsOn>
	                	<dependency>tempCrit</dependency>
	               	</dependsOn>
	               	<tags>	                
	               		<tag>
		                	<tag>Location.type</tag>
			                <value>
			             		<xsl:call-template name="tagLocationType">
						         		<xsl:with-param name="locationAddress" select="locationAddress"/>
						         		<xsl:with-param name="locationType" select="locationType"/>
						         		<xsl:with-param name="locationDefault" select="$defaultLocationType"/>	 					
			 					</xsl:call-template>
			 				</value>
						</tag>
						
	               	<tag><tag>Temperature</tag><value></value></tag></tags>
				</trigger>
				<trigger>
					<id>tempCrit</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.avg(300)}>{$TEMP_CRIT:"<xsl:value-of select="locationType"/>"}</expression>
	                <name lang="EN"><xsl:value-of select="locationAddress"/> temperature is above critical threshold: >{$TEMP_CRIT:"<xsl:value-of select="locationType"/>"} (<xsl:value-of select="$nowEN" />)</name>
	                <name lang="RU">[<xsl:value-of select="locationAddress"/>]Температура очень высокая: >{$TEMP_CRIT:"<xsl:value-of select="locationType"/>"} (<xsl:value-of select="$nowRU" />)</name>
	                <url/>
	                <priority>4</priority>
	                <description/>
	                <tags>
		                <tag>
		                	<tag>Location.type</tag>
			                <value>
			             		<xsl:call-template name="tagLocationType">
						         		<xsl:with-param name="locationAddress" select="locationAddress"/>
						         		<xsl:with-param name="locationType" select="locationType"/>
						         		<xsl:with-param name="locationDefault" select="$defaultLocationType"/>	 					
			 					</xsl:call-template>
			 				</value>
						</tag>
	 				
	                <tag><tag>Temperature</tag><value></value></tag>
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
			<name>[<xsl:value-of select="locationAddress"/>] Temperature status</name>
			<group>Temperature</group>
			<description>Temperature status of testpoint: <xsl:value-of select="locationAddress"/></description>
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
			<name>[<xsl:value-of select="locationAddress"/>] Temperature sensor location</name>
			<group>Temperature</group>
			<description>Temperature location of testpoint: <xsl:value-of select="locationAddress"/></description>
			<history><xsl:copy-of select="$history1week"/></history>
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
			<triggers>
					<trigger>
					    <id>health.disaster</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$HEALTH_DISASTER_STATUS}</expression>
		                <name lang="EN">System is in unrecoverable state!</name>
		                <name lang="RU">Статус системы: сбой</name>
		                <url/>
		                <priority>5</priority>
		                <description lang="EN">Please check the device for faults</description>
		                <description lang="RU">Проверьте устройство</description>
					</trigger>
					<trigger>
					    <id>health.warning</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$HEALTH_WARN_STATUS}</expression>
		                <name lang="EN">System status is in warning state</name>
		                <name lang="RU">Статус системы: предупреждение</name>
		                <url/>
		                <priority>2</priority>
		                <description lang="EN">Please check the device for warnings</description>
		                <description lang="RU">Проверьте устройство</description>
		                <dependsOn>
		                	<dependency>health.critical</dependency>
		               	</dependsOn>
					</trigger>
					<trigger>
						<id>health.critical</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$HEALTH_CRIT_STATUS}</expression>
		                <name lang="EN">System status is in critical state</name>
		                <name lang="RU">Статус системы: авария</name>
		                <url/>
		                <priority>4</priority>
		                <description lang="EN">Please check the device for errors</description>
		                <description lang="RU">Проверьте устройство</description>
		                <dependsOn>
		                	<dependency>health.disaster</dependency>
		               	</dependsOn>
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




<xsl:template match="template/metrics/system.hw.diskarray.status">
	 <xsl:variable name="metric" as="element()*">
		<metric>
			<name lang="EN">[<xsl:value-of select="locationAddress"/>] Disk array controller status</name>
			<name lang="RU">[<xsl:value-of select="locationAddress"/>] Статус контроллера дискового массива</name>
			<group>Disk Arrays</group>
			<history><xsl:copy-of select="$history1week"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<triggers>
				<trigger>
				    <id>disk_array.disaster</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$DISK_ARRAY_DISASTER_STATUS}</expression>
	                <name lang="EN">[<xsl:value-of select="locationAddress"/>] Disk array controller is in unrecoverable state!</name>
	                <name lang="RU">[<xsl:value-of select="locationAddress"/>] Статус контроллера дискового массива: сбой</name>
	                <url/>
	                <priority>5</priority>
	                <description lang="EN">Please check the device for faults</description>
	                <description lang="RU">Проверьте устройство</description>
	                <tags><tag><tag>Location.type</tag><value><xsl:value-of select="locationType"/></value></tag></tags>
				</trigger>
				<trigger>
				    <id>disk_array.warning</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$DISK_ARRAY_WARN_STATUS}</expression>
	                <name lang="EN">[<xsl:value-of select="locationAddress"/>] Disk array controller is in warning state</name>
	                <name lang="RU">[<xsl:value-of select="locationAddress"/>] Статус контроллера дискового массива: предупреждение</name>
	                <url/>
	                <priority>2</priority>
	                <description lang="EN">Please check the device for warnings</description>
	                <description lang="RU">Проверьте устройство</description>
	                <dependsOn>
	                	<dependency>disk_array.critical</dependency>
	               	</dependsOn>
	               	<tags><tag><tag>Location.type</tag><value><xsl:value-of select="locationType"/></value></tag></tags>
				</trigger>
				<trigger>
					<id>disk_array.critical</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$DISK_ARRAY_CRIT_STATUS}</expression>
	                <name lang="EN">[<xsl:value-of select="locationAddress"/>] Disk array controller is in critical state</name>
	                <name lang="RU">[<xsl:value-of select="locationAddress"/>] Статус контроллера дискового массива: авария</name>
	                <url/>
	                <priority>4</priority>
	                <description lang="EN">Please check the device for errors</description>
	                <description lang="RU">Проверьте устройство</description>
	                <dependsOn>
	                	<dependency>disk_array.disaster</dependency>
	               	</dependsOn>
	               	<tags><tag><tag>Location.type</tag><value><xsl:value-of select="locationType"/></value></tag></tags>
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
			<name lang="EN">[<xsl:value-of select="locationAddress"/>] Disk array controller model</name>
			<name lang="RU">[<xsl:value-of select="locationAddress"/>] Модель контроллера дискового массива</name>
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
			<name lang="EN">[<xsl:value-of select="locationAddress"/>] Physical Disk Status</name>
			<name lang="RU">[<xsl:value-of select="locationAddress"/>] Статус физического диска</name>
			<group>Disks</group>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<triggers>
					<trigger>
					    <id>disk.notok</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.str({$DISK_OK_STATUS})}=0 and 
						{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.str("")}=0</expression>
		                <name lang="EN">[<xsl:value-of select="locationAddress"/>] Physical disk is not in OK state</name>
		                <name lang="RU">[<xsl:value-of select="locationAddress"/>] Статус физического диска не норма</name>
		                <url/>
		                <priority>2</priority>
		                <description lang="EN">Please check physical disk for warnings or errors</description>
		                <description lang="RU">Проверьте диск</description>
		                <dependsOn>
		                	<dependency>disk.fail</dependency>
		                	<dependency>disk.warning</dependency>
		               	</dependsOn>
		               	<tags><tag><tag>Location.type</tag><value><xsl:value-of select="locationType"/></value></tag></tags>
					</trigger>
		
					<trigger>
					    <id>disk.warning</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$DISK_WARN_STATUS}</expression>
		                <name lang="EN">[<xsl:value-of select="locationAddress"/>] Physical disk is in warning state</name>
		                <name lang="RU">[<xsl:value-of select="locationAddress"/>] Статус физического диска: предупреждение</name>
		                <url/>
		                <priority>2</priority>
		                <description lang="EN">Please check physical disk for warnings or errors</description>
		                <description lang="RU">Проверьте диск</description><dependsOn>
		                	<dependency>disk.fail</dependency>
		               	</dependsOn>
		               	<tags><tag><tag>Location.type</tag><value><xsl:value-of select="locationType"/></value></tag></tags>
					</trigger>
					<trigger>
						<id>disk.fail</id>
						<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}={$DISK_FAIL_STATUS}</expression>
		                <name lang="EN">[<xsl:value-of select="locationAddress"/>] Physical disk failed</name>
		                <name lang="RU">[<xsl:value-of select="locationAddress"/>] Статус физического диска: сбой</name>
		                <url/>
		                <priority>4</priority>
						<description lang="EN">Please check physical disk for warnings or errors</description>
		                <description lang="RU">Проверьте диск</description>
		                <tags><tag><tag>Location.type</tag><value><xsl:value-of select="locationType"/></value></tag></tags>             
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
			<name lang="EN">[<xsl:value-of select="locationAddress"/>] Physical Disk Serial Number</name>
			<name lang="RU">[<xsl:value-of select="locationAddress"/>] Серийный номер физического диска</name>
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
			<description>The time since the network management portion of the system was last re-initialized.<xsl:value-of select="locationAddress"/></description>
			<units>uptime</units>
			<zabbixKey>system.uptime</zabbixKey>
			<update><xsl:copy-of select="$update1min"/></update>
			<triggers>
				<trigger>
				    <id>uptime.restarted</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}&lt;600 or {<xsl:value-of select="../../name"/>:snmptrap.fallback.str(coldStart)}=1</expression><!-- TODO proper multiitem triggers shall be invented -->
					<recovery_expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.last(0)}&gt;600 or {<xsl:value-of select="../../name"></xsl:value-of>:METRIC.nodata(1800)}=1</recovery_expression>
					<manual_close>1</manual_close>
	                <name lang="EN"><xsl:value-of select="locationAddress"/> The {HOST.NAME} has just been  restarted</name>
	                <name lang="RU"><xsl:value-of select="locationAddress"/>{HOST.NAME} был только что перезагружен</name>
	                <url/>
	                <priority>2</priority>
	                <description lang="EN">The device uptime is less then 10 minutes or SNMP trap(coldStart) received</description>
	                <description lang="RU">Аптайм устройства менее 10 минут или был получен SNMP trap(coldStart)</description>
	                <dependsOn>
	                	<dependency>uptime.nodata</dependency>
	               	</dependsOn>
				</trigger>
				<trigger>
					<id>uptime.nodata</id>
					<expression>{<xsl:value-of select="../../name"></xsl:value-of>:METRIC.nodata({$SNMP_TIMEOUT})}=1</expression>
	                <name lang="EN"><xsl:value-of select="locationAddress"/> No SNMP data collection</name>
	                <name lang="RU"><xsl:value-of select="locationAddress"/> Нет сбора данных по SNMP</name>
	                <url/>
	                <priority>2</priority>
	                <description lang="EN">SNMP object sysUptime.0 is not available for polling. Please check device connectivity and SNMP settings.</description>
	                <description lang="RU">Не удается опросить sysUptime.0. Проверьте доступность устройства и настройки SNMP.</description>
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
			<history><xsl:copy-of select="$history1week"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1min"/></update>
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
			<history><xsl:copy-of select="$history1week"/></history>
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
		<history><xsl:copy-of select="$history1week"/></history>
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
			<name>system ObjectID</name>
			<group>General</group>
			<zabbixKey>system.objectid</zabbixKey>
			<history><xsl:copy-of select="$history1week"/></history>
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
			<history><xsl:copy-of select="$history1week"/></history>
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
			<zabbixKey>system.objectid</zabbixKey>
			<history><xsl:copy-of select="$history1week"/></history>
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
			<name>OS</name>
			<group>Inventory</group>
			<zabbixKey>system.sw.os</zabbixKey>
			<history><xsl:copy-of select="$history1week"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1day"/></update>
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
			<zabbixKey>system.hw.model</zabbixKey>
			<history><xsl:copy-of select="$history1week"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1day"/></update>
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
			<name lang="EN">Hardware Serial Number</name>
			<name lang="RU">Серийный номер</name>
			<group>Inventory</group>
			<zabbixKey>system.hw.serialnumber</zabbixKey>
			<history><xsl:copy-of select="$history1week"/></history>
			<trends><xsl:copy-of select="$trends0days"/></trends>
			<update><xsl:copy-of select="$update1day"/></update>
			<valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
			<inventory_link>8</inventory_link> <!-- serial_noa-->
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
			<zabbixKey>system.hw.firmware</zabbixKey>
			<history><xsl:copy-of select="$history1week"/></history>
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

</xsl:stylesheet>

