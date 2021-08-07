import 'package:firebase_database/firebase_database.dart';
import 'package:memexd/models/template_model.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GetTemplates {

  // Future<List<TemplateData>?>
  getTemplates() async {

    // await getAllDBTemplates();
    List<TemplateData>? templateData;
    List<TemplateData>? localTemplateData = await getLocalTemplate();
    if(localTemplateData != null) {
      int localTemplateSize = localTemplateData.length;
      int? dbTemplateSize = await getDBTemplateCount();
      if(localTemplateSize != dbTemplateSize) {
        int diff = dbTemplateSize! - localTemplateSize;
        if(diff>0)
        {
          templateData = await getDiffDBTemplates(diff, localTemplateData);
        }
      }
      else {
        templateData = localTemplateData;
      }
    }
    else {
      templateData = await getAllDBTemplates();
    }
    // return templateData;

}

  Future<List<TemplateData>> getAllDBTemplates() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<TemplateData> dbTemplateList = [];

    await FirebaseDatabase.instance
        .reference()
        .child('Templates')
        .once()
        .then(
            (DataSnapshot snapshot) {
          Map<dynamic, dynamic> tempData = snapshot.value;
          tempData.forEach((key, value) {
            dbTemplateList.add(TemplateData.fromJson(value));
          });
        });

    final String templateListString = TemplateData.encode(dbTemplateList);
    await prefs.setString('templateData', templateListString);
    return dbTemplateList;
  }

  Future<List<TemplateData>> getDiffDBTemplates(int count ,List<TemplateData> localTemplateData) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<TemplateData> dbTemplateList = localTemplateData;

    await FirebaseDatabase.instance
        .reference()
        .child('Templates')
        .limitToLast(count)
        .once()
        .then(
            (DataSnapshot snapshot) {
          Map<dynamic, dynamic> tempData = snapshot.value;
          tempData.forEach((key, value) {
            dbTemplateList.add(TemplateData.fromJson(value));
          });
        });

    final String templateListString = TemplateData.encode(dbTemplateList);
    await prefs.setString('templateData', templateListString);
    return dbTemplateList;
  }

  Future<int?> getDBTemplateCount() async {
    return await FirebaseDatabase.instance
        .reference()
        .child("Extras")
        .child("ttc")
        .once()
        .then((DataSnapshot snapshot) {
          return snapshot.value;
    });
  }

  Future<List<TemplateData>?> getLocalTemplate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? templateData = prefs.getString('templateData');
    if(templateData != null) {
      List<TemplateData>? templateList = TemplateData.decode(templateData);
      return templateList;
    }
    else
      return null;
  }
}


