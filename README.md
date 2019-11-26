# Zabbix Template Generation Tool

## Run as jar

You will need maven to build.  

then do:

```text
mvn package
```

grab jar file in target dir

```text
java -jar target/zabbix-template-generator-0.33.jar
```

or

```text
mkdir /opt/zabbix-template-generator
cp target/zabbix-template-generator-0.33.jar /opt/zabbix-template-generator
cp -Rf bin /opt/zabbix-template-generator
cd /opt/zabbix-template-generator
chmod u+x zabbix-template-generator-0.33.jar
./zabbix-template-generator-0.33.jar
```

## Overview

This tool serve to aid with templates generation in Zabbix.
We suggest to use this tool because we want to achieve the following goals:

- A dozens or hundreds of Templates can be changed in bulk
- Same templates for different versions of Zabbix
- Same templates for different versions of SNMP(if SNMP)
- Localized templates. It must be possible to generate identical template in different language(changing metric/trigger names/descriptions). But otherwise it must be the same template.
- Many metrics in different templates are actually the same. Take `CPU load`, or `Memory utilization` for example. Different devices or OS will have different keys or SNMP oid how to retrieve such metrics - but we want to enforce that these will the be the same metric across all different templates, systems and devices. With the same set of triggers applied.  
Generator will help us to do that with the concept of `prototypes`
- Same applies to triggers. We use `prototypes` of triggers in this generator to reuse triggers in different templates.
- We also want to ensure some baseline quality of the template for the new template. For example, if there is a new template for network device - metrics must be defined that collect `CPU load`, `Memory utilization`, `Interface utilization` to reach `Performance` baseline.
It also must has metrics that collect `Temperature` of at least one temperature sensor to be sure it gets `Fault` baseline. This tool helps to check that template has a decent level of quality.
- Template guidelines also can be enforced.

## Under the hood

Template generator is the java app with `Apache Camel` framework at its core used to define templates building flow. See ZabbixTemplateBuilder.java. What's also involved:

- JSON, YAML schema validation for `in` and `prototype` files.
- Drools to define rules to do all the magic, transformation, validation and baselining.
- Freemarker to XML and Markdown(README) generation at the end.

Simplified, the flow can be seen like this:

`[IN]-----merge with-----> [PROTOTYPES] ---->[DROOLS RULES: validate, tranform] -----> [OUTPUT: templates in XML with README for different versions of the template: 3.4,3.2, in English, in Russian, for SNMPv2, for SNMPv1]`

## Features

Here comes the list of all the magic and so magic features in use.

### Optional attributes and enums as strings

**Implemented as**: Java class  
**How to use**: This feature inspired Zabbix to support the same in 4.4: instead of defining all item attributes, including the ones that are not used - only non-default and mandatory fields can be defined. Also instead of of integers -
string constants are used for Zabbix enums. All enumeration constatns are syncronized with Zabbix 4.4 similar feature. As the result, `in` templates are much shorter and easier to read and work with.  
**Next steps status**: Support all Zabbix attributes possible as is. Currently some are not support, like host screens, for instance.

### YAML and JSON support

**Implemented as**: Java Jackson lib  
**How to use**: JSON and even YAML(only `in` files now) can be used for defining templates and prototypes instead of hard to read XML. JSON flavour used also supports comments and trailing comma in files.  
**Next steps status**: Support YAML in prototypes as well.

### Autodocs

**Implemented as**: Freemarker template  
**How to use**: In the template, define special section called `_documentation`. There you can define `_overview`, `_tested_on`, `_zabbix_config`, `_setup`, `_refs`, `_zabbix_forum_url`. After generation their contents will be used to generate this template README file in markdown.  Lists of items, discoveries, triggers will be taken from the template resulting tempalte.  
There is also additional field in `macros`, called `_description` that must be used to provide the description how this macros is used.  
**Next steps status**: Update JSON Schema accordingly.

### _prototype and _id attributes

