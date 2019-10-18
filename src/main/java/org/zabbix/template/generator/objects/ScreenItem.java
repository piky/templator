package org.zabbix.template.generator.objects;

import java.util.ArrayList;
import com.fasterxml.jackson.annotation.JsonAlias;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonInclude.Include;

@JsonInclude(value = Include.NON_EMPTY)
public class ScreenItem {

    // https://www.zabbix.com/documentation/current/manual/api/reference/screenitem/object#screen_item
    @JsonAlias({ "resourcetype", "resource_type" })
    private ScreenResourceType resourceType;

    private int width = 750;
    private int height = 100;
    private int x = 0;
    private int y = 0;
    private int colspan = 1;
    private int rowspan = 1;
    private int elements = 25;
    private Valign valign = Valign.MIDDLE;
    private Halign halign = Halign.CENTER;

    @JsonProperty("_graph_id")
    private String graphId;
    @JsonProperty("_metric_id")
    private String metricId;
    /*
     * Screen item display option.
     * 
     * Possible values for data overview and triggers overview screen items: 0 -
     * (default) display hosts on the left side; 1 - display hosts on the top.
     * 
     * Possible values for hosts info and triggers info screen elements: 0 -
     * (default) horizontal layout; 1 - vertical layout.
     * 
     * Possible values for clock screen items: 0 - (default) local time; 1 - server
     * time; 2 - host time.
     * 
     * Possible values for plain text screen items: 0 - (default) display values as
     * plain text; 1 - display values as HTML.
     */
    private int style = 0;
    private String url;
    private Dynamic dynamic = Dynamic.NOT_DYNAMIC;
    /*
     * Order in which actions or triggers must be sorted.
     * 
     * Possible values for history of actions screen elements: 3 - time, ascending;
     * 4 - time, descending; 5 - type, ascending; 6 - type, descending; 7 - status,
     * ascending; 8 - status, descending; 9 - retries left, ascending; 10 - retries
     * left, descending; 11 - recipient, ascending; 12 - recipient, descending.
     * 
     * Possible values for latest host group issues and latest host issues screen
     * items: 0 - (default) last change, descending; 1 - severity, descending; 2 -
     * host, ascending.
     */
    @JsonAlias("sort_triggers")
    private int sortTriggers = 0;
    @JsonAlias("max_columns")
    private int maxColumns = 3;
    /*
     * Application or part of application name by which data in screen item can be
     * filtered. Applies to resource types: “Data overview” and “Triggers overview”.
     */
    private String application;

    @JsonAlias("resource")
    private ArrayList<ScreenResource> resource = new ArrayList<ScreenResource>(0);

    public enum Dynamic implements ZabbixValue {

        NOT_DYNAMIC(0), DYNAMIC(1);

        private int zabbixValue;

        Dynamic(int zabbixValue) {
            this.setZabbixValue(zabbixValue);
        }

        @Override
        public int getZabbixValue() {
            return zabbixValue;
        }



        public void setZabbixValue(int zabbixValue) {
            this.zabbixValue = zabbixValue;
        }

    };

    public enum Valign implements ZabbixValue {

        MIDDLE(0), TOP(1), BOTTOM(2);

        private int zabbixValue;

        Valign(int zabbixValue) {
            this.setZabbixValue(zabbixValue);
        }

        @Override
        public int getZabbixValue() {
            return zabbixValue;
        }



        public void setZabbixValue(int zabbixValue) {
            this.zabbixValue = zabbixValue;
        }

    };

    public enum Halign implements ZabbixValue {

        CENTER(0), LEFT(1), RIGHT(2);

        private int zabbixValue;

        Halign(int zabbixValue) {
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

    public ScreenResourceType getResourceType() {
        return resourceType;
    }

    public void setResourceType(ScreenResourceType resourceType) {
        this.resourceType = resourceType;
    }

    public int getWidth() {
        return width;
    }

    public void setWidth(int width) {
        this.width = width;
    }

    public int getHeight() {
        return height;
    }

    public void setHeight(int height) {
        this.height = height;
    }

    public int getX() {
        return x;
    }

    public void setX(int x) {
        this.x = x;
    }

    public int getY() {
        return y;
    }

    public void setY(int y) {
        this.y = y;
    }

    public int getColspan() {
        return colspan;
    }

    public void setColspan(int colspan) {
        this.colspan = colspan;
    }

    public int getRowspan() {
        return rowspan;
    }

    public void setRowspan(int rowspan) {
        this.rowspan = rowspan;
    }

    public int getElements() {
        return elements;
    }

    public void setElements(int elements) {
        this.elements = elements;
    }

    public Valign getValign() {
        return valign;
    }

    public void setValign(Valign valign) {
        this.valign = valign;
    }

    public Halign getHalign() {
        return halign;
    }

    public void setHalign(Halign halign) {
        this.halign = halign;
    }

    public int getStyle() {
        return style;
    }

    public void setStyle(int style) {
        this.style = style;
    }

    public String getUrl() {
        return url;
    }

    public void setUrl(String url) {
        this.url = url;
    }

    public Dynamic getDynamic() {
        return dynamic;
    }

    public void setDynamic(Dynamic dynamic) {
        this.dynamic = dynamic;
    }

    public int getSortTriggers() {
        return sortTriggers;
    }

    public void setSortTriggers(int sortTriggers) {
        this.sortTriggers = sortTriggers;
    }

    public int getMaxColumns() {
        return maxColumns;
    }

    public void setMaxColumns(int maxColumns) {
        this.maxColumns = maxColumns;
    }

    public String getApplication() {
        return application;
    }

    public void setApplication(String application) {
        this.application = application;
    }

    public ArrayList<ScreenResource> getResource() {
        return resource;
    }

    public void setResource(ArrayList<ScreenResource> resource) {
        this.resource = resource;
    }

    public String getGraphId() {
        return graphId;
    }

    public void setGraphId(String graphId) {
        this.graphId = graphId;
    }

    public String getMetricId() {
        return metricId;
    }

    public void setMetricId(String metricId) {
        this.metricId = metricId;
    };

}
