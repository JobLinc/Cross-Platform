// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:joblinc/features/premium/data/services/email_sender_service.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:joblinc/features/premium/data/services/stripe_service.dart';
// import 'package:joblinc/features/premium/data/models/user_model.dart';

// class MockStripeService extends Mock implements StripeService {}
// class MockGmailService extends Mock implements GmailService {}
// class MockUserModel extends Mock implements User {}
// class MockBuildContext extends Mock implements BuildContext{}

// void main() {
//   late MockStripeService mockStripeService;
//   late MockGmailService mockGmailService;
//   late MockUserModel mockUserModel;
//   late MockBuildContext mockContext;

//   setUp(() {
//     mockStripeService = MockStripeService();
//     mockGmailService = MockGmailService();
//     mockUserModel = MockUserModel();
//     mockContext=MockBuildContext();
//   });

//   group('StripeService API Tests', () {
//     test('calls createPaymentIntent and returns a client secret', () async {
//       final mockResponse = {
//         "client_secret": "client_secret_123",
//         "id": "pi_123456789"
//       };

//       when(() => mockStripeService.createPaymentIntent(14.99, 'usd'))
//           .thenAnswer((_) async => mockResponse);

//       final result = await mockStripeService.createPaymentIntent(14.99, 'usd');

//       expect(result, isNotNull);
//       expect(result, isA<Map<String, dynamic>>());
//       expect(result!["client_secret"], "client_secret_123");
//       expect(result["id"], "pi_123456789");
//     });

//     test('calls makePayment, updates user, and sends confirmation email (Gmail SMTP)', () async {
//       when(() => mockStripeService.makePayment(any(), any(), any()))
//           .thenAnswer((_) async {});

//       when(() => mockUserModel.isPremiumUser).thenReturn(false);
//       when(() => mockGmailService.sendEmail(
//             to: any(named: "to"),
//             subject: any(named: "subject"),
//             body: any(named: "body"),
//           )).thenAnswer((_) async => true);

//       await mockStripeService.makePayment(mockContext,14.99, () {
//         mockUserModel.isPremiumUser = true;
//       });

//       verify(() => mockStripeService.makePayment(mockContext, 14.99, any())).called(1);
//       expect(mockUserModel.isPremiumUser, true);

//       verify(() => mockGmailService.sendEmail(
//             to: any(named: "to"),
//             subject: "Payment Confirmation - JobLinc",
//             body: "Your premium plan is now active. 🎉",
//           )).called(1);
//     });

//     test('handles createPaymentIntent API failure', () async {
//       when(() => mockStripeService.createPaymentIntent(any(), any()))
//           .thenThrow(DioException(requestOptions: RequestOptions(path: '')));

//       expect(
//           () => mockStripeService.createPaymentIntent(14.99, 'usd'),
//           throwsA(isA<DioException>())
//       );
//     });

//     test('handles failed email sending after payment (Gmail SMTP)', () async {
//       when(() => mockStripeService.makePayment(any(), any(), any()))
//           .thenAnswer((_) async {});

//       when(() => mockGmailService.sendEmail(
//             to: any(named: "to"),
//             subject: any(named: "subject"),
//             body: any(named: "body"),
//           )).thenAnswer((_) async => false);

//       await mockStripeService.makePayment(mockContext,14.99, () {});

//       verify(() => mockGmailService.sendEmail(
//             to: any(named: "to"),
//             subject: "Payment Confirmation - JobLinc",
//             body: "Your premium plan is now active. 🎉",
//           )).called(1);
//     });
//   });
// }
