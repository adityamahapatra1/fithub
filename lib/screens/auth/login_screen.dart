import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../dashboard/dashboard_screen.dart';
import '../../widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController(text: 'student@college.edu');
  final _passwordController = TextEditingController(text: 'password');

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Fitness Squad')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.fitness_center, size: 64, color: Colors.deepPurple),
            const SizedBox(height: 24),
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email', border: OutlineInputBorder())),
            const SizedBox(height: 12),
            TextField(controller: _passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
            const SizedBox(height: 24),
            CustomButton(
              label: 'Login',
              loading: auth.isLoading,
              onPressed: () async {
                final success = await context.read<AuthProvider>().login(_emailController.text, _passwordController.text);
                if (success && context.mounted) {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}