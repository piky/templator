<#ftl output_format="XML">
<#assign zbx_ver = headers.zbx_ver?string>
<#assign template_type = headers.template_type?string>
<#assign snmp_community = '{$SNMP_COMMUNITY}'>
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
    <#list body.templates?sort_by("name") as t>
        <template>
            <template>${t.name}</template>
            <name>${t.name}</name>
            <description><@generate_template_description t/></description>
            <#if (t.templates?size > 0)>
            <templates>
            <#list t.templates?sort as dep>
                <template>
                   <name>${dep}</name>
                </template>
            </#list>
            </templates>
            </#if>
            <groups>
                <#list generate_groups(t.classes![]) as g>
                    <group>
                        <name>${g?replace('_',' ')}</name>
                    </group>
                </#list>
            </groups>
            <#assign applications = distinct_by_key(t.getMetricsByZbxVer(t.getMetricsRegistry(),zbx_ver),'group')>
            <#if (applications?size>0)>
            <applications>
                <#list applications as g>
                <application>
                    <name>${g?replace('_',' ')}</name>
                </application>
                </#list>
            </applications>
            </#if>

            <#assign metrics = t.getMetricsByZbxVer(t.metrics,zbx_ver)?sort_by("key")>
            <#if (metrics?size>0)>
            <items>
                <#list metrics?sort_by("key") as m>
                <item>
                    <@item m t/>
                </item>
                </#list>
            </items>
            </#if>

            <#assign discoveryRules = t.getDiscoveryRulesByZbxVer(t.discoveryRules,zbx_ver)>
            <#if (discoveryRules?size > 0)>
            <discovery_rules>
	            <#list discoveryRules?sort_by("key") as dr>
	            <discovery_rule>
	                <@discovery_rule dr t/>
	            </discovery_rule>
                </#list>
            </discovery_rules>
            </#if>

            <#if (t.macros?size > 0)>
            <macros>
                <#list t.macros?sort_by("macro") as macro>
                <macro>
                    ${xml_wrap(macro.macro,'macro','')}
                    ${xml_wrap(macro.value,'value','')}
                    ${xml_wrap(macro.description!'','description','')}
                </macro>
                </#list>
            </macros>
            </#if>
            <#if (t.screens?size > 0)>
            <screens>
            <#list t.screens?sort_by("name") as s>
                <screen>
                    <@screen s/>
                </screen>
            </#list>
            </screens>
            </#if>
        </template>
      </#list>
    </templates>
    
    <#assign triggers = []>
    <#list body.templates as t>
        <#list t.getMetricsByZbxVer(t.metrics,zbx_ver) as m>
            <#list m.triggers as tr>
                <#if (tr.getMetricsUsed()?size > 0)> <#-- only complex triggers -->
                    <#assign triggers = triggers + [{"trigger": tr, "metric": m, "template": t}]>
                </#if>
            </#list>
        </#list>
    </#list>
    <#if (triggers?size>0)>
    <triggers>
        <#list triggers?sort_by(["trigger","name"]) as tr>
        <trigger>
            <@trigger tr.trigger tr.metric tr.template/>
        </trigger>
        </#list>
	</triggers>
    </#if>

    <#assign graphs = []>
    <#list body.templates as t>
        <#list t.getMetricsByZbxVer(t.metrics,zbx_ver) as m>
            <#list m.graphs as g>
                <#assign graphs = graphs + [{"graph":g, "template": t}]>
            </#list>
        </#list>
    </#list>
    <#if (graphs?size>0)>
    <graphs>
        <#list graphs?sort_by(["graph","name"]) as g>
        <graph>
            <@graph g.graph g.template/>
        </graph>
        </#list>
    </graphs>
    </#if>
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
    </#if>
</zabbix_export>

