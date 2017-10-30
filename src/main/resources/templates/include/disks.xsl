<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xpath-default-namespace="http://www.example.org/zbx_template_new/"
                xmlns="http://www.example.org/zbx_template_new/">

    <xsl:template match="template/metrics/system.hw.diskarray.cache.status">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Disk array cache controller status</name>
                <name lang="RU">Статус кэша контроллера дискового массива</name>
                <group>Disk Arrays</group>
                <history><xsl:copy-of select="$history7days"/></history>
                <trends><xsl:copy-of select="$trends0days"/></trends>
                <valueType><xsl:value-of select="if (valueType!='') then valueType else $valueTypeInt"/></valueType>
                <triggers>
                    <xsl:if test="not(../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_CRIT_STATUS')])
				and not(../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_OK_STATUS')])
and not(imported[contains(text(),'true')])">">
                        <xsl:message terminate="yes">Error: provide at least macro for DISK_ARRAY_CACHE_BATTERY_CRIT_STATUS , DISK_ARRAY_CACHE_BATTERY_OK_STATUS</xsl:message>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_CRIT_STATUS')]">
                        <trigger>
                            <id>diskarray.cache.crit</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$DISK_ARRAY_CACHE_CRIT_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Disk array cache controller is in critical state!</name>
                            <name lang="RU">Статус контроллера дискового массива: авария</name>
                            <url/>
                            <priority>3</priority>
                            <description lang="EN">Please check the device for faults</description>
                            <description lang="RU">Проверьте устройство</description>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk Array</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>

                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_WARN_STATUS')]">
                        <trigger>
                            <id>diskarray.cache.warn</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$DISK_ARRAY_CACHE_WARN_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Disk array cache controller is in warning state</name>
                            <name lang="RU">Статус кэша контроллера дискового массива: предупреждение</name>
                            <url/>
                            <priority>2</priority>
                            <description lang="EN">Please check the device for faults</description>
                            <description lang="RU">Проверьте устройство</description>
                            <dependsOn>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_CRIT_STATUS')]"><dependency>diskarray.cache.crit</dependency></xsl:if>
                            </dependsOn>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk Array</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_OK_STATUS')]">
                        <trigger>
                            <id>diskarray.cache.notok</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_notok_e">
                                    <xsl:with-param name="macro">$DISK_ARRAY_CACHE_OK_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Disk array cache controller is not in optimal state</name>
                            <name lang="RU">Статус кэша контроллера дискового массива не норма</name>
                            <url/>
                            <priority>2</priority>
                            <description lang="EN">Please check the device for faults</description>
                            <description lang="RU">Проверьте устройство</description>
                            <dependsOn>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_WARN_STATUS')]"><dependency>diskarray.cache.warn</dependency></xsl:if>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CRIT_STATUS')]"><dependency>diskarray.cache.crit</dependency></xsl:if>
                            </dependsOn>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk Array</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                </triggers>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric" />
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="template/metrics/system.hw.diskarray.cache.battery.status">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Disk array cache controller battery status</name>
                <name lang="RU">Статус батарейки кэша контроллера дискового массива</name>
                <group>Disk Arrays</group>
                <history><xsl:copy-of select="$history7days"/></history>
                <trends><xsl:copy-of select="$trends0days"/></trends>
                <valueType><xsl:value-of select="if (valueType!='') then valueType else $valueTypeInt"/></valueType>
                <triggers>
                    <xsl:if test="not(../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_BATTERY_CRIT_STATUS')])
				and not(../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_BATTERY_OK_STATUS')])
and not(imported[contains(text(),'true')])">">
                        <xsl:message terminate="yes">Error: provide at least macro for DISK_ARRAY_CACHE_BATTERY_CRIT_STATUS , DISK_ARRAY_CACHE_BATTERY_OK_STATUS</xsl:message>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_BATTERY_CRIT_STATUS')]">
                        <trigger>
                            <id>diskarray.cache.battery.crit</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$DISK_ARRAY_CACHE_BATTERY_CRIT_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Disk array cache controller battery is in critical state!</name>
                            <name lang="RU">Статус батарейки кэша контроллера дискового массива: авария</name>
                            <url/>
                            <priority>3</priority>
                            <description lang="EN">Please check the device for faults</description>
                            <description lang="RU">Проверьте устройство</description>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk Array</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>

                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_BATTERY_WARN_STATUS')]">
                        <trigger>
                            <id>diskarray.cache.battery.warn</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$DISK_ARRAY_CACHE_BATTERY_WARN_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Disk array cache controller battery is in warning state</name>
                            <name lang="RU">Статус батарейки кэша контроллера дискового массива: предупреждение</name>
                            <url/>
                            <priority>2</priority>
                            <description lang="EN">Please check the device for faults</description>
                            <description lang="RU">Проверьте устройство</description>
                            <dependsOn>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_BATTERY_CRIT_STATUS')]"><dependency>diskarray.cache.battery.crit</dependency></xsl:if>
                            </dependsOn>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk Array</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_BATTERY_OK_STATUS')]">
                        <trigger>
                            <id>diskarray.cache.battery.notok</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_notok_e">
                                    <xsl:with-param name="macro">$DISK_ARRAY_CACHE_BATTERY_OK_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Disk array cache controller battery is not in optimal state</name>
                            <name lang="RU">Статус батарейки кэша контроллера дискового массива не норма</name>
                            <url/>
                            <priority>2</priority>
                            <description lang="EN">Please check the device for faults</description>
                            <description lang="RU">Проверьте устройство</description>
                            <dependsOn>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_BATTERY_WARN_STATUS')]"><dependency>diskarray.cache.battery.warn</dependency></xsl:if>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CACHE_BATTERY_CRIT_STATUS')]"><dependency>diskarray.cache.battery.crit</dependency></xsl:if>
                            </dependsOn>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk Array</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                </triggers>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric" />
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>



    <xsl:template match="template/metrics/system.hw.diskarray.status">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Disk array controller status</name>
                <name lang="RU">Статус контроллера дискового массива</name>
                <group>Disk Arrays</group>
                <history><xsl:copy-of select="$history7days"/></history>
                <trends><xsl:copy-of select="$trends0days"/></trends>
                <valueType><xsl:value-of select="if (valueType!='') then valueType else $valueTypeInt"/></valueType>
                <triggers>
                    <xsl:if test="not(../../macros/macro/macro[contains(text(),'$DISK_ARRAY_FAIL_STATUS')])
				and not(../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CRIT_STATUS')])
				and not(../../macros/macro/macro[contains(text(),'$DISK_ARRAY_OK_STATUS')])
and not(imported[contains(text(),'true')])">">
                        <xsl:message terminate="yes">Error: provide at least macro for DISK_ARRAY_FAIL_STATUS or DISK_ARRAY_CRIT_STATUS , DISK_ARRAY_OK_STATUS</xsl:message>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_FAIL_STATUS')]">
                        <trigger>
                            <id>disk_array.fail</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$DISK_ARRAY_FAIL_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Disk array controller is in unrecoverable state!</name>
                            <name lang="RU">Статус контроллера дискового массива: сбой</name>
                            <url/>
                            <priority>5</priority>
                            <description lang="EN">Please check the device for faults</description>
                            <description lang="RU">Проверьте устройство</description>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk Array</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CRIT_STATUS')]">
                        <trigger>
                            <id>disk_array.crit</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$DISK_ARRAY_CRIT_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Disk array controller is in critical state</name>
                            <name lang="RU">Статус контроллера дискового массива: авария</name>
                            <url/>
                            <priority>4</priority>
                            <description lang="EN">Please check the device for faults</description>
                            <description lang="RU">Проверьте устройство</description>
                            <dependsOn>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_FAIL_STATUS')]"><dependency>disk_array.fail</dependency></xsl:if>
                            </dependsOn>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk Array</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_WARN_STATUS')]">
                        <trigger>
                            <id>disk_array.warn</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$DISK_ARRAY_WARN_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Disk array controller is in warning state</name>
                            <name lang="RU">Статус контроллера дискового массива: предупреждение</name>
                            <url/>
                            <priority>3</priority>
                            <description lang="EN">Please check the device for faults</description>
                            <description lang="RU">Проверьте устройство</description>
                            <dependsOn>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CRIT_STATUS')]"><dependency>disk_array.crit</dependency></xsl:if>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_FAIL_STATUS')]"><dependency>disk_array.fail</dependency></xsl:if>
                            </dependsOn>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk Array</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_OK_STATUS')]">
                        <trigger>
                            <id>disk_array.notok</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_notok_e">
                                    <xsl:with-param name="macro">$DISK_ARRAY_OK_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Disk array controller is not in optimal state</name>
                            <name lang="RU">Статус контроллера дискового массива не норма</name>
                            <url/>
                            <priority>2</priority>
                            <description lang="EN">Please check the device for faults</description>
                            <description lang="RU">Проверьте устройство</description>
                            <dependsOn>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_WARN_STATUS')]"><dependency>disk_array.warn</dependency></xsl:if>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_CRIT_STATUS')]"><dependency>disk_array.crit</dependency></xsl:if>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_ARRAY_FAIL_STATUS')]"><dependency>disk_array.fail</dependency></xsl:if>
                            </dependsOn>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk Array</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                </triggers>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric" />
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="template/metrics/system.hw.diskarray.model">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Disk array controller model</name>
                <name lang="RU">Модель контроллера дискового массива</name>
                <group>Disk Arrays</group>
                <trends><xsl:copy-of select="$trends0days"/></trends>
                <update><xsl:copy-of select="$update1day"/></update>
                <valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric" />
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="template/metrics/system.hw.physicaldisk.status">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Physical disk status</name>
                <name lang="RU">Статус физического диска</name>
                <group>Physical Disks</group>
                <trends><xsl:copy-of select="$trends0days"/></trends>
                <update><xsl:copy-of select="$update3min"/></update>
                <triggers>
                    <xsl:if test="not(../../macros/macro/macro[contains(text(),'$DISK_FAIL_STATUS')]) and not(../../macros/macro/macro[contains(text(),'$DISK_OK_STATUS')])">
                        <xsl:message terminate="yes">Error: provide at least macro for $DISK_FAIL_STATUS or $DISK_OK_STATUS</xsl:message>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_FAIL_STATUS')]">
                        <trigger>
                            <id>disk.fail</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$DISK_FAIL_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Physical disk failed</name>
                            <name lang="RU">Статус физического диска: сбой</name>
                            <url/>
                            <priority>4</priority>
                            <description lang="EN">Please check physical disk for warnings or errors</description>
                            <description lang="RU">Проверьте диск</description>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_WARN_STATUS')]">
                        <trigger>
                            <id>disk.warn</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$DISK_WARN_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Physical disk is in warning state</name>
                            <name lang="RU">Статус физического диска: предупреждение</name>
                            <url/>
                            <priority>2</priority>
                            <description lang="EN">Please check physical disk for warnings or errors</description>
                            <description lang="RU">Проверьте диск</description>
                            <dependsOn>
                                <dependency>disk.fail</dependency>
                            </dependsOn>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_OK_STATUS')]">
                        <trigger>
                            <id>disk.notok</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_notok_e">
                                    <xsl:with-param name="macro">$DISK_OK_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Physical disk is not in OK state</name>
                            <name lang="RU">Статус физического диска не норма</name>
                            <url/>
                            <priority>2</priority>
                            <description lang="EN">Please check physical disk for warnings or errors</description>
                            <description lang="RU">Проверьте диск</description>
                            <dependsOn>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_FAIL_STATUS')]"><dependency>disk.fail</dependency></xsl:if>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_WARN_STATUS')]"><dependency>disk.warn</dependency></xsl:if>
                            </dependsOn>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                </triggers>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric" />
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="template/metrics/system.hw.physicaldisk.smart_status">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Physical disk S.M.A.R.T. status</name>
                <name lang="RU">S.M.A.R.T. статус диска</name>
                <group>Physical Disks</group>
                <trends><xsl:copy-of select="$trends0days"/></trends>
                <update><xsl:copy-of select="$update3min"/></update>
                <triggers>
                    <xsl:if test="not(../../macros/macro/macro[contains(text(),'$DISK_SMART_FAIL_STATUS')]) and not(../../macros/macro/macro[contains(text(),'$DISK_SMART_OK_STATUS')])
