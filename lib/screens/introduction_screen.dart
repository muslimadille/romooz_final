import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:active_ecommerce_flutter/screens/main.dart';
import 'package:active_ecommerce_flutter/style_classes.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IntroductionSreen extends StatefulWidget {
  const IntroductionSreen({Key key}) : super(key: key);

  @override
  State<IntroductionSreen> createState() => _IntroductionSreenState();
}

Widget _buildFullscreenImage(String assetName) {
  return Image.asset(
    'assets/$assetName',
    fit: BoxFit.cover,
    height: double.infinity,
    width: double.infinity,
    alignment: Alignment.center,
  );
}

Widget _buildImage(String assetName, [double width = 350]) {
  return Image.asset(
    'assets/$assetName',
    width: width,
    fit: BoxFit.fitHeight,
  );
}

class _IntroductionSreenState extends State<IntroductionSreen> {
  final introKey = GlobalKey<IntroductionScreenState>();

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    void _onIntroEnd(context) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => Main()),
      );
    }

    return IntroductionScreen(
      key: introKey,
      globalBackgroundColor: Colors.white,
      // globalHeader: Align(
      //   alignment: Alignment.bottomCenter,
      //   child: SafeArea(
      //     child: Padding(
      //       padding: const EdgeInsets.only(top: 16, right: 16),
      //       child: _buildImage('black-logo.png', 100),
      //     ),
      //   ),
      // ),
      globalFooter: SizedBox(
        width: double.infinity,
        height: 60,
        child: PrimaryButton(
          color: MyTheme.purpel,
          reduis: 0.4,
          title: AppLocalizations.of(context).go_to_home,
          onTap: () {
            _onIntroEnd(context);
          },
        ),
      ),
      pages: [
        PageViewModel(
          bodyWidget: ChangeTextStyleLarge(
            title: 'Get your groccery now',
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
          title: "احصل على مقاضيك الان",
          image: _buildFullscreenImage("intro/img3.png"),
          decoration: pageDecoration.copyWith(
            contentMargin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
          reverse: true,
        ),
        PageViewModel(
          bodyWidget: ChangeTextStyleLarge(
            title: 'Explore our packages',
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
          title: "اكتشف باقتنا",
          image: _buildFullscreenImage("intro/img1.png"),
          decoration: pageDecoration.copyWith(
            contentMargin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
          reverse: true,
        ),
        PageViewModel(
          bodyWidget: ChangeTextStyleLarge(
            title: 'Select your location',
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
          title: "حدد موقعك",
          image: _buildFullscreenImage("intro/img4.png"),
          decoration: pageDecoration.copyWith(
            contentMargin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 3,
          ),
          reverse: true,
        ),
        PageViewModel(
          bodyWidget: ChangeTextStyleLarge(
            title: 'Fresh fruits and vegetables',
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w500,
          ),
          title: "فواكة و خضروات طازجة",
          image: _buildFullscreenImage("intro/img2.png"),
          decoration: pageDecoration.copyWith(
            contentMargin:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 25),
            fullScreen: true,
            bodyFlex: 2,
            imageFlex: 4,
          ),
          reverse: true,
        ),
      ],
      onDone: () => _onIntroEnd(context),
      //onSkip: () => _onIntroEnd(context), // You can override onSkip callback
      showSkipButton: false,
      skipOrBackFlex: 0,
      nextFlex: 0,
      showBackButton: true,
      //rtl: true, // Display as right-to-left
      back: const Icon(
        Icons.arrow_back,
        color: Color(0xFF553F86),
      ),
      skip: Text('${AppLocalizations.of(context).skip}',
          style: TextStyle(fontWeight: FontWeight.w600)),
      next: Icon(
        Icons.arrow_forward,
        color: MyTheme.purpel,
      ),
      done: Text('${AppLocalizations.of(context).club_point_screen_done}',
          style: TextStyle(
              fontWeight: FontWeight.w600, color: MyTheme.accent_color)),
      curve: Curves.fastLinearToSlowEaseIn,
      controlsMargin: const EdgeInsets.all(16),
      controlsPadding: kIsWeb
          ? const EdgeInsets.all(12.0)
          : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
      dotsDecorator: const DotsDecorator(
        size: Size(10.0, 10.0),
        color: Color(0xFFBDBDBD),
        activeSize: Size(22.0, 10.0),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(25.0)),
        ),
      ),
      dotsContainerDecorator: const ShapeDecoration(
        color: Colors.black87,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8.0)),
        ),
      ),
    );
  }
}
