package org.zabbix.template.generator.objects;

public enum PreprocessingStepType implements ZabbixValue {

    MULTIPLIER(1), RIGHT_TRIM(2), LEFT_TRIM(3), TRIM(4), REGEX(5), BOOLEAN_TO_DECIMAL(6), OCTAL_TO_DECIMAL(7),
    HEXADECIMAL_TO_DECIMAL(8), SIMPLE_CHANGE(9), CHANGE_PER_SECOND(10), XML_XPATH(11), JSONPATH(12), IN_RANGE(13),
    MATCHES_REGULAR_EXPRESSION(14), DOES_NOT_MATCH_REGULAR_EXPRESSION(15), CHECK_FOR_ERROR_IN_JSON(16),
    CHECK_FOR_ERROR_IN_XML(17), CHECK_FOR_ERROR_IN_REGULAR_EXPRESSION(18), DISCARD_UNCHANGED(19),
    DISCARD_UNCHANGED_WITH_HEARTBEAT(20), JAVASCRIPT(21), PROMETHEUS_PATTERN(22), PROMETHEUS_TO_JSON(23);
    private int zabbixValue;

    PreprocessingStepType(int zabbixValue) {
        this.setZabbixValue(zabbixValue);
    }

    @Override
    public int getZabbixValue() {
        return zabbixValue;
    }

    public void setZabbixValue(int zabbixValue) {
        this.zabbixValue = zabbixValue;
    }

}