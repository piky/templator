package org.zabbix.template.generator.objects;

import java.io.IOException;

import org.apache.commons.lang3.StringUtils;
import org.apache.commons.text.WordUtils;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;

//http://www.baeldung.com/jackson-deserialization
public class MetricDeserializer extends StdDeserializer<Metric> { 
	private static String pck = "org.zabbix.template.generator.objects";
	public static Class<?> getMetricClass(String prototype) throws MetricNotFoundException{
		
			String fqdn = StringUtils.remove(WordUtils.capitalizeFully(prototype,'.'), ".");
			try {
				return Class.forName(pck+"."+fqdn);
			} catch (ClassNotFoundException e) {
				throw new MetricNotFoundException("No such class: "+fqdn,e);
			}
		 	
	}
	public MetricDeserializer() { 
		this(null); 
	} 

	public MetricDeserializer(Class<?> vc) { 
		super(vc); 
	}

	@Override
	public Metric deserialize(JsonParser jp, DeserializationContext ctxt) 
			throws IOException, JsonProcessingException {
		JsonNode node = jp.getCodec().readTree(jp);

		ObjectMapper mapper = new ObjectMapper();

		//get prototype name from json 
		String protoName = node.get("prototype").textValue();
		//get class
		Class<?> c;
		c = getMetricClass(protoName); 
		//convert from jsonnode to class c
		Metric out = (Metric) mapper.convertValue( node, c );

		return out;

	}






}