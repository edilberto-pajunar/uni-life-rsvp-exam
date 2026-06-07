import 'package:uni_life_rsvp_exam/features/events/data/event.dart';
import 'package:uni_life_rsvp_exam/features/home/data/models/app_user.dart';

class AppConstant {
  static List<AppUser> users = [
    const AppUser(id: '1', name: 'John Doe', email: 'john.doe@example.com'),
    const AppUser(id: '2', name: 'Jane Doe', email: 'jane.doe@example.com'),
    const AppUser(id: '3', name: 'Jim Doe', email: 'jim.doe@example.com'),
    const AppUser(id: '4', name: 'Jill Doe', email: 'jill.doe@example.com'),
    const AppUser(id: '5', name: 'Jack Doe', email: 'jack.doe@example.com'),
  ];
  static List<Event> events = [
    Event(
      id: '1',
      title: 'Event 1',
      description: 'Description 1',
      location: 'Location 1',
      startTime: DateTime.now(),
      capacity: 100,
      rsvpCount: 0,
      isRsvped: false,
      attendees: [users[0], users[1], users[2], users[3], users[4]],
    ),
    Event(
      id: '2',
      title: 'Event 2',
      description: 'Description 2',
      location: 'Location 2',
      startTime: DateTime.now(),
      capacity: 100,
      rsvpCount: 0,
      isRsvped: false,
      attendees: [users[0], users[1], users[2], users[3], users[4]],
    ),
    Event(
      id: '3',
      title: 'Event 3',
      description: 'Description 3',
      location: 'Location 3',
      startTime: DateTime.now(),
      capacity: 100,
      rsvpCount: 0,
      isRsvped: false,
      attendees: [users[0], users[1], users[2], users[3], users[4]],
    ),
    Event(
      id: '4',
      title: 'Event 4',
      description: 'Description 4',
      location: 'Location 4',
      startTime: DateTime.now(),
      capacity: 100,
      rsvpCount: 0,
      isRsvped: false,
      attendees: [users[0], users[1], users[2], users[3], users[4]],
    ),
    Event(
      id: '5',
      title: 'Event 5',
      description: 'Description 5',
      location: 'Location 5',
      startTime: DateTime.now(),
      capacity: 100,
      rsvpCount: 0,
      isRsvped: false,
      attendees: [users[0], users[1], users[2], users[3], users[4]],
    ),
  ];
}
