import 'package:flutter/material.dart';
import 'package:joblinc/features/adminpanel/ui/widgets/map_chart.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapChart(),
    );
  }
}
