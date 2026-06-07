import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_life_rsvp_exam/core/constants/typography.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';
import 'package:uni_life_rsvp_exam/features/auth/presentation/pages/login_page.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_clickable.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_field.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_scaffold.dart';

class SignUpPage extends StatefulWidget {
  static const String routeName = 'sign-up-route';
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormBuilderState>();

  void _onSubmit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      // TODO: handle sign up
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
              'Create Account',
              style: AppTypography.headlineL.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.xs),
            Text(
              'Join us and get started',
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
                    name: 'name',
                    hintText: 'John Doe',
                    label: 'Full Name',
                    isRequired: true,
                    textCapitalization: TextCapitalization.words,
                  ),
                  SizedBox(height: AppSizes.md),
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
                    hintText: 'Create a password',
                    label: 'Password',
                    obscureText: true,
                    showPasswordToggle: true,
                    isRequired: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSizes.xl),
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
                  'Sign Up',
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
                    const TextSpan(text: 'Already have an account? '),
                    WidgetSpan(
                      alignment: PlaceholderAlignment.middle,
                      child: AppClickable(
                        onPressed: () => context.goNamed(LoginPage.routeName),
                        showSplash: false,
                        child: Text(
                          'Log in',
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
