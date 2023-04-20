[JsonObject(MemberSerialization.OptOut)]修饰类，只序列化public属性和public字段，不需要被序列化的属性或字段可以用[JsonIgnoreAttribute](https://www.newtonsoft.com/json/help/html/T_Newtonsoft_Json_JsonIgnoreAttribute.htm)修饰。

[JsonObject(MemberSerialization.OptIn)]修饰类，只序列化被 [JsonPropertyAttribute](https://www.newtonsoft.com/json/help/html/T_Newtonsoft_Json_JsonPropertyAttribute.htm)修饰的属性和字段(无论属性和字段的访问修饰符是public，protected还是private，只要被[JsonPropertyAttribute](https://www.newtonsoft.com/json/help/html/T_Newtonsoft_Json_JsonPropertyAttribute.htm)修饰都会被序列化)。

[JsonObject(MemberSerialization.Fields)]修饰类，会序列化所有的字段 (无论字段的访问修饰符是public，protected还是private)，但不会序列化任何属性。不需要被序列化的字段或会生成back-field的属性可以用[JsonIgnoreAttribute](https://www.newtonsoft.com/json/help/html/T_Newtonsoft_Json_JsonIgnoreAttribute.htm)修饰。

