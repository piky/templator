<#ftl output_format="plainText">
<#assign zbx_ver = headers.zbx_ver?string>

<#list body.templates as t>
# ${t.name}

## Overview

For Zabbix version: ${zbx_ver}  
<#if t.documentation??>
<#if t.documentation.overview??>
${t.documentation.overview!''}
</#if>
<#if (t.documentation.testedOn?size > 0)>
This template was tested on:

<#list t.documentation.testedOn as tested>
- ${tested.name}, version ${tested.version!''}
</#list>
</#if>
</#if>

## Setup

<#if t.documentation??>
<#if t.documentation.setup??>
${t.documentation.setup!''}
</#if>
</#if>

## Zabbix configuration

<#if t.documentation??>
<#if t.documentation.zabbixConfig??>
${t.documentation.zabbixConfig!''}
</#if>
</#if>

<#if (t.macros?size > 0)>
### Macros used

|Name|Description|Default|
|----|-----------|-------|
<#list t.macros as macro>
|${macro.macro}|${(macro.description!'-')?replace("(\n|\r\n)+","</br>",'r')}|${macro.value}|
</#list>
</#if>

<#if (t.templates?size > 0)>
## Template links

|Name|
|----|
<#list t.templates as dep>
|${dep}|
</#list>
</#if>

## Discovery rules

<#if (t.discoveryRules?size > 0)>
|Name|Description|Type|
|----|-----------|----|
<#list t.getDiscoveryRulesByZbxVer(t.discoveryRules,zbx_ver) as dr>
|${dr.name}|${(dr.description!'-')?replace("(\n|\r\n)+","</br>",'r')}|${dr.type}|
</#list>
</#if>

## Items collected

|Name|Description|Type|
|----|-----------|----|
<#--list metrics without discovery -->
<#list t.getMetricsByZbxVer(t.metrics,zbx_ver) as m>
|${m.name}|${(m.description!'-')?replace("(\n|\r\n)+","</br>",'r')}|${m.type}|
</#list>
<#--now list metrics from discovery rules -->
<#if (t.discoveryRules?size > 0)>
<#list t.getDiscoveryRulesByZbxVer(t.discoveryRules,zbx_ver) as dr>
<#list t.getMetricsByZbxVer(dr.metrics,zbx_ver) as m>
|${m.name}|${(m.description!'-')?replace("(\n|\r\n)+","</br>",'r')}|${m.type}|
</#list>
</#list>
</#if>


## Triggers

|Name|Description|Expression|Severity|
|----|-----------|----|----|
<#list t.getMetricsByZbxVer(t.metrics,zbx_ver) as m>
    <#list m.triggers as tr>
|${tr.name}|${(tr.description!'-')?replace("(\n|\r\n)+","</br>",'r')}|`${(tr.expression!'-')?replace("(\n|\r\n)+"," ",'r')}`|${tr.priority}|
    </#list>
</#list>
<#--now list metrics triggers from discovery rules -->
<#if (t.discoveryRules?size > 0)>
<#list t.getDiscoveryRulesByZbxVer(t.discoveryRules,zbx_ver) as dr>
<#list t.getMetricsByZbxVer(dr.metrics,zbx_ver) as m>
    <#list m.triggers as tr>
|${tr.name}|${(tr.description!'-')?replace("(\n|\r\n)+","</br>",'r')}|`${(tr.expression!'-')?replace("(\n|\r\n)+"," ",'r')}`|${tr.priority}|
    </#list>
</#list>
</#list>
</#if>

## References
<#if t.documentation??>
<#if t.documentation.ref??>
${t.documentation.ref!''}
</#if>
</#if>
</#list>