<#-- m - metric-->
<#macro item m t>
                    <name>${m.name}</name>
                    <#if m.type == 'SNMP'>
                    <type>${headers.default_item_type}</type>
                    <#elseif m.type == 'ZABBIX_PASSIVE' && template_type == 'ZABBIX_ACTIVE' && m.key != 'system.localtime'>
                    <type>${headers.default_item_type}</type>
                    <#elseif m.type != 'ZABBIX_PASSIVE'> <#-- default -->
                    <type>${m.type}</type>
                    </#if>
                    <#if m.type == 'SNMP'>
                    <snmp_community>${snmp_community}</snmp_community>
                    </#if>
                    ${xml_wrap(m.oid!'','snmp_oid','')}
                    <key>${m.key}</key>
                    ${xml_wrap(time_suffix_to_seconds(m.delay!''),'delay','1m')}
                    ${xml_wrap(time_suffix_to_days(m.history!''),'history','30d')}
                    ${xml_wrap(time_suffix_to_days(m.trends!''),'trends','365d')}
                    <#-- forced disabling of key=system.localtime for zabbix active template, since it is not supported that way -->
                    <#if m.type == 'ZABBIX_PASSIVE' && template_type == 'ZABBIX_ACTIVE' && m.key == 'system.localtime'>
                    <status>DISABLED</status>
                    </#if>
                    ${xml_wrap(m.valueType!'','value_type','UNSIGNED')}
                    ${xml_wrap((prepare_units(m.units!'')),'units','')}
                    ${xml_wrap(m.expressionFormula!'','params','')}
                    ${xml_wrap(m.authType!'','authtype','NONE')}
                    ${xml_wrap(m.username!'','username','')}
                    ${xml_wrap(m.password!'','password','')}
                    ${xml_wrap(m.description!'','description','')}
                    ${xml_wrap(m.inventoryLink!'','inventory_link','NONE')}
                    <#if m.applicationPrototype??>
                    <#if m.discoveryRule??><#-- item prototype-->
                    <application_prototypes>
                        <application_prototype>
                            <name>${m.applicationPrototype}</name>
                        </application_prototype>
                    </application_prototypes>
                    </#if>
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
                    </#if>
                    ${xml_wrap(m.logtimefmt!'','logtimefmt','')}
                    <@preprocessing m zbx_ver/>
                    ${xml_wrap(m.timeout!'3s','timeout','3s')}
                    ${xml_wrap(m.url!'','url','')}
                    ${xml_wrap(m.statusCodes!'200','status_codes','200')}
                    ${xml_wrap(m.followRedirects,'follow_redirects','YES')}
                    ${xml_wrap(m.postType!'0','post_type','0')}
                    ${xml_wrap(m.httpProxy!'','http_proxy','')}
                    ${xml_wrap(m.headers!'','headers','')}
                    ${xml_wrap(m.retrieveMode!'','retrieve_mode','BODY')}
                    ${xml_wrap(m.requestMethod!'','request_method','GET')}
                    <@master_item m 'master_item'/>
                    
                    <#-- inline trigggers -->
                    <#assign triggers = []>
                    <#if m.discoveryRule??>
                        <#assign trigger_tag = 'trigger_prototype'>
                    <#else>
                        <#assign trigger_tag = 'trigger'>
                    </#if>
                    <#list m.triggers as tr>
                        <#if (tr.getMetricsUsed()?size == 0)>
                            <#assign triggers = triggers + [{"trigger": tr, "metric":m, "template":t}]>
                        </#if>
                    </#list>
                    <#if (triggers?size>0)>
                    <${trigger_tag}s>
                        <#list triggers as tr>
                        <${trigger_tag}>
                            <@trigger tr.trigger tr.metric tr.template/>
                        </${trigger_tag}>
                        </#list>
                    </${trigger_tag}s>
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
            <type>${dr.type!'none'}</type>
            </#if>
            <#if dr.type == 'SNMP'>
            <snmp_community>${snmp_community}</snmp_community>
            <#else>
            </#if>
            ${xml_wrap(dr.oid!'','snmp_oid','')}
            <key>${dr.key}</key>
            ${xml_wrap(time_suffix_to_seconds(dr.delay!''),'delay','')}
            <#--  <status>0</status>  -->
            <#--  <allowed_hosts/>
            <snmpv3_contextname/>
            <snmpv3_securityname/>
            <snmpv3_securitylevel>0</snmpv3_securitylevel>
            <snmpv3_authprotocol>0</snmpv3_authprotocol>
            <snmpv3_authpassphrase/>
            <snmpv3_privprotocol>0</snmpv3_privprotocol>
            <snmpv3_privpassphrase/>
            <params/>
            <ipmi_sensor/>
            <authtype>0</authtype>
            <username/>
            <password/>
            <publickey/>
            <privatekey/>
            <port/>  -->
            <#if dr.filter??>
            <filter>
                <evaltype>${dr.filter.evalType}</evaltype>
                ${xml_wrap(dr.filter.formula!'','formula','')}
                <conditions>
                <#list dr.filter.conditions as cond>
                    <condition>
                        <macro>${cond.macro}</macro>
                        <value>${cond.value}</value>
                        ${xml_wrap(cond.operator!'MATCHES_REGEX','operator','MATCHES_REGEX')}
                        <formulaid>${cond.formulaid!''}</formulaid>
                    </condition>
                </#list>
                </conditions>
            </filter>
            </#if>
            ${xml_wrap(time_suffix_to_days(dr.lifetime!''),'lifetime','30d')}
            ${xml_wrap(dr.description!'','description','')}<#-- <xsl:value-of select="replace(./description, '^\s+|\s+$', '')"/> -->
            <item_prototypes>
                <#list metrics?sort_by("key") as m>
                    <item_prototype>
                        <@item m t/>
                    </item_prototype>
                </#list>
            </item_prototypes>

            <#-- trigger -->
            <#assign triggers = []>
            <#list metrics as m>
                <#if (m.triggers?size>0)>
                    <#list m.triggers as tr>
                        <#if (tr.getMetricsUsed()?size > 0)> <#-- only complex triggers -->
                            <#assign triggers = triggers + [{"trigger":tr, "metric":m, "template": t}]>
                        </#if>
                    </#list>
                </#if>
            </#list>
            <#if (triggers?size>0)>
            <trigger_prototypes>
                    <#list triggers?sort_by(["trigger","name"]) as tr>
                    <trigger_prototype>
                        <@trigger tr.trigger tr.metric tr.template/>
                    </trigger_prototype>
                    </#list>
            </trigger_prototypes>
            </#if>
            
            <#-- graphs -->
            <#assign graphs = []>
        	<#list metrics as m>
        		<#list m.graphs as g>
                    <#assign graphs = graphs + [g]>
                </#list>
            </#list>
            <#if (graphs?size>0)>
            <graph_prototypes>
            <#list graphs?sort_by("name") as g>
                 <graph_prototype>
                    <@graph g t/>
                </graph_prototype>
            </#list>
			</graph_prototypes>
            </#if>
            <#--  <timeout>3s</timeout>
            <url/>
            <query_fields/>
            <posts/>
            <status_codes>200</status_codes>
            <follow_redirects>1</follow_redirects>
            <post_type>0</post_type>
            <http_proxy/>
            <headers/>
            <retrieve_mode>0</retrieve_mode>
            <request_method>0</request_method>
            <allow_traps>0</allow_traps>
            <ssl_cert_file/>
            <ssl_key_file/>
            <ssl_key_password/>
            <verify_peer>0</verify_peer>
            <verify_host>0</verify_host>  -->
            <@master_item dr 'master_item'/>
            <@lld_macro_paths dr/>
            <@preprocessing dr zbx_ver/>
 </#macro>

