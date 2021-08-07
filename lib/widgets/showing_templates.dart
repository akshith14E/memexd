import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/controllers/showing_template_controller.dart';
import 'package:memexd/models/template_model.dart';
import 'package:memexd/services/get_templates.dart';
import 'package:memexd/widgets/showing_templates_tile.dart';

class ShowingTemplates extends StatefulWidget {
  String sorter;
  ShowingTemplates(this.sorter);
  @override
  _ShowingTemplatesState createState() => _ShowingTemplatesState();
}

class _ShowingTemplatesState extends State<ShowingTemplates> {
  @override
  void initState() {
    if (widget.sorter == 'All') {
      List<TemplateData> templates;
      GetTemplates getTemplates = GetTemplates();
      getTemplates.getLocalTemplate().then((value) {
        templates = value!;
        context.read(showingTemplatesProvider.notifier).show(templates);
      });
    } else if (widget.sorter == 'In') {
      List<TemplateData> templates;
      GetTemplates getTemplates = GetTemplates();
      getTemplates.getLocalTemplate().then((value) {
        templates = value!;
        context.read(showingTemplatesProvider.notifier).sort('In', templates);
      });
    } else if (widget.sorter == 'It') {
      List<TemplateData> templates;
      GetTemplates getTemplates = GetTemplates();
      getTemplates.getLocalTemplate().then((value) {
        templates = value!;
        context.read(showingTemplatesProvider.notifier).sort('It', templates);
      });
    }

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        return ShowingTemplatesTile(
          watch(showingTemplatesProvider),
        );
      },
    );
  }
}
