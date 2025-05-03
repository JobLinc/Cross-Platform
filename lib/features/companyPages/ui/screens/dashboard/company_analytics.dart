import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:joblinc/core/helpers/auth_helpers/auth_service.dart';
import 'package:joblinc/core/theming/colors.dart';

import 'package:joblinc/core/di/dependency_injection.dart';
import 'package:joblinc/features/companypages/data/data/company.dart';
import 'package:joblinc/features/companypages/data/data/models/company_stats.dart';
import 'package:joblinc/features/companypages/data/data/repos/getmycompany_repo.dart';
import 'package:joblinc/features/companypages/data/data/services/getmycompany.dart';

class CompanyAnalytics extends StatelessWidget {
  final Company company;
  const CompanyAnalytics({super.key, required this.company});

  @override
  Widget build(BuildContext context) {
    AuthService authService = getIt<AuthService>();
    authService.refreshToken(companyId: company.id);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Company Analytics'),
        backgroundColor: ColorsManager.darkCrimsonRed,
      ),
      body: FutureBuilder<CompanyStats>(
        future: CompanyRepositoryImpl(
          CompanyApiService(getIt<Dio>()),
        ).getCompanyStats(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final stats = snapshot.data!;
          final totalApplicants = stats.totalApplicantsCount;
          final accepted = stats.acceptedApplicantsCount;
          final rejected = stats.rejectedApplicantsCount;
          final acceptedPercent = totalApplicants == 0
              ? 0
              : ((accepted / totalApplicants) * 100).toStringAsFixed(1);
          final rejectedPercent = totalApplicants == 0
              ? 0
              : ((rejected / totalApplicants) * 100).toStringAsFixed(1);

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _StatCard(
                  title: 'Total Job Postings',
                  value: stats.totalJobsCount.toString(),
                  icon: Icons.work_outline,
                  color: Colors.blue,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  title: 'Total Applicants',
                  value: totalApplicants.toString(),
                  icon: Icons.people_outline,
                  color: Colors.orange,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  title: 'Accepted Candidates',
                  value: '$accepted ($acceptedPercent%)',
                  icon: Icons.check_circle_outline,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                _StatCard(
                  title: 'Rejected Candidates',
                  value: '$rejected ($rejectedPercent%)',
                  icon: Icons.cancel_outlined,
                  color: Colors.red,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Icon(icon, color: color, size: 36),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        trailing: Text(
          value,
          style: TextStyle(
              fontSize: 20, color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