**Implemented as**: Java class  
**How to use**: That's the key functionality. If you need to reuse metric or trigger definition, then instead of defining it in the template - item or trigger can be defined in `prototypes` dir instead:

```json
    {
        "_id": "proc.num",
        "name": "Number of processes running",
        "type": "ZABBIX_PASSIVE",
        "triggers": [
            {
                "_id": "trigger.proc.not_running",
                "name": "not running",
                "expression": "{TEMPLATE_NAME:METRIC.last()}=0",
                "priority": "HIGH"
            }
        ]
    },
```

Note the `_id` attribute.  
Then back in the `in` file, this prototype can be referenced using `_prototype` attribute:

```json
{
    "templates": [
        {
            "name": "Template App Nginx Zabbix agent",
            "items": [
                {
                    "_id": "nginx.proc.num",
                    "_prototype": "proc.num",
                    "key": "proc.num[nginx]",
                    "_group": "Nginx",
                    "_resource": "Nginx"
                }
            ]
        }
    ]
}
```

And only fields required can be redefined while common stays, including graphs and trigger mappings.

**Next steps status**: None

### Adding templates to specific Template groups using template classes

**Implemented as**: Freemarker logic  
**How to use**: Template _classes can be defined in `in` files. They serve as tags to activate something.
For example:

- `OS` - adds template to Template/Operating systems `group`
- `Network` - adds template to Template/Network devices `group`
- `Server` - adds template to Template/Server hardware `group`
- `Module` - adds template to Template/Modules `group`
- `App` - adds template to Template/Applications `group`
- `DB` - adds template to Template/Databases `group`

**Next steps status**: Wrong to have it in Freemarker, implement in Drools instead.

### Define Zabbix version required in the template

**Implemented as**: Freemarker + Java + Drools
**How to use**: Use `_zbx_ver` attribute on the template level to define minimum Zabbix version required to run this template. Older templates will not be generated. You can also define `_zbx_ver` on the item level. Such metric will be skipped for older templates and will be removed from any graphs.
**Next steps status**: None

### Special variables to use in template and prototype definitions

**Implemented as**: Freemarker + Drools  
**How to use**:

- Since trigger is defined inside the metric, you can safely use `TEMPLATE_NAME:METRIC` macro instead of metric and template name in trigger expressions.
- Use `__<item._id>__` macro in trigger expressions and graph items to reference some items.
- Use `__<trigger._id>__` in trigger dependencies instead of name+trigger expression
- Use `__RESOURCE__` and `__RESOURCE_TYPE__` to reference `_resource` metric attribute.

**Next steps status**: Use Drools only.

### Loose trigger dependencies

**Implemented as**: Drools: see `populate.trigger.dependencies.drl`  
**How to use**: In triggers you can define trigger dependencies using `__<trigger._id>__`. Trigger dependencies are loose. If trigger mentioned in dependency is not defined in the same scope (i.e. `_resource` + `discoveryRule`) then no dependency is made and no error is given.  
For example temperature warning trigger:

```json
{
        "_id": "tempWarn",
        "expression": "{TEMPLATE_NAME:METRIC.avg(5m)}>{$TEMP_WARN:\"__RESOURCE_TYPE__\"}",
        "recovery_expression": "{TEMPLATE_NAME:METRIC.max(5m)}<{$TEMP_WARN:\"__RESOURCE_TYPE__\"}-3",
        "name": "Temperature is above warning threshold: >{$TEMP_WARN:\"__RESOURCE_TYPE__\"}",
        "priority": "WARNING",
        "_depends_on": [
            "tempCrit",
            "tempCrit.combined"
        ],
        "_translations": {
            "RU": {
                "name": "Температура выше нормы: >{$TEMP_WARN:\"__RESOURCE_TYPE__\"}"
            }
        }
    },
```

Depends on triggers with _ids: `tempCrit` or `tempCrit.combined` only if they are defined as well for the same `_resource`.

