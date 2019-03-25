<#ftl output_format="XML">
<#assign zbx_ver = headers.zbx_ver?string>
<#assign snmp_community= '{$SNMP_COMMUNITY}'>
<?xml version="1.0" encoding="UTF-8"?>
<zabbix_export>
    <version>${zbx_ver}</version>
    <date>2015-12-30T14:41:30Z</date>
    <groups>
        <#list generate_groups(body.getUniqueTemplateClasses()![]) as g>
            <group>
                <name>${g?replace('_',' ')}</name>
            </group>
        </#list>
    </groups>
    <templates>
    <#list body.templates as t>
        <template>
            <template>${t.name}</template>
            <name>${t.name}</name>
            <description><@generate_template_description t/></description>       
            <groups>
                <#list generate_groups(t.classes![]) as g>
                    <group>
                        <name>${g?replace('_',' ')}</name>
                    </group>
                </#list>
            </groups>
            <applications>
                <#list distinct_by_key(t.getMetricsByZbxVer(t.getMetricsRegistry(),zbx_ver),'group') as g>
                <application>
                    <name>${g?replace('_',' ')}</name>
                </application>
                </#list>
            </applications>
            <items>
                <#list t.getMetricsByZbxVer(t.metrics,zbx_ver) as m>
                <item>
                    <@item m/>
                </item>
                </#list>
            </items>
            <#if (t.discoveryRules?size > 0)>
            <discovery_rules>
	            <#list t.discoveryRules as dr>
	            <discovery_rule>
	                <@discovery_rule dr t/>
	            </discovery_rule>
            </#list>
            </discovery_rules>
            <#else>
            <discovery_rules/>
            </#if>                    
            <#if zbx_ver = '3.4'>
            <httptests/>
            </#if>
            <#if (t.macros?size > 0)>
            <macros>
                <#list t.macros as macro>
                <macro>
                    ${xml_wrap(macro.macro,'macro')}
                    ${xml_wrap(macro.value,'value')}
                </macro>
                </#list>
            </macros>
            <#else>
            <macros/>
            </#if>
            <#if (t.templates?size > 0)>
            <templates>
            <#list t.templates as dep>
                <template>
                   <name>${dep}</name>
                </template>
            </#list>
            </templates>
            <#else>
            <templates/>
            </#if>
            <screens/>
        </template>
      </#list>
    </templates>
    <graphs>
        <#list body.templates as t>
        	<#list t.getMetricsByZbxVer(t.metrics,zbx_ver) as m>
        		<#list m.graphs as g>
                <graph>
                    <@graph g t/>
                </graph>
                </#list>
            </#list>
        </#list>    
    </graphs>
    <triggers>
        <#list body.templates as t>
        	<#list t.getMetricsByZbxVer(t.metrics,zbx_ver) as m>
        		<#list m.triggers as tr>
                <trigger>
                    <@trigger tr t/>
                </trigger>
                </#list>
            </#list>
        </#list>
	</triggers>
    <#if (body.valueMaps?size > 0)>
    <value_maps>
    <#list body.valueMaps as vm>
        <value_map>
            <name>${vm.name}</name>
            <mappings>
                <#list vm.mappings as mapping>
                <mapping>
                    <value>${mapping.value}</value>
                    <newvalue>${mapping.newValue}</newvalue>
                </mapping>
                </#list>
            </mappings>
        </value_map>
    </#list>
    </value_maps>
    <#else>
    <value_maps/>
    </#if>
</zabbix_export>

