import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';
import 'package:sizer/sizer.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  double distance = 10.0;

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
                  minHeight: 15.h, // Minimum height when fully collapsed
                  maxHeight: 20.h, // Maximum height when fully expanded
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
                          FlutterSlider(
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
                                  borderRadius: BorderRadius.circular(2.w),
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
                            onDragging: (handlerIndex, lowerValue, upperValue) {
                              setState(() {
                                distance = lowerValue;
                              });
                            },
                          ),
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
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final party = upcomingParties[index];
                    return SmallInfoCard(
                      title: party["title"]!,
                      subtitle: party["subtitle"]!,
                      imageUrl: party["imageUrl"]!,
                      detail1: 'asdasdsa',
                      detail2: 'asdasdas',
                    );
                  },
                  childCount: upcomingParties.length,
                ),
              ),
            ],
          );
        },
      ),
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
      "imageUrl": "https://file.rendit.io/n/3Sz3FTq5fl.png",
    },
    // ... other parties
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsets.only(left: 4.w),
      itemCount: ongoingParties.length,
      itemBuilder: (context, index) {
        final party = ongoingParties[index];
        return ScrollGalleryItem(
          title: party["title"]!,
          subtitle: party["subtitle"]!,
          imageUrl: party["imageUrl"]!,
        );
      },
    );
  }
}

// Widget for individual items in the horizontal gallery
class ScrollGalleryItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String imageUrl;

  const ScrollGalleryItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      margin: EdgeInsets.only(right: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.w),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(3.w)),
            child: Image.network(
              imageUrl,
              height: 12.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: TextStyle(
                        fontSize: 11.sp, fontWeight: FontWeight.bold)),
                SizedBox(height: 0.5.h),
                Text(subtitle,
                    style: TextStyle(fontSize: 9.sp, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SmallInfoCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String detail1;
  final String detail2;
  final String imageUrl;

  const SmallInfoCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.detail1,
    required this.detail2,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3.w),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Image at the top
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(3.w)),
            child: Image.network(
              imageUrl,
              height: 25.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Text content
          Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First pair of text views (title and subtitle)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                          fontSize: 12.sp, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(height: 0.5.h),
                // Second pair of text views (detail1 and detail2)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      detail1,
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                    ),
                    Text(
                      detail2,
                      style: TextStyle(fontSize: 10.sp, color: Colors.grey),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// Delegate for the sticky header with dynamic content
class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.childBuilder,
  });

  final double minHeight;
  final double maxHeight;
  final Widget Function(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
    double minExtent,
    double maxExtent,
  ) childBuilder;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return SizedBox.expand(
      child: childBuilder(
        context,
        shrinkOffset,
        overlapsContent,
        minExtent,
        maxExtent,
      ),
    );
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        childBuilder != oldDelegate.childBuilder;
  }
}
