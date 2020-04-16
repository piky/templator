<#ftl output_format="XML">
<#assign zbx_ver = headers.zbx_ver?string>
<#assign aDateTime = .now>
<#assign template_type = headers.template_type?string>
<#assign snmp_community = '{$SNMP_COMMUNITY}'>
<?xml version="1.0" encoding="UTF-8"?>
<zabbix_export>
    <version>${zbx_ver}</version>
    <date>${aDateTime?iso("UTC")}</date>
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
	            <#list t.getDiscoveryRulesByZbxVer(t.discoveryRules,zbx_ver) as dr>
	            <discovery_rule>
	                <@discovery_rule dr t/>
	            </discovery_rule>
                </#list>
            </discovery_rules>
            <#else>
            <discovery_rules/>
            </#if>
            <#if zbx_ver == '3.4' || zbx_ver == '4.0' || zbx_ver == '4.2'>
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
            <#if (t.screens?size > 0)>
            <screens>
            <#list t.screens as s>
                <screen>
                    <@screen s/>
                </screen>
            </#list>
            </screens>
            <#else>
            <screens/>
            </#if>
            <#if zbx_ver == '4.2'>
            <tags/>
            </#if>
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
                    <type>${headers.default_item_type}</type>
                    <#elseif m.type == 'ZABBIX_PASSIVE' && template_type == 'ZABBIX_ACTIVE' && m.key != 'system.localtime'>
                    <type>${headers.default_item_type}</type>
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
                    <#-- forced disabling of key=system.localtime for zabbix active template, since it is not supported that way -->
                    <#if m.type == 'ZABBIX_PASSIVE' && template_type == 'ZABBIX_ACTIVE' && m.key == 'system.localtime'>
                    <status>1</status>
                    <#else>
                    <status>0</status>
                    </#if>
                    <value_type>${m.valueType.getZabbixValue()}</value_type>
                    <allowed_hosts/>
                    ${xml_wrap((prepare_units(m.units!'')),'units')}
                    <#if zbx_ver == '3.2'>
                        <#local delta_value = 0>
                    <#if m.preprocessing??>
                        <#list m.preprocessing as p>
                            <#if p.type == 'CHANGE_PER_SECOND'>
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
                    <#if zbx_ver == '3.2'>
                    <delay_flex/>
                    </#if>
                    ${xml_wrap(m.expressionFormula!'','params')}
                    <ipmi_sensor/>
                    <#if zbx_ver == '3.2'>
                    <data_type>0</data_type>
                    </#if>
                    ${xml_wrap(m.authType.getZabbixValue()?c,'authtype')}
                    ${xml_wrap(m.username!'','username')}
                    ${xml_wrap(m.password!'','password')}
                    <publickey/>
                    <privatekey/>
                    <port/>
                    ${xml_wrap(m.description!'','description')}
                    <inventory_link>${m.inventoryLink.getZabbixValue()}</inventory_link>
                    <#if m.applicationPrototype??>
                    <applications/>
                    <#else>
                    <applications>
                    <#-- change group to array in Java? -->
                    <#list [m.group] as g>
                    <application>
                        <name>${g?replace('_',' ')}</name>
                    </application>
                    </#list>
                    </applications>
                    </#if>
                    <#if m.valueMap??>
                    <valuemap>
                        <name>${m.valueMap}</name>
                    </valuemap>
                    <#else>
                    <valuemap/>
                    </#if>
                    ${xml_wrap(m.logtimefmt!'','logtimefmt')}
                    <#if zbx_ver == '3.4' || zbx_ver == '4.0' || zbx_ver == '4.2'>
                    <@preprocessing m zbx_ver/>
                    </#if>
                    <#if zbx_ver == '3.4' || zbx_ver == '4.0' || zbx_ver == '4.2'>
                    <jmx_endpoint/>
                    </#if>
                    <#if m.discoveryRule??><#-- item prototype-->
                        <#if m.applicationPrototype??>
                    <application_prototypes>
                        <application_prototype>
                            <name>${m.applicationPrototype}</name>
                        </application_prototype>
                    </application_prototypes>
                        <#else>
                    <application_prototypes/>
                        </#if>
                    </#if>
                    <#if zbx_ver == '4.0' || zbx_ver == '4.2'>
                    ${xml_wrap(m.timeout!'3s','timeout')}
                    ${xml_wrap(m.url!'','url')}
                    <#if (m.query_fields?size > 0)>
                    <query_fields>
                        <#list m.query_fields as qf>
                        <query_field>
                            ${xml_wrap(qf.name,'name')}
                            ${xml_wrap(qf.value,'value')}
                        </query_field>
                        </#list>
                    </query_fields>
                    <#else>
                    <query_fields/>
                    </#if>
                    <posts/>
                    ${xml_wrap(m.statusCodes!'200','status_codes')}
                    ${xml_wrap(m.followRedirects.getZabbixValue()?c,'follow_redirects')}
                    ${xml_wrap(m.postType!'0','post_type')}
                    ${xml_wrap(m.httpProxy!'','http_proxy')}
                    <#--  ${xml_wrap(m.headers!'','headers')}  -->
                   <#if (m.headers?size > 0)>
                    <headers>
                        <#list m.headers as hd>
                        <header>
                            ${xml_wrap(hd.name,'name')}
                            ${xml_wrap(hd.value,'value')}
                        </header>
                        </#list>
                    </headers>
                    <#else>
                    <headers/>
                    </#if>
                    ${xml_wrap(m.retrieveMode.getZabbixValue()?c,'retrieve_mode')}
                    ${xml_wrap(m.requestMethod.getZabbixValue()?c,'request_method')}
                    <output_format>0</output_format>
                    <allow_traps>0</allow_traps>
                    <ssl_cert_file/>
                    <ssl_key_file/>
                    <ssl_key_password/>
                    <verify_peer>0</verify_peer>
                    <verify_host>0</verify_host>
                    </#if>
                    <#if zbx_ver == '3.4'>
                        <#if m.discoveryRule??>
                            <@master_item m 'master_item_prototype'/>
                        <#else><#-- normal item -->
                            <@master_item m 'master_item'/>
                        </#if>
                    </#if>
                    <#if zbx_ver == '4.0' || zbx_ver == '4.2'>
                            <@master_item m 'master_item'/>
                    </#if>