<#-- m - metric-->
<#macro item m>
                    <name>${m.name}</name>
                    <#if m.type == 'SNMP'>
                    <type>${headers.snmp_item_type}</type>
                    <#else>
                    <type>${m.type.getZabbixValue()!'none'}</type>
                    </#if>
                    <#if m.type == 'SNMP'>
                    <snmp_community>${snmp_community}</snmp_community>
                    <#else>
                    <snmp_community/>
                    </#if>
                    <#if zbx_ver == '3.2'>
                        <#local multiplier_value = 0>
                    <#if m.preprocessing??>
                        <#list m.preprocessing as p>
                            <#if p.type == 'MULTIPLIER'>
                                <#local multiplier_value = 1>
                                <#break>
                            </#if>
                        </#list>
                    </#if>
                    <multiplier>${multiplier_value}</multiplier>
                    </#if>
                    ${xml_wrap(m.oid!'','snmp_oid')}
                    <key>${m.key}</key>
                    <delay>${time_suffix_to_seconds(m.delay)}</delay>
                    <history>${time_suffix_to_days(m.history)}</history>
                    <trends>${time_suffix_to_days(m.trends)}</trends>
                    <status>0</status>
                    <value_type>${m.valueType.getZabbixValue()}</value_type>
                    <allowed_hosts/>
                    ${xml_wrap((prepare_units(m.units!'')),'units')}
                    <#if zbx_ver == '3.2'>
                        <#local delta_value = 0>
                    <#if m.preprocessing??>
                        <#list m.preprocessing as p>
                            <#if p.type == 'DELTA_PER_SECOND'>
                                <#local delta_value = 1>
                                <#break>
                            </#if>
                        </#list>
                    </#if>
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
                    <#if m.preprocessing??>
                        <#list m.preprocessing as p>
                            <#if p.type == 'MULTIPLIER'>
                                <#local formula_value = p.params>
                                <#break>
                            </#if>
                        </#list>
                    </#if>
                    <formula>${formula_value}</formula>
                    </#if>
                    <#if zbx_ver = '3.2'>
                    <delay_flex/>
                    </#if>
                    ${xml_wrap(m.expressionFormula!'','params')}
                    <ipmi_sensor/>
                    <#if zbx_ver = '3.2'>
                    <data_type>0</data_type>
                    </#if>
                    <authtype>0</authtype>
                    <username/>
                    <password/>
                    <publickey/>
                    <privatekey/>
                    <port/>
                    ${xml_wrap(m.description!'','description')}<#-- <xsl:value-of select="replace(./description, '^\s+|\s+$', '')"/> -->
                    <inventory_link>${m.inventoryLink.getZabbixValue()}</inventory_link>
                    <applications>
                    <#-- change group to array in Java? -->
                    <#list [m.group] as g>
                    <application>
                        <name>${g?replace('_',' ')}</name>
                    </application>
                    </#list>
                    </applications>
                    <#if m.valueMap??>
                    <valuemap>
                        <name>${m.valueMap}</name>
                    </valuemap>
                    <#else>
                    <valuemap/>
                    </#if>
                    ${xml_wrap(m.logtimefmt!'','logtimefmt')}
                    <#if zbx_ver == '3.4'>
                    <#if m.preprocessing??>
                    <preprocessing>
                    <#list m.preprocessing as p>
                        <step>
                            <type>${p.type.getZabbixValue()}</type>
                            <params>${p.params!''}</params>
                        </step>
                    </#list>
                    </preprocessing>
                    <#else>
                    <preprocessing/>
                    </#if>
                    </#if>
                    <#if zbx_ver = '3.4'>
                    <jmx_endpoint/>
                    </#if>
                    <#if m.discoveryRule??><#-- item prototype-->
                    <application_prototypes/>
                    </#if>
                    <#if zbx_ver = '3.4'>
                        <#if m.discoveryRule??>
                            <@master_item m 'master_item_prototype'/>
                        <#else><#-- normal item -->
                            <@master_item m 'master_item'/>
                        </#if>
                    </#if>

</#macro>

<#macro discovery_rule dr t>
            <#assign metrics = t.getMetricsByZbxVer(dr.metrics,zbx_ver)>
            <name>${dr.name}</name>
            <type>${headers.snmp_item_type}</type>
            <snmp_community>${snmp_community}</snmp_community>
            <snmp_oid>${dr.oid}</snmp_oid>
            <key>${dr.key}</key>
            <delay>${time_suffix_to_seconds('1h')}</delay>
            <status>0</status>
            <allowed_hosts/>
            <snmpv3_contextname/>
            <snmpv3_securityname/>
            <snmpv3_securitylevel>0</snmpv3_securitylevel>
            <snmpv3_authprotocol>0</snmpv3_authprotocol>
            <snmpv3_authpassphrase/>
            <snmpv3_privprotocol>0</snmpv3_privprotocol>
            <snmpv3_privpassphrase/>
            <#if zbx_ver = '3.2'>
            <delay_flex/>
            </#if>
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
                ${xml_wrap(dr.filter.formula!'','formula')}
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
            <lifetime>${time_suffix_to_days('30d')}</lifetime>
            ${xml_wrap(dr.description!'','description')}<#-- <xsl:value-of select="replace(./description, '^\s+|\s+$', '')"/> -->
            <item_prototypes>
                <#list metrics as m>
                    <item_prototype>
                        <@item m/>
                    </item_prototype>
                </#list>
            </item_prototypes>
            <trigger_prototypes>
            	<#list metrics as m>
            		<#list m.triggers as tr>
                    <trigger_prototype>
                        <@trigger tr t/>
                    </trigger_prototype>
                    </#list>
                </#list>
            </trigger_prototypes>
            <graph_prototypes>
        	<#list metrics as m>
        		<#list m.graphs as g>
                <graph_prototype>
                    <@graph g t/>
                </graph_prototype>
                </#list>
            </#list>    
			</graph_prototypes>
            <#-- <xsl:apply-templates select="../../metrics/*[discoveryRule = $disc_name]/graphs/graph"/>  -->
            <host_prototypes/>
            <#if zbx_ver = '3.4'>
            <jmx_endpoint/>
            </#if>
 </#macro>

