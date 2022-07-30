import 'package:active_ecommerce_flutter/helpers/shared_value_helper.dart';
import 'package:active_ecommerce_flutter/my_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_indicator/loading_indicator.dart';

class ChangeTextStyleMainMajor extends StatelessWidget {
  final String title;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  final int maxLine;
  ChangeTextStyleMainMajor(
      {this.title,
      this.color,
      this.fontWeight,
      this.textAlign,
      this.textDecoration,
      this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      textAlign: textAlign,
      style: app_language.$ == 'ar'
          ? TextStyle(
              color: color,
              fontFamily: "Tajawal",
              fontSize: MyTheme.majorTextSize,
              fontWeight: fontWeight,
              decoration: textDecoration)
          : TextStyle(
              color: color,
              fontFamily: "SFPro",
              fontSize: MyTheme.majorTextSize,
              fontWeight: fontWeight,
              decoration: textDecoration,
            ),
    );
  }
}

class ChangeTextStyleMajor extends StatelessWidget {
  final String title;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  ChangeTextStyleMajor(
      {this.title,
      this.color,
      this.fontWeight,
      this.textAlign,
      this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        textAlign: textAlign,
        style: app_language.$ == 'ar'
            ? TextStyle(
                color: color,
                fontFamily: "Tajawal",
                fontSize: MyTheme.majorTextSize,
                fontWeight: fontWeight,
                decoration: textDecoration)
            : TextStyle(
                color: color,
                fontFamily: "SFPro",
                fontSize: MyTheme.majorTextSize,
                fontWeight: fontWeight,
                decoration: textDecoration,
              ));
  }
}

class ChangeTextStyleLarge extends StatelessWidget {
  final String title;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  ChangeTextStyleLarge(
      {this.title,
      this.color,
      this.fontWeight,
      this.textAlign,
      this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        textAlign: textAlign,
        style: app_language.$ == 'ar'
            ? TextStyle(
                color: color,
                fontFamily: "Tajawal",
                fontSize: MyTheme.largeTextSize,
                fontWeight: fontWeight,
                decoration: textDecoration)
            : TextStyle(
                color: color,
                fontFamily: "SFPro",
                fontSize: MyTheme.largeTextSize,
                fontWeight: fontWeight,
                decoration: textDecoration));
  }
}

class ChangeTextStyleMedium extends StatelessWidget {
  final String title;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  final int maxLine;
  ChangeTextStyleMedium(
      {this.title,
      this.color,
      this.fontWeight,
      this.textAlign,
      this.maxLine,
      this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        textAlign: textAlign,
        maxLines: maxLine,
        style: app_language.$ == 'ar'
            ? TextStyle(
                color: color,
                fontFamily: "Tajawal",
                fontSize: MyTheme.mediumTextSize,
                fontWeight: fontWeight,
                decoration: textDecoration)
            : TextStyle(
                color: color,
                fontFamily: "SFPro",
                fontSize: MyTheme.mediumTextSize,
                fontWeight: fontWeight,
                decoration: textDecoration));
  }
}

class ChangeTextStyleSmall extends StatelessWidget {
  final String title;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextDecoration textDecoration;

  ChangeTextStyleSmall(
      {this.title,
      this.color,
      this.fontWeight,
      this.textAlign,
      this.textDecoration});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        textAlign: textAlign,
        style: app_language.$ == 'ar'
            ? TextStyle(
                color: color,
                fontFamily: "Tajawal",
                fontSize: MyTheme.smallTextSize,
                fontWeight: fontWeight,
                decoration: textDecoration)
            : TextStyle(
                color: color,
                fontFamily: "SFPro",
                fontSize: MyTheme.smallTextSize,
                fontWeight: fontWeight,
                decoration: textDecoration));
  }
}

