import 'package:flutter/material.dart';
import 'package:joblinc/core/routing/routes.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  // Widget build(BuildContext context) {
  //   return SafeArea(
  //     child: Scaffold(
  //       body: Center(
  //           child: Column(
  //         children: [
  //           const Text('Onboarding Screen'),

  //           // Navigations for testing screens while working on the app (will be removed later)
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, Routes.loginScreen);
  //               },
  //               child: const Text('Login')),
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, Routes.signUpScreen);
  //               },
  //               child: const Text('Signup')),
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, Routes.homeScreen);
  //               },
  //               child: const Text('Home')),
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, Routes.profileScreen);
  //               },
  //               child: const Text('Profile')),
  //           ElevatedButton(
  //               onPressed: () {
  //                 Navigator.pushNamed(context, Routes.chatScreen);
  //               },
  //               child: const Text('Chat')),
  //         ],
  //       )),
  //     ),
  //   );
  // }
  Widget build(BuildContext context) {
    return ScreenUtilInit
    (
      designSize: Size(412,924),
      minTextAdapt: true,
      builder:(context, child) {
        return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        
     
        body:Center(
          child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(child: Image(image: AssetImage('images/JobLinc.jpg'),)),
               Text(
                      "Join a trusted community of 1B professionals",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.sp, // Responsive text size
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
              SizedBox(height:  MediaQuery.of(context).size.height/3),
          
            generalbutton(text_and_iconColor: Colors.black,context: context,text: "Continue with google", widgetcolor: Colors.transparent, icon: FontAwesomeIcons.g,onTap:(){ Navigator.pushNamed(context, Routes.loginScreen);}),
            SizedBox(height: MediaQuery.of(context).size.height/50),
            generalbutton(text_and_iconColor: Colors.black,context: context,text: "Sign in with email ", widgetcolor: Colors.transparent, icon: Icons.email,onTap: (){Navigator.pushNamed(context, Routes.loginScreen);}),
            SizedBox(height: MediaQuery.of(context).size.height/50),
            generalbutton(text_and_iconColor: Colors.black,context: context,text: "Sign-up", widgetcolor: Colors.transparent, icon: Icons.person_add,onTap:(){Navigator.pushNamed(context, Routes.signUpScreen);})
            
          ],
          
          ),
        ),

        backgroundColor: Colors.white,
      ),
    );
      }
    );
  }
}
Widget generalbutton({required String text,required Color widgetcolor,required IconData icon,required GestureTapCallback onTap ,required BuildContext context,required Color text_and_iconColor})
{
  return GestureDetector
  (
    onTap:onTap,
    child: Container
    (
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
      decoration:   BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.black, width: 1.5),
          color: widgetcolor
        ),
        width: 0.8.sw,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: text_and_iconColor), // Icon
          SizedBox(width:  MediaQuery.of(context).size.width/20), // Space between icon and text
         Text(
            text,
            style: TextStyle(color: text_and_iconColor, fontSize: 18.sp),
            textAlign: TextAlign.center,
         ),
        ],
      ),
    ),
    
  );
}