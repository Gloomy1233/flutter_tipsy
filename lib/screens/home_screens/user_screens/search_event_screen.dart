import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/services/firebase_call_events_service.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:sizer/sizer.dart';

import '../widgets_home/small_info_card.dart';
import '../widgets_home/sticky_header_sliver_app_bar.dart';

class SearchEventScreen extends StatefulWidget {
  const SearchEventScreen({super.key});

  @override
  State<SearchEventScreen> createState() => _SearchEventScreenState();
}

class _SearchEventScreenState extends State<SearchEventScreen> {
  double distance = 10.0;
  ValueNotifier<double> radiusNotifier = ValueNotifier(1000.0);
  Stream<List<GeoDocumentSnapshot<Map<String, dynamic>>>>? _userStream;
  @override
  void initState() {
    super.initState();
    _initializeStream();

    // Listen to changes in the radiusNotifier
    radiusNotifier.addListener(_onRadiusChanged);
  }

  void _onRadiusChanged() {
    // Re-initialize the stream when the radius changes

    _initializeStream();
  }

  Future<void> _initializeStream() async {
    final geoQueryService = EventService();

    // Initialize the stream for users within the radius
    // Initialize the stream for users within the radius
    print(radiusNotifier.value);
    setState(() {
      _userStream = geoQueryService.getEventsInRadius(
        37.7749,
        122.4194,
        radiusNotifier.value,
      );
    });
  }

  final List<Map<String, String>> upcomingParties = [
    {
      "title": "Beach Party",
      "subtitle": "Saturday, 5 PM",
      "imageUrl": "https://file.rendit.io/n/g8WQ25WlWn.png",
    },
    {
      "title": "Techno Rave",
      "subtitle": "Friday, 10 PM",
      "imageUrl": "https://file.rendit.io/n/YzzPLqLWgk.png",
    },
    {
      "title": "Techno Rave",
      "subtitle": "Friday, 10 PM",
      "imageUrl": "https://file.rendit.io/n/YzzPLqLWgk.png",
    },
    {
      "title": "Techno Rave",
      "subtitle": "Friday, 10 PM",
      "imageUrl": "https://file.rendit.io/n/YzzPLqLWgk.png",
    },
    // ... other parties
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Sizer(
        builder: (context, orientation, screenType) {
          return CustomScrollView(
            slivers: [
              // Current Time and Ongoing Parties
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      // Current Time Display
                      CurrentTimeDisplay(),
                      SizedBox(height: 2.h),
                      // Ongoing Parties Title
                      SectionTitle(title: "Ongoing Parties"),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              ),
              // Ongoing Parties Horizontal List
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 25.h,
                  child: OngoingPartiesSection(),
                ),
              ),
              // Spacing after Ongoing Parties
              SliverPadding(
                padding: EdgeInsets.symmetric(vertical: 2.h),
                sliver: SliverToBoxAdapter(child: SizedBox.shrink()),
              ),
              // Sticky Search Bar and Slider with Dynamic Content
              SliverPersistentHeader(
                pinned: true,
                delegate: SliverAppBarDelegate(
                  minHeight: 14.h, // Minimum height when fully collapsed
                  maxHeight: 18.h, // Maximum height when fully expanded
                  childBuilder: (
                    BuildContext context,
                    double shrinkOffset,
                    bool overlapsContent,
                    double minExtent,
                    double maxExtent,
                  ) {
                    // Calculate the proportion of shrinkage
                    double shrinkRatio = shrinkOffset / (maxExtent - minExtent);
                    shrinkRatio = shrinkRatio.clamp(0.0, 1.0);

                    return Container(
                      color: Colors.white,
                      padding: EdgeInsets.symmetric(horizontal: 4.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Search Bar
                          SizedBox(height: 2.h), // Adjusted for better spacing
                          TextField(
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.search),
                              hintText: "Search for parties...",
                              filled: true,
                              fillColor: Colors.grey[200],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(3.w),
                              ),
                            ),
                          ),
                          // Conditionally render the title and spacing
                          SizedBox(height: (2.h * (1 - shrinkRatio))),
                          if (shrinkRatio < 1.0) ...[
                            Opacity(
                              opacity: (1 - shrinkRatio),
                              child: Text(
                                "Filter by Distance",
                                style: TextStyle(
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(height: 1.h * (1 - shrinkRatio)),
                          ],
                          // The slider remains visible at all times
                          ValueListenableBuilder<double>(
                              valueListenable: radiusNotifier,
                              builder: (context, radiusValue, child) {
                                return FlutterSlider(
                                  values: [distance],
                                  max: 100,
                                  min: 0,
                                  handlerHeight: 2.h,
                                  handlerWidth: 3.h,
                                  trackBar: FlutterSliderTrackBar(
                                    activeTrackBarHeight: 1.h,
                                    inactiveTrackBarHeight: 1.h,
                                    activeTrackBar: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFFD4A5FF),
                                          Color(0xFFFFD59E)
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      borderRadius: BorderRadius.circular(1.w),
                                    ),
                                    inactiveTrackBar: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(1.w),
                                    ),
                                  ),
                                  tooltip: FlutterSliderTooltip(
                                    alwaysShowTooltip: false,
                                    positionOffset:
                                        FlutterSliderTooltipPositionOffset(
                                      top: -4.h,
                                    ),
                                    textStyle: TextStyle(
                                      fontSize: 10.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black,
                                    ),
                                    boxStyle: FlutterSliderTooltipBox(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(2.w),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black12,
                                            offset: Offset(0, 3),
                                            blurRadius: 6,
                                          ),
                                        ],
                                      ),
                                    ),
                                    format: (String value) => "$value km",
                                  ),
                                  handler: FlutterSliderHandler(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Color(0xFF3C3A5A),
                                    ),
                                    child: const SizedBox.shrink(),
                                  ),
                                  step: const FlutterSliderStep(step: 1),
                                  onDragCompleted:
                                      (handlerIndex, lowerValue, upperValue) {
                                    setState(() {
                                      radiusNotifier.value = lowerValue;
                                      distance = lowerValue;
                                    });
                                  },
                                );
                              })
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Upcoming Parties Title
              SliverPadding(
                padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SectionTitle(title: "Upcoming Parties"),
                      SizedBox(height: 1.h),
                    ],
                  ),
                ),
              ),
              // Upcoming Parties List
              SliverToBoxAdapter(
                child: StreamBuilder<
                    List<GeoDocumentSnapshot<Map<String, dynamic>>>>(
                  stream: _userStream,
                  builder: (context, geoSnapshot) {
                    if (geoSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (!geoSnapshot.hasData || geoSnapshot.data!.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text(
                          "No upcoming parties.",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      );
                    }

                    List<GeoDocumentSnapshot<Map<String, dynamic>>> geoDocs =
                        geoSnapshot.data!;

                    // Map the GeoDocuments to your Party data model
                    List<Party> parties = geoDocs.map((geoDoc) {
                      Map<String, dynamic> data =
                          geoDoc.documentSnapshot.data()!;
                      return Party.fromMap(data);
                    }).toList();
                    print("asdasdasdsa" + parties.toString());
                    return ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: parties.length,
                      itemBuilder: (context, index) {
                        final party = parties[index];
                        return SmallInfoCard(
                          title: party.title,
                          subtitle: party.subtitle,
                          imageUrl: party.imageUrl,
                          detail1: 'asdasd',
                          detail2: 'adsasdas',
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Party {
  final String title;
  final String subtitle;
  final String imageUrl;
  final String guests;
  final GeoPoint geopoint;
  final String geohash;

  Party({
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.guests,
    required this.geopoint,
    required this.geohash,
  });

  factory Party.fromMap(Map<String, dynamic> data) {
    // Safely extract the 'location' map
    final locationData = data['location'] as Map<String, dynamic>?;

    // Extract 'geohash' and 'geopoint' from 'location'
    final geohash =
        locationData != null ? locationData['geohash'] as String? ?? '' : '';
    final geopoint = locationData != null
        ? locationData['geopoint'] as GeoPoint? ?? GeoPoint(0, 0)
        : GeoPoint(0, 0);

    return Party(
      title: data['title'] as String? ?? '',
      subtitle: data['subtitle'] as String? ?? '',
      imageUrl: data['imageUrl'] as String? ?? '',
      guests: data['guests'] as String? ?? '',
      geohash: geohash,
      geopoint: geopoint,
    );
  }
}

// Widget to display the current time
class CurrentTimeDisplay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      "Current Time: ${TimeOfDay.now().format(context)}",
      style: TextStyle(fontSize: 12.sp),
    );
  }
}

// Widget for section titles
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({required this.title});
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.bold),
    );
  }
}