<#-- tr - trigger-->
<#macro trigger tr t>
	
	<expression>${tr.expression?replace('TEMPLATE_NAME',t.name)}</expression>
	<#local recovery_mode = 0>
	<#if tr.recoveryExpression??>
		<#local recovery_mode = 1>
	<#elseif tr.recoveryMode??>
		<#local recovery_mode = tr.recoveryMode.getZabbixValue()>
	<#else>		
		<#local recovery_mode = 0>
	</#if>
	${xml_wrap(recovery_mode!0,'recovery_mode')}
	${xml_wrap((tr.recoveryExpression!'')?replace('TEMPLATE_NAME',t.name),'recovery_expression')}
    <name>${tr.name}</name>
    <correlation_mode>0</correlation_mode>
    <correlation_tag/>
    ${xml_wrap(tr.url!'','url')}
    <status>0</status>
    <priority>${tr.priority!'0'}</priority>
    ${xml_wrap(tr.description!'','description')}
    <type>0</type>
    ${xml_wrap(tr.manualClose.getZabbixValue(),'manual_close')}
	<dependencies>
		<#list tr.dependencies as trd>
		<dependency>
			${xml_wrap(trd.name!'','name')}
			${xml_wrap((trd.expression!'')?replace('TEMPLATE_NAME',t.name),'expression')}
			${xml_wrap((trd.recoveryExpression!'')?replace('TEMPLATE_NAME',t.name),'recovery_expression')}
		</dependency>
		</#list>
    </dependencies>
    <tags/>
	
</#macro>

<#-- g - graph , t - current template -->
<#macro graph g t>
            ${xml_wrap(g.name,'name')}
            ${xml_wrap(g.width?c,'width')}
            ${xml_wrap(g.height?c,'height')}
            ${xml_wrap(g.yAxisMin?c,'yaxismin')}
            ${xml_wrap(g.yAxisMax?c,'yaxismax')}            
			${xml_wrap(g.showWorkPeriod?c,'show_work_period')}
			${xml_wrap(g.showTriggers?c,'show_triggers')}
			${xml_wrap(g.graphType.getZabbixValue()?c,'type')}
			${xml_wrap(g.showLegend?c,'show_legend')}
			${xml_wrap(g.show3d?c,'show_3d')}
			${xml_wrap(g.percentLeft?string("0.0000;; decimalSeparator='.'"),'percent_left')}
			${xml_wrap(g.percentRight?string("0.0000;; decimalSeparator='.'"),'percent_right')}			
			${xml_wrap(g.yMinType.getZabbixValue()?c,'ymin_type_1')}
			${xml_wrap(g.yMaxType.getZabbixValue()?c,'ymax_type_1')}
			<#-- ymin type with not implemented--> 
            <ymin_item_1>0</ymin_item_1>
            <ymax_item_1>0</ymax_item_1>
            <graph_items>
            	<#list g.graphItems as gi>
            	<graph_item>
            		<sortorder>${gi?index}</sortorder>
            		${xml_wrap(gi.drawType.getZabbixValue()?c,'drawtype')}
            		${xml_wrap(gi.graphColors[gi?index],'color')}
            		${xml_wrap(gi.yAxisSide.getZabbixValue()?c,'yaxisside')}
            		${xml_wrap(gi.calcFnc.getZabbixValue()?c,'calc_fnc')}
            		${xml_wrap(gi.type.getZabbixValue()?c,'type')}
                    <item>
                        <host>${t.name}</host> 
                        <key>${gi.metricKey}</key>
                        <#-- ${xml_wrap(gi.type.getZabbixValue()?c,'discoveryRule')} -->
                    </item>
            	</graph_item>
            	</#list>    
            </graph_items>

