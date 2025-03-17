import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:joblinc/features/premium/payment_constants.dart';

class StripeService {
  StripeService._();
  static final StripeService instance =StripeService._();

  Future<void> makePayment(double amount) async{
    try{
      String? paymentIntentClientSecret= await createPaymentIntent(amount,"usd");
      if(paymentIntentClientSecret == null) {return;}

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret:paymentIntentClientSecret,
        merchantDisplayName: "JobLinc"
      ));
      await processPayment();
    }
    catch(e){
      print(e);
    }
  }

  Future<String?> createPaymentIntent(double amount,String currency) async{
    try{
      final Dio dio=Dio();
      Map<String,dynamic> data ={
        "amount":(amount*100).toInt(),
        "currency": currency
      };

      var response= await dio.post("https://api.stripe.com/v1/payment_intents",
        data:data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers:{
            "Authorization":"Bearer $stripeSecretKey",
            "Content-Type":'application/x-www-form-urlencoded'
          }
        )
      );
      if (response.data != null){
        print (response.data);
        return response.data["client_secret"];
      }
      return null;
    }
    catch(e){
      print(e);
    }
    return null;
  } 

  Future<void>processPayment() async{
    try{
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    }
    catch(e){
      print(e);
    }
  }
}