</#macro>

<#macro discovery_rule dr t>
            <#assign metrics = t.getMetricsByZbxVer(dr.metrics,zbx_ver)>
            <name>${dr.name}</name>
            <#if dr.type == 'SNMP'>
            <type>${headers.default_item_type}</type>
            <#elseif dr.type == 'ZABBIX_PASSIVE' && template_type == 'ZABBIX_ACTIVE'>
            <type>${headers.default_item_type}</type>
            <#else>
            <type>${dr.type.getZabbixValue()!'none'}</type>
            </#if>
            <#if dr.type == 'SNMP'>
            <snmp_community>${snmp_community}</snmp_community>
            <#else>
            <snmp_community/>
            </#if>
            ${xml_wrap(dr.oid!'','snmp_oid')}
            <key>${dr.key}</key>
            <delay>${time_suffix_to_seconds(dr.delay)}</delay>
            <status>0</status>
            <allowed_hosts/>
            <snmpv3_contextname/>
            <snmpv3_securityname/>
            <snmpv3_securitylevel>0</snmpv3_securitylevel>
            <snmpv3_authprotocol>0</snmpv3_authprotocol>
            <snmpv3_authpassphrase/>
            <snmpv3_privprotocol>0</snmpv3_privprotocol>
            <snmpv3_privpassphrase/>
            <#if zbx_ver == '3.2'>
            <delay_flex/>
            </#if>
            ${xml_wrap(dr.expressionFormula!'','params')}
            <ipmi_sensor/>
            ${xml_wrap(dr.authType.getZabbixValue()?c,'authtype')}
            ${xml_wrap(dr.username!'','username')}
            ${xml_wrap(dr.password!'','password')}
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
                        <operator>${cond.operator.getZabbixValue()}</operator>
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
            <lifetime>${time_suffix_to_days(dr.lifetime)}</lifetime>
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
            <host_prototypes/>
            <#if zbx_ver == '3.4' || zbx_ver == '4.0' || zbx_ver == '4.2'>
            <jmx_endpoint/>
            </#if>
            <#if zbx_ver == '4.0' || zbx_ver == '4.2'>
            <posts/>
            ${xml_wrap(dr.timeout!'3s','timeout')}
            ${xml_wrap(dr.url!'','url')}
            ${xml_wrap(dr.statusCodes!'200','status_codes')}
            ${xml_wrap(dr.followRedirects.getZabbixValue()?c,'follow_redirects')}
            ${xml_wrap(dr.postType!'0','post_type')}
            ${xml_wrap(dr.httpProxy!'','http_proxy')}
            <#if (dr.headers?size > 0)>
            <headers>
                <#list dr.headers as hd>
                <header>
                    ${xml_wrap(hd.name,'name')}
                    ${xml_wrap(hd.value,'value')}
                </header>
                </#list>
            </headers>
            <#else>
            <headers/>
            </#if>
            <#if (dr.query_fields?size > 0)>
            <query_fields>
                <#list dr.query_fields as qf>
                <query_field>
                    ${xml_wrap(qf.name,'name')}
                    ${xml_wrap(qf.value,'value')}
                </query_field>
                </#list>
            </query_fields>
            <#else>
            <query_fields/>
            </#if>
            ${xml_wrap(dr.retrieveMode.getZabbixValue()?c,'retrieve_mode')}
            ${xml_wrap(dr.requestMethod.getZabbixValue()?c,'request_method')}
            <allow_traps>0</allow_traps>
            <ssl_cert_file/>
            <ssl_key_file/>
            <ssl_key_password/>
            <verify_peer>0</verify_peer>
            <verify_host>0</verify_host>
            </#if>
            <#if zbx_ver == '4.2'>
            <@lld_macro_paths dr/>
            <@preprocessing dr zbx_ver/>
            <@master_item dr 'master_item'/>
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
    <priority>${tr.priority.getZabbixValue()}</priority>
    <#assign description =''>
    <#if tr.operationalData??>
    <#assign description = tr.operationalData+'\n' >
    <#else>
    <#assign description = 'Last value: {ITEM.LASTVALUE1}\n'>
    </#if>
    ${xml_wrap(description+tr.description!'','description')}
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
			${xml_wrap(g.showWorkPeriod.getZabbixValue()?c,'show_work_period')}
			${xml_wrap(g.showTriggers.getZabbixValue()?c,'show_triggers')}
			${xml_wrap(g.graphType.getZabbixValue()?c,'type')}
			${xml_wrap(g.showLegend.getZabbixValue()?c,'show_legend')}
			${xml_wrap(g.show3d.getZabbixValue()?c,'show_3d')}
			${xml_wrap(g.percentLeft?string("0.0000;; decimalSeparator='.'"),'percent_left')}
			${xml_wrap(g.percentRight?string("0.0000;; decimalSeparator='.'"),'percent_right')}			
			${xml_wrap(g.yMinType.getZabbixValue()?c,'ymin_type_1')}
			${xml_wrap(g.yMaxType.getZabbixValue()?c,'ymax_type_1')}
			<#-- ymin type with not implemented--> 
            <ymin_item_1>0</ymin_item_1>
            <ymax_item_1>0</ymax_item_1>
            <graph_items>
            	<#list g.getGraphItemsByZbxVer(g.graphItems,zbx_ver) as gi>
            	<graph_item>
            		<sortorder>${gi?index}</sortorder>
            		${xml_wrap(gi.drawType.getZabbixValue()?c,'drawtype')}
            		${xml_wrap(gi.color!(gi.graphColors[gi?index]),'color')}
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

