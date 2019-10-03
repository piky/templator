package org.zabbix.template.generator.objects;

public enum PreprocessingStepType implements ZabbixValue {

    MULTIPLIER(1), RTRIM(2), LTRIM(3), TRIM(4), REGEX(5), BOOL_TO_DECIMAL(6), OCTAL_TO_DECIMAL(7), HEX_TO_DECIMAL(8),
    SIMPLE_CHANGE(9), CHANGE_PER_SECOND(10), XMLPATH(11), JSONPATH(12), IN_RANGE(13), MATCHES_REGEX(14),
    NOT_MATCHES_REGEX(15), CHECK_JSON_ERROR(16), CHECK_XML_ERROR(17), CHECK_REGEX_ERROR(18), DISCARD_UNCHANGED(19),
    DISCARD_UNCHANGED_HEARTBEAT(20), JAVASCRIPT(21), PROMETHEUS_PATTERN(22), PROMETHEUS_TO_JSON(23), CSV_TO_JSON(24);

    private int zabbixValue;

    PreprocessingStepType(int zabbixValue) {
        this.setZabbixValue(zabbixValue);
    }

    @Override
    public int getZabbixValue() {
        return zabbixValue;
    }

    public String getZabbixValue(String version) {
        if (new Version(version).compareTo(new Version("4.4")) >= 0) {
            return this.toString();
        } else {
            return new Integer(zabbixValue).toString();
        }
    }

    public void setZabbixValue(int zabbixValue) {
        this.zabbixValue = zabbixValue;
    }

}