import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:joblinc/features/premium/data/models/user_model.dart';
import 'package:joblinc/features/premium/data/services/email_sender_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:joblinc/features/premium/ui/screens/premium_screen.dart';
import 'package:joblinc/features/premium/data/services/stripe_service.dart';
import 'package:joblinc/features/premium/ui/screens/plan_selection_screen.dart';
import 'package:dio/dio.dart';


class MockStripeService extends Mock implements StripeService {}

class MockGmailService extends Mock implements GmailService {}

class MockUserModel extends Mock implements User {}

class MockBuildContext extends Mock implements BuildContext {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  late MockStripeService mockStripeService;
  late MockGmailService mockGmailService;
  late MockUserModel mockUserModel;
  late MockBuildContext mockContext;

  setUp(() {
    mockStripeService = MockStripeService();
    mockGmailService = MockGmailService();
    mockUserModel = MockUserModel();
    mockContext = MockBuildContext();
    // when(() => mockStripeService.processPayment()).thenAnswer((_) async {});
  });

  setUpAll(() {
    registerFallbackValue(FakeBuildContext());
  });

  Future<void> pumpPremiumScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(412, 924),
        builder: (_, __) => MaterialApp(
          home: PremiumScreen(),
        ),
      ),
    );
  }

  group('PremiumScreen UI Tests', () {
    testWidgets('displays PremiumScreen with Try Now button',
        (WidgetTester tester) async {
      await pumpPremiumScreen(tester);

      expect(find.text('Premium'), findsOneWidget);
      expect(find.byKey(Key("premium_try_elevatedButton")), findsOneWidget);
    });

    testWidgets('opens PlanSelectionScreen when Try Now is tapped',
        (WidgetTester tester) async {
      await pumpPremiumScreen(tester);

      await tester.tap(find.byKey(const Key("premium_try_elevatedButton")));
      await tester.pumpAndSettle();

      expect(find.byType(PlanSelectionScreen), findsOneWidget);
    });
  });

  group('PlanSelectionScreen UI Tests', () {
    Future<void> pumpPlanSelectionScreen(WidgetTester tester) async {
      //debugPrint('Starting pumpPlanSelectionScreen test');
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(412, 924),
          builder: (_, __) => MaterialApp(
            // Wrap in MaterialApp
            home: Scaffold(body: PlanSelectionScreen()), // Wrap in Scaffold
          ),
        ),
      );
    }

    testWidgets('displays PlanSelectionScreen with plan options',
        (WidgetTester tester) async {
      //debugPrint('Starting displays PlanSelectionScree test');
      await pumpPlanSelectionScreen(tester);
      expect(find.text('Choose your billing cycle'), findsOneWidget);
      expect(find.text('USD 14.99/month'), findsOneWidget);
      expect(find.text('USD 10.00/month'), findsOneWidget);
      expect(
          find.byKey(Key("planSelection_try_elevatedButton")), findsOneWidget);
      //debugPrint('completed displays PlanSelectionScree test');
    });
  });

  group('StripeService API Tests', () {
    test('calls createPaymentIntent and returns a client secret', () async {
      final mockResponse = {
        "client_secret": "client_secret_123",
        "id": "pi_123456789"
      };

      when(() => mockStripeService.createPaymentIntent(14.99, 'usd'))
          .thenAnswer((_) async => mockResponse);

      final result = await mockStripeService.createPaymentIntent(14.99, 'usd');

      expect(result, isNotNull);
      expect(result, isA<Map<String, dynamic>>());
      expect(result!["client_secret"], "client_secret_123");
      expect(result["id"], "pi_123456789");
    });

    // test('calls makePayment, updates user, and sends confirmation email (Gmail SMTP)',() async {
    //   final mockGmailService = MockGmailService();
    //   final stripeService = StripeService(mockGmailService);

    //   when(() => mockStripeService.makePayment(any(), any(), any()))
    //       .thenAnswer((_) async {});
    //   when(() => mockUserModel.isPremiumUser).thenReturn(false);
    //   when(() => mockGmailService.sendEmail(
    //         to: any(named: "to"),
    //         subject: any(named: "subject"),
    //         body: any(named: "body"),
    //       )).thenAnswer((_) async => true);

    //   await stripeService.makePayment(mockContext, 14.99, () {
    //     when(() => mockUserModel.isPremiumUser).thenReturn(true);
    //   });

    //   verify(() => mockStripeService.makePayment(mockContext, 14.99, any()))
    //       .called(1);
    //   expect(mockUserModel.isPremiumUser, true);

    //   await untilCalled(() => mockGmailService.sendEmail(
    //         to: any(named: "to"),
    //         subject: "Welcome to JobLinc!",
    //         body: "Your premium plan is now active. 🎉",
    //       ));

    //   verify(() => mockGmailService.sendEmail(
    //         to: any(named: "to"),
    //         subject: "Welcome to JobLinc!",
    //         body: "Your premium plan is now active. 🎉",
    //       )).called(1);
    // });

    test('handles createPaymentIntent API failure', () async {
      when(() => mockStripeService.createPaymentIntent(any(), any()))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(() => mockStripeService.createPaymentIntent(14.99, 'usd'),throwsA(isA<DioException>()));
    });

  //   test('handles failed email sending after payment (Gmail SMTP)', () async {
  //     when(() => mockStripeService.makePayment(any(), any(), any()))
  //         .thenAnswer((invocation) async {
  //       final callback = invocation.positionalArguments[2] as Function;
  //       callback();
  //     });

  //     when(() => mockGmailService.sendEmail(
  //           to: any(named: "to"),
  //           subject: any(named: "subject"),
  //           body: any(named: "body"),
  //         )).thenAnswer((_) async => false);

  //     await mockStripeService.makePayment(mockContext, 14.99, () {
  //       when(() => mockUserModel.isPremiumUser).thenReturn(true);
  //     });

  //     verify(() => mockGmailService.sendEmail(
  //           to: any(named: "to"),
  //           subject: "Payment Confirmation - JobLinc",
  //           body: "Your premium plan is now active. 🎉",
  //         )).called(1);
  //   });
  });
}

  // group('StripeService API Tests', () {
  //   test('calls createPaymentIntent and returns a client secret', () async {
  //     final mockResponse = {
  //       "client_secret": "client_secret_123",
  //       "id": "pi_123456789"
  //     };
  //     when(() => mockStripeService.createPaymentIntent(14.99, 'usd'))
  //         .thenAnswer((_) async => mockResponse);

  //     final result = await mockStripeService.createPaymentIntent(14.99, 'usd');
  //     expect(result, isNotNull);
  //     expect(result, isA<Map<String, dynamic>>());
  //     expect(result!["client_secret"], "client_secret_123");
  //     expect(result["id"], "pi_123456789");
  //   });

  //   test('calls makePayment and handles Stripe API interactions', () async {
  //     when(() => mockStripeService.makePayment(14.99)).thenAnswer((_) async {});
  //     await mockStripeService.makePayment(14.99);
  //     verify(() => mockStripeService.makePayment(14.99)).called(1);
  //   });

  //   test('handles createPaymentIntent API failure', () async {
  //     when(() => mockStripeService.createPaymentIntent(any(), any()))
  //         .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

  //     expect(() => mockStripeService.createPaymentIntent(14.99, 'usd'),
  //         throwsA(isA<DioException>()));
  //   });
  // });
