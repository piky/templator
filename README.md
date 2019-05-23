## About
Please read:  
https://documentation.zabbix.lan/specifications/3.4/zbxnext-3725/generator
and
https://documentation.zabbix.lan/specifications/3.4/zbxnext-3725

Structure:

**bin** - templates
* bin/in - metric_source files  
* bin/merged - intermediate merged files (not yet converted to zabbix_export.xsd)  
* bin/out - zabbix templates generated ready to be delivered and imported    

**src** - generator code 
Spring-boot and Apache Camel are used to glue XSLT transformations.    

## Install

You will need maven to build.  

then do:  
```
cd templates
mvn package
```
grab jar file in target dir  


```
cd templates
java -jar target/zabbix-template-generator-0.5.jar
```  
or  

```
mkdir /opt/zabbix-template-generator
cp target/zabbix-template-generator-0.5.jar /opt/zabbix-template-generator
cp -Rf bin /opt/zabbix-template-generator
cd /opt/zabbix-template-generator
chmod u+x zabbix-template-generator-0.5.jar
./zabbix-template-generator-0.5.jar
```  


## Generator usage

# in-files
in-files names:  
use 00, 01 etc for templates that should be imported first  


Classes magic.
```xml
<classes>
  	  	<class>Fault</class>
  	  	<class>Inventory</class>
  	  	<class>Server</class>
  	  	<class>SNMP Device</class>
  	  	<class>SNMPv2</class>
</classes>
```
SNMP Device - Attaches Template Module Generic SNMPvx (and ping template)  
SNMPv2 - v2 version of SNMP generated  
Fault, Inventory, Performance - what Macros would be attached.
Interfaces EtherLike Extension - to link Etherlike template

Documentation: 
```
	  <documentation>
	  	<overview></overview>
	  	<issues>
	  		<issue>
	  			<description>D-Link reports missing PSU as fail(4)</description>
	  			<version>Firmware: 	1.73R008,hardware revision:	B1</version>
	  			<device>DGS-3420-26SC Gigabit Ethernet Switch</device>
	  		</issue>  	  			  		  		
	  	</issues>
	  </documentation>
```




Value maps:  
if SNMP, use raw value maps provided by the vendor. You can change 'camelCase' to 'Camel case' though.


## merge
-  memory magic(TODO)
-  triggers with expressions prototypes (SICK, TODO)