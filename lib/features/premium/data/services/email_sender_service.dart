import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';

class GmailService {
  String senderEmail = "joblinc.official@gmail.com";
  String senderPassword = "strcykhepbbuqtvv"; //Use an App Password

  GmailService({this.senderEmail="joblinc.official@gmail.com", this.senderPassword="strcykhepbbuqtvv"});

  /// Send an email via Gmail SMTP
  Future<bool> sendEmail({
    required String to,
    required String subject,
    required String body,
  }) async {
    final smtpServer = gmail(senderEmail, senderPassword);

    final message = Message()
      ..from = Address(senderEmail, "JobLinc")
      ..recipients.add(to)
      ..subject = subject
      ..html = "<p>$body</p>"; // Supports HTML

    try {
      await send(message, smtpServer);
      //print("Email sent successfully!");
      return true;
    } catch (e) {
      //print("Error sending email: $e");
      return false;
    }
  }
}
