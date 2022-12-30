import 'dart:ui';

import 'package:active_ecommerce_flutter/app_config.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/introduction_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:package_info/package_info.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:wave_image/wave_image.dart';

import 'package:is_first_run/is_first_run.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  PackageInfo _packageInfo = PackageInfo(
    appName: AppConfig.app_name,
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
  );

  AnimationController animationController;

  @override
  void initState() {
    //on Splash Screen hide statusbar
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);

    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 500),
    );
    animationController.forward();
    animationController.addListener(() {
      setState(() {
        if (animationController.status == AnimationStatus.completed) {
          animationController.repeat();
        }
      });
    });
    _initPackageInfo();
    _initFirstRun();
  }

  bool firstRun = false;
  Future<void> _initFirstRun() async {
    firstRun = await IsFirstRun.isFirstRun();
  }



  @override
  void dispose() {
    //before going to other screen show statusbar
    SystemChrome.setEnabledSystemUIOverlays(
        [SystemUiOverlay.top, SystemUiOverlay.bottom]);
    animationController.dispose();
    super.dispose();
  }

  Future<void> _initPackageInfo() async {
    final PackageInfo info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  Future<Widget> loadFromFuture() async {
    // <fetch data from server. ex. login>

    return Future.value(Main());
  }

  @override
  Widget build(BuildContext context) {
    return CustomSplashScreen(
      //comment this
      seconds: 8,

      //comment this
      navigateAfterSeconds: Main(),//firstRun?IntroductionSreen():

      //navigateAfterFuture: loadFromFuture(), //uncomment this
      // title: Row(
      //   mainAxisSize: MainAxisSize.min,
      //   children: <Widget>[
      //     DefaultTextStyle(
      //       style: const TextStyle(
      //         fontSize: 40.0,
      //         fontFamily: 'Tajawal',
      //       ),
      //       child: AnimatedTextKit(
      //         animatedTexts: [
      //           TyperAnimatedText('We',
      //               textStyle: TextStyle(color: Colors.black)),
      //           TyperAnimatedText('Make Groceries',
      //               textStyle: TextStyle(color: Colors.black)),
      //           TyperAnimatedText('Better',
      //               textStyle: TextStyle(
      //                   color: MyTheme.accent_color,
      //                   fontWeight: FontWeight.bold)),
      //         ],
      //         onTap: () {
      //           print("Tap Event");
      //         },
      //       ),
      //     ),
      //   ],
      // ),
      useLoader: false,
      // loadingText: Text(
      //   AppConfig.copyright_text,
      //   style: TextStyle(
      //     fontWeight: FontWeight.w400,
      //     fontSize: 13.0,
      //     color: MyTheme.dark_grey,
      //   ),
      // ),
      // image:

      // image: AnimatedBuilder(
      //     animation: animationController,
      //     child: new Container(
      //       height: 80.0,
      //       width: 80.0,
      //       child: Image.asset(
      //         "assets/black-logo.png",
      //       ),
      //     )),
      // image: AnimatedBuilder(
      //   animation: animationController,
      //   child: Container(
      //     child: Image.asset("assets/black-logo.png"),
      //   ),
      //   builder: (BuildContext context, Widget _widget) {
      //     return new Transform.rotate(
      //       angle: animationController.value,
      //       child: _widget,
      //     );
      //   },
      // ),
      // image: Image.asset("assets/black-logo.png"),
      // image: WaveImage(
      //   boarderColor: Colors.transparent,
      //   boarderWidth: 2,
      //   imageSize: 100,
      //   imageUrl: 'assets/black-logo.png',
      //   radius: 50,
      //   speed: 200,
      //   waveColor: MyTheme.accent_color2,
      // ),
      photoSize: 100.0,
      imageBackground:
          Image.asset("assets/splash-screen.gif", fit: BoxFit.fitHeight),
      // backgroundColor: MyTheme.white,
      backgroundPhotoSize: 100.0,
    );
  }
}

class CustomSplashScreen extends StatefulWidget {
  /// Seconds to navigate after for time based navigation
  final int seconds;

  /// App title, shown in the middle of screen in case of no image available
  final Widget title;

  /// Page background color
  final Color backgroundColor;

  /// Style for the laodertext
  final TextStyle styleTextUnderTheLoader;

  /// The page where you want to navigate if you have chosen time based navigation
  final dynamic navigateAfterSeconds;

  /// Main image size
  final double photoSize;

  final double backgroundPhotoSize;

  /// Triggered if the user clicks the screen
  final dynamic onClick;

  /// Loader color
  final Color loaderColor;

  /// Main image mainly used for logos and like that
  final Widget image;

  final Widget backgroundImage;

  /// Loading text, default: "Loading"
  final Text loadingText;

  ///  Background image for the entire screen
  final Widget imageBackground;

  /// Background gradient for the entire screen
  final Gradient gradientBackground;

  /// Whether to display a loader or not
  final bool useLoader;

  /// Custom page route if you have a custom transition you want to play
  final Route pageRoute;

  /// RouteSettings name for pushing a route with custom name (if left out in MaterialApp route names) to navigator stack (Contribution by Ramis Mustafa)
  final String routeName;

  /// expects a function that returns a future, when this future is returned it will navigate
  final Future<dynamic> navigateAfterFuture;

