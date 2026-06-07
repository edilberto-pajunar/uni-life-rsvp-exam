import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uni_life_rsvp_exam/core/constants/typography.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';
import 'package:uni_life_rsvp_exam/features/auth/presentation/pages/login_page.dart';
import 'package:uni_life_rsvp_exam/features/auth/providers/auth_provider.dart';
import 'package:uni_life_rsvp_exam/features/home/presentation/pages/home_page.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_clickable.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_field.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_scaffold.dart';

class SignUpPage extends ConsumerStatefulWidget {
  static const String routeName = 'sign-up-route';
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool _submitted = false;

  void _onSubmit() {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final fields = _formKey.currentState!.value;
      setState(() => _submitted = true);
      ref
          .read(authProvider.notifier)
          .signUp(
            name: fields['name'] as String,
            email: fields['email'] as String,
            password: fields['password'] as String,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(authProvider, (_, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(next.error.toString())));
        setState(() => _submitted = false);
      }
      if (next is AsyncData && _submitted) {
        context.goNamed(HomePage.routeName);
      }
    });

    final isLoading = ref.watch(authProvider) is AsyncLoading;

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
              disabled: isLoading,
              borderRadius: BorderRadius.circular(AppSizes.radiusLg),
              child: Container(
                height: AppSizes.xxxxl,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isLoading
                      ? AppColors.primary.withValues(alpha: 0.7)
                      : AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSizes.radiusLg),
                ),
                child: isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : Text(
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