**Next steps status**: Use Drools only.

### Adding template links using template classes

**Implemented as**: Drools: see `populate.templates.drl`  
**How to use**: Template _classes can be defined in `in` files. They serve as tags to activate something.
For example to link templates:

- if class = `SNMP_DEVICE` -> attach SNMP GENERIC template
- if class = `INTERFACES` -> attach SNMP INTERFACES template
- if class = `INTERFACES_SIMPLE` -> attach SNMP INTERFACES_SIMPLE
- if class = `Interfaces EtherLike Extension` -> attach Template Module EtherLike-MIB

**Next steps status**: Consider to drop this magic in favor of explicitly defining template links

### Auto importing templates into running Zabbix

**Implemented as**: Camel route: see `ZabbixTemplateImporter.java`  
**How to use**: Set `zabbix.enable=true` in application.properties file to autoimport templates. Use other `zabbix.*` attributes to define where the zabbix is.

**Next steps status**: None

### Macros automatically added for specific metrics

**Implemented as**: Drools: see `populate.templates.drl`  
**How to use**: If metric with specific `_id` is used, macros can be automatically populated. For example for `vfs.fs.pused`:

```java
rule "Rule 7: generate additional macros (vfs.fs.pused)"
    agenda-group "populate"
    no-loop
when
    $t: Template($metrics: metricsRegistry)
    exists (Metric(id == "vfs.fs.pused") from $metrics)
then
    logger.info(marker,"Found vfs.fs.pused metric, adding additional MACRO...");
    modify($t) {
        getMacros().add(new UserMacro("{$VFS.FS.PUSED.MAX.CRIT}","90")),
        getMacros().add(new UserMacro("{$VFS.FS.PUSED.MAX.WARN}","80"));
    };
end
```

**Next steps status**: Consider to drop this magic in favor of explicitly defining macros. Or at least document all of them.

### Singleton LLD support

