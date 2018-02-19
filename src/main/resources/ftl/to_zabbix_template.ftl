<#ftl output_format="XML">
<#assign t = body>
<#assign zbx_ver = '3.4'>
<#assign snmp_community= '{$SNMP_COMMUNITY}'>
<zabbix_export>
			<version>${zbx_ver}</version>
            <date>2015-12-30T14:41:30Z</date>
			<groups>
				<group><name>Templates/Test</name></group> <#-- will populate in the next xslt -->
			</groups>
            <templates>
                  <template>
	            	  <template>${t.name}</template>
	            	  <name>${t.name}</name>
	                  <description>>${t.description}</description>
	                  <groups>
	                  	<group><name>Templates/Test</name></group>
		                <#-- <group>
		                    <xsl:choose>
		                        <xsl:when test="./classes[class='OS']"><name>Templates/Operating Systems</name></xsl:when>
		                        <xsl:when test="./classes[class='Network']"><name>Templates/Network Devices</name></xsl:when>
		                        <xsl:when test="./classes[class='Server']"><name>Templates/Servers Hardware</name></xsl:when>
		                        <xsl:when test="./classes[class='Module']"><name>Templates/Modules</name></xsl:when>
		                        <xsl:otherwise><name>Templates/Modules</name></xsl:otherwise>
		                    </xsl:choose>
		                </group>
		                 -->
		            </groups>
		            <applications>
		                <#list distinct_by_key(t.metricsRegistry,'group') as g>
		                <application>
	                		<name>${g}</name>
	                	</application>
		                </#list>
		            </applications>
		            <items>
		            	<#list t.metrics as m>
		            	<item>
		            		<@item m/>
	            		</item>
		            	</#list>
		            </items>
		            <discovery_rules>
		                <#list t.discoveryRules as dr>
		            	<discovery_rule>
		            		<@discovery_rule dr/>
	            		</discovery_rule>
		            	</#list>
		            </discovery_rules>
		            <#if zbx_ver = '3.4'><httptests/></#if>
		            <macros>
		            	<#list t.macros as macro>
	                    <macro>
	                        <macro>${macro.macro}</macro>
	                        <value>${macro.value}</value>
	                    </macro>
		            	</#list>
		            </macros>
		            <#-- <macros>//TODO
		                <xsl:for-each-group select="macros/macro" group-by="macro">
		                    <macro>
		                        <macro><xsl:value-of select="./macro"/></macro>
		                        <value><xsl:value-of select="./value"/></value>
		                    </macro>
		                </xsl:for-each-group>
		            </macros> -->
		            <templates/>
		            <#-- //TODO<xsl:copy-of copy-namespaces="no" select="./templates"/><!-- template dependencies block --> 
		            <screens/>
		        </template>
            </templates>
            <graphs/>
            <#-- <graphs>
                <xsl:apply-templates select="child::*/*/metrics/*[not (discoveryRule)]/graphs/graph"/>
            </graphs> -->
            <triggers/>
            <#-- <triggers>
                <xsl:apply-templates select="child::*/*/metrics/*[not (discoveryRule)]/triggers/trigger"/>
            </triggers> -->
            <value_maps/>
            <#-- <value_maps>
                <xsl:copy-of copy-namespaces="no" select="child::*/value_maps/*"/>
            </value_maps> -->
        </zabbix_export>

