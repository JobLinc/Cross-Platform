import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:joblinc/features/premium/data/models/user_model.dart';
import 'package:joblinc/features/premium/data/services/email_sender_service.dart';
import 'package:joblinc/features/premium/payment_constants.dart';

class StripeService {
  final GmailService gmailService;

  StripeService(this.gmailService);

  static final StripeService instance = StripeService(GmailService());

  Future<void> makePayment(BuildContext context, double amount,
      VoidCallback onPremiumUpdated) async {
    try {
      Map<String, dynamic>? paymentIntent = await createPaymentIntent(amount, "usd");
      if (paymentIntent == null) return;

      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent["client_secret"],
          merchantDisplayName: "JobLinc",
        ),
      );

      await Stripe.instance.presentPaymentSheet();
      await handlePaymentAndSendEmail(context, paymentIntent["id"], mockMainUser.email, onPremiumUpdated);
    } catch (e) {
      //print("Error in makePayment: $e");
    }
  }

  Future<Map<String, dynamic>?> createPaymentIntent(
      double amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": (amount * 100).toInt(),
        "currency": currency
      };

      var response = await dio.post("https://api.stripe.com/v1/payment_intents",
          data: data,
          options:
              Options(contentType: Headers.formUrlEncodedContentType, headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          }));
      if (response.data != null) {
        //print (response.data);
        return response.data;
      }
      return null;
    } catch (e) {
      //print(e);
    }
    return null;
  }

  Future<void> handlePaymentAndSendEmail(
      BuildContext context,
      String paymentIntentID,
      String userEmail,
      VoidCallback onPremiumUpdated) async {
    try {
      mockMainUser.isPremiumUser = true;
      onPremiumUpdated();

      if (context.mounted) {
        Navigator.pop(context, true);
      }

      //print("Payment confirmed successfully!");
      await sendPaymentConfirmationEmail(paymentIntentID, userEmail);
    } catch (e) {
      //print("Error confirming payment: $e");
    }
  }

  Future<void> sendPaymentConfirmationEmail(
      String paymentIntentId, String recipientEmail) async {
    bool success = await gmailService.sendEmail(
      to: recipientEmail,
      subject: "Welcome to JobLinc!",
      body: "Your premium plan is now active. 🎉",
    );

    // if (success) {
    //   print("Email sent successfully!");
    // } else {
    //   print("Failed to send email.");
    // }
  }
}
