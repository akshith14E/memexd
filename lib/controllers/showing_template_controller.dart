import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/models/template_model.dart';
import 'package:memexd/providers/auth_provider.dart';
import 'package:memexd/providers/shared_preferences_provider.dart';
import 'package:memexd/services/get_templates.dart';
import 'package:shared_preferences/shared_preferences.dart';

final showingTemplatesProvider =
    StateNotifierProvider<ShowingTemplatesController, List<TemplateData>>(
        (ref) => ShowingTemplatesController());

class ShowingTemplatesController extends StateNotifier<List<TemplateData>> {
  static final templateKey = 'templateKey';

  ShowingTemplatesController() : super([]);
  List<TemplateData> temporaryList = [];

  List<TemplateData>? getTemplate() {
    GetTemplates getTemplates = GetTemplates();
    getTemplates.getLocalTemplate().then((value) {
      return value;
    });
  }

  void sort(String sortName, List<TemplateData> templates) {
    temporaryList = [];
    for (TemplateData temp in templates) {
      if (temp.c == sortName) {
        temporaryList.add(temp);
      }
    }
    state = temporaryList;
  }

  void shuffle() {
    state = temporaryList;
    state.shuffle();
  }

  void search(String searchString, List<TemplateData> templates) async {
    temporaryList = [];
    final String search = searchString.toLowerCase();
    final List<String> parts = search.split("([,\\s]* )");
    for (TemplateData template in templates) {
      if (search != "") {
        int count = 0;
        for (String part in parts) {
          if (kmp(template.t, part)) count++;
        }
        if (parts.length == count)
          temporaryList.insert(0, template);
        else if (parts.length / 2 < count)
          temporaryList.insert(temporaryList.length, template);
      }
    }
    state = temporaryList;
  }

  List computeLPS(String pattern) {
    List lps = List.filled(pattern.length, null, growable: true);
    lps[0] = 0;
    int m = pattern.length;
    int j = 0;
    int i = 1;

    while (i < m) {
      if (pattern[j] == pattern[i]) {
        lps[i] = j + 1;
        i++;
        j++;
      } else if (j > 0) {
        j = lps[j - 1];
      } else {
        // no match
        lps[i] = 0;
        i++;
      }
    }

    return lps;
  }

  bool kmp(String text, String pattern) {
    int n = text.length;
    int m = pattern.length;

    int i = 0;
    int j = 0;
    List lps = computeLPS(pattern);

    while (i < n) {
      if (pattern[j] == text[i]) {
        i++;
        j++;
      }

      if (j == m) {
        j = lps[j - 1];
        i += m - 1;
        return true;
      } else if (i < n && pattern[j] != text[i]) {
        if (j != 0) {
          j = lps[j - 1];
        } else {
          i = i + 1;
        }
      }
    }
    return false;
  }

  void show(List<TemplateData> templates) {
    temporaryList = templates;
    state = temporaryList;
  }
}
