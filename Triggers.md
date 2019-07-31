# Adding triggers


Triggers are defined inside the metric, in `triggers` array:

for example in JSON:
```
                        ...
                        {
                            "prototype": "sensor.temp.value",
                            "oid": "1.3.6.1.4.1.9.9.13.1.3.1.3.{#SNMPINDEX}",
                            "_snmpObject": "ciscoEnvMonTemperatureValue.{#SNMPINDEX}",
                            "_mib": "CISCO-ENVMON-MIB",
                            "_vendor_description": "The current measurement of the test point being instrumented.",
                            "_resource": "{#SNMPVALUE}",
                            "triggers": [
                                {
                                    "prototype": "tempWarn.combined"
                                },
                                {
                                    "prototype": "tempCrit.combined",
                                    "expression": "{TEMPLATE_NAME:METRIC.avg(5m)}>{$TEMP_CRIT:\"__RESOURCE_TYPE__\"}\nor\n{TEMPLATE_NAME:__sensor.temp.status__.last(0)}={$TEMP_CRIT_STATUS}\nor\n{TEMPLATE_NAME:__sensor.temp.status__.last(0)}={$TEMP_DISASTER_STATUS}"
                                },
                                {
                                    "prototype": "tempLow"
                                }
                            ]
                        },
                        ...
```

## The most important fields you need to define:

prototype: - reference to prototype if needed.
expression:
recovery_expression:
other fields from the trigger can be defined, applied:

https://www.zabbix.com/documentation/4.0/manual/api/reference/trigger/object

in expressions used special MACRO: TEMPLATE_NAME:METRIC to reference metric where trigger is situated. Or use
__metric_id__ to reference any other metric.

## Composition of trigger name
_resource of the metric is used


## prototypes
you can also define trigger not in `in` file but in prototypes


## Translating triggers

## Redefining metric triggers set of prototype

You can redefine which triggers will be active to this specific template. Example:
In prototype of `system.status` metric only `health.crit` trigger is present:
```
    {
        "name": "Overall system health status",
        "_translations": {
            "RU": {
                "name": "Общий статус системы"
            }
        },
        "id": "system.status",
        "_group": "Status",
        "delay": "30s",
        "history": "2w",
        "trends": "0d",
        "triggers": [
            {
                "prototype":"health.crit"
            }
        ]

    }
    ...
```
If you want to have more triggers for this metric, you may actually redefine this metric in `in` file like so:
```in "in" file
{
              "prototype": "system.status",
              "oid": "1.3.6.1.4.1.9.9.719.1.9.35.1.42.{#SNMPINDEX}",
              "_snmpObject": "cucsComputeRackUnitOperState.{#SNMPINDEX}",
              "_mib": "CISCO-UNIFIED-COMPUTING-COMPUTE-MIB",
              "_resource": "{#UNIT_LOCATION}",
              "_vendor_description": "Cisco UCS compute:RackUnit:operState managed object property",
              "valueMap": "CISCO-UNIFIED-COMPUTING-TC-MIB::CucsLsOperState",
              "triggers": [
                {
                  "prototype":"health.crit"
                },
                {
                  "prototype":"health.warn"
                }
              ]
},
```
that way, not only `health.crit` trigger but also `health.warn` trigger will be assigned to this metric.


### Health check triggers

- Define usermacro with value you want to check for. Use the following format for the macro:
{$OBJECT_FAIL_STATUS}
{$OBJECT_CRIT_STATUS}
{$OBJECT_WARN_STATUS}
{$OBJECT_NOTOK_STATUS}

If there are multiple status, then use context user macro like so:

{$OBJECT_WARN_STATUS:"notoperable"}
{$OBJECT_WARN_STATUS:"degraded"}

but you need to redefine trigger expression after that:
```
 "metrics": [
            {
              "prototype": "system.hw.diskarray.status",
              "oid": "1.3.6.1.4.1.9.9.719.1.45.1.1.6.{#SNMPINDEX}",
              "_snmpObject": "cucsStorageControllerOperState.{#SNMPINDEX}",
              "_mib": "CISCO-UNIFIED-COMPUTING-STORAGE-MIB",
              "_resource": "{#DISKARRAY_LOCATION}",
              "valueMap": "CISCO-UNIFIED-COMPUTING-TC-MIB::CucsEquipmentOperability",
              "triggers":[
                {
                  "prototype":"disk_array.crit",
                  "expression": "{TEMPLATE_NAME:METRIC.count(#1,{$DISK_ARRAY_CRIT_STATUS:\"inoperable\"},eq)}=1"
                },
                {
                  "prototype":"disk_array.warn",
                  "expression": "{TEMPLATE_NAME:METRIC.count(#1,{$DISK_ARRAY_WARN_STATUS:\"degraded\"},eq)}=1 or {TEMPLATE_NAME:METRIC.count(#1,{$DISK_ARRAY_WARN_STATUS:\"notoperable\"},eq)}=1"
                },
                {
                  "prototype":"disk_array.notok",
                  "expression": "{TEMPLATE_NAME:METRIC.count(#1,{$DISK_ARRAY_OK_STATUS:\"operable\"},ne)}=1"
                }
              ]
            }
```
note that for `notok` use `ne` not `eq`,