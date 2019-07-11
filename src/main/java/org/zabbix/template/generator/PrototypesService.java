package org.zabbix.template.generator;

import java.io.File;
import java.io.IOException;
import java.util.HashMap;

import javax.annotation.PostConstruct;

import com.fasterxml.jackson.core.JsonFactory;
import com.fasterxml.jackson.core.JsonParser;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.core.io.ResourceLoader;
import org.springframework.core.io.support.ResourcePatternUtils;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.JsonNodeType;

@Service("prototypesService")
public class PrototypesService {

	private static HashMap<String, JsonNode> prototypes = new HashMap<String, JsonNode>();
	private static final Logger logger = LogManager.getLogger(PrototypesService.class.getName());

	private ResourceLoader resourceLoader;

	@Autowired
	public PrototypesService(ResourceLoader resourceLoader) {
		this.resourceLoader = resourceLoader;
	}

	public static HashMap<String, JsonNode> getPrototypes() {
		return prototypes;
	}

	public static void setPrototypes(HashMap<String, JsonNode> prototypes) {
		PrototypesService.prototypes = prototypes;
	}

	private static void addFileToMap(ObjectMapper mapper, File file) throws JsonProcessingException, IOException {

		JsonNode node = mapper.readTree(file);
		if (node.getNodeType() == JsonNodeType.ARRAY) {
			for (JsonNode jn : node) {
				prototypes.put(jn.get("id").asText(), jn);
				logger.debug(jn.get("id").asText());
			}
		} else if (node.getNodeType() == JsonNodeType.OBJECT) {
			prototypes.put(node.get("id").asText(), node);
			logger.debug(node.get("id").asText());
		} else {
			logger.error("Unknown JSON object in file");
		}

	}

	@PostConstruct
	public void init() {
		try {

			Resource[] resources = ResourcePatternUtils.getResourcePatternResolver(resourceLoader)
					.getResources("file:bin/prototypes/*");
			// mapper JSON
			// create factory to enable comments for json
			JsonFactory f = new JsonFactory();
			f.enable(JsonParser.Feature.ALLOW_COMMENTS);

			ObjectMapper mapper = new ObjectMapper(f);

			for (Resource r : resources) {
				File file = r.getFile();
				addFileToMap(mapper, file);
			}

			logger.info("Prototypes map was loaded successfully.");

		} catch (IOException | NullPointerException e) {
			logger.error("Prototypes map could not be initialized. ", e);
		}
	}

}
