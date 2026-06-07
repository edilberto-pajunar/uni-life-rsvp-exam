import 'package:flutter/material.dart';
import 'package:uni_life_rsvp_exam/core/constants/constant.dart';
import 'package:uni_life_rsvp_exam/core/theme/app_sizes.dart';
import 'package:uni_life_rsvp_exam/features/events/presentation/widgets/event_card.dart';
import 'package:uni_life_rsvp_exam/presentation/atoms/app_scaffold.dart';

class HomePage extends StatelessWidget {
  static const String routeName = '/home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBar: AppBar(title: const Text('Home')),
      body: ListView.separated(
        itemBuilder: (context, index) {
          return EventCard(event: AppConstant.events[index]);
        },
        separatorBuilder: (_, _) => const SizedBox(height: AppSizes.md),
        itemCount: AppConstant.events.length,
      ),
    );
  }
}
