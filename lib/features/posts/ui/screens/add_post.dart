import 'package:flutter/material.dart';
import 'package:joblinc/core/widgets/universal_bottom_bar.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: UniversalBottomBar(),
    );
  }
}
