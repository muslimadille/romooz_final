import UIKit
import Flutter
import GoogleMaps
import OPPWAMobile
import FirebaseCore
import FirebaseMessaging

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    
    //flutter channel handeler
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
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
      if #available(iOS 10.0, *) {
        UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
      }
    GMSServices.provideAPIKey("AIzaSyApCEdqLS8_AlhwBaZIQ_wr0-h5QVKh9bg")
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    ////============firebase notifications=============================
    override func application(_ application: UIApplication,didRegisterForRemoteNotificationsWithDeviceToken deviceToken:Data){
        Messaging.messaging().apnsToken = deviceToken
        super.application(application, didRegisterForRemoteNotificationsWithDeviceToken: deviceToken)
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
        checkoutsettings.paymentBrands = ["VISA", "MADA","MASTER"]
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
    
    ///==================apple pay=======================
    
    private func getApplePayMethod(result:@escaping FlutterResult , call:FlutterMethodCall){
        let provider = OPPPaymentProvider (mode: OPPProviderMode.live)
        let checkoutSettings = OPPCheckoutSettings()
        let paymentRequest = OPPPaymentProvider.paymentRequest(withMerchantIdentifier: "merchant.com.romoozfruits.hyperpay.live", countryCode: "SA 966")
        let args=call.arguments as? Dictionary<String,Any>
        let checkoutId=(args?["checkoutId"] as? String)!
        paymentRequest.supportedNetworks =  [PKPaymentNetwork.visa,PKPaymentNetwork.masterCard]
        checkoutSettings.applePayPaymentRequest = paymentRequest
        let checkoutProvider = OPPCheckoutProvider(paymentProvider: provider, checkoutID: checkoutId, settings: checkoutSettings)
        
        checkoutProvider?.presentCheckout(withPaymentBrand: "APPLEPAY",
           loadingHandler: { (inProgress) in
            //result("loading")
        }, completionHandler: { (transaction, error) in
            if error != nil {
                result("error")
            } else {
                if transaction?.redirectURL != nil {
                    result("redirect")
                    // Shopper was redirected to the issuer web page.
                    // Request payment status when shopper returns to the app using transaction.resourcePath or just checkout id.
                } else {
                    result("success")
                    // Request payment status for the synchronous transaction from your server using transactionPath.resourcePath or just checkout id.
                }
            }
        }, cancelHandler: {
            result("cancele")
            // Executed if the shopper closes the payment page prematurely.
        })
        
    }
    
    
}


