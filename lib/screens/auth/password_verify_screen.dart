import 'package:flutter/material.dart';
import '../../services/storage_service.dart';

/// 密码验证页面
class PasswordVerifyScreen extends StatefulWidget {
  const PasswordVerifyScreen({super.key});

  @override
  State<PasswordVerifyScreen> createState() => _PasswordVerifyScreenState();
}

class _PasswordVerifyScreenState extends State<PasswordVerifyScreen> {
  final _passwordController = TextEditingController();
  final _storageService = StorageService();
  
  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleVerify() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final isValid = await _storageService.verifyPassword(_passwordController.text);
      
      if (!mounted) return;

      if (isValid) {
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        setState(() {
          _errorMessage = '密码错误';
          _passwordController.clear();
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 400),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(
                Icons.lock_outline,
                size: 64,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 24),
              Text(
                '输入密码',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '解锁你的笔记',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                autofocus: true,
                onSubmitted: (_) => _handleVerify(),
                decoration: InputDecoration(
                  labelText: '密码',
                  border: const OutlineInputBorder(),
                  errorText: _errorMessage,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility : Icons.visibility_off),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _isLoading ? null : _handleVerify,
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('解锁'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