  /// Use one of the provided factory constructors instead of.
  @protected
  CustomSplashScreen({
    this.loaderColor,
    this.navigateAfterFuture,
    this.seconds,
    this.photoSize,
    this.backgroundPhotoSize,
    this.pageRoute,
    this.onClick,
    this.navigateAfterSeconds,
    this.title = const Text(''),
    this.backgroundColor = Colors.white,
    this.styleTextUnderTheLoader = const TextStyle(
        fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.black),
    this.image,
    this.backgroundImage,
    this.loadingText = const Text(""),
    this.imageBackground,
    this.gradientBackground,
    this.useLoader = true,
    this.routeName,
  });

  factory CustomSplashScreen.timer(
          {@required int seconds,
          Color loaderColor,
          Color backgroundColor,
          double photoSize,
          Text loadingText,
          Image image,
          Route pageRoute,
          dynamic onClick,
          dynamic navigateAfterSeconds,
          Text title,
          TextStyle styleTextUnderTheLoader,
          Widget imageBackground,
          Gradient gradientBackground,
          bool useLoader,
          String routeName}) =>
      CustomSplashScreen(
        loaderColor: loaderColor,
        seconds: seconds,
        photoSize: photoSize,
        loadingText: loadingText,
        backgroundColor: backgroundColor,
        image: image,
        pageRoute: pageRoute,
        onClick: onClick,
        navigateAfterSeconds: navigateAfterSeconds,
        title: title,
        styleTextUnderTheLoader: styleTextUnderTheLoader,
        imageBackground: imageBackground,
        gradientBackground: gradientBackground,
        useLoader: useLoader,
        routeName: routeName,
      );

  factory CustomSplashScreen.network(
          {@required Future<dynamic> navigateAfterFuture,
          Color loaderColor,
          Color backgroundColor,
          double photoSize,
          double backgroundPhotoSize,
          Text loadingText,
          Image image,
          Route pageRoute,
          dynamic onClick,
          dynamic navigateAfterSeconds,
          Text title,
          TextStyle styleTextUnderTheLoader,
          Widget imageBackground,
          Gradient gradientBackground,
          bool useLoader,
          String routeName}) =>
      CustomSplashScreen(
        loaderColor: loaderColor,
        navigateAfterFuture: navigateAfterFuture,
        photoSize: photoSize,
        backgroundPhotoSize: backgroundPhotoSize,
        loadingText: loadingText,
        backgroundColor: backgroundColor,
        image: image,
        pageRoute: pageRoute,
        onClick: onClick,
        navigateAfterSeconds: navigateAfterSeconds,
        title: title,
        styleTextUnderTheLoader: styleTextUnderTheLoader,
        imageBackground: imageBackground,
        gradientBackground: gradientBackground,
        useLoader: useLoader,
        routeName: routeName,
      );

  @override
  _CustomSplashScreenState createState() => _CustomSplashScreenState();
}

class _CustomSplashScreenState extends State<CustomSplashScreen> {
  @override
  void initState() {
    super.initState();
    if (widget.routeName != null &&
        widget.routeName is String &&
        "${widget.routeName[0]}" != "/") {
      throw ArgumentError(
          "widget.routeName must be a String beginning with forward slash (/)");
    }
    if (widget.navigateAfterFuture == null) {
      Timer(Duration(seconds: widget.seconds), () {
        if (widget.navigateAfterSeconds is String) {
          // It's fairly safe to assume this is using the in-built material
          // named route component
          Navigator.of(context)
              .pushReplacementNamed(widget.navigateAfterSeconds);
        } else if (widget.navigateAfterSeconds is Widget) {
          Navigator.of(context).pushReplacement(widget.pageRoute != null
              ? widget.pageRoute
              : MaterialPageRoute(
                  settings: widget.routeName != null
                      ? RouteSettings(name: "${widget.routeName}")
                      : null,
                  builder: (BuildContext context) =>
                      widget.navigateAfterSeconds));
        } else {
          throw ArgumentError(
              'widget.navigateAfterSeconds must either be a String or Widget');
        }
      });
    } else {
      widget.navigateAfterFuture.then((navigateTo) {
        if (navigateTo is String) {
          // It's fairly safe to assume this is using the in-built material
          // named route component
          Navigator.of(context).pushReplacementNamed(navigateTo);
        } else if (navigateTo is Widget) {
          Navigator.of(context).pushReplacement(widget.pageRoute != null
              ? widget.pageRoute
              : MaterialPageRoute(
                  settings: widget.routeName != null
                      ? RouteSettings(name: "${widget.routeName}")
                      : null,
                  builder: (BuildContext context) => navigateTo));
        } else {
          throw ArgumentError(
              'widget.navigateAfterFuture must either be a String or Widget');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: app_language_rtl.$ ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: InkWell(
          onTap: widget.onClick,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                child: widget.imageBackground,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Hero(
                      tag: "backgroundImageInSplash",
                      child: Container(child: widget.backgroundImage),
                    ),
                    radius: widget.backgroundPhotoSize,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 120.0),
                    child: Container(
                        width: double.infinity,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 60.0),
                              child: CircleAvatar(
                                backgroundColor: Colors.transparent,
                                child: Hero(
                                  tag: "splashscreenImage",
                                  child: Container(child: widget.image),
                                ),
                                radius: widget.photoSize,
                              ),
                            ),
                            widget.title,
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                            ),
                            widget.loadingText
                          ],
                        )),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
