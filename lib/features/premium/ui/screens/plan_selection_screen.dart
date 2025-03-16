import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PlanSelectionScreen extends StatelessWidget {
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
                    borderRadius: BorderRadius.circular(10.r)
                  )
                ),
              ),
              Text(
                'Choose your billing cycle',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                ),
                SizedBox(height: 10.h),
                buildPlanOption("USD 14.99/month", "1 month free, then SAR 14.99 per month"),
                SizedBox(height: 10.h),
                buildPlanOption("USD 10.00/month", "Billed annually at SAR 119.99 (Save 33%)"),   
                Spacer(),
                ElevatedButton(
                onPressed: () => {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red[400],
                  foregroundColor: Colors.white,
                ),
                child: Text('Try 1 month for USD0'),
              ),
            ],
          ),
        );
      }
    );
  }   



  Widget buildPlanOption(String title, String subtitle){
    return ListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      leading: Radio(
        value: title,
        groupValue: title,
        onChanged: (_) {},
        fillColor: WidgetStateProperty.resolveWith((states){
          if (states.contains(WidgetState.selected)){
            return Colors.red[700];
          }
          return Colors.grey[400];
        }),
      ),
    );
  }

}


