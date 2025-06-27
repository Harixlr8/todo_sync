import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase/utils/colors.dart';
import 'package:todo_with_firebase/view/signup_screen.dart';
import 'package:todo_with_firebase/view_model/loginview_model.dart';
import 'package:todo_with_firebase/widgets/customTextFormField.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LoginViewModel(),
      child: Scaffold(
        body: Consumer<LoginViewModel>(
          builder:
              (context, viewModel, _) => Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: viewModel.formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: AppColors().primary.withOpacity(0.8),
                          child: const Icon(
                            Icons.lock_outline,
                            size: 48,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Welcome Back',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Login to your account',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 30),
                        AppTextFormField(
                          controller: viewModel.emailController,
                          hintText: 'Email',
                          icon: Icons.email_outlined,
                          validator: viewModel.validateEmail,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),
                        AppTextFormField(
                          controller: viewModel.passwordController,
                          hintText: 'Password',
                          icon: Icons.lock_outline,
                          validator: viewModel.validatePassword,
                          obscureText: true,
                        ),
                        const SizedBox(height: 24),
                        viewModel.isLoading
                            ? const CupertinoActivityIndicator()
                            : SizedBox(
                              width: double.infinity,
                              child: ElevatedButton.icon(
                                onPressed: () => viewModel.login(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors().primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                icon: const Icon(Icons.login),
                                label: const Text('Login'),
                              ),
                            ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const SignUpScreen(),
                              ),
                            );
                          },
                          child: const Text(
                            'New User? SignUp!!',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
        ),
      ),
    );
  }
}
