import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:joblinc/features/premium/data/services/stripe_service.dart';
import 'package:joblinc/features/premium/payment_constants.dart';

class PlanSelectionScreen extends StatefulWidget {
  @override
  State<PlanSelectionScreen> createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  double? selectedPlan = 14.99;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        expand: false,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Center(
                  child: Container(
                      width: 50.w,
                      height: 5.h,
                      decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(10.r))),
                ),
                Text('Choose your billing cycle',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                SizedBox(height: 10.h),
                buildPlanOption(
                    "planSelection_Option1_radio", 
                    14.99,
                    "USD 14.99/month",
                    "Billed monthly USD 14.99 per month"
                    ),
                SizedBox(height: 10.h),
                buildPlanOption(
                    "payment_planSelectionOption2_radio",
                    119.99,
                    "USD 10.00/month",
                    "Billed annually at USD 119.99 (Save 33%)"
                    ),
                Spacer(),
                ElevatedButton(
                  key: Key("planSelection_try_elevatedButton"),
                  onPressed: () {
                    StripeService.instance.makePayment(selectedPlan!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red[400],
                    foregroundColor: Colors.white,
                  ),
                  child: Text(selectedPlan == 14.99
                      ? 'Try 1 month for 14.99 USD'
                      : 'Try 1 year for 119.99 USD'),
                ),
              ],
            ),
          );
        });
  }

  Widget buildPlanOption(
      String keyName, double value, String title, String subtitle) {
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Radio<double>(
        key: Key(keyName),
        value: value,
        groupValue: selectedPlan,
        onChanged: (double? newPlan) {
          setState(() {
            selectedPlan = newPlan;
          });
        },
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.red[700];
          }
          return Colors.grey[400];
        }),
      ),
    );
  }
}
