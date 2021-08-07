import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/controllers/template_example_controller.dart';
import 'package:memexd/widgets/custom_app_bar.dart';
import 'package:memexd/widgets/progress_indicator.dart';
import 'package:memexd/widgets/template_example_list.dart';

class TemplateExampleScreen extends StatefulWidget {
  static String get id => 'Template_Example_Screen';
  final String? url;
  TemplateExampleScreen({this.url});

  @override
  _TemplateExampleScreenState createState() => _TemplateExampleScreenState(url!);
}

class _TemplateExampleScreenState extends State<TemplateExampleScreen> {
  String url;
  _TemplateExampleScreenState(this.url);
  @override
  void initState() {
    super.initState();
    context.read(templateExampleProvider.notifier).sortPostsbyTemplates(url);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: customAppbar(context),
        body: Consumer(builder: (context, watch, child) {
          return watch(templateExampleProvider).when(
              data: (_) => TemplateExampleList(
                  posts: watch(templateExampleProvider).data!.value),
              loading: () => Progress(),
              error: (e, _) => Container(
                    child: Text('error occured'),
                  ));
        }),
      ),
    );
  }
}