class ChangeTextStyleXSmall extends StatelessWidget {
  final String title;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  final int maxLine;
  ChangeTextStyleXSmall(
      {this.title,
      this.color,
      this.fontWeight,
      this.textAlign,
      this.textDecoration,
      this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        textAlign: textAlign,
        maxLines: this.maxLine,
        overflow: TextOverflow.ellipsis,
        style: app_language.$ == 'ar'
            ? TextStyle(
                color: color,
                fontFamily: "Tajawal",
                fontSize: MyTheme.smallTextSize,
                fontWeight: fontWeight,
                decoration: textDecoration)
            : TextStyle(
                color: color,
                fontFamily: "SFPro",
                fontSize: MyTheme.smallTextSize,
                fontWeight: fontWeight,
                decoration: textDecoration));
  }
}

class ChangeTextStyleTinySmall extends StatelessWidget {
  final String title;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final TextDecoration textDecoration;
  final int maxLine;
  ChangeTextStyleTinySmall(
      {this.title,
      this.color,
      this.fontWeight,
      this.textAlign,
      this.textDecoration,
      this.maxLine});

  @override
  Widget build(BuildContext context) {
    return Text(title,
        textAlign: textAlign,
        maxLines: this.maxLine,
        overflow: TextOverflow.ellipsis,
        style: app_language.$ == 'ar'
            ? TextStyle(
                color: color,
                fontFamily: "Tajawal",
                fontSize: MyTheme.smallTextSize,
                fontWeight: fontWeight,
                decoration: textDecoration)
            : TextStyle(
                color: color,
                fontFamily: "SFPro",
                fontSize: MyTheme.smallTextSize,
                fontWeight: fontWeight,
                decoration: textDecoration));
  }
}

// ignore: must_be_immutable
class StatusLine extends StatelessWidget {
  double thickness;
  Color color;
  StatusLine({this.thickness, this.color});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Divider(
        thickness: thickness,
        color: color,
      ),
    );
  }
}

class PrimaryButton extends StatefulWidget {
  const PrimaryButton(
      {@required this.title,
      this.titleColor,
      this.onTap,
      this.color,
      this.reduis,
      this.fontWeight});

  final String title;
  final Color titleColor;
  final Function onTap;
  final Color color;
  final FontWeight fontWeight;
  final double reduis;

  @override
  _PrimaryButtonState createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(widget.color),
        backgroundColor: MaterialStateProperty.all<Color>(widget.color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: widget.color),
          ),
        ),
      ),
      child: Container(
        child: Center(
          child: ChangeTextStyleMedium(
            title: widget.title,
            color:
                widget.titleColor == null ? MyTheme.white : widget.titleColor,
            fontWeight: widget.fontWeight == null
                ? FontWeight.normal
                : widget.fontWeight,
            textAlign: TextAlign.center,
          ),
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(widget.reduis == null ? 15 : widget.reduis),
          ),
        ),
      ),
    );
  }
}

class SecondaryButton extends StatefulWidget {
  const SecondaryButton({@required this.title, this.onTap, this.color});

  final String title;
  final Function onTap;
  final Color color;

  @override
  _SecondaryButtonState createState() => _SecondaryButtonState();
}

class _SecondaryButtonState extends State<SecondaryButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTap,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all<Color>(widget.color),
        backgroundColor: MaterialStateProperty.all<Color>(widget.color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
            side: BorderSide(color: widget.color),
          ),
        ),
      ),
      child: Container(
        child: Center(
          child: ChangeTextStyleMedium(
            title: widget.title,
            color: widget.color,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
        ),
        decoration: BoxDecoration(
          color: MyTheme.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(
              width: 2.0, color: widget.color, style: BorderStyle.solid),
        ),
      ),
    );
  }
}

class SecondaryButtonBorder extends StatefulWidget {
  const SecondaryButtonBorder({@required this.title, this.onTap, this.color});

  final String title;
  final Function onTap;
  final Color color;

  @override
  _SecondaryButtonBorderState createState() => _SecondaryButtonBorderState();
}

