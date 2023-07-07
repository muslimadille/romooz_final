import UIKit
import Flutter
import GoogleMaps
import OPPWAMobile
import FirebaseCore
import FirebaseMessaging
import SafariServices


@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate ,OPPCheckoutProviderDelegate,SFSafariViewControllerDelegate,PKPaymentAuthorizationViewControllerDelegate{
    var checkoutid:String = "";
    var total:String = "";
    var subtotal:String = "";
    var discount:String = "";
    var taxs:String = "";
    var shipping:String = "";



    var flutterResult:FlutterResult?
    var provider = OPPPaymentProvider(mode: OPPProviderMode.live)
    var transaction: OPPTransaction?




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
          guard call.method == "startApplePay" else {
          result(FlutterMethodNotImplemented)
          return
          }
          self.startApplePay(flutterResult: result , call: call)
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
        checkoutsettings.paymentBrands = ["MADA"]
        // Set shopper result URL
        checkoutsettings.shopperResultURL =
        "com.romooz.romoozfruitsapp.payments://result"
        let args=call.arguments as? Dictionary<String,Any>
        let checkoutid=(args?["checkoutId"] as? String)!
        let checkoutProvider = OPPCheckoutProvider(paymentProvider: provider, checkoutID:checkoutid , settings: checkoutsettings)

        checkoutProvider?.presentCheckout(forSubmittingTransactionCompletionHandler: { (transaction, error) in
        guard let transaction = transaction else {
        // Handle invalid transaction, check error
        result("Handle invalid transaction, check error")
        return
        }
        if transaction.type == .synchronous {
            result(transaction.resourcePath)
            return

        } else if transaction.type == .asynchronous {
                result(transaction.redirectURL?.absoluteString)
            return
                    
        } else {
        // Executed in case of failure of the transaction for any reason
        result("Executed in case of failure of the transaction for any reason")
            return
        }
        }, cancelHandler: {
        // Executed if the shopper closes the payment page prematurely
        result("Executed if the shopper closes the payment page prematurely")
        })
    }
    
    ///==================apple pay=======================
    
        private func startApplePay(flutterResult:@escaping FlutterResult , call:FlutterMethodCall) {
            let checkoutSettings = OPPCheckoutSettings()
            checkoutSettings.paymentBrands = ["APPLEPAY"]
            checkoutSettings.shopperResultURL = "com.romooz.romoozfruitsapp.payments://result"

            
            let args=call.arguments as? Dictionary<String,Any>

            self.flutterResult=flutterResult
            self.checkoutid=(args?["checkoutId"] as? String)!
            self.total=(args?["total"] as? String)!
            self.subtotal=(args?["subtotal"] as? String)!
            self.discount=(args?["discount"] as? String)!
            self.taxs=(args?["tax"] as? String)!
            self.shipping=(args?["shipping"] as? String)!
            
            let provider = OPPPaymentProvider (mode: OPPProviderMode.test)
            OPPPaymentProvider.deviceSupportsApplePay()

        let request = PKPaymentRequest() // Create the PKPaymentRequest object
        // Configure the request as per your requirements
        request.merchantIdentifier = "merchant.com.romooz.romoozfruitsapp.live"
        request.countryCode = "SA"
        request.currencyCode = "SAR"
            request.merchantCapabilities = [.capability3DS, .capabilityEMV, .capabilityCredit,.capabilityDebit]
        request.requiredShippingAddressFields = []
            request.requiredBillingContactFields=[]
            request.requiredShippingContactFields=[]
        if #available(iOS 12.1.1, *) {
            request.supportedNetworks = [ PKPaymentNetwork.mada,PKPaymentNetwork.visa,
                                                 PKPaymentNetwork.masterCard ,PKPaymentNetwork.interac, PKPaymentNetwork.discover, PKPaymentNetwork.amex]
        } else {
            // Fallback on earlier versions
            request.supportedNetworks = [ PKPaymentNetwork.visa,
                                          PKPaymentNetwork.masterCard ,PKPaymentNetwork.interac, PKPaymentNetwork.discover, PKPaymentNetwork.amex]
        }
            
            let discount = PKPaymentSummaryItem(label: "الخصم", amount: NSDecimalNumber(string: self.discount))
            let shipping = PKPaymentSummaryItem(label: "الشحن", amount: NSDecimalNumber(string: self.shipping))
            let subTotal =  PKPaymentSummaryItem(label: "المجموع الفرعي", amount: NSDecimalNumber(string: self.subtotal))

            let total = PKPaymentSummaryItem(label: "Romooz", amount: NSDecimalNumber(string: self.total))
            let tax = PKPaymentSummaryItem(label: "الضريبة", amount:NSDecimalNumber(string: self.taxs))
                       
            request.paymentSummaryItems = [subTotal,shipping,tax,discount,total]

            if OPPPaymentProvider.canSubmitPaymentRequest(request) {
                                      if let vc = PKPaymentAuthorizationViewController(paymentRequest: request) as PKPaymentAuthorizationViewController? {
                                          vc.delegate = self
                                         self.window?.rootViewController?.present(vc, animated: true, completion: nil)
                                      } else {
                                          self.flutterResult?("Apple Pay not supported.")                                      }
                                  }
       
      }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, completion: @escaping (PKPaymentAuthorizationStatus) -> Void) {

        
        if let params = try? OPPApplePayPaymentParams(checkoutID: self.checkoutid, tokenData: payment.token.paymentData) as OPPApplePayPaymentParams? {
                
            params.shopperResultURL="com.romooz.romoozfruitsapp.payments://result"
    
                   self.provider.submitTransaction(OPPTransaction(paymentParams: params), completionHandler: { (transaction, error) in
                       if (error != nil) {
                           self.flutterResult?(error)
                           
                                            } else {
                           // Send request to your server to obtain transaction status.
                                                
                           completion(.success)
                           self.flutterResult?("DONE")

      
                       }
                   })
               }
           }
      
       func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
      }
    
    
    

}


