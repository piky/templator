package org.zabbix.api;

import java.util.HashMap;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.autoconfigure.condition.ConditionalOnProperty;
import org.springframework.stereotype.Service;

import io.github.hengyunabc.zabbix.api.DefaultZabbixApi;
import io.github.hengyunabc.zabbix.api.Request;
import io.github.hengyunabc.zabbix.api.RequestBuilder;

@ConditionalOnProperty(value = "zabbix.enabled")
@Service
public class ZabbixService extends DefaultZabbixApi {

	private boolean login;
	private String auth;
	private static final Logger logger = LogManager.getLogger(ZabbixService.class.getName());
	private float version;

	@Autowired
	public ZabbixService(@Value("${zabbix.login}") String zabbix_login, @Value("${zabbix.password}") String zabbix_pass,
			@Value("${zabbix.url.api}") String url, @Value("${zabbix.version}") String ver) {
		super(url);

		this.init();
		this.login = login(zabbix_login, zabbix_pass);
		this.version = Float.parseFloat(ver);
	}

	/*
	 * public boolean login(String user, String password) {
	 * 
	 * try { logger.info("Logging into Zabbix"); return super.login(user, password);
	 * } catch (Exception e){
	 * logger.error("Failed to login to Zabbix, try again later"); return false; }
	 * 
	 * }
	 */

	@Override
	public boolean login(String user, String password) {
		logger.info("Logging into Zabbix");
		this.auth = null;
		try {
			Request request = RequestBuilder.newBuilder().paramEntry("user", user).paramEntry("password", password)
					.method("user.login").build();
			JSONObject response = call(request);

			String auth = response.getString("result");
			checkResponse(response, request);
			if (auth != null && !auth.isEmpty()) {
				this.auth = auth;
				return true;
			}
		} catch (Exception e) {
			logger.error("Failed to login to Zabbix, try again later");
			return false;
		}
		return false;
	}

	public void logout() {

		if (this.login) {
			logger.info("Logging out from Zabbix...");

			Request getRequest = RequestBuilder.newBuilder().method("user.logout").build();
			JSONObject getResponse = this.call(getRequest);

		}
		this.destroy();
	}

	protected void finalize() {
		this.logout();
		this.destroy();
	}

	public void importTemplate(String configuration) throws zabbixAuthException, zabbixResponseException {

		JSONObject rules = new JSONObject();

		JSONObject createMissing = new JSONObject();
		createMissing.put("createMissing", new Boolean(true));

		JSONObject updateExisting = new JSONObject();
		updateExisting.put("updateExisting", new Boolean(true));

		JSONObject deleteMissing = new JSONObject();
		deleteMissing.put("deleteMissing", new Boolean(true));

		rules.put("hosts", new HashMap<String, Object>() {
			{
				put("createMissing", true);
			}
		});
		rules.put("hosts", new HashMap<String, Object>() {
			{
				put("createMissing", true);
				put("updateExisting", true);
			}
		});
		rules.put("templates", new HashMap<String, Object>() {
			{
				put("createMissing", true);
				put("updateExisting", true);
			}
		});
		rules.put("templateLinkage", new HashMap<String, Object>() {
			{
				put("createMissing", true);
			}
		});
		rules.put("applications", new HashMap<String, Object>() {
			{
				put("createMissing", true);
				put("deleteMissing", true);
			}
		});
		rules.put("discoveryRules", new HashMap<String, Object>() {
			{
				put("createMissing", true);
				put("updateExisting", true);
				put("deleteMissing", true);
			}
		});
		rules.put("items", new HashMap<String, Object>() {
			{
				put("createMissing", true);
				put("updateExisting", true);
				put("deleteMissing", true);
			}
		});
		rules.put("triggers", new HashMap<String, Object>() {
			{
				put("createMissing", true);
				put("updateExisting", true);
				put("deleteMissing", true);
			}
		});
		rules.put("graphs", new HashMap<String, Object>() {
			{
				put("createMissing", true);
				put("updateExisting", true);
				put("deleteMissing", true);
			}
		});
		// change to "screens" for version 5.2 and later
		if (this.version < 5.2f) {
			rules.put("templateScreens", new HashMap<String, Object>() {
				{
					put("createMissing", true);
					put("updateExisting", true);
				}
			});
		} else {
			rules.put("screens", new HashMap<String, Object>() {
				{
					put("createMissing", true);
					put("updateExisting", true);
				}
			});
		}
		rules.put("maps", new HashMap<String, Object>() {
			{
				put("createMissing", true);
				put("updateExisting", true);
			}
		});
		rules.put("valueMaps", new HashMap<String, Object>() {
			{
				put("createMissing", true);
				put("updateExisting", true);
			}
		});

		Request getRequest = RequestBuilder.newBuilder().method("configuration.import").paramEntry("format", "xml")
				.paramEntry("rules", rules).paramEntry("source", configuration).build();

		// getRequest.setAuth(this.getAuth());
		try {
			JSONObject getResponse = this.doRequest(getRequest);
			checkResponse(getResponse, getRequest);
		} catch (Exception e) {
			logger.error("Failed to import templates to Zabbix: " + e.getMessage());
		}

	}

	public JSONObject doRequest(Request getRequest) throws zabbixAuthException, zabbixResponseException {

		JSONObject getResponse;
		// since we made auth field in this class not in original DefaultZabbixApi
		if (this.getAuth() == null) {
			throw new zabbixAuthException("Failed to login");
		}
		getRequest.setAuth(this.getAuth());
		try {
			getResponse = this.call(getRequest);
			checkResponse(getResponse, getRequest);
			// logger.debug(getRequest.toString());
			// logger.debug(getResponse.toString());
			// if (!getResponse.getJSONArray("result").isEmpty()) {
			// return getResponse.getJSONArray("result");
			// } else {
			// return getResponse.getJSONArray("result");
			// }
			return getResponse;
		} catch (java.lang.RuntimeException re) {
			logger.error("Caught RuntimeException " + re.getMessage());
		}
		return null;

	}

	protected void checkResponse(JSONObject getResponse, Request getRequest)
			throws zabbixAuthException, zabbixResponseException {
		/*
		 * "error": { "code": -32602, "message": "Invalid params.", "data":
		 * "Session terminated, re-login, please." or "Not authorised" },
		 */
		logger.debug("" + getRequest);
		logger.debug("" + getResponse);
		if (getResponse.containsKey("error")) {

			if (getResponse.getJSONObject("error").containsKey("data")) {
				String data = getResponse.getJSONObject("error").getString("data");
				// logger.warn("Got: "+data+" for method: "+ getRequest.getMethod() +", params:
				// "+getRequest.getParams());
				if (data.contains("Session terminated, re-login, please.") || data.contains("Not authorised")) {
					throw new zabbixAuthException("Session terminated, re-login, please.");
				} else {
					throw new zabbixResponseException(
							"Error response from Zabbix: " + data + " for method: " + getRequest.getMethod());
					// + ", params: " + getRequest.getParams());
				}
			}
		} else if (getResponse.get("result").getClass() == JSONArray.class) {
			if (getResponse.getJSONArray("result").isEmpty()) {
				logger.warn("Object not found in Zabbix for response: " + " for method: " + getRequest.getMethod()
						+ ", params: " + getRequest.getParams());
			}
		}

	}

	protected String getAuth() {
		return auth;
	}

	class zabbixAuthException extends Exception {
		public zabbixAuthException(String message) {
			super(message);
		}

	}

	class zabbixResponseException extends Exception {
		public zabbixResponseException(String message) {
			super(message);
		}
	}

}