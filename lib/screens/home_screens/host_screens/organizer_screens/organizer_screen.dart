import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/screens/home_screens/host_screens/party_details_host_screen.dart';
import 'package:flutter_tipsy/screens/home_screens/widgets_home/small_info_card.dart';
import 'package:sizer/sizer.dart';

// If your EventModel is in /viewmodels/event_model.dart, import accordingly:
import '../../../../utils/utils.dart';
import '../../../../viewmodels/current_user.dart';
import '../../../../viewmodels/event_model.dart';

class OrganizerScreen extends StatefulWidget {
  const OrganizerScreen({Key? key}) : super(key: key);

  @override
  State<OrganizerScreen> createState() => _OrganizerScreenState();
}

class _OrganizerScreenState extends State<OrganizerScreen> {
  bool showUpcoming = true;
  bool showPast = false;
  bool showSaved = false;

  /// A Future that returns the list of events from Firestore
  Future<List<EventModel>> _fetchEvents() async {
    final eventIds = CurrentUser().user?.eventIds;
    if (eventIds == null || eventIds.isEmpty) {
      // No events for this user
      return [];
    }

    // Query Firestore by document IDs
    final querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .where(FieldPath.documentId, whereIn: eventIds)
        .get();

    // Convert each document into an EventModel.
    // Make sure EventModel.fromMap expects a DocumentSnapshot or a Map.
    final events = querySnapshot.docs
        .map(
            (doc) => EventModel.fromMap(doc.data())) // <--- the same way you do
        .toList();
    print("asdas $events");
    return events;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FutureBuilder<List<EventModel>>(
        future: _fetchEvents(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Events Found'));
          }

          // All events for the user
          final allEvents = snapshot.data!;
          print(allEvents);
          // Filter them into categories. Adjust logic to your real fields.
          final upcomingEvents =
              allEvents.where((e) => e.type == "upcomingEvent").toList();
          final pastEvents =
              allEvents.where((e) => e.type == "pastEvent").toList();
          final savedEvents =
              allEvents.where((e) => e.type == "savedEvent").toList();

          // Build your UI
          return Column(
            children: [
              // Header or Title
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Organizer',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),

              // Upcoming Events
              SectionToggleButton(
                title: 'Upcoming Events',
                isActive: showUpcoming,
                onTap: () {
                  setState(() {
                    showUpcoming = !showUpcoming;
                  });
                },
              ),
              if (showUpcoming) ...[
                for (final event in upcomingEvents)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PartyDetailHostPage(
                            eventModel: event,
                          ),
                        ),
                      );
                    },
                    child: SmallInfoCard(
                      title: event.title,
                      subtitle:
                          "${event.acceptedGuests.length} / ${event.maxGuests}",
                      imageUrl: event.images[0],
                      detail1: event.isOpenParty == true ? "Open" : "Private",
                      detail2:
                          formatDateString1(event.date!.toLocal().toString()),
                      height: 15.h,
                    ),
                  ),
              ],

              // Past Events
              SectionToggleButton(
                title: 'Past Events',
                isActive: showPast,
                onTap: () {
                  setState(() {
                    showPast = !showPast;
                  });
                },
              ),
              if (showPast) ...[
                for (final event in pastEvents)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PartyDetailHostPage(
                            eventModel: event,
                          ),
                        ),
                      );
                    },
                    child: SmallInfoCard(
                      title: event.title,
                      subtitle:
                          "${event.acceptedGuests.length} / ${event.maxGuests}",
                      imageUrl: event.images[0],
                      detail1: event.isOpenParty == true ? "Open" : "Private",
                      detail2:
                          formatDateString1(event.date!.toLocal().toString()),
                      height: 15.h,
                    ),
                  ),
              ],

              // Saved Events
              SectionToggleButton(
                title: 'Saved Events',
                isActive: showSaved,
                onTap: () {
                  setState(() {
                    showSaved = !showSaved;
                  });
                },
              ),
              if (showSaved) ...[
                for (final event in savedEvents)
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PartyDetailHostPage(
                            eventModel: event,
                          ),
                        ),
                      );
                    },
                    child: SmallInfoCard(
                      title: event.title,
                      subtitle:
                          "${event.acceptedGuests.length} / ${event.maxGuests}",
                      imageUrl: event.images[0],
                      detail1: event.isOpenParty == true ? "Open" : "Private",
                      detail2:
                          formatDateString1(event.date!.toLocal().toString()),
                      height: 15.h,
                    ),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class SectionToggleButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const SectionToggleButton({
    Key? key,
    required this.title,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
        decoration: BoxDecoration(
          color: isActive ? Colors.grey.shade800 : Colors.grey.shade600,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Icon(
              isActive ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