<#-- m - metric-->
<#macro item m>
					        <name>${m.name}</name>
					        <type>${m.type.getZabbixValue()!'none'}</type>
					        <#if m.type == 'SNMP'>
							<snmp_community>${snmp_community}</snmp_community>
							<#else>
							<snmp_community/>
							</#if>
							<#if zbx_ver == '3.2'>
								<#local multiplier_value = 0>
								<#list m.preprocessing as p>
									<#if p.type == 'MULTIPLIER'>
										<#local multiplier_value = 1>	
										<#break>
									</#if>	
								</#list>
							<multiplier>${multiplier_value}</multiplier>
							</#if>
							<snmp_oid>${m.oid}</snmp_oid>
					        <key>${m.key}</key>
							<delay>${time_suffix_to_seconds(m.delay)}</delay> <#-- <xsl:call-template name="time_suffix_to_seconds"> -->                
					        <history>${time_suffix_to_days(m.history)}</history><#-- <xsl:call-template name="time_suffix_to_days">  -->
					        <trends>${time_suffix_to_days(m.trends)}</trends><#-- <xsl:call-template name="time_suffix_to_days">  -->
					        <status>0</status>
					        <value_type>${m.valueType.getZabbixValue()}</value_type>
					        <allowed_hosts/>
					        <units>${m.units!''}</units>
							<#if zbx_ver == '3.2'>
								<#local delta_value = 0>
								<#list m.preprocessing as p>
									<#if p.type == 'DELTA_PER_SECOND'>
										<#local delta_value = 1>	
										<#break>
									</#if>	
								</#list>
							<delta>${delta_value}</delta>
							</#if>					         
					        <snmpv3_contextname/>
					        <snmpv3_securityname/>
					        <snmpv3_securitylevel>0</snmpv3_securitylevel>
					        <snmpv3_authprotocol>0</snmpv3_authprotocol>
					        <snmpv3_authpassphrase/>
					        <snmpv3_privprotocol>0</snmpv3_privprotocol>
					        <snmpv3_privpassphrase/>
							<#if zbx_ver == '3.2'>
								<#local formula_value = 0>
								<#list m.preprocessing as p>
									<#if p.type == 'MULTIPLIER'>
										<#local formula_value = 1>	
										<#break>
									</#if>	
								</#list>
							<formula>${formula_value}</formula>
							</#if>
					        <#if zbx_ver = '3.2'><delay_flex/></#if>
					        <params>${m.expressionFormula!''}</params>
					        <ipmi_sensor/>
					        <#if zbx_ver = '3.2'><data_type>0</data_type></#if>
					        <authtype>0</authtype>
					        <username/>
					        <password/>
					        <publickey/>
					        <privatekey/>
					        <port/>
					        <description></description><#-- <xsl:value-of select="replace(./description, '^\s+|\s+$', '')"/> -->
					        <inventory_link>${m.inventoryLink!0}</inventory_link>
					        <applications>
					        <#-- change group to array in Java?<#list m.group>
					        	<application>
					                <name>${g}</name>
					            </application>
					        </#list> -->
					        </applications>
					        <valuemap>
					        <#-- 
					            <xsl:choose>
					                <xsl:when test="./valueMap != ''">
					                    <name>
					                        <xsl:value-of select="./valueMap"/>
					                    </name>
					                </xsl:when>
					            </xsl:choose>
					         -->
					        </valuemap>
					        <logtimefmt>${m.logtimefmt!''}</logtimefmt>
					        <#if zbx_ver == '3.4'>
					        <preprocessing>
					        <#list m.preprocessing as p>
					            <step>
					                <type>${p.type.getZabbixValue()}</type>
					                <params>${p.params!''}</params>
					            </step>
					        </#list>
					        </preprocessing>
					        </#if>
				            <#if zbx_ver = '3.4'><jmx_endpoint/></#if>
				            <#if zbx_ver = '3.4'>
				            	<#if m.discoveryRule??><#-- item prototype-->
				            <application_prototypes/>
				            <master_item_prototype/>
				            	<#else><#-- normal item -->
				            <master_item/>
				            	</#if>
				            </#if>					        
</#macro>

<#macro discovery_rule dr>
	
            <name>${dr.name}</name>
            <type>4</type><#-- <xsl:copy-of select="$snmp_item_type"/> -->
            <snmp_community>${snmp_community}</snmp_community>
            <snmp_oid>${dr.oid}</snmp_oid>
            <key>${dr.key}</key>
            <delay>1h</delay>
            <#--<xsl:call-template name="time_suffix_to_seconds">
                    <xsl:with-param name="time" select="$discoveryDelay"/>
                </xsl:call-template>  -->
            <status>0</status>
            <allowed_hosts/>
            <snmpv3_contextname/>
            <snmpv3_securityname/>
            <snmpv3_securitylevel>0</snmpv3_securitylevel>
            <snmpv3_authprotocol>0</snmpv3_authprotocol>
            <snmpv3_authpassphrase/>
            <snmpv3_privprotocol>0</snmpv3_privprotocol>
            <snmpv3_privpassphrase/>
            <#if zbx_ver = '3.2'><delay_flex/></#if>
            <params/>
            <ipmi_sensor/>
            <authtype>0</authtype>
            <username/>
            <password/>
            <publickey/>
            <privatekey/>
            <port/>
            <filter>
            <#if dr.filter??>
            	<evaltype>${dr.filter.evalType.getZabbixValue()}</evaltype>
            	<formula>${dr.filter.formula!''}</formula>
            	<conditions>
            	<#list dr.filter.conditions as cond>
            		<condition>
            			<macro>${cond.macro}</macro>
            			<value>${cond.value}</value>
            			<operator>${cond.operator}</operator>
						<formulaid>${cond.formulaid!''}</formulaid>
            		</condition>
            	</#list>
            	</conditions>
            <#else>
            	<evaltype>0</evaltype>
                <formula/>
                <conditions/>
            </#if>
            </filter>
            <lifetime>30d</lifetime>
            <#-- lifetime: <xsl:call-template name="time_suffix_to_days">
                    <xsl:with-param name="time">30d</xsl:with-param>
                </xsl:call-template> -->
            <description></description><#-- <xsl:value-of select="replace(./description, '^\s+|\s+$', '')"/> -->
            <item_prototypes>
				<#list dr.metrics as m>
	            	<item_prototype>
		            	<@item m/>
            		</item_prototype>
            	</#list>
            </item_prototypes>
            <trigger_prototypes/><#--  <xsl:apply-templates select="../../metrics/*[discoveryRule = $disc_name]/triggers/trigger"/> -->
            <graph_prototypes/><#-- <xsl:apply-templates select="../../metrics/*[discoveryRule = $disc_name]/graphs/graph"/>  -->
            <host_prototypes/>
            <#if zbx_ver = '3.4'><jmx_endpoint/></#if>
 </#macro>

