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
public class TriggerDeserializer extends StdDeserializer<Trigger> { 

	
	private HashMap<String,JsonNode> prototypes = PrototypesService.getPrototypes();
	
	public TriggerDeserializer() { 
		this(null); 
	} 

	public TriggerDeserializer(Class<?> vc) { 
		super(vc); 
	}	
	
	
	@Override
	public Trigger deserialize(JsonParser jp, DeserializationContext ctxt) 
			throws IOException, JsonProcessingException, MetricPrototypeNotFoundException {
		JsonNode node = jp.getCodec().readTree(jp);

		ObjectMapper mapper = new ObjectMapper();

		//get prototype name from json 
		String protoName = node.get("prototype").textValue();
		
		JsonNode defaultJson = prototypes.get(protoName);
		if (defaultJson != null) {
			Trigger defaults = mapper.treeToValue(defaultJson,TriggerDefault.class);
			ObjectReader updater = mapper.readerForUpdating(defaults);
			Trigger merged = updater.readValue(node);
			
			return merged;
		
		} else {
			throw new MetricPrototypeNotFoundException("There is no such prototype: "+protoName);
		}
	}

}