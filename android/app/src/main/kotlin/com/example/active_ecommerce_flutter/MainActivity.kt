package com.romooz.app.customer

import android.content.Intent
import android.os.Parcel
import android.widget.Toast
import androidx.annotation.NonNull
import com.oppwa.mobile.connect.checkout.dialog.CheckoutActivity
import com.oppwa.mobile.connect.checkout.meta.CheckoutActivityResult
import com.oppwa.mobile.connect.checkout.meta.CheckoutSettings
import com.oppwa.mobile.connect.payment.PaymentParams
import com.oppwa.mobile.connect.payment.card.CardPaymentParams
import com.oppwa.mobile.connect.provider.Connect
import com.oppwa.mobile.connect.provider.Transaction
import com.oppwa.mobile.connect.provider.TransactionType
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {

/**
 * use custum ui steps to handle payment cycle by send your data from flutter engin
1- Preparing checkout (configure with amount, currency and other information),
2-Collecting shopper payment details,
4-Creating and submitting transaction,
5-Requesting payment result.
* */

    private val CHANNEL = "hyperPayChannel"
    val paymentBrands = hashSetOf("VISA", "MASTER","MADA")
    var checkoutSettings:CheckoutSettings? = null
    var _result: MethodChannel.Result? = null
    var paymentParams: PaymentParams?=null
    private var shopperResultUrl: String = ""



    // config flutter engin
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        shopperResultUrl = this.packageName.replace("_", "")
        shopperResultUrl += ".payments"

        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            val args: Map<String, Any> = call.arguments as Map<String, Any>
            _result=result
            when (call.method){
                "getPaymentMethod"->{
                    receivePayment(args["checkoutId"] as String)
                }
                "setCardParams"->{
                   var params=CardPaymentParams(
                       args["checkoutId"] as String,
                       args["brand"] as String,
                       args["number"] as String,
                       args["holder"] as String,
                       args["expiryMonth"] as String,
                       args["expiryYear"] as String,
                       args["cvv"] as String
                   )
                    setCardParams(params)

                }
                else->{
                    result.notImplemented()
                }
            }

        }

    }
    fun setCardParams(cardPaymentParams:CardPaymentParams){
        paymentParams=cardPaymentParams

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        if(resultCode!=null){
            //handleCheckoutResult(resultCode)
            _result!!.success("${resultCode}")
        }else{
            _result?.notImplemented()
        }

    }



    //===============================================================
//1- Preparing checkout (configure with amount, currency and other information)



    private  fun receivePayment(checkoutId:String ){
        shopperResultUrl = this.packageName.replace("_", "")
        shopperResultUrl += ".payments"
        checkoutSettings=CheckoutSettings(checkoutId, paymentBrands, Connect.ProviderMode.LIVE)
        checkoutSettings!!.setLocale("ar_AR")
        checkoutSettings!!.shopperResultUrl = "$shopperResultUrl://result"
        intent = checkoutSettings!!.createCheckoutActivityIntent(this)
        startActivityForResult(intent, CheckoutActivity.REQUEST_CODE_CHECKOUT)
    }




    private fun handleCheckoutResult(result: CheckoutActivityResult) {
        if (result.isCanceled) {
            Toast.makeText(this,"REQUEST HAS BEEN CANCELED",Toast.LENGTH_LONG).show()
            _result!!.success("canceled")
            return
        }

        if (result.isErrored) {
            Toast.makeText(this,"REQUEST HAS AN ERROR",Toast.LENGTH_LONG).show()
            _result!!.success("error")
            return
        }

        val transaction: Transaction? = result.transaction
        _result!!.success("success")

        val resourcePath = result.resourcePath

        if (transaction != null) {
            if (transaction.transactionType === TransactionType.SYNC) {
                // request payment status
            } else {
                // wait for the asynchronous transaction callback in the onNewIntent()
            }
        }
    }
    fun isValidCardNum(cardNum:String):Boolean{
        if (!CardPaymentParams.isNumberValid("4200 0000 0000 0000")) {
           return false
        }
        return true
    }



}
