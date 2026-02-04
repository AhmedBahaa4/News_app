import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/core/utils/route/app_routes.dart';
import 'package:news_app/core/utils/theme/app_colors.dart';
import 'package:news_app/features/auth/cubit/auth_cubit.dart';
import 'package:news_app/features/auth/cubit/password_cubit.dart';
import 'package:news_app/features/auth/views/widgets/label_with_text_field.dart';
import 'package:news_app/features/auth/views/widgets/main_button.dart';
import 'package:news_app/features/auth/views/widgets/social_media_buttom.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final authCubit = context.read<AuthCubit>();

    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        // Email/Password Register Success
        if (state is AuthDone) {
          // Clear fields
          _usernameController.clear();
          _emailController.clear();
          _passwordController.clear();
          _formKey.currentState?.reset();

          if (!context.mounted) {
            return;
          }
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (_) => false,
          );
        }

        // Email/Password Register Error
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }

        // Google Auth Success
        if (state is GoogleAuthDone || state is FacebookAuthDone) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            AppRoutes.home,
            (_) => false,
          );
        }

   if (state is GoogleAuthError) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(state.message)),
  );
} else if (state is FacebookAuthError) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(state.message)),
  );
}

      },
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Create Account',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Text(
                      'Start your journey with us',
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(color: AppColors.grey),
                    ),
                    SizedBox(height: size.height * 0.03),

                    /// Username
                    LabelWithTextField(
                      label: 'Username',
                      controller: _usernameController,
                      prefixIcon: Icons.person_outline,
                      hintText: 'Enter your username',
                      obsecureText: false,
                    ),

                    /// Email
                    LabelWithTextField(
                      label: 'Email',
                      controller: _emailController,
                      prefixIcon: Icons.email_outlined,
                      hintText: 'Enter your email',
                      obsecureText: false,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(height: size.height * 0.02),

                    /// Password with visibility toggle
                    BlocBuilder<PasswordCubit, PasswordState>(
                      builder: (context, state) {
                        final isVisible = state is PasswordVisibilityChanged
                            ? state.isVisible
                            : false;

                        return LabelWithTextField(
                          label: 'Password',
                          controller: _passwordController,
                          prefixIcon: Icons.lock_outline,
                          hintText: 'Enter your password',
                          obsecureText: !isVisible,
                          suffixIcon: IconButton(
                            icon: Icon(
                              isVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              context
                                  .read<PasswordCubit>()
                                  .toggleVisibility();
                            },
                          ),
                        );
                      },
                    ),
                    SizedBox(height: size.height * 0.03),

                    /// Create Account Button
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is AuthLoading;
                        return MainButton(
                          text: 'Create Account',
                          isLoading: isLoading,
                          onTap: isLoading
                              ? null
                              : () {
                                  if (_formKey.currentState!.validate()) {
                                    authCubit.registerWithEmailAndPassword(
                                      _emailController.text.trim(),
                                      _passwordController.text,
                                      _usernameController.text.trim(),
                                    );
                                  }
                                },
                        );
                      },
                    ),
                    SizedBox(height: size.height * 0.01),

                    /// Already have account?
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Already have an account? Login',
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge
                              ?.copyWith(color: AppColors.blue),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    Center(
                      child: Text(
                        'Or using other methods',
                        style: Theme.of(context)
                            .textTheme
                            .labelLarge
                            ?.copyWith(color: AppColors.grey),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),

                    /// Google
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is GoogleAuthenticating;
                        return SocialMediaBottom(
                          imgurl:
                              'https://t4.ftcdn.net/jpg/03/91/79/25/360_F_391792593_BYfEk8FhvfNvXC5ERCw166qRFb8mYWya.jpg',
                          text: 'Google',
                          isLoading: isLoading,
                          onTap: () async {
                            await authCubit.authWithGoogle();
                          },
                        );
                      },
                    ),
                    SizedBox(height: size.height * 0.02),

                    /// Facebook
                    BlocBuilder<AuthCubit, AuthState>(
                      builder: (context, state) {
                        final isLoading = state is FacebookAuthenticating;
                        return SocialMediaBottom(
                          imgurl:
                              'https://upload.wikimedia.org/wikipedia/commons/0/05/Facebook_Logo_%282019%29.png',
                          text: 'Facebook',
                          isLoading: isLoading,
                          onTap: () async {
                            await authCubit.authWithFacebook();
                          },
                        );
                      },
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
