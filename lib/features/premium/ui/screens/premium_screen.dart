import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:joblinc/features/premium/payment_constants.dart';
import 'package:joblinc/features/premium/ui/screens/plan_selection_screen.dart';

class PremiumScreen extends StatefulWidget {
  const PremiumScreen({super.key});

  @override
  State<PremiumScreen> createState() => _PremiumScreenState();
}

class _PremiumScreenState extends State<PremiumScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:Text('Premium')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              children: [
                Text(
                  "Join the millions of LinkedIn members using Premium to get ahead.",
                  style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                  key: Key("premium_try_elevatedButton"),
                  onPressed: ()=> showPlanScreen(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                  ),
                  child: Text('Try now for 14.99 USD'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }


  void showPlanScreen(BuildContext context) async {
  await setup();
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (context)=>PlanSelectionScreen(),
    );
  }

  Future<void> setup() async{
    //WidgetsFlutterBinding.ensureInitialized();
    Stripe.publishableKey=stripePublishKey;
  }
}