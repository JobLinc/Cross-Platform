import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/ui/widgets/homePage/about.dart';

// Helper function to create a widget that initializes ScreenUtil
Widget createScreenUtilTestWidget(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(375, 812), // iPhone X design size
    minTextAdapt: true,
    splitScreenMode: true,
    builder: (_, __) => MaterialApp(
      home: Scaffold(
        body: child,
      ),
    ),
  );
}

void main() {
  testWidgets('CompanyHomeAbout displays company data correctly',
      (WidgetTester tester) async {
    // Initial company data
    final initialCompany = Company(
      id: '1',
      name: 'Test Company',
      profileUrl: 'test-company',
      industry: 'Technology',
      organizationSize: '11-50 employees',
      organizationType: 'Privately Held',
      website: 'https://testcompany.com',
      overview: 'This is a test company',
      isFollowing: false, // Add required parameter
    );

    // Build the widget with proper ScreenUtil initialization
    await tester.pumpWidget(
      createScreenUtilTestWidget(CompanyHomeAbout(company: initialCompany)),
    );

    // Verify initial data is displayed correctly
    expect(find.text('Website'), findsOneWidget);
    expect(find.text('https://testcompany.com'), findsOneWidget);
    expect(find.text('Industry'), findsOneWidget);
    expect(find.text('Technology'), findsOneWidget);
    expect(find.text('Company size'), findsOneWidget);
    expect(find.text('11-50 employees'), findsOneWidget);
    expect(find.text('Type'), findsOneWidget);
    expect(find.text('Privately Held'), findsOneWidget);

    // Create updated company data to simulate editing
    final updatedCompany = Company(
      id: '1',
      name: 'Test Company',
      profileUrl: 'test-company',
      industry: 'Finance',
      organizationSize: '51-200 employees',
      organizationType: 'Public Company',
      website: 'https://updatedcompany.com',
      overview: 'This is an updated test company',
      isFollowing: false, // Add required parameter
    );

    // Rebuild the widget with updated company data
    await tester.pumpWidget(
      createScreenUtilTestWidget(CompanyHomeAbout(company: updatedCompany)),
    );

    // Verify updated data is displayed correctly
    expect(find.text('Website'), findsOneWidget);
    expect(find.text('https://updatedcompany.com'), findsOneWidget);
    expect(find.text('Industry'), findsOneWidget);
    expect(find.text('Finance'), findsOneWidget);
    expect(find.text('Company size'), findsOneWidget);
    expect(find.text('51-200 employees'), findsOneWidget);
    expect(find.text('Type'), findsOneWidget);
    expect(find.text('Public Company'), findsOneWidget);
  });

  testWidgets('CompanyHomeAbout hides LinkedIn website',
      (WidgetTester tester) async {
    // Company with LinkedIn website
    final company = Company(
      id: '1',
      name: 'LinkedIn Company',
      profileUrl: 'linkedin-company',
      industry: 'Technology',
      organizationSize: '11-50 employees',
      organizationType: 'Privately Held',
      website: 'https://linkedin.com/company/test',
      overview: 'This is a test company',
      isFollowing: false, // Add required parameter
    );

    // Build the widget with proper ScreenUtil initialization
    await tester.pumpWidget(
      createScreenUtilTestWidget(CompanyHomeAbout(company: company)),
    );

    // Verify website field is not displayed for LinkedIn URLs
    expect(find.text('Website'), findsNothing);
    expect(find.text('https://linkedin.com/company/test'), findsNothing);

    // But other fields are still displayed
    expect(find.text('Industry'), findsOneWidget);
    expect(find.text('Technology'), findsOneWidget);
  });
}
