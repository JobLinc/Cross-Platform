import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:joblinc/features/premium/ui/screens/premium_screen.dart';
import 'package:joblinc/features/premium/data/services/stripe_service.dart';
import 'package:joblinc/features/premium/ui/screens/plan_selection_screen.dart';
import 'package:dio/dio.dart';

// Mock StripeService
class MockStripeService extends Mock implements StripeService {}

void main() {
  late MockStripeService mockStripeService;
  
  setUp(() {
    mockStripeService = MockStripeService();
    // when(() => mockStripeService.processPayment()).thenAnswer((_) async {});
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
    testWidgets('displays PremiumScreen with Try Now button', (WidgetTester tester) async {
      await pumpPremiumScreen(tester);

      expect(find.text('Premium'), findsOneWidget);
      expect(find.text('Join the millions of LinkedIn members using Premium to get ahead.'), findsOneWidget);
      expect(find.byKey(const Key("premium_try_elevatedButton")), findsOneWidget);
    });

    testWidgets('opens PlanSelectionScreen when Try Now is tapped', (WidgetTester tester) async {
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
          builder: (_, __) => MaterialApp(  // Wrap in MaterialApp
            home: Scaffold(body: PlanSelectionScreen()),  // Wrap in Scaffold
          ),
        ),
      );
    }


    testWidgets('displays PlanSelectionScreen with plan options', (WidgetTester tester) async {
      //debugPrint('Starting displays PlanSelectionScree test');
      await pumpPlanSelectionScreen(tester);
      expect(find.text('Choose your billing cycle'), findsOneWidget);
      expect(find.text('USD 14.99/month'), findsOneWidget);
      expect(find.text('USD 10.00/month'), findsOneWidget);
      expect(find.byKey(const Key("planSelection_try_elevatedButton")), findsOneWidget);
      //debugPrint('completed displays PlanSelectionScree test');
    });
  });

  group('StripeService API Tests', () {
    test('calls createPaymentIntent and returns a client secret', () async {
      when(() => mockStripeService.createPaymentIntent(14.99, 'usd'))
          .thenAnswer((_) async => 'client_secret_123');

      final result = await mockStripeService.createPaymentIntent(14.99, 'usd');
      expect(result, 'client_secret_123');
    });

    test('calls makePayment and handles Stripe API interactions', () async {
      when(() => mockStripeService.makePayment(14.99)).thenAnswer((_) async {});
      await mockStripeService.makePayment(14.99);
      verify(() => mockStripeService.makePayment(14.99)).called(1);
    });

    test('handles createPaymentIntent API failure', () async {
      when(() => mockStripeService.createPaymentIntent(any(), any()))
          .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

      expect(() => mockStripeService.createPaymentIntent(14.99, 'usd'), throwsA(isA<DioException>()));
    });
  });
}