// Widget for the ongoing parties section
class OngoingPartiesSection extends StatelessWidget {
  final List<Map<String, String>> ongoingParties = [
    {
      "title": "Ongoing Party 1",
      "subtitle": "DJ Night at Club XYZ",
      "imageUrl": "https://file.rendit.io/n/A36fGa3nsC.png",
    },
    {
      "title": "Ongoing Party 2",
      "subtitle": "Live Music at Rooftop Bar",
      "imageUrl":
          "https://balsamiq.com/assets/learn/controls/scrollbars/uses-Long-page.png",
    },
    {
      "title": "Ongoing Party 2",
      "subtitle": "Live Music at Rooftop Bar",
      "imageUrl": "https://file.rendit.io/n/3Sz3FTq5fl.png",
    },
    {
      "title": "Ongoing Party 2",
      "subtitle": "Live Music at Rooftop Bar",
      "imageUrl":
          "https://global.discourse-cdn.com/brave/optimized/3X/3/9/39db17a092c56703fb99fb2d8767fc96a461d199_2_689x408.jpeg",
    },
    {
      "title": "Ongoing Party 2",
      "subtitle": "Live Music at Rooftop Bar",
      "imageUrl": "https://file.rendit.io/n/3Sz3FTq5fl.png",
    },
    // ... other parties
  ];
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300, // Set the height of the cards
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.4), // Snapping effect
        itemCount: ongoingParties.length,
        itemBuilder: (context, index) {
          final party = ongoingParties[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0), // Rounded corners
              child: Stack(
                children: [
                  // Background Image
                  Positioned.fill(
                    child: Image.network(
                      party["imageUrl"]!,
                      fit: BoxFit.cover, // Make the image cover the card
                    ),
                  ),
                  // Overlay with title and subtitle
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.black.withOpacity(0.0),
                          ],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                      ),
                    ),
                  ),
                  // Title and Subtitle
                  Positioned(
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          party["title"]!,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          party["subtitle"]!,
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
