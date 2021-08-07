import 'package:flutter/material.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/screens/editor_screen.dart';
import 'package:memexd/services/ad_helper.dart';
import 'package:memexd/widgets/fading_cube.dart';
import '../models/template_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:memexd/providers/editor_providers.dart';

class ShowingTemplatesTile extends StatefulWidget {
  final List<TemplateData> list;
  ShowingTemplatesTile(this.list);

  @override
  _ShowingTemplatesTileState createState() => _ShowingTemplatesTileState();
}

class _ShowingTemplatesTileState extends State<ShowingTemplatesTile> {
  @override
  Widget build(BuildContext context) {
    InterstitialAdsWidget adObject = new InterstitialAdsWidget();
    adObject.createInterad();
    String x =
        "https://firebasestorage.googleapis.com/v0/b/memexd-61ae8.appspot.com/o/";
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      itemCount: widget.list.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () {
            context.read(customTemplateProvider).state = null;
            context.read(templateImageProvider).state = CachedNetworkImage(
                imageUrl: x + widget.list[index].tu,
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(
                      value: downloadProgress.progress),
              errorWidget: (context, url, error) => Icon(Icons.error),
            );
            adObject.showInterad();
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => EditorScreen(url: widget.list[index].tu)));
          },
          child: ClipRRect(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            child: Card(
              color: Theme.of(context).backgroundColor,
              elevation: 0,
              child: Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(6),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: x + widget.list[index].ic,
                    progressIndicatorBuilder: (context, url, downloadProgress) =>
                        SpinKitFadingCube(
                      color: kPrimaryColor,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
