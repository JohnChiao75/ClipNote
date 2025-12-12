import 'package:flutter/material.dart';

/// 主界面
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.settings_outlined),
          onPressed: () {
            Navigator.of(context).pushNamed('/settings');
          },
          tooltip: '设置',
        ),
        title: const Text('ClipNote'),
      ),
      body: const Center(
        child: Text(''),
      ),
    );
  }
}