<#--     <xsl:template name="triggerTemplate">
        <xsl:variable name="template_name" select="../../../../name"/>
        <xsl:variable name="metric_name" select="../../name"/>
        <xsl:variable name="metric_alarm_object" select="../../alarmObject"/>
        <xsl:variable name="disc_name" select="../../discoveryRule"/>

        <expression><xsl:value-of select="replace(./expression,'TEMPLATE_NAME',$template_name)"/></expression>
        <recovery_mode>
            <xsl:choose>
                <xsl:when test="./recovery_expression != ''">1</xsl:when>
                <xsl:when test="./recovery_mode != ''"><xsl:value-of select="./recovery_mode"/></xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </recovery_mode>
        <recovery_expression><xsl:value-of select="replace(./recovery_expression,'TEMPLATE_NAME',$template_name)"/></recovery_expression>
        <name><xsl:value-of select="./name"/></name>
        <correlation_mode>0</correlation_mode>
        <correlation_tag/>
        <url><xsl:value-of select="./url"/></url>
        <status>0</status>
        <priority><xsl:value-of select="./priority"/></priority>
        <description><xsl:value-of select="replace(./description, '^\s+|\s+$', '')"/></description>
        <type>0</type>
        <manual_close>
            <xsl:choose>
                <xsl:when test="./manual_close = 1">1</xsl:when>
                <xsl:otherwise>0</xsl:otherwise>
            </xsl:choose>
        </manual_close>
        <dependencies>
            <xsl:for-each select="./dependsOn/dependency">
                <xsl:variable name="trigger_id" select="."/>
                <dependency>
                    <xsl:choose>
                        <xsl:when test="../global = true()"> <!-- search in other templates (other merge files (refactor this!!!) 
                            <xsl:variable name="module" select="doc('file:bin/merged/00template_module_icmp_ping.xml')"></xsl:variable>
                            <name><xsl:value-of select="$module//metrics/*[alarmObject = $metric_alarm_object and (discoveryRule=$disc_name or (not(discoveryRule) and not($disc_name = '')))]/triggers/trigger[id=$trigger_id]/name[@lang=$lang or not(@lang)]"/></name>
                            <expression><xsl:value-of select="replace($module//template/metrics/*[alarmObject = $metric_alarm_object and (discoveryRule=$disc_name or (not(discoveryRule) and not($disc_name = '')))]/triggers/trigger[id=$trigger_id]/expression,'TEMPLATE_NAME',$template_name)"/></expression>
                            <recovery_expression><xsl:value-of select="replace($module//template/metrics/*[alarmObject = $metric_alarm_object and (discoveryRule=$disc_name or (not(discoveryRule) and not($disc_name = '')))]/triggers/trigger[id=$trigger_id]/recovery_expression,'TEMPLATE_NAME',$template_name)"/></recovery_expression>
                        </xsl:when>
                        <--<xsl:when test="../global = true()"> &lt;!&ndash; search in other templates (but templates must in the same file) &ndash;&gt;
                            <name><xsl:value-of select="//template/metrics/*[alarmObject = $metric_alarm_object and (discoveryRule=$disc_name or (not(discoveryRule) and not($disc_name = '')))]/triggers/trigger[id=$trigger_id]/name"/></name>
                            <expression><xsl:value-of select="replace(//template/metrics/*[alarmObject = $metric_alarm_object and (discoveryRule=$disc_name or (not(discoveryRule) and not($disc_name = '')))]/triggers/trigger[id=$trigger_id]/expression,'TEMPLATE_NAME',$template_name)"/></expression>
                            <recovery_expression><xsl:value-of select="replace(//template/metrics/*[alarmObject = $metric_alarm_object and (discoveryRule=$disc_name or (not(discoveryRule) and not($disc_name = '')))]/triggers/trigger[id=$trigger_id]/recovery_expression,'TEMPLATE_NAME',$template_name)"/></recovery_expression>
                        </xsl:when>
                        <xsl:otherwise>
                            <name><xsl:value-of select="//template[name=$template_name]/metrics/*[alarmObject = $metric_alarm_object and (discoveryRule=$disc_name or (not(discoveryRule) and not($disc_name = '')))]/triggers/trigger[id=$trigger_id]/name"/></name>
                            <expression><xsl:value-of select="replace(//template[name=$template_name]/metrics/*[alarmObject = $metric_alarm_object and (discoveryRule=$disc_name or (not(discoveryRule) and not($disc_name = '')))]/triggers/trigger[id=$trigger_id]/expression,'TEMPLATE_NAME',$template_name)"/></expression>
                            <recovery_expression><xsl:value-of select="replace(//template[name=$template_name]/metrics/*[alarmObject = $metric_alarm_object and (discoveryRule=$disc_name or (not(discoveryRule) and not($disc_name = '')))]/triggers/trigger[id=$trigger_id]/recovery_expression,'TEMPLATE_NAME',$template_name)"/></recovery_expression>
                        </xsl:otherwise>
                    </xsl:choose>
                </dependency>
            </xsl:for-each>
        </dependencies>
        <!--<tags><xsl:copy-of copy-namespaces="no" select="./tags/*"/></tags>   removed tags for now 
        <tags/>
    </xsl:template>
 -->

<#-- 
    <xsl:template match="metrics/*/triggers/trigger">

        <xsl:choose>
            <xsl:when test="../../.[not (discoveryRule)]">
                <trigger>
                    <xsl:call-template name="triggerTemplate"/>
                </trigger>
            </xsl:when>
            <xsl:otherwise>
                <trigger_prototype>
                    <xsl:call-template name="triggerTemplate"/>
                </trigger_prototype>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="graphTemplate">
        <xsl:copy-of copy-namespaces="no" select="name"/>
        <xsl:copy-of copy-namespaces="no" select="width"/>
        <xsl:copy-of copy-namespaces="no" select="height"/>
        <xsl:copy-of copy-namespaces="no" select="yaxismin"/>
        <xsl:copy-of copy-namespaces="no" select="yaxismax"/>
        <xsl:copy-of copy-namespaces="no" select="show_work_period"/>

        <xsl:copy-of copy-namespaces="no" select="show_triggers"/>
        <xsl:copy-of copy-namespaces="no" select="type"/>
        <xsl:copy-of copy-namespaces="no" select="show_legend"/>
        <xsl:copy-of copy-namespaces="no" select="show_3d"/>
        <xsl:copy-of copy-namespaces="no" select="percent_left"/>
        <xsl:copy-of copy-namespaces="no" select="percent_right"/>

        <xsl:copy-of copy-namespaces="no" select="ymin_type_1"/>
        <xsl:copy-of copy-namespaces="no" select="ymax_type_1"/>
        <xsl:copy-of copy-namespaces="no" select="ymin_item_1"/>
        <xsl:copy-of copy-namespaces="no" select="ymax_item_1"/>
        <xsl:copy-of copy-namespaces="no" select="graph_items"/>
    </xsl:template>

    <xsl:template match="metrics/*/graphs/graph">

        <xsl:choose>
            <xsl:when test="../../.[not (discoveryRule)]">
                <graph>
                    <xsl:call-template name="graphTemplate"/>
                </graph>
            </xsl:when>
            <xsl:otherwise>
                <graph_prototype>
                    <xsl:call-template name="graphTemplate"/>
                </graph_prototype>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    

    </xsl:template>
 -->

 <#function time_suffix_to_seconds time>
 	<#if zbx_ver='3.2'>
 		<#if time?ends_with('s')><#return time?keep_before('s')>
 		<#elseif time?ends_with('m')><#return (time?keep_before('m')?number)*60>
 		<#elseif time?ends_with('h')><#return (time?keep_before('h')?number)*3600>
 		<#elseif time?ends_with('d')><#return (time?keep_before('d')?number)*86400>
 		<#else><#return time>
 		</#if>
 	<#else> <#-- 3.4 --><#--as is, but add 's' if no suffix-->
		<#if time?matches('[0-9]+','r')>
			<#return time+'s'>
		<#else>
			<#return time>
		</#if>
 	</#if>
 </#function>
 
 <#function time_suffix_to_days time>
 	<#if zbx_ver='3.2'>
 		<#if time?ends_with('d')><#return time?keep_before('d')>
 		<#elseif time?ends_with('w')><#return (time?keep_before('w')?number)*7>
 		<#else><#return time>
 		</#if>
 	<#else> <#-- 3.4 --><#--as is, but add 'd' if no suffix-->
		<#if time?matches('[0-9]+','r')>
			<#return time+'d'>
		<#else>
			<#return time>
		</#if>
 	</#if>
 </#function>
 
 <#-- This function get a list of objects and the key of this object. Then it returns list(unique set) of values of this key-->
 <#function distinct_by_key list key>
 	<#local dlist = {}>
	<#list list as le>
		<#local dlist = dlist + {le[key]:le[key]}>
	</#list>
	<#return dlist?values>
 </#function>