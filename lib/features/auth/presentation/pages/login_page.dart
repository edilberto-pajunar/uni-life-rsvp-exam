import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_life_rsvp_exam/core/constants/typography.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';
import 'package:uni_life_rsvp_exam/features/auth/presentation/pages/sign_up_page.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_clickable.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_field.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_scaffold.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = 'login-route';
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onSubmit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // TODO: handle login
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: AppScaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: AppSizes.xxl),
            Text(
              'Welcome back',
              style: AppTypography.headlineL.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Sign in to continue',
              style: AppTypography.bodyS.copyWith(
                color: AppColors.black.withValues(
                  alpha: AppSizes.opacityTextSecondary,
                ),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xxl),
            FormBuilder(
              key: _formKey,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AppField(
                    name: 'email',
                    hintText: 'you@example.com',
                    label: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    isRequired: true,
                    textCapitalization: TextCapitalization.none,
                  ),
                  SizedBox(height: AppSizes.md),
                  AppField(
                    name: 'password',
                    hintText: 'Enter your password',
                    label: 'Password',
                    obscureText: true,
                    showPasswordToggle: true,
                    isRequired: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.sm),
            // Align(
            //   alignment: Alignment.centerRight,
            //   child: AppClickable(
            //     onPressed: () {},
            //     borderRadius: BorderRadius.circular(AppSizes.radiusSm),
            //     showSplash: false,
            //     child: Padding(
            //       padding: const EdgeInsets.symmetric(
            //         vertical: AppSizes.xs,
            //         horizontal: AppSizes.xs,
            //       ),
            //       child: Text(
            //         'Forgot password?',
            //         style: AppTypography.bodyXS.copyWith(
            //           color: AppColors.primary,
            //           fontWeight: FontWeight.w600,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            const SizedBox(height: AppSizes.lg),
            AppClickable(
              onPressed: _onSubmit,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              child: Container(
                height: AppSizes.xxxxl,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: Text(
                  'Login',
                  style: AppTypography.buttonMedium.copyWith(
                    color: AppColors.white,
                  ),
                ),
              ),
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: AppSizes.md),
              child: RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: AppTypography.bodyS.copyWith(
                    color: AppColors.black.withValues(
                      alpha: AppSizes.opacityTextSecondary,
                    ),
                  ),
                  children: [
                    const TextSpan(text: "Don't have an account? "),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: AppClickable(
                        onPressed: () => context.goNamed(SignUpPage.routeName),
                        showSplash: false,
                        child: Text(
                          'Sign up',
                          style: AppTypography.bodyS.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