and not(imported[contains(text(),'true')])">">
                        <xsl:message terminate="yes">Error: provide at least macro for DISK_SMART_FAIL_STATUS or DISK_SMART_OK_STATUS</xsl:message>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_SMART_FAIL_STATUS')]">
                        <trigger>
                            <id>disk_smart.fail</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$DISK_SMART_FAIL_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Physical disk S.M.A.R.T. failed</name>
                            <name lang="RU">Статус S.M.A.R.T. физического диска: сбой</name>
                            <url/>
                            <priority>4</priority>
                            <description lang="EN">Disk probably requires replacement.</description>
                            <description lang="RU">Возможно требуется замена диска.</description>
                            <dependsOn>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_FAIL_STATUS')]"><dependency>disk.fail</dependency></xsl:if>
                            </dependsOn>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_SMART_OK_STATUS')]">
                        <trigger>
                            <id>disk_smart.notok</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_notok_e">
                                    <xsl:with-param name="macro">$DISK_SMART_OK_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Physical disk S.M.A.R.T. status is not in OK state</name>
                            <name lang="RU">Статус S.M.A.R.T. физического диска не норма</name>
                            <url/>
                            <priority>3</priority>
                            <description lang="EN">Disk probably requires replacement.</description>
                            <description lang="RU">Возможно требуется замена диска.</description>
                            <dependsOn>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_FAIL_STATUS')]"><dependency>disk.fail</dependency></xsl:if>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_OK_STATUS')]"><dependency>disk.notok</dependency></xsl:if>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$DISK_SMART_FAIL_STATUS')]"><dependency>disk_smart.fail</dependency></xsl:if>
                            </dependsOn>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Disk</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                </triggers>
            </metric>
        </xsl:variable>
        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric" />
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="template/metrics/system.hw.physicaldisk.serialnumber">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Physical disk serial number</name>
                <name lang="RU">Серийный номер физического диска</name>
                <group>Physical Disks</group>
                <trends><xsl:copy-of select="$trends0days"/></trends>
                <update><xsl:copy-of select="$update1day"/></update>
                <valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
                <triggers>
                    <xsl:call-template name="proto_t_sn_changed">
                        <xsl:with-param name="id">physicaldisk.sn.changed</xsl:with-param>
                        <xsl:with-param name="defaultAlarmObjectType">Disk</xsl:with-param>
                    </xsl:call-template>
                </triggers>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric" />
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="template/metrics/system.hw.physicaldisk.model">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Physical disk model name</name>
                <name lang="RU">Модель физического диска</name>
                <group>Physical Disks</group>
                <history><xsl:copy-of select="$history14days"/></history>
                <trends><xsl:copy-of select="$trends0days"/></trends>
                <update><xsl:copy-of select="$update1hour"/></update>
                <valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric" />
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="template/metrics/system.hw.physicaldisk.part_number">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Physical disk part number</name>
                <name lang="RU">Код производителя диска</name>
                <group>Physical Disks</group>
                <history><xsl:copy-of select="$history14days"/></history>
                <trends><xsl:copy-of select="$trends0days"/></trends>
                <update><xsl:copy-of select="$update1hour"/></update>
                <valueType><xsl:copy-of select="$valueTypeChar"/></valueType>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric" />
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="template/metrics/system.hw.physicaldisk.size | template/metrics/system.hw.virtualdisk.size">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Disk size</name>
                <name lang="RU">Размер диска</name>
                <group><xsl:value-of select="if (name() = 'system.hw.physicaldisk.size')
                                                then ('Physical Disks')
                                             else if (name() = 'system.hw.virtualdisk.size')
                                                then ('Virtual Disks')
                                             else ()"/></group>
                <history><xsl:copy-of select="$history14days"/></history>
                <trends><xsl:copy-of select="$trends0days"/></trends>
                <update><xsl:copy-of select="$update1hour"/></update>
                <units>B</units>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric" />
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="template/metrics/system.hw.physicaldisk.media_type">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Physical disk media type</name>
                <name lang="RU">Тип диска</name>
                <group>Physical Disks</group>
                <history><xsl:copy-of select="$history14days"/></history>
                <trends><xsl:copy-of select="$trends0days"/></trends>
                <update><xsl:copy-of select="$update1hour"/></update>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric" />
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="template/metrics/system.hw.physicaldisk.power_on_hours">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Physical disk power on hours</name>
                <name lang="RU">Количество часов включенным</name>
                <group>Physical Disks</group>
                <history><xsl:copy-of select="$history14days"/></history>
                <trends><xsl:copy-of select="$trendsDefault"/></trends>
                <update><xsl:copy-of select="$update1hour"/></update>
                <units>s</units>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric"/>
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="template/metrics/system.hw.virtualdisk.layout">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Layout type</name>
                <name lang="RU">Конфигурация</name>
                <group>Virtual Disks</group>
                <history><xsl:copy-of select="$history14days"/></history>
                <trends><xsl:copy-of select="$trendsDefault"/></trends>
                <update><xsl:copy-of select="$update1hour"/></update>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric"/>
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="template/metrics/system.hw.virtualdisk.readpolicy | template/metrics/system.hw.virtualdisk.writepolicy">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN"><xsl:value-of select="if (name() = 'system.hw.virtualdisk.readpolicy')
                                                then ('Read policy')
                                             else if (name() = 'system.hw.virtualdisk.writepolicy')
                                                then ('Write policy')
                                             else ()"/></name>
                <group>Virtual Disks</group>
                <history><xsl:copy-of select="$history14days"/></history>
                <trends><xsl:copy-of select="$trendsDefault"/></trends>
                <update><xsl:copy-of select="$update1hour"/></update>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric"/>
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="template/metrics/system.hw.virtualdisk.state">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Current state</name>
                <name lang="RU">Текущее состояние</name>
                <group>Virtual Disks</group>
                <history><xsl:copy-of select="$history14days"/></history>
                <trends><xsl:copy-of select="$trendsDefault"/></trends>
                <update><xsl:copy-of select="$update3min"/></update>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric"/>
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>


    <xsl:template match="template/metrics/system.hw.virtualdisk.status">
        <xsl:variable name="metric" as="element()*">
            <metric>
                <name lang="EN">Status</name>
                <name lang="RU">Текущий статус</name>
                <group>Virtual Disks</group>
                <history><xsl:copy-of select="$history14days"/></history>
                <trends><xsl:copy-of select="$trendsDefault"/></trends>
                <update><xsl:copy-of select="$update3min"/></update>
                <triggers>
                    <xsl:if test="not(../../macros/macro/macro[contains(text(),'$VDISK_FAIL_STATUS')]) and not(../../macros/macro/macro[contains(text(),'$VDISK_OK_STATUS')])">
                        <xsl:message terminate="yes">Error: provide at least macro for VDISK_FAIL_STATUS or VDISK_OK_STATUS</xsl:message>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$VDISK_FAIL_STATUS')]">
                        <trigger>
                            <id>vdisk.fail</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$VDISK_FAIL_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Virtual disk failed</name>
                            <name lang="RU">Статус виртуального диска: сбой</name>
                            <url/>
                            <priority>4</priority>
                            <description lang="EN">Please check virtual disk for warnings or errors</description>
                            <description lang="RU">Проверьте диск</description>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Virtual disk</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$VDISK_WARN_STATUS')]">
                        <trigger>
                            <id>vdisk.warn</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_e">
                                    <xsl:with-param name="macro">$VDISK_WARN_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Virtual disk is in warning state</name>
                            <name lang="RU">Статус виртуального диска: предупреждение</name>
                            <priority>3</priority>
                            <description lang="EN">Please check virtual disk for warnings or errors</description>
                            <description lang="RU">Проверьте диск</description>
                            <dependsOn>
                                <dependency>vdisk.fail</dependency>
                            </dependsOn>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Virtual disk</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                    <xsl:if test="../../macros/macro/macro[contains(text(),'$VDISK_OK_STATUS')]">
                        <trigger>
                            <id>vdisk.notok</id>
                            <expression>
                                <xsl:call-template name="proto_t_simple_status_notok_e">
                                    <xsl:with-param name="macro">$VDISK_OK_STATUS</xsl:with-param>
                                </xsl:call-template>
                            </expression>
                            <name lang="EN">Virtual disk is not in OK state</name>
                            <name lang="RU">Статус виртуального диска не норма</name>
                            <priority>2</priority>
                            <description lang="EN">Please check virtualdisk for warnings or errors</description>
                            <description lang="RU">Проверьте диск</description>
                            <dependsOn>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$VDISK_FAIL_STATUS')]"><dependency>vdisk.fail</dependency></xsl:if>
                                <xsl:if test="../../macros/macro/macro[contains(text(),'$VDISK_WARN_STATUS')]"><dependency>vdisk.warn</dependency></xsl:if>
                            </dependsOn>
                            <tags>
                                <tag>
                                    <tag>Alarm.object.type</tag>
                                    <value>
                                        <xsl:call-template name="tagAlarmObjectType">
                                            <xsl:with-param name="alarmObjectType" select="alarmObjectType"/>
                                            <xsl:with-param name="alarmObjectDefault">Virtual disk</xsl:with-param>
                                        </xsl:call-template>
                                    </value>
                                </tag>
                            </tags>
                        </trigger>
                    </xsl:if>
                </triggers>
            </metric>
        </xsl:variable>

        <xsl:copy>
            <xsl:call-template name="defaultMetricBlock">
                <xsl:with-param name="metric" select="$metric"/>
            </xsl:call-template>
        </xsl:copy>
    </xsl:template>


</xsl:stylesheet>

