
<#ftl output_format="plainText">
<#assign zbx_ver = headers.zbx_ver?string>

<#list body.templates as t>
# ${t.name}

## Overview

For Zabbix version: ${zbx_ver}  
<#if t.documentation??>
<#if t.documentation.overview??>
${(t.documentation.overview!'')}
</#if>
<#if (t.documentation.testedOn?size > 0)>

This template was tested on:

<#list t.documentation.testedOn as tested>
- ${tested.name}<#if tested.version??>, version ${tested.version!''}</#if>
</#list>
</#if>
</#if>

## Setup

<#if t.documentation??>
${(t.documentation.setup!'Refer to the vendor documentation.')}
<#else>
Refer to the vendor documentation.
</#if>

## Zabbix configuration

<#if t.documentation??>
${(t.documentation.zabbixConfig!'No specific Zabbix configuration is required.')}
<#else>
No specific Zabbix configuration is required.
</#if>

<#if (t.macros?size > 0)>
### Macros used

|Name|Description|Default|
|----|-----------|-------|
<#list t.macros as macro>
|${macro.macro} |${(macro.description!'-')?replace("^(.+)$","<p>$1</p>",'rm')?replace("(\n|\r\n)+","",'r')} |`${macro.value}` |
</#list>
</#if>

## Template links

<#if (t.templates?size > 0)>
|Name|
|----|
<#list t.templates as dep>
|${dep} |
</#list>
<#else>
There are no template links in this template.
</#if>

## Discovery rules

<#if (t.discoveryRules?size > 0)>
|Name|Description|Type|Key and additional info|
|----|-----------|----|----|
<#list t.getDiscoveryRulesByZbxVer(t.discoveryRules,zbx_ver) as dr>
|${dr.name} |${(dr.description!'-')?replace("^(.+)$","<p>$1</p>",'rm')?replace("(\n|\r\n)+","",'r')} |${dr.type} |${dr.key}<#if (dr.preprocessing?size>0)><p>**Preprocessing**:</p><#list dr.preprocessing as prep><p>- ${prep.type}<#if prep.params??>: `${(prep.params!'')?replace("(\n|\r\n)+"," ",'r')}`</p></#if></#list></#if><#if (dr.filter??)><p>**Filter**:</p>${dr.filter.evalType} ${dr.filter.formula!''}<#list dr.filter.conditions as cond><p>- ${cond.formulaid}: ${cond.macro} <#if cond.value??>${cond.operator} `${(cond.value!'')?replace("(\n|\r\n)+"," ",'r')}`</p></#if></#list></#if> |
</#list>
</#if>

## Items collected

|Group|Name|Description|Type|Key and additional info|
|-----|----|-----------|----|---------------------|
<#list t.getMetricsByZbxVer(t.metricsRegistry,zbx_ver)?sort_by("group") as m>
|${m.group} |${m.name} |${(m.description!'-')?replace("^(.+)$","<p>$1</p>",'rm')?replace("(\n|\r\n)+","",'r')} |${m.type} |${m.key}<#if (m.preprocessing?size>0)><p>**Preprocessing**:</p><#list m.preprocessing as prep><p>- ${prep.type}<#if prep.params??>: `${(prep.params!'')?replace("(\n|\r\n)+"," ",'r')}`</p><#if (prep.errorHandler!="ORIGINAL_ERROR")><p>⛔️ON_FAIL: `${prep.errorHandler} -> ${prep.errorHandlerParams!''}`</p></#if></#if></#list></#if><#if (m.expressionFormula??)><p>**Expression**:</p>`${(m.expressionFormula!'')?replace("(\n|\r\n)+"," ",'r')}`</#if> |
</#list>

## Triggers

|Name|Description|Expression|Severity|Dependencies and additional info|
|----|-----------|----|----|----|
<#list t.getMetricsByZbxVer(t.metricsRegistry,zbx_ver)?sort_by("group") as m>
    <#list m.triggers as tr>
|${tr.name} |${(tr.description!'-')?replace("^(.+)$","<p>$1</p>",'rm')?replace("(\n|\r\n)+","",'r')} |`${(tr.expression!'-')?replace("(\n|\r\n)+"," ",'r')}`<#if tr.recoveryExpression??><p>Recovery expression:</p>`${(tr.recoveryExpression!'-')?replace("(\n|\r\n)+"," ",'r')}`</#if> |${tr.priority} |<#if (tr.manualClose == 'YES')><p>Manual close: YES</p></#if><#if (tr.dependencies?size>0)><p>**Depends on**:</p><#list tr.dependencies as dep><p>- ${dep.name}</p></#list></#if> |
    </#list>
</#list>

## Feedback

Please report any issues with the template at https://support.zabbix.com
<#if t.documentation??>
<#if t.documentation.zabbixForumUrl??>

You can also provide a feedback, discuss the template or ask for help with it at [ZABBIX forums](${t.documentation.zabbixForumUrl}).
</#if>
</#if>

<#if t.documentation??>
<#if (t.documentation.issues?size>0)>
## Known Issues
<#list t.documentation.issues as i>

<#if i.description??>
- Description: ${i.description!''}
</#if>
<#if i.version??>
  - Version: ${i.version!''}
</#if>
<#if i.device??>
  - Device: ${i.device!''}
</#if>
</#list>

</#if>
<#if t.documentation.ref??>

## References

${t.documentation.ref!''}
</#if>
</#if>
</#list>