<#-- tr - trigger-->
<#-- TODO remove  m --> 
<#macro trigger tr m t>
    <#-- no other metrics used -->
    <#if (tr.getMetricsUsed()?size == 0)>
	<expression>${tr.expression?replace('(TEMPLATE_NAME):(.+?)\\.([a-z]+\\(.*?\\))\\s*(})',"$3$4",'r')}</expression>
    <#else>
    <expression>${tr.expression?replace('TEMPLATE_NAME',t.name)}</expression>
    </#if>
	<#local recovery_mode = 'EXPRESSION'>
	<#if tr.recoveryExpression??>
		<#local recovery_mode = 'RECOVERY_EXPRESSION'>
	<#elseif tr.recoveryMode??>
		<#local recovery_mode = tr.recoveryMode>
	<#else>	
		<#local recovery_mode = 'EXPRESSION'>
	</#if>
	${xml_wrap(recovery_mode,'recovery_mode','EXPRESSION')}
    <#if (tr.getMetricsUsed()?size == 0)>
    ${xml_wrap((tr.recoveryExpression!'')?replace('(TEMPLATE_NAME):(.+?)\\.([a-z]+\\(.*?\\))\\s*(})',"$3$4",'r'),'recovery_expression','')}
    <#else>
    ${xml_wrap((tr.recoveryExpression!'')?replace('TEMPLATE_NAME',t.name),'recovery_expression','')}
    </#if>
    <name>${tr.name}</name>
    ${xml_wrap(tr.operationalData!'','opdata','')}
    <#--  <correlation_mode>0</correlation_mode>
    <correlation_tag/>  -->
    ${xml_wrap(tr.url!'','url','')}
    <#--  <status>0</status>  -->
    <priority>${tr.priority}</priority>
    ${xml_wrap(tr.description!'','description','')}
    <#--  <type>0</type>  -->
    ${xml_wrap(tr.manualClose,'manual_close','NO')}
    <#if (tr.dependencies?size>0)>
	<dependencies>
		<#list tr.dependencies as trd>
		<dependency>
			${xml_wrap(trd.name!'','name','')}
			${xml_wrap((trd.expression!'')?replace('TEMPLATE_NAME',t.name),'expression','')}
			${xml_wrap((trd.recoveryExpression!'')?replace('TEMPLATE_NAME',t.name),'recovery_expression','')}
		</dependency>
		</#list>
    </dependencies>
    </#if>
    <#--  <tags/>  -->