<#macro screen s>
            ${xml_wrap(s.name,'name')}
            ${xml_wrap(s.hsize?c,'hsize')}
            ${xml_wrap(s.vsize?c,'vsize')}
            <screen_items>
            	<#list s.screenItems as si>
            	<screen_item>
            		${xml_wrap(si.resourceType.getZabbixValue()?c,'resourcetype')}
            		${xml_wrap(si.width?c,'width')}
                    ${xml_wrap(si.height?c,'height')}
                    ${xml_wrap(si.x?c,'x')}
                    ${xml_wrap(si.y?c,'y')}
                    ${xml_wrap(si.colspan?c,'colspan')}
                    ${xml_wrap(si.rowspan?c,'rowspan')}
                    ${xml_wrap(si.elements?c,'elements')}
                    ${xml_wrap(si.valign.getZabbixValue()?c,'valign')}
                    ${xml_wrap(si.halign.getZabbixValue()?c,'halign')}
                    ${xml_wrap(si.style?c,'style')}
                    ${xml_wrap(si.url!'','url')}
            		${xml_wrap(si.dynamic.getZabbixValue()?c,'dynamic')}
            		${xml_wrap(si.sortTriggers?c,'sort_triggers')}
                    <#--graph/ graph proto -->
                    <#if (si.resourceType.getZabbixValue() == 0 || si.resourceType.getZabbixValue() == 20)>
                    <resource>
                        <name>${si.resource[0].name}</name>
                        <host>${si.resource[0].host}</host> 
                    </resource>
                    <#else> <#--simple graph, plain text...-->
                    <resource>
                        <key>${si.resource[0].name}</key>
                        <host>${si.resource[0].host}</host>
                    </resource>
                    </#if>
            		${xml_wrap(si.maxColumns?c,'max_columns')}
                    ${xml_wrap(si.application!'','application')}
            	</screen_item>
            	</#list>
            </screen_items>
