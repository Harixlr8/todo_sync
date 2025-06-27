import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_with_firebase/utils/colors.dart';
import 'package:todo_with_firebase/view_model/loginview_model.dart';
import 'package:todo_with_firebase/widgets/customTextFormField.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

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
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors().primary.withOpacity(0.8),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.person_add_alt_1, color: Colors.white),
                              SizedBox(width: 8),
                              Text(
                                "Let's get started",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Join the Family!',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Create your new account',
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
                          controller: viewModel.displayNameController,
                          hintText: 'Username',
                          icon: Icons.person_outline,
                          validator: viewModel.validateUser,
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
                              child: ElevatedButton(
                                onPressed: () => viewModel.signUp(context),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors().primary,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 16,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                child: const Text('Sign Up'),
                              ),
                            ),
                        const SizedBox(height: 16),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Already a user? Login!!',
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