class _SecondaryButtonBorderState extends State<SecondaryButtonBorder> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        child: Center(
          child: ChangeTextStyleMedium(
            title: widget.title,
            color: widget.color,
            fontWeight: FontWeight.w400,
            textAlign: TextAlign.center,
          ),
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(width: 1.0, color: widget.color),
        ),
      ),
    );
  }
}

class SecondaryButtonWithIcon extends StatefulWidget {
  const SecondaryButtonWithIcon(
      {@required this.title, this.onTap, this.color, this.icon});

  final String title;
  final IconData icon;
  final Function onTap;
  final Color color;

  @override
  _SecondaryButtonWithIconState createState() =>
      _SecondaryButtonWithIconState();
}

class _SecondaryButtonWithIconState extends State<SecondaryButtonWithIcon> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              widget.icon,
              color: widget.color,
              size: 30,
            ),
            ChangeTextStyleLarge(
              title: widget.title,
              color: widget.color,
              fontWeight: FontWeight.w400,
              textAlign: TextAlign.center,
            ),
          ],
        ),
        decoration: BoxDecoration(
          color: MyTheme.white,
          borderRadius: BorderRadius.all(
            Radius.circular(5),
          ),
          border: Border.all(
              width: 2.0, color: widget.color, style: BorderStyle.solid),
        ),
      ),
    );
  }
}

class TwoButtonAction extends StatelessWidget {
  const TwoButtonAction(
      {this.leftBtnTitle,
      this.rightBtnTitle,
      this.leftBtnClick,
      this.rightBtnClick,
      this.btnColor});

  final String leftBtnTitle;
  final Function leftBtnClick;
  final String rightBtnTitle;
  final Function rightBtnClick;
  final Color btnColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: MyTheme.white,
      margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Container(
              child: SecondaryButton(
                title: rightBtnTitle,
                color: MyTheme.accent_color,
                onTap: rightBtnClick,
              ),
              height: 50,
            ),
          ),
          SizedBox(
            width: 15,
          ),
          Expanded(
            child: Container(
              child: PrimaryButton(
                  title: leftBtnTitle,
                  color: btnColor,
                  fontWeight: FontWeight.w500,
                  onTap: leftBtnClick),
              height: 50,
            ),
          ),
        ],
      ),
    );
  }
}

class SocialBotton extends StatelessWidget {
  const SocialBotton(
      {@required this.title,
      this.color,
      this.colorText,
      this.colorBorder,
      this.onTap,
      this.icon});

  final String title;
  final Function onTap;
  final Color color;
  final Color colorText;
  final Color colorBorder;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
        border: Border.all(
          color: colorBorder,
          width: 0.5,
        ),
      ),
      child: Container(
        width: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SvgPicture.asset(
              icon,
              width: 25,
              fit: BoxFit.fitWidth,
            ),
            SizedBox(
              width: 10,
            ),
            ChangeTextStyleMedium(
              fontWeight: FontWeight.w200,
              title: title,
              color: colorText,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ButtonWithIcon extends StatelessWidget {
  const ButtonWithIcon({this.title, this.icon, this.onTap});

  final String title;
  final String icon;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: <Widget>[
          SvgPicture.asset(
            icon,
            color: MyTheme.accent_color,
            width: 12,
          ),
          SizedBox(
            width: 5,
          ),
          ChangeTextStyleXSmall(
            title: title,
            color: MyTheme.accent_color,
            fontWeight: FontWeight.w400,
          ),
        ],
      ),
    );
  }
}

class CircleTabIndicator extends Decoration {
  final BoxPainter _painter;

  CircleTabIndicator({@required Color color, @required double radius})
      : _painter = _CirclePainter(color, radius);

  @override
  BoxPainter createBoxPainter([onChanged]) => _painter;
}

class _CirclePainter extends BoxPainter {
  final Paint _paint;
  final double radius;