</#macro>

<#-- g - graph , t - current template -->
<#macro graph g t>
            ${xml_wrap(g.name,'name','')}
            ${xml_wrap(g.width?c,'width','900')}
            ${xml_wrap(g.height?c,'height','200')}
            ${xml_wrap(g.yAxisMin?c,'yaxismin','0')}
            ${xml_wrap(g.yAxisMax?c,'yaxismax','100')}            
			${xml_wrap(g.showWorkPeriod!'YES','show_work_period','YES')}
			${xml_wrap(g.showTrigger!'YES','show_triggers','YES')}
			${xml_wrap(g.graphType!'','type','NORMAL')}
			${xml_wrap(g.showLegend!'YES','show_legend','YES')}
			${xml_wrap(g.show3d!'NO','show_3d','NO')}
			${xml_wrap(g.percentLeft?string("0.0000;; decimalSeparator='.'"),'percent_left','0.0000')}
			${xml_wrap(g.percentRight?string("0.0000;; decimalSeparator='.'"),'percent_right','0.0000')}			
			${xml_wrap(g.yMinType!'','ymin_type_1','CALCULATED')}
			${xml_wrap(g.yMaxType!'','ymax_type_1','CALCULATED')}
			<#-- ymin type with not implemented--> 
            <#--  <ymin_item_1>0</ymin_item_1>
            <ymax_item_1>0</ymax_item_1>  -->
            <graph_items>
            	<#list g.graphItems as gi>
            	<graph_item>
                    ${xml_wrap(gi?index,'sortorder','0')}
            		${xml_wrap(gi.drawType!'','drawtype','SINGLE_LINE')}
            		${xml_wrap(gi.color!(gi.graphColors[gi?index]),'color','')}
            		${xml_wrap(gi.yAxisSide!'','yaxisside','LEFT')}
            		${xml_wrap(gi.calcFnc!'','calc_fnc','AVG')}
            		${xml_wrap(gi.type!'','type','SIMPLE')}
                    <item>
                        <host>${t.name}</host> 
                        <key>${gi.metricKey}</key>
                        <#-- ${xml_wrap(gi.type!'','discoveryRule','')} -->
                    </item>
            	</graph_item>
            	</#list>    
            </graph_items>

