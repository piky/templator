<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
<!--  zabbix template as an output -->
<xsl:output method="html" indent="yes"/>

<xsl:param name="lang" select="EN"/> <!-- EN as defaults -->

<xsl:template match="/">
<html>
	<body>
		<xsl:apply-templates select="child::*/template"/>
	</body>
</html>
</xsl:template>

<xsl:template match="template">
		<h1><xsl:value-of select="./name"/></h1>
		<p><xsl:value-of select="./description"/></p>
		
		<h2>Templates links</h2>
		<xsl:variable name="templatesLinks">
			<xsl:copy-of select="./templates/template"/>
		</xsl:variable>
		<xsl:call-template name="templatesLinksTable">
			<xsl:with-param name="templatesLinks" select="$templatesLinks"/>
		</xsl:call-template>		
	
		
		<h2>Discovery rules</h2>
		<xsl:variable name="discoveryTable">
			<xsl:copy-of select="./discoveryRules/discoveryRule"/>
		</xsl:variable>
		<xsl:call-template name="discoveryTable" >
			<xsl:with-param name="discoveryTable" select="$discoveryTable"/>
		</xsl:call-template>
				
		
		
		<h2>Items</h2>
		<xsl:variable name="items">
			<xsl:copy-of select="./metrics/*"/>
		</xsl:variable>
		<xsl:call-template name="itemsTable">
			<xsl:with-param name="items" select="$items"/>
		</xsl:call-template>
		
				
		<h2>Triggers</h2>
		<xsl:variable name="triggers">
			<xsl:copy-of select="./metrics/*/triggers/trigger"/>
		</xsl:variable>
		<xsl:call-template name="triggersTable" >
			<xsl:with-param name="triggers" select="$triggers"/>
		</xsl:call-template>
</xsl:template>

<xsl:template name="templatesLinksTable">
  <xsl:param name="templatesLinks"/>
  <table border="1">
    <tr bgcolor="#9acd32">
      <th>Name</th>
    </tr>

    <xsl:for-each select="$templatesLinks/*">
    <tr>
      <td><xsl:value-of select="./name"/></td>
    </tr>
    </xsl:for-each>
  </table>
</xsl:template>


<xsl:template name="discoveryTable">
  <xsl:param name="discoveryTable"/>
  <table border="1">
    <tr bgcolor="#9acd32">

      <th>Name</th>
      <th>Key</th>
      <th>SNMP OID</th>
      <th>Description</th>
    </tr>

    <xsl:for-each select="$discoveryTable/*">
    <tr>
      <td><xsl:value-of select="./name"/></td>
      <td><xsl:value-of select="./key"/></td>
      <td><xsl:value-of select="./snmp_oid"/></td>
      <td><xsl:value-of select="./description"/></td>
    </tr>
    </xsl:for-each>
  </table>
</xsl:template>


<xsl:template name="itemsTable">
  <xsl:param name="items"/>
  <table border="1">
    <tr bgcolor="#9acd32">
      <th>Application</th>
      <th>Discovery Rule</th>
      <th>Name</th>
      <th>Key</th>
      <th>SNMP OID</th>
      <th>Description</th>
      <th>Documentation</th>
      <th>Type</th>
    </tr>
    <xsl:for-each select="$items/*">
    <tr>
      <td><xsl:value-of select="./group"/></td>
      <td><xsl:value-of select="./discoveryRule"/></td>
      <td><xsl:value-of select="./name"/></td>
      <td><xsl:value-of select="./snmpObject"/></td>
      <td><xsl:value-of select="./oid"/></td>
      <td><xsl:value-of select="./description"/></td>
      <td><xsl:value-of select="./documentation"/></td>
      <td><xsl:value-of select="./itemType"/></td>
    </tr>
    </xsl:for-each>
  </table>
</xsl:template>


<xsl:template name="triggersTable">
  <xsl:param name="triggers"/>
  <table border="1">
    <tr bgcolor="#9acd32">
      <th>Name</th>
      <th>Description</th>
      <th>Expression</th>
      <th>Documentation</th>
      <th>Severity</th>
    </tr>

    <xsl:for-each select="$triggers/*">
    <tr>
      <td><xsl:value-of select="./name"/></td>
      <td><xsl:value-of select="./description"/></td>
      <td><xsl:value-of select="./expression"/></td>
      <td><xsl:value-of select="./documentation"/></td>
      <xsl:choose>
      <xsl:when test="./priority = 0">
         <td bgcolor="#97AAB3">
         Not classified(0)
         </td>
      </xsl:when>      
      <xsl:when test="./priority = 1">
         <td bgcolor="#7499FF">
         Info(1)
         </td>
      </xsl:when>
      <xsl:when test="./priority = 2">
         <td bgcolor="#FFC859">
         Warning(2)
         </td>
      </xsl:when>
      <xsl:when test="./priority = 3">
         <td bgcolor="#FFA059">
         Average(3)
         </td>
      </xsl:when>
      <xsl:when test="./priority = 4">
         <td bgcolor="#E97659">
         High(4)
         </td>
      </xsl:when>
      <xsl:when test="./priority = 5">
         <td bgcolor="#E45959">
         Disaster(5)
         </td>
      </xsl:when>
      <xsl:otherwise>
         <td><xsl:value-of select="./priority"/></td>
      </xsl:otherwise>
      </xsl:choose>
    </tr>
    </xsl:for-each>
  </table>
</xsl:template>


</xsl:stylesheet>