  _CirclePainter(Color color, this.radius)
      : _paint = Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4.0
          ..color = MyTheme.accent_color;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    final Offset circleOffset =
        offset + Offset(cfg.size.width / 2, cfg.size.height - radius - 5);
    //canvas.drawCircle(circleOffset, radius, _paint);
//    canvas.drawRRect(
//      RRect.fromRectAndRadius(
//          Rect.fromLTWH(cfg.size.width / 2, cfg.size.height - radius - 5,
//             20,  10),
//          Radius.circular(15)),
//      _paint,
//    );
    canvas.drawLine(Offset(cfg.size.width / 2, 30), circleOffset, _paint);

//    canvas.drawRect(
//        new Rect.fromLTRB(
//            0.0, 0.0, cfg.size.width , cfg.size.height - radius - 5),
//        new Paint()..color = new Color(0xFF0099FF));
  }
}

class AddingPrimaryButton extends StatelessWidget {
  const AddingPrimaryButton({this.onTap, this.buttonTitle});

  final String buttonTitle;
  final Function onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Center(
        child: Container(
          child: ChangeTextStyleXSmall(
            title: buttonTitle,
            color: MyTheme.accent_color,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class CountryLang extends StatelessWidget {
  const CountryLang({
    @required String countryLangFlag,
    @required String countryLangTitle,
    @required bool choosencountryLang,
    @required Animation<double> countryLangAnimation,
  })  : _choosencountryLang = choosencountryLang,
        _countryLangFlag = countryLangFlag,
        _countryLangTitle = countryLangTitle,
        _countryLangAnimation = countryLangAnimation;

  final String _countryLangFlag;
  final String _countryLangTitle;
  final bool _choosencountryLang;
  final Animation<double> _countryLangAnimation;

  @override
  Widget build(BuildContext context) {
//    if(_choosencountryLang == "ar" || _choosencountryLang == "en"){
//
//    }
    return Container(
      padding: EdgeInsets.only(left: 30, top: 10, bottom: 8),
      child: Row(
        children: <Widget>[
          Image.asset(
            _countryLangFlag,
            width: 50,
          ),
          Container(
            child: ChangeTextStyleXSmall(
              title: _countryLangTitle,
              color: MyTheme.font_grey,
            ),
          ),
          new Spacer(),
          Visibility(
            visible: _choosencountryLang,
            child: Container(
              margin: EdgeInsets.only(right: _countryLangAnimation.value),
              child: Icon(
                Icons.done,
                color: MyTheme.accent_color,
                size: 35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore: non_constant_identifier_names
Container NotificationSwitchs() {
  return Container(
    child: Row(
      children: <Widget>[
        Expanded(
          child: ChangeTextStyleTinySmall(
            title:
                "For faster and more secure checkout, save your card details.",
            color: MyTheme.font_grey,
            fontWeight: FontWeight.normal,
            maxLine: 2,
          ),
        ),
        Switch(
          value: true,
          onChanged: (value) {},
          activeTrackColor: MyTheme.accent_color,
          activeColor: MyTheme.accent_color,
        ),
      ],
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
    ),
  );
}

class LoaderButton extends StatelessWidget {
  const LoaderButton({this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: color, borderRadius: BorderRadius.all(Radius.circular(50))),
      width: 45,
      height: 45,
      child: LoadingIndicator(
        indicatorType: Indicator.circleStrokeSpin,
        colors: [MyTheme.white],
      ),
    ));
  }
}

class HomeTitleSection extends StatelessWidget {
  const HomeTitleSection({@required this.title, this.onPressed, this.noSeeAll});

  final String title;
  final Function onPressed;
  final bool noSeeAll;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ChangeTextStyleLarge(
              title: title,
              color: MyTheme.font_grey,
              fontWeight: FontWeight.w600,
            ),
          ),
          Visibility(
            visible: noSeeAll,
            child: TextButton(
              onPressed: onPressed,
              child: ChangeTextStyleXSmall(
                title: "see-all",
                color: MyTheme.accent_color,
              ),
            ),
          )
        ],
      ),
    );
  }
}
