# Zabbix Template Generation tool

## Overview and why generating

This tool serve to aid with templates generation in Zabbix.
We suggest to use this tools because we want to achieve the following goals:
- A dozers or hunders of Templates can be changed in bulk
- Same templates for different versions of Zabbix
- Same templates for different versions of SNMP(if SNMP)
- Localized templates. It must be possible to generate identical template in different language(changing metric/trigger names/descriptions). But otherwise it must be the same template.
- Many metrics in different templates are actually the same. Take `CPU load`, or `Memory utilization` for example. Different devices or OS will have different keys or SNMP oid how to retrieve such metrics - but we want to enforce that these will the be the same metric acros all different templates,systems and devices. With the same set of triggers applied.
Generator will help us to do so with the concept of `prototypes`
- Same applies to triggers. We use `prototypes` of triggers in this generator to reuse triggers in different templates.
- We also want to ensure some baseline quality of the template for the new template. For example, if there is a new template for network device - metrics must be defined that collect `CPU load`,`Memory utilization`, `Interface utilization` to reach `Performance` baseline.
It also must has metrics that collect `Temperature` of at least one temperature sensor to be sure it gets `Fault` baseline. This tool helps to check that template has a decent level of quality.


## Workflow of the tool
`<in> ----merge with-----> <prototypes> ----check merge result with the set of rules ---> generate different versions of the template: for 3.4, 3.2, in English, in Russian, for SNMPv2 and for SNMPv1...`

### In
You can completely define the template in the `in` file: json and yaml(experimental) are supported for this.

### Prototypes
However, to reuse metric definitions - you can define most of its fields in `prototypes` dir. Then, back in `in` file you can reference the prototype.
Once referenced, any additional metric fields can be redefined. So metrics can be customized even if prototype is used.

### Usage of template classes

Template classes can be defined in `in` files. They serve as tags to activate something.
For example
`OS` - adds template to Template/Operating systems group  
`Network` - adds template to Template/Network devices group  
`Server` - adds template to Template/Server hardware group  
`Module` - adds template to Template/Modules group  
`App` - adds template to Template/Applications group  

### Conventions
TODO

### Adding a metric

#### Adding preprocessing

### Adding a trigger to metric
TODO
- use `TEMPLATE_NAME:METRIC` instead of the real trigger keys in expressions/recoveryExpressions
- use `__trigger_ID__` to replace other metrics used in trigger expressions. For example: TODO
- If trigger uses multiple metrics, you only need to define this trigger inside first metric
### Macros


### Template dependencies



### Value Maps



### Limit metric to minimum version


### JSONSchema


## Magic stuff
TODO
- memory utilization, vfs utilization
- how metrics are enriched if in LLD (keys, names) What is ALARM_OBJECT, ALARM_OBJECT_TYPE


_____________________________________________------------
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