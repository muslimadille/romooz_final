import UIKit
import Flutter
import GoogleMaps
import OPPWAMobile


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
     // applePayButton.isEnabled = OPPPaymentProvider.deviceSupportsApplePay()
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let paymentChannel = FlutterMethodChannel(name: "hyperPayChannel",
      binaryMessenger: controller.binaryMessenger)

      paymentChannel.setMethodCallHandler ({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
          guard call.method == "getPaymentMethod" else {
          result(FlutterMethodNotImplemented)
          return
          }
          self.getPaymentMethod(result: result , call: call)
      })
      GeneratedPluginRegistrant.register(with: self)

    GMSServices.provideAPIKey("AIzaSyApCEdqLS8_AlhwBaZIQ_wr0-h5QVKh9bg")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    private func getPaymentMethod(result:@escaping FlutterResult , call:FlutterMethodCall){
        let provider = OPPPaymentProvider (mode: OPPProviderMode.live)
        let checkoutsettings=OPPCheckoutSettings()


        checkoutsettings.language="ar"
        // General colors of the checkout UI
        func getColorFromHex(rgbValue:UInt32)->UIColor{
           let red = CGFloat((rgbValue & 0xFF0000) >> 16)/255.0
           let green = CGFloat((rgbValue & 0xFF00) >> 8)/255.0
           let blue = CGFloat(rgbValue & 0xFF)/255.0

           return UIColor(red:red, green:green, blue:blue, alpha:1.0)
        }
        checkoutsettings.theme.primaryBackgroundColor = UIColor.white
        checkoutsettings.theme.primaryForegroundColor = UIColor.black
        checkoutsettings.theme.confirmationButtonColor = getColorFromHex(rgbValue:0xffc93246)
        checkoutsettings.theme.confirmationButtonTextColor = UIColor.white
        checkoutsettings.theme.errorColor = getColorFromHex(rgbValue:0xffc93246)
        checkoutsettings.theme.activityIndicatorSecondaryStyle = .gray;
        checkoutsettings.theme.separatorColor = UIColor.lightGray

        // Navigation bar customization
        checkoutsettings.theme.navigationBarTintColor = UIColor.white
        checkoutsettings.theme.navigationBarBackgroundColor = getColorFromHex(rgbValue:0xffc93246)

        // Payment brands list customization
        checkoutsettings.theme.cellHighlightedBackgroundColor = getColorFromHex(rgbValue:0xffc93246)
        checkoutsettings.theme.cellHighlightedTextColor = UIColor.white

        // Fonts customization
        checkoutsettings.theme.primaryFont = UIFont.systemFont(ofSize: 14.0)
        checkoutsettings.theme.secondaryFont = UIFont.systemFont(ofSize: 12.0)
        checkoutsettings.theme.confirmationButtonFont = UIFont.systemFont(ofSize: 15.0)
        checkoutsettings.theme.errorFont = UIFont.systemFont(ofSize: 12.0)

        // set available payment brands for your shop
        checkoutsettings.paymentBrands = ["VISA", "MADA",
        "MASTER","APPLE_PAY"]
        // Set shopper result URL
        checkoutsettings.shopperResultURL =
        "com.romooz.app.shoppingapp.payments://result"
        let args=call.arguments as? Dictionary<String,Any>
        let checkoutId=(args?["checkoutId"] as? String)!
        let checkoutProvider = OPPCheckoutProvider(paymentProvider: provider, checkoutID: checkoutId , settings: checkoutsettings)

        checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
        guard let transaction = transaction else {
        // Handle invalid transaction, check error
        result("100")
        return
        }
        if transaction.type == .synchronous {
        result("100")
        } else if transaction.type == .asynchronous {
        result(transaction.redirectURL?.absoluteString)
        } else {
        // Executed in case of failure of the transaction for any reason
        result("100")
        }
        }, cancelHandler: {
        // Executed if the shopper closes the payment page prematurely
        result("100")
        })
    }
}


