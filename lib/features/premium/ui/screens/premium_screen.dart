import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/features/premium/data/models/user_model.dart';
import 'package:joblinc/features/premium/payment_constants.dart';
import 'package:joblinc/features/premium/ui/screens/plan_selection_screen.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  @override
  void initState() {
    super.initState();
    Stripe.publishableKey = stripePublishKey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Premium')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: mockMainUser.isPremiumUser
                ? buildPremiumAdvantages()
                : buildTryPremium(),
          ),
        ],
      ),
    );
  }

  Widget buildTryPremium() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Join the millions of professionals using Premium to get ahead.",
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20.h),
        ElevatedButton(
          key: Key("premium_try_elevatedButton"),
          onPressed: () => showPlanScreen(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red[400],
            foregroundColor: Colors.white,
          ),
          child: Text('Try now for 14.99 USD'),
        ),
      ],
    );
  }

  Widget buildPremiumAdvantages() {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ShaderMask(
              shaderCallback: (bounds) => LinearGradient(
                colors: [Colors.red, Colors.orange],
              ).createShader(bounds),
              child: Text(
                "You're a Premium User! 🎉",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // This will be masked by the gradient
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          buildAdvantageItem(Icons.trending_up, "Stand out in job searches"),
          buildAdvantageItem(Icons.insights, "In-depth profile insights"),
          buildAdvantageItem(Icons.school, "Access to premium courses"),
          buildAdvantageItem(Icons.lock_open, "Unlimited profile views"),
        ],
      ),
    );
  }

  Widget buildAdvantageItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(6.w),
            decoration: BoxDecoration(
              color: Colors.green[100],
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.green[700], size: 24.sp),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showPlanScreen(BuildContext context) async {
    bool? result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => PlanSelectionScreen(),
    );

    if (result == true) {
      setState(() {});
    }
  }
}
