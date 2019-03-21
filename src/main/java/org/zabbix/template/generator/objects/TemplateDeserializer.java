package org.zabbix.template.generator.objects;

import java.io.IOException;

import com.fasterxml.jackson.core.JsonParser;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.DeserializationContext;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.deser.std.StdDeserializer;

//http://www.baeldung.com/jackson-deserialization
public class TemplateDeserializer extends StdDeserializer<Template> {

	public TemplateDeserializer() {
		this(null);
	}

	public TemplateDeserializer(Class<?> vc) {
		super(vc);
	}

	@Override
	public Template deserialize(JsonParser jp, DeserializationContext ctxt)
			throws IOException, JsonProcessingException, MetricPrototypeNotFoundException {
		JsonNode node = jp.getCodec().readTree(jp);

		ObjectMapper mapper = new ObjectMapper();

		Template template = mapper.treeToValue(node, TemplateDefault.class);
		// put all metrics into registry
		template.constructMetricsRegistry();
		// template.getMetricsRegistry().forEach((m)->System.out.println(m.getName()));

		return template;
	}

}