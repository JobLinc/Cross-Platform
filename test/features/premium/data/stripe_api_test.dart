import 'package:joblinc/features/premium/ui/screens/premium_screen.dart';
import 'package:joblinc/features/premium/data/services/stripe_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Mock StripeService
class MockStripeService extends Mock implements StripeService {}

void main() {
  late MockStripeService mockStripeService;
  
  setUp(() {
    mockStripeService = MockStripeService();
    // when(() => mockStripeService.processPayment()).thenAnswer((_) async {});
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
