package org.zabbix.template.generator.objects;

import java.io.IOException;
import java.util.HashMap;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.text.WordUtils;

import org.zabbix.template.generator.PrototypesService;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.ObjectReader;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;

//http://www.baeldung.com/jackson-deserialization
public class MetricDeserializer extends StdDeserializer<Metric> {
	private static String pck = "org.zabbix.template.generator.objects";

	private HashMap<String, JsonNode> prototypes = PrototypesService.getPrototypes();

	public static Class<?> getMetricClass(String prototype) throws MetricPrototypeNotFoundException {

		String fqdn = StringUtils.remove(WordUtils.capitalizeFully(prototype, '.'), ".");
		try {
			return Class.forName(pck + "." + fqdn);
		} catch (ClassNotFoundException e) {
			throw new MetricPrototypeNotFoundException("No such class: " + fqdn);
		}

	}

	public MetricDeserializer() {
		this(null);
	}

	public MetricDeserializer(Class<?> vc) {
		super(vc);
	}

	/*
	 * @Override public Metric deserialize(JsonParser jp, DeserializationContext
	 * ctxt) throws IOException, JsonProcessingException { JsonNode node =
	 * jp.getCodec().readTree(jp);
	 * 
	 * ObjectMapper mapper = new ObjectMapper();
	 * 
	 * //get prototype name from json String protoName =
	 * node.get("prototype").textValue(); //get class Class<?> c; c =
	 * getMetricClass(protoName);
	 * 
	 * //convert from jsonnode to class c Metric out = (Metric) mapper.convertValue(
	 * node, c ); //System.out.println(prototypes.get("system.cpu.util"));
	 * System.out.println(PrototypesService.getPrototypes().toString()); return out;
	 * 
	 * 
	 * 
	 * String defaultJson = "{\r\n" + "	\"prototype\":\"sensor.temp.value\",\r\n" +
	 * "	\"name\":\"Temperature\",\r\n" +
	 * "	\"description\":\"Temperature readings of testpoint: <xsl:value-of select=\\\"alarmObject\\\"/>\",\r\n"
	 * + "	\"valueType\":\"FLOAT\",\r\n" + "	\"group\":\"Temperature\"\r\n" +
	 * "}"; Metric defaults = mapper.readValue(defaultJson,MetricDefault.class);
	 * 
	 * ObjectReader updater = mapper.readerForUpdating(defaults); Metric merged =
	 * updater.readValue(node);
	 * 
	 * 
	 * 
	 * }
	 */

	@Override
	public Metric deserialize(JsonParser jp, DeserializationContext ctxt)
			throws IOException, JsonProcessingException, MetricPrototypeNotFoundException {
		JsonNode node = jp.getCodec().readTree(jp);

		ObjectMapper mapper = new ObjectMapper();

		// get prototype name from json
		String protoName;
		try {
			protoName = node.get("prototype").textValue();
		} catch (NullPointerException npe) {
			// assign default as 'none'
			protoName = "none";
		}

		JsonNode defaultJson = prototypes.get(protoName);
		if (defaultJson != null) {
			Metric defaults = mapper.treeToValue(defaultJson, MetricDefault.class);
			ObjectReader updater = mapper.readerForUpdating(defaults);
			Metric merged = updater.readValue(node);

			return merged;

		} else {
			throw new MetricPrototypeNotFoundException("There is no such prototype: " + protoName);
		}
	}

}