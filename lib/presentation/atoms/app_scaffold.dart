import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_colors.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final Color? backgroundColor;
  final EdgeInsetsDirectional? padding;
  final PreferredSizeWidget? appBar;
  final bool resizeToAvoidBottomInset;
  final bool safeArea;
  final bool showLoading;

  const AppScaffold({
    super.key,
    required this.body,
    this.backgroundColor = AppColors.background,
    this.padding = AppSizes.defaultPadding,
    this.appBar,
    this.resizeToAvoidBottomInset = true,
    this.safeArea = true,
    this.showLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: backgroundColor,
        extendBody: true,
        appBar: appBar,
        body: SafeArea(
          top: safeArea,
          bottom: true,
          child: Padding(padding: padding ?? EdgeInsets.zero, child: body),
        ),
        resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      ),
    );
  }
}