</#macro>

<#macro screen s>
            ${xml_wrap(s.name,'name','')}
            ${xml_wrap(s.hsize?c,'hsize','')}
            ${xml_wrap(s.vsize?c,'vsize','')}
            <screen_items>
            	<#list s.screenItems as si>
            	<screen_item>
            		${xml_wrap(si.resourceType.getZabbixValue()?c,'resourcetype','')}
                    ${xml_wrap(si.style?c,'style','')}
                    <#--graph/ graph proto -->
                    <#if (si.resourceType == 'GRAPH' || si.resourceType == 'GRAPH_PROTOTYPE')>
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
            		${xml_wrap(si.width?c,'width','')}
                    ${xml_wrap(si.height?c,'height','')}
                    ${xml_wrap(si.x?c,'x','')}
                    ${xml_wrap(si.y?c,'y','')}
                    ${xml_wrap(si.colspan?c,'colspan','')}
                    ${xml_wrap(si.rowspan?c,'rowspan','')}
                    ${xml_wrap(si.elements?c,'elements','')}
                    ${xml_wrap(si.valign.getZabbixValue()?c,'valign','')}
                    ${xml_wrap(si.halign.getZabbixValue()?c,'halign','')}
                    ${xml_wrap(si.dynamic.getZabbixValue()!'','dynamic','')}
                    ${xml_wrap(si.sortTriggers!'0','sort_triggers','')}
                    ${xml_wrap(si.url!'','url','SHOW_ALWAYS')}
                    ${xml_wrap(si.application!'','application','SHOW_ALWAYS')}
            		${xml_wrap(si.maxColumns?c,'max_columns','')}

            	</screen_item>
            	</#list>
            </screen_items>
</#macro>


<#macro master_item m tag>
        <#-- m is metric or discovery -->
        <#if m.masterItem??>
            <${tag}>
                ${xml_wrap(m.masterItem,'key','')}
            </${tag}>
        </#if>
</#macro>

<#macro preprocessing m zbx_ver>
        <#-- m is metric or discovery -->
        <#if (m.preprocessing?size>0)>
            <preprocessing>
            <#list m.preprocessing as p>
                <#if (zbx_ver='3.4' || zbx_ver='3.2' || zbx_ver='4.0') && (p.type == 19 || p.type == 20)>
                <#-- skip discards preprocessing for template versions < 4.2-->
                    <#continue>
                </#if>
                <step>
                    <type>${p.type}</type>
                    <params>${p.params!''}</params>
                    ${xml_wrap(p.errorHandler!'','error_handler','ORIGINAL_ERROR')}
                    ${xml_wrap(p.errorHandlerParams!'','error_handler_params','')}
                </step>
            </#list>
            </preprocessing>
        </#if>
</#macro>

<#macro lld_macro_paths dr>
    <#if (dr.lldMacroPaths?size>0)>
        <lld_macro_paths>
        <#list dr.lldMacroPaths as lld_path>
            <lld_macro_path>
                <lld_macro>${lld_path.lldMacro}</lld_macro>
                <path>${lld_path.path}</path>
            </lld_macro_path>
        </#list>
        </lld_macro_paths>
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

 <#function xml_wrap var tag default>
     <#if var?string == default?string>
        <#local string></#local>
     <#else>
        <#local string><${tag}>${var?trim}</${tag}></#local>
     </#if>
     <#return string>
 </#function>