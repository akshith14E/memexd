import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:memexd/controllers/theme_controller.dart';
import 'package:memexd/providers/shared_preferences_provider.dart';
import 'package:memexd/screens/comments_screen.dart';
import 'package:memexd/screens/cutout.dart';
import 'package:memexd/screens/edit_profile_screen.dart';
import 'package:memexd/screens/editor_screen.dart';
import 'package:memexd/screens/follow_list_screen.dart';
import 'package:memexd/screens/post_screen.dart';
import 'package:memexd/screens/profile_screen.dart';
import 'package:memexd/screens/saved_posts_list_screen.dart';
import 'package:memexd/screens/searched_user_profile.dart';
import 'package:memexd/screens/signin_screen.dart';
import 'package:memexd/screens/template_example_screen.dart';
import 'package:memexd/screens/template_screen.dart';
import 'package:memexd/screens/about_us_screen.dart';
import 'package:memexd/screens/search_memers_screen.dart';
import 'package:memexd/screens/home_screen.dart';
import 'package:memexd/screens/user_meme_screen.dart';
import 'package:memexd/widgets/custom_dialog_box.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/root_page.dart';
import 'package:memexd/screens/registration_screen.dart';
import 'package:memexd/services/auth_checker.dart';
import 'screens/follow_us_screen.dart';
import 'screens/reach_us_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final sharedPrefs = await SharedPreferences.getInstance();
  await Firebase.initializeApp();
  MobileAds.instance.initialize();

  runApp(ProviderScope(overrides: [
    sharedPrefsProvider.overrideWithValue(sharedPrefs),
  ], child: MyApp()));
}

class MyApp extends ConsumerWidget {
  Route<dynamic>? _onGenerateRoute(RouteSettings routeSettings) {
    final arguments = routeSettings.arguments;
    switch (routeSettings.name) {
      case './Comments_Screen':
        return MaterialPageRoute(
            builder: (_) => arguments is String
                ? CommentsScreen(postId: arguments)
                : CommentsScreen(postId: ""));
      case 'User_Screen':
        return MaterialPageRoute(
            builder: (_) => SearchedProfile(userId: arguments.toString()));
    }
  }

  static FirebaseAnalytics analytics = FirebaseAnalytics();
  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);

  @override
  Widget build(BuildContext context, watch) {
    return MaterialApp(
      title: 'MemeXD',
      debugShowCheckedModeBanner: false,
      theme: watch(themeControllerProvider).themeData,
      navigatorObservers: [observer],
      initialRoute: AuthChecker.id,
      onGenerateRoute: _onGenerateRoute,
      routes: {
        'dialogBox': (context) => CustomDialogBox(),
        Home.id: (context) => Home(),
        AuthChecker.id: (context) => AuthChecker(),
        Cutout.id: (context) => Cutout(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        RootPage.id: (context) => RootPage(),
        EditorScreen.id: (context) => EditorScreen(),
        AboutUsScreen.id: (context) => AboutUsScreen(),
        SearchMemersScreen.id: (context) => SearchMemersScreen(),
        FollowUsScreen.id: (context) => FollowUsScreen(),
        FollowListScreen.id: (context) => FollowListScreen(),
        ReachUsScreen.id: (context) => ReachUsScreen(),
        UserMemesScreen.id: (context) => UserMemesScreen(),
        SavedPostListScreen.id: (context) => SavedPostListScreen(),
        TemplateScreen.id: (context) => TemplateScreen(),
        EditProfile.id: (context) => EditProfile(),
        //EditProfileScreen.id: (context) => EditProfileScreen(),
        SigninScreen.id: (context) => SigninScreen(),
        ProfileScreen.id: (context) => ProfileScreen(),
        PostScreen.id: (context) => PostScreen(),
        TemplateExampleScreen.id: (context) => TemplateExampleScreen(),
      },
    );
  }
}