</#macro>


<#macro master_item m tag>
        <#if m.masterItem??>
            <${tag}>
                ${xml_wrap(m.masterItem,'key')}
            </${tag}>
        <#else>
            <${tag}/>
        </#if>
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
 <#function generate_groups groups_list>
    <#local glist = []>
    <#local found = false>

    <#list groups_list as g>
          <#switch g>
          <#case 'OS'>
            <#local found = true>
            <#local glist = glist + ["Templates/Operating systems"]>
            <#break>
          <#case 'NETWORK'>
            <#local found = true>
            <#local glist = glist + ["Templates/Network devices"]>
            <#break>
          <#case 'SERVER'>
            <#local found = true>
            <#local glist = glist + ["Templates/Server hardware"]>
            <#break>
          <#case 'MODULE'>
            <#local found = true>
            <#local glist = glist + ["Templates/Modules"]>
            <#break>
          <#case 'APP'>
            <#local found = true>
            <#local glist = glist + ["Templates/Applications"]>
            <#break>
          <#default>
        </#switch>
    </#list>
    <#if found == false>
            <#local glist = glist + ["Templates/Modules"]>
	</#if>

    <#return (glist)?sort>
 </#function>

<#macro generate_template_description t>
${t.description!''} version: ${headers.template_ver}
<#if t.documentation??>
<#if t.documentation.overview??>
Overview: ${t.documentation.overview!''}
</#if>
</#if>
<#assign mibs = t.getUniqueMibs(t.getMetricsByZbxVer(t.getMetricsRegistry(),zbx_ver))![]>
<#if (mibs?size>0)>
MIBs used:
<#list mibs as mib>
${mib}
</#list>
</#if>
<#if t.documentation??>
<#if (t.documentation.issues?size>0)>
Known Issues:
<#list t.documentation.issues as i>
<#if i.description??>
description : ${i.description!''}
</#if>
<#if i.version??>
version : ${i.version!''}
</#if>
<#if i.version??>
device : ${i.device!''}
</#if>
</#list>
</#if>
</#if>
</#macro>

 <#function time_suffix_to_seconds time>
     <#if zbx_ver='3.2'>
         <#if time?ends_with('s')><#return time?keep_before('s')>
         <#elseif time?ends_with('m')><#return ((time?keep_before('m')?number)*60)?c>
         <#elseif time?ends_with('h')><#return ((time?keep_before('h')?number)*3600)?c>
         <#elseif time?ends_with('d')><#return ((time?keep_before('d')?number)*86400)?c>
         <#else><#return time>
         </#if>
     <#else> <#-- 3.4 --><#--as is, but add 's' if no suffix-->
        <#if time == '0'>
            <#return time>
        <#elseif time?matches('[0-9]+','r')>
            <#return time+'s'>
        <#else>
            <#return time>
        </#if>
     </#if>
 </#function> 
 <#function time_suffix_to_days time>
     <#if zbx_ver='3.2'>
         <#if time?ends_with('d')><#return time?keep_before('d')>
         <#elseif time?ends_with('w')><#return ((time?keep_before('w')?number)*7)?c>
         <#else><#return time>
         </#if>
     <#else> <#-- 3.4 --><#--as is, but add 'd' if no suffix-->
        <#if time == '0'>
            <#return time>
        <#elseif time?matches('[0-9]+','r')>
            <#return time+'d'>
        <#else>
            <#return time>
        </#if>
     </#if>
 </#function>

 <#function prepare_units units>
     <#if zbx_ver='3.4' || zbx_ver='3.2'>
         <#if units?starts_with('!')><#return units?keep_after('!')>
         <#else><#return units>
         </#if>
     <#else> <#-- 4.0 or newer-->
            <#return units>
     </#if>
 </#function> 
 
 <#-- This function get a list of objects and the key of this object. Then it returns sorted list(unique set) of values of this key-->
 <#function distinct_by_key list key>
     <#local dlist = {}>
    <#list list as le>
        <#local dlist = dlist + {le[key]:le[key]}>
    </#list>
    <#return (dlist?values)?sort>
 </#function>
 <#function xml_wrap var tag>
     <#if var?string != ''>
     <#local string><${tag}>${var?trim}</${tag}></#local>
     <#else>
     <#local string><${tag}/></#local>
     </#if>
     <#return string>
 </#function>