</#macro>


<#macro master_item m tag>
        <#-- m is metric or discovery -->
        <#if m.masterItem??>
            <${tag}>
                ${xml_wrap(m.masterItem,'key')}
            </${tag}>
        <#else>
            <${tag}/>
        </#if>
</#macro>

<#macro preprocessing m zbx_ver>
        <#-- m is metric or discovery -->
        <#if m.preprocessing??>
            <preprocessing>
            <#list m.preprocessing as p>
                <#if (zbx_ver='3.4' || zbx_ver='3.2' || zbx_ver='4.0') && (p.type.getZabbixValue() == 19 || p.type.getZabbixValue() == 20)>
                <#-- skip discards preprocessing for template versions < 4.2-->
                    <#continue>
                </#if>
                <step>
                    <type>${p.type.getZabbixValue()}</type>
                    <params>${p.params!''}</params>
                    <#if zbx_ver == '4.2'>
                    ${xml_wrap(p.errorHandler.getZabbixValue()?c,'error_handler')}
                    ${xml_wrap(p.errorHandlerParams!'','error_handler_params')}
                    </#if>
                </step>
            </#list>
            </preprocessing>
        <#else>
            <preprocessing/>
        </#if>
</#macro>

<#macro lld_macro_paths dr>
    <#if dr.lldMacroPaths??>
        <lld_macro_paths>
        <#list dr.lldMacroPaths as lld_path>
            <lld_macro_path>
                <lld_macro>${lld_path.lldMacro}</lld_macro>
                <path>${lld_path.path}</path>
            </lld_macro_path>
        </#list>
        </lld_macro_paths>
    <#else>
        <lld_macro_paths/>
    </#if>
</#macro>

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
          <#case 'DB'>
            <#local found = true>
            <#local glist = glist + ["Templates/Databases"]>
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
<#if t.description??>
${t.description!''}

</#if>
<#if headers.template_type == 'SNMP'>
<#assign mibs = t.getUniqueMibs(t.getMetricsByZbxVer(t.getMetricsRegistry(),zbx_ver))![]>
<#if (mibs?size>0)>
MIBs used:
<#list mibs as mib>
${mib}
</#list>

</#if>
</#if>
<#if t.documentation??>
<#if (t.documentation.issues?size>0)>
Known Issues:
<#list t.documentation.issues as i>

<#if i.description??>
  Description: ${i.description!''}
</#if>
<#if i.version??>
  Version: ${i.version!''}
</#if>
<#if i.device??>
  Device: ${i.device!''}
</#if>
</#list>

</#if>
<#if t.documentation.zabbixForumUrl??>
You can discuss this template or leave feedback on our forum ${t.documentation.zabbixForumUrl}

</#if>
</#if>
<#-- Please report any issues or suggest an improvement on https://support.zabbix.com -->
Template tooling version used: ${headers.template_ver}

</#macro>

 <#function time_suffix_to_seconds time>
     <#if zbx_ver='3.2'>
         <#if time?ends_with('s')><#return time?keep_before('s')>
         <#elseif time?ends_with('m')><#return ((time?keep_before('m')?number)*60)?c>
         <#elseif time?ends_with('h')><#return ((time?keep_before('h')?number)*3600)?c>
         <#elseif time?ends_with('d')><#return ((time?keep_before('d')?number)*86400)?c>
         <#else><#return time>
         </#if>
     <#else> <#-- 3.4 || 4.0 + --><#--as is, but add 's' if no suffix-->
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
         <#elseif time?ends_with('h')>
            <#if (time?keep_before('h')?number) < 24>
                <#-- reset to 1d -->
                <#return 1>
            <#else>
                <#-- converts to closest number in days -->
                <#return ((time?keep_before('h')?number)/24)?round>
            </#if>
         <#else><#return time>
         </#if>
     <#else> <#-- 3.4 || 4.0 --><#--as is, but add 'd' if no suffix-->
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