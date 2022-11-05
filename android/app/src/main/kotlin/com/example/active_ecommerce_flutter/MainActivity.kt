package com.romooz.app.customer

import android.content.Intent
import android.widget.Toast
import androidx.annotation.NonNull
import com.oppwa.mobile.connect.checkout.dialog.CheckoutActivity
import com.oppwa.mobile.connect.checkout.meta.CheckoutActivityResult
import com.oppwa.mobile.connect.checkout.meta.CheckoutSettings
import com.oppwa.mobile.connect.provider.Connect
import com.oppwa.mobile.connect.provider.Transaction
import com.oppwa.mobile.connect.provider.TransactionType
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {



    private val CHANNEL = "hyperPayChannel"
    val paymentBrands = hashSetOf("VISA", "MASTER","MADA","DIRECTDEBIT_SEPA")
    var checkoutSettings:CheckoutSettings? = null
    var _result: MethodChannel.Result? = null


    // Set shopper result URL
    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "getPaymentMethod") {
                val args: Map<String, Any> = call.arguments as Map<String, Any>
                _result=_result
                if (true) {
                    receivePayment(args["checkoutId"] as String)
                    // result.success(batteryLevel)
                } else {
                    result.error("UNAVAILABLE", "Battery level not available.", null)
                }

            } else {
                result.notImplemented()
            }

        }

    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)

        handleCheckoutResult(data as CheckoutActivityResult)
    }



    //===============================================================

    private  fun receivePayment(checkoutId:String ){
        checkoutSettings=CheckoutSettings(checkoutId, paymentBrands, Connect.ProviderMode.LIVE)
        checkoutSettings!!.shopperResultUrl = "companyname://result"
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

}
