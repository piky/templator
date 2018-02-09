package org.zabbix.template.generator;


import com.fasterxml.jackson.databind.JsonNode;

public class ClassChooser {
	private static String pck = "org.zabbix.template.generator.objects";
	  public static Class<?> getMetricClass(String prototype){
		  try {
			return Class.forName(pck+"."+prototype);
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return null;
		  
		  
	  }

}
