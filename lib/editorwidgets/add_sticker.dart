import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:memexd/constants/color_constants.dart';
import 'package:memexd/providers/editor_providers.dart';
import 'package:memexd/screens/cutout.dart';
import 'package:memexd/screens/editor_screen.dart';
import 'package:memexd/services/image_services.dart';

// enum WidgetMarker { none, sticker, text, delete }

class AddSticker extends ConsumerWidget {
  List<String> stickers = [
    'stickers/5863b6db7d90850fc3ce2932.png',
    'stickers/achievement_unlocked.png',
    'stickers/airpods.png',
    'stickers/alchemy.jpg',
    'stickers/bananaducttape.png',
    'stickers/bba.png',
    'stickers/BernieYeahGood.jpg',
    'stickers/block.jpg',
    'stickers/boof1.png',
    'stickers/boof2.png',
    'stickers/boof3.png',
    'stickers/boof4.png',
    'stickers/boomer.png',
    'stickers/brainletconcave.png',
    'stickers/brainlethelmet.png',
    'stickers/bubble_1_512.png',
    'stickers/bubble_3a.png',
    'stickers/bubble_4a.png',
    'stickers/bubble_12_512.png',
    'stickers/buffdoge.png',
    'stickers/c75.png',
    'stickers/canudont.jpg',
    'stickers/changedaworld.jpg',
    'stickers/cheems.png',
    'stickers/classictrollface.png',
    'stickers/communismblack.png',
    'stickers/communismred.png',
    'stickers/cryingjordanleft.png',
    'stickers/cryingzoomer.png',
    'stickers/dancingjoker.png',
    'stickers/dancingminijoker.png',
    'stickers/destruction.jpg',
    'stickers/fbi_hat_2.png',
    'stickers/fbi_hat_3.png',
    'stickers/fucking_kidding_me.png',
    'stickers/gauntlet.png',
    'stickers/glasses_0_8bit_512.png',
    'stickers/glasses_2_black_512.png',
    'stickers/h_a_laser_eye_512_c.png',
    'stickers/h_a_laser_eye_512_d3.png',
    'stickers/h_eyes_1_512.png',
    'stickers/h_eyes_3_512.png',
    'stickers/hmm.jpg',
    'stickers/illuminati_1.png',
    'stickers/illuminati_2.png',
    'stickers/illusion.jpg',
    'stickers/jokerrunning.png',
    'stickers/karenhair.png',
    'stickers/littleboy.png',
    'stickers/lol_face.png',
    'stickers/markipliersticker.jpg',
    'stickers/mememan_trans.png',
    'stickers/monopoly.jpg',
    'stickers/moustache_2c_512.png',
    'stickers/moustache_3c_512.png',
    'stickers/moustache_7c_512.png',
    'stickers/moustachebeard_1c_512.png',
    'stickers/moustachebeard_2c_512.png',
    'stickers/noucard.png',
    'stickers/onehanded.jpg',
    'stickers/purepng.com-mobile-phone-with-touchmobilemobile-phonehandymobile-devicetouchscreenmobile-phone-device-231519333033ywohl.png',
    'stickers/ragefu.png',
    'stickers/reverse.png',
    'stickers/revive.png',
    'stickers/RtardAlien.png',
    'stickers/shaqhot.png',
    'stickers/silenceviolence.jpg',
    'stickers/skulltrumpettext.png',
    'stickers/sneak.jpg',
    'stickers/speech.jpg',
    'stickers/suiciderate.jpg',
    'stickers/tarnation.png',
    'stickers/tobecontinued.png',
    'stickers/triggered.png',
    'stickers/truebajzl.png',
    'stickers/upvote.png',
    'stickers/victoryroyale.png',
    'stickers/wholesome100.jpg',
    'stickers/Yeet.png',
  ];

  @override
  Widget build(BuildContext context, ScopedReader watch) {
    final widgetList = watch(widgetDataProvider);
    final _cutoutImage = watch(cutoutImageProvider);
    return Container(
      padding: EdgeInsets.only(
          top: MediaQuery.of(context).size.height * 0.02,
          left: 5.0,
          right: 5.0),
      height: MediaQuery.of(context).size.height * 0.35,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(35), topLeft: Radius.circular(35)),
        // boxShadow: [
        //   BoxShadow(
        //       color: Colors.white10,
        //       offset: Offset(10, -10),
        //       blurRadius: 15.0,
        //       spreadRadius: 0.5)
        // ],
      ),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 10,
          mainAxisSpacing: 5,
        ),
        itemCount: stickers.length + 1,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return IconButton(
              icon: Icon(Icons.add),
              onPressed: () async {
                String? _pickedStickerImage = await imagePickCrop(ImageSource.gallery);
                //context.read(pickedStickerProvider).state = _pickedStickerImage;
                Uint8List list = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cutout(
                      pickedStickerfromPhone: _pickedStickerImage,
                    ),
                  ),
                );

                context
                    .read(widgetDataProvider.notifier)
                    .addStickerCustom(list);
                context.read(selectedWidgetIndexProvider).state =
                    widgetList.length;
                context.read(selectedWidgetProvider).state = widgetList.length;
                context.read(showStickerWidgetProvider).state = !watch(showStickerWidgetProvider).state;
                context.read(selectedWidgetMarker1Provider).state =
                    WidgetMarker1.none;
              },
            );
          } else {
            return GestureDetector(
              child: Image.asset(stickers[index - 1]),
              onTap: () {
                // final _key = GlobalKey();
                // Image.asset(stickers[index - 1], key: _key,); //it can be any widget
                //
                // Size? size = _key.currentContext!.size;
                // double height = size!.height;
                // double width = size.width;
                // double scale = 0.25;
                //
                // Offset offset = Offset(dx, dy)

                context
                    .read(widgetDataProvider.notifier)
                    .addSticker(stickers[index - 1]);
                context.read(selectedWidgetIndexProvider).state =
                    widgetList.length;
                context.read(selectedWidgetProvider).state = widgetList.length;
                context.read(showStickerWidgetProvider).state = !watch(showStickerWidgetProvider).state;
                context.read(selectedWidgetMarker1Provider).state =
                    WidgetMarker1.none;
              },
            );
          }
        },
      ),
    );
  }
}
