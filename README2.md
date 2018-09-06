## Features 
- any fields can be overridden  
- custom metric can be added  

## Conventions used  
metric.prototype must be in dot notation. Metric subclass - in TitleCase.  
use camelCase for jsonInput (in @JsonAlias({}) add _ notation like in Zabbix API)     
- in discovery filter provide: formulaid in condition
- arrays must be provided with default value of zero elements.
- use TEMPLATE_NAME:METRIC instead of real trigger keys in expressions/recoveryExpressions use __trigger_ID__ to replace other metrics used in trigger expressions.
- Minimize conditions and complex logic in Freemarker. Do all weird and magic stuff in Drools.
      


## Classes 'magic'  
### magic 1  
```
<xsl:when test="./classes[class='OS']"><name>Templates/Operating Systems</name></xsl:when>
<xsl:when test="./classes[class='Network']"><name>Templates/Network Devices</name></xsl:when>
<xsl:when test="./classes[class='Server']"><name>Templates/Servers Hardware</name></xsl:when>
<xsl:when test="./classes[class='Module']"><name>Templates/Modules</name></xsl:when>
<xsl:otherwise><name>Templates/Modules</name></xsl:otherwise>
```

### magic 2  

```
    <!--  define macros with default values to add into template-->
    <xsl:variable name="MACROS" as="element()*">
        <Performance>
            <CPU_UTIL_MAX>
                <value>90</value>
            </CPU_UTIL_MAX>
            <MEMORY_UTIL_MAX><value>90</value></MEMORY_UTIL_MAX>
        </Performance>
        <Fault>
            <!-- <TEMP_CRIT>
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
               </TEMP_WARN> -->

            <TEMP_CRIT><value>60</value></TEMP_CRIT>
            <TEMP_WARN><value>50</value></TEMP_WARN>
            <TEMP_CRIT_LOW><value>5</value></TEMP_CRIT_LOW>
            <STORAGE_UTIL_CRIT><value>90</value></STORAGE_UTIL_CRIT>
            <STORAGE_UTIL_WARN><value>80</value></STORAGE_UTIL_WARN>
        </Fault>
        <General>
            <SNMP_TIMEOUT><value>3m</value></SNMP_TIMEOUT>
        </General>
        <IF-MIB>
            <IFCONTROL><value>1</value></IFCONTROL>
            <IF_UTIL_MAX><value>90</value></IF_UTIL_MAX>
            <IF_ERRORS_WARN><value>2</value></IF_ERRORS_WARN>
        </IF-MIB>
        <IF-MIB_Simple>
            <IFCONTROL><value>1</value></IFCONTROL>
            <IF_UTIL_MAX><value>95</value></IF_UTIL_MAX>
            <IF_ERRORS_WARN><value>2</value></IF_ERRORS_WARN>
        </IF-MIB_Simple>
        <ICMP>
            <ICMP_LOSS_WARN><value>20</value></ICMP_LOSS_WARN>
            <ICMP_RESPONSE_TIME_WARN><value>0.15</value></ICMP_RESPONSE_TIME_WARN>
        </ICMP>
    </xsl:variable>
```

### magic 3  
attach sub templates

if class = SNMP_DEVICE -> attach SNMP GENERIC
if class = INTERFACES -> attach SNMP INTERFACES
if class = INTERFACES_SIMPLE -> attach SNMP INTERFACES_SIMPLE
if class = Interfaces EtherLike Extension -> Attach Template Module EtherLike-MIB
### magic 4: SNMPvX
add to all template names with SNMP items. This gets rewritten to SNMPv1, SNMPv2 or SNMPv3. (currently in camel route)  


### why generator is implemented in the first place?
What XML format should be so it can be a part of Zabbix?

Templates
  - Require of 'template/metric/trigger prototypes'
    - Reusing item/trigger names and descriptions
  - Need to fill in all attributes, even if they are not used. No defaults. Too verbose! Too much boilerplate!
    - Built in translations
  - Templates are Zabbix version specific. Shouldn't be. So you end up o
  - All enum attributes are shown as integers. Not possible to remember them!
  - Style: Application and Tag reusing

Triggers
  - Edit triggers/trigger prototypes in Zabbix in XML form because of Trigger dependencies. You need to reference templates by expression+name+rec_expression. Thats HARD.
  - Introduce trigger 'snippets': Built in into zabbix expressions for one or two metrics.
  - Introduce shorter trigger expressions that do not mention template/host name by default.

What can help to reduce the requirement for external generation tool?
- introduction to short identifier for templates/triggers/metrics
- switch to JSON as less verbose
- allow not to use all attributes