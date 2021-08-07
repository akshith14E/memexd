import 'dart:convert';


class TemplateData {
  String ic;
  String t;
  String c;
  String tu;
  TemplateData({
    required this.ic,
    required this.t,
    required this.c,
    required this.tu,
  });
  factory TemplateData.fromJson(dynamic json) => TemplateData(
        ic: json['ic'],
        t: json['t'],
        c: json['c'],
        tu: json['tu'],
      );

  static Map<String, dynamic> toMap(TemplateData template) => {
    'ic': template.ic,
    't': template.t,
    'c': template.c,
    'tu': template.tu
  };

  static String encode(List<TemplateData> templateData) => json.encode(
    templateData
        .map<Map<String, dynamic>>((template) => TemplateData.toMap(template))
        .toList(),
  );

  static List<TemplateData> decode(String templateData) =>
      (json.decode(templateData) as List<dynamic>)
          .map<TemplateData>((item) => TemplateData.fromJson(item))
          .toList();
}