**Implemented as**: Drools: see `populate.drl`  
**How to use**: you may set `_singleton`: true for any discovery rule. This will add macro {#SINGLETON} as a suffix to all graphs inside this Discovery rule. Just make sure you generate such empty macro {#SINGLETON} in LLD preprocessing. For example:

```yaml
      - name: CPU discovery
        type: DEPENDENT
        master_item: system.cpu.num
        key: snmp.cpu.discovery
        description: This discovery will create set of per core CPU metrics from UCD-SNMP-MIB, using {#CPUNUM} in preprocessing. That's the only reason why LLD is used.
        _singleton: true
        _zbx_ver: "4.2"
        preprocessing:
          - type: JAVASCRIPT
            params: |
              //count the number of CPU cores
              return JSON.stringify([{"{#CPUNUM}": value, "{#SNMPINDEX}": 0, "{#SINGLETON}":""}])
```

**Next steps status**: None

### Ability to add screens

**Implemented as**: Drools populate.screens.drl  
**How to use**: Graphs and Simple graphs are supported. Prototypes vs nonprototypes are choosen automatically.  
Add `screens` section into template. Don't forget to define `hsize`, `vsize` and `x`, `y` for each `screen_item`.  
use `_graph_id` to reference existing graphs by `_id`
use `_metric_id_` to reference existing metric by `_id` (for simple graphs)

```json
"screens": [
                {
                    "name": "Test",
                    "hsize": 2,
                    "vsize": 4,
                    "screen_items": [
                        {
                            "x": 0,
                            "y": 0,
                            "_graph_id": "graph.nginx.current.connections"
                        },
                        {
                            "x": 1,
                            "y": 0,
                            "_metric_id": "nginx.connections.writing"
                        }
                    ]
                }
            ]
```

use `resourcetype` and `resource` attributes(just like in Zabbix API) when you need to reference graphs/items from linked templates as `_graph_id/_metric_id` would not work with objects from linked template.

```yaml
    screens:
      - name: System performance
        hsize: 2
        vsize: 4
        screen_items:
          - resourcetype: GRAPH
            resource:
              - name: System load
            x: 0
            y: 0
          - resourcetype: GRAPH_PROTOTYPE
            resource:
              - name: CPU usage{#SINGLETON}
            x: 1
            y: 0
          - resourcetype: GRAPH
            resource:
              - name: Memory usage
            x: 0
            y: 1
```

**Next steps status**: None

### SNMPvX

**Implemented as**: In Apache Camel route  
**How to use**: `SNMPvX` is added automatically to all templates with SNMP items. This gets rewritten to SNMPv1, SNMPv2 or SNMPv3.  
**Next steps status**: Consider to drop this magic to explicitly defining such suffix.

add to all template names with SNMP items. This gets rewritten to SNMPv1, SNMPv2 or SNMPv3. (currently in camel route)  

### Zabbix agent active auto template generation

**Implemented as**: In Apache Camel route and freemarker  
**How to use**: Add special template `class` into `_classes` named `ZABBIX_ACTIVE`. Additional `by Zabbix active` template will be generated automatically. Make sure template name ends with `by Zabbix agent`.
If there is a link to template `Template Module Zabbix agent` then link is changed to `Template Module Zabbix agent active` too.  
**Next steps status**: Implementation is rather a complete hack. Should be changed.

### Baseline validation of templates

**Implemented as**: Drools rules, see baseline.*.drl files  
**How to use**: Template _classes can be defined in `in` files. When assigned, they check that minimum set of metrics is defined
For example:

- If `Network` and `INVENTORY` classes assigned then at least these metrics must be defined:

```text
Metric (id =='system.hw.model') and
Metric (id =='system.hw.serialnumber') and
Metric (id =='system.sw.os') and
Metric (id =='system.hw.firmware') and
Metric (id =='system.hw.version')
```

To get full compliance add at least this:

```text
Metric (id =='system.hw.model') and
Metric (id =='system.hw.serialnumber')
```

For minimum baseline compliance

**Next steps status**: Document all baseline rules

### Generator file filtering

**Implemented as**: Camel route  
**How to use**: You can define file name filter in `application.properties` file to limit which templates must be generated.  
**Next steps status**: None

### XSD validation of the XML template

**Implemented as**: XSD validation in Apache Camel  
**How to use**: Tempalte is checked automatically at the end.  
**Next steps status**: No longer maintained. Must be removed.

### More stuff

Describe in more detail, TODO:

- vfs.fs utilization formula automatically created (see Drools)
- how metrics are enriched if in LLD (keys, names) What is RESOURCE, RESOURCE_TYPE
- if `application_prototype` is defined, then application is not filled with `_group` value. This enforces 'Single application guideline'
- discard preprocessing steps are magically stripped for templates versions < 4.2
- discard preprocessing steps are magically added for inventory like metrics and healthchecks
- Generator automatically resets 'trends' to 0 for non-numeric items (TEXT, LOG...)
- use `TEMPLATE_NAME:METRIC` instead of real trigger keys in expressions/recovery_expressions use `__metric_id__` to replace other metrics used in trigger expressions.
- If trigger uses multiple metrics, you only need to define this trigger inside first metric
- Value maps validation - if value map is used in the metric but value map itself cannot be found - validation error is thrown
- Macros validation - if macro is used in the metric key or trigger expression but user macro itself cannot be found - validation error is thrown.
- Macros validation - if macro is defined but not used anywhere - validation error is thrown. To bypass it, add `_override: true` to macro
- Inventory links purging if in LLD. If item is in LLD - then inventory link is removed. This rule is ignored if `_singleton` is set to true
- Quotes is present in item parameters are properly escaped in calculated item formula. More on this https://www.zabbix.com/documentation/current/manual/config/items/itemtypes/calculated
- Ability to override `_resource` concatenation in item, trigger and graph names. use `__RESOURCE__` in prototype name instead for more beatiful names
