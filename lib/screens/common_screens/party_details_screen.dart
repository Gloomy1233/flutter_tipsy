import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/widgets/gradient_button.dart';
import 'package:sizer/sizer.dart';

import '../../utils/constants.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/full_screen_image.dart';

class PartyDetailPage extends StatefulWidget {
  final String title;
  final String activities;
  final String attire;
  final String decor;
  final String imageUrl;
  final String iconUrl;

  const PartyDetailPage({
    super.key,
    required this.title,
    required this.activities,
    required this.attire,
    required this.decor,
    required this.imageUrl,
    required this.iconUrl,
  });

  @override
  State<PartyDetailPage> createState() => _PartyDetailPageState();
}

class _PartyDetailPageState extends State<PartyDetailPage> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  final List<String> _images = [
    'https://media.istockphoto.com/id/1391421103/photo/desert-sand-formations-in-saudi-arabia.jpg?s=2048x2048&w=is&k=20&c=POgrDbhZTpoDa4tW48rP28isvS0cizmJrlrw8EP7YW8=',
    'https://images.unsplash.com/photo-1467810563316-b5476525c0f9?fit=crop&w=800&q=80',
    'https://plus.unsplash.com/premium_photo-1669472897414-098c530ffb64?q=80&w=1965&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D',
  ];

  double _bottomContainerHeightFactor = 0.3;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    double offset = _scrollController.offset;
    double factor = 0.5 + (offset / 400) * 0.2;
    if (factor > 0.7) factor = 0.7;
    if (factor < 0.3) factor = 0.3;
    if (factor != _bottomContainerHeightFactor) {
      setState(() {
        _bottomContainerHeightFactor = factor;
      });
    }
  }

  void _showFullScreenImage(String imageUrl) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImage(
          imageUrl: imageUrl,
          onDelete: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final secondaryTextColor = Colors.grey.shade700;
    final backgroundColor = Colors.black;

    return Scaffold(
      body: Stack(
        children: [
          // Background Image Slider
          Positioned(
            height: 70.h,
            width: 100.w,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _images.length,
              onPageChanged: (index) {},
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _showFullScreenImage(_images[index]),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: FastCachedImage(
                      url: _images[index],
                      fit: BoxFit.cover,
                      fadeInDuration: const Duration(seconds: 1),
                      errorBuilder: (context, exception, stacktrace) {
                        return Text(stacktrace.toString());
                      },
                      loadingBuilder: (context, progress) {
                        return Container(
                          color: Colors.grey[450],
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              if (progress.isDownloading &&
                                  progress.totalBytes != null)
                                Text(
                                  '${progress.downloadedBytes ~/ 1024} / ${progress.totalBytes! ~/ 1024} kb',
                                  style: const TextStyle(color: Colors.red),
                                ),
                              SizedBox(
                                width: 120,
                                height: 120,
                                child: CircularProgressIndicator(
                                  color: Colors.red,
                                  value: progress.progressPercentage.value,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),

          // Cancel / Back Button
          SafeArea(
            minimum: EdgeInsets.only(
                left: 45.w,
                top: 5.h * _bottomContainerHeightFactor,
                right: 45.w),
            left: true,
            right: true,
            child: IconButton(
              icon: Icon(
                Icons.cancel_rounded,
                color: Colors.white,
                size: 10.w,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          // Left and Right Arrows
          Positioned(
            left: 1.w,
            height: 20.h / _bottomContainerHeightFactor,
            width: 20.w,
            child: IconButton(
              alignment: Alignment.centerLeft,
              icon: Icon(Icons.chevron_left, color: Colors.white, size: 10.w),
              onPressed: () {
                _pageController.previousPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            ),
          ),
          Positioned(
            right: 1.w,
            height: 20.h / _bottomContainerHeightFactor,
            width: 20.w,
            child: IconButton(
              icon: Icon(Icons.chevron_right, color: Colors.white, size: 10.w),
              onPressed: () {
                _pageController.nextPage(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeIn,
                );
              },
            ),
          ),

          // Bottom Content Card
          Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              height: 120.h * _bottomContainerHeightFactor,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(5.h),
                  topRight: Radius.circular(5.h),
                ),
                color: Colors.white,
              ),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned.fill(
                    child: BackgroundWidget(),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 8),
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (notification) {
                        if (notification is ScrollUpdateNotification) {
                          _handleScroll();
                        }
                        return false;
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          // image: DecorationImage(
                          //     image: FastCachedImageProvider(widget.imageUrl)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title/Price/Description Container
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: const Offset(0, 3),
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Title Row (RAVE PARTY and "Free")
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "RAVE PARTY",
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w700,
                                            color: primaryDark,
                                          ),
                                        ),
                                        Text(
                                          "Free",
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: FontWeight.w700,
                                            color: primaryDark,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 1.h),
                                    // Now show the extra details below "RAVE PARTY"
                                    Text(
                                      "Theme: ${widget.title}",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: primaryDark,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      "Attire: ${widget.attire}",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: primaryDark,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      "Decor: ${widget.decor}",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: primaryDark,
                                      ),
                                    ),
                                    SizedBox(height: 1.h),
                                    Text(
                                      "Activities: ${widget.activities}",
                                      style: TextStyle(
                                        fontSize: 15.sp,
                                        color: primaryDark,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),

                                    // Description
                                    Text(
                                      "RaveParty with a variety of music for the admirers of this culture. Bring your own booze. Please be aware there will be zero tolerance for drunk people so please drink responsibly. The party follows a Bring your own Booze policy so be prepared in Advance.",
                                      style: TextStyle(
                                        fontSize: 16.sp,
                                        color: Colors.grey.shade700,
                                      ),
                                    ),
                                    SizedBox(height: 2.h),

                                    // Features List with icons
                                    _buildFeatureRow(Icons.flash_on,
                                        "Strobe Lights/Laser Lights"),
                                    _buildFeatureRow(Icons.wifi, "Wifi"),
                                    _buildFeatureRow(Icons.home, "Large Place"),
                                    _buildFeatureRow(
                                      Icons.speaker,
                                      "Woofer-SubWoofer",
                                    ),
                                    _buildFeatureRow(Icons.music_note,
                                        "Edm-Rave-Drum n’Bass"),
                                    _buildFeatureRow(
                                      Icons.wb_sunny_outlined,
                                      "Cozy Atmosphere",
                                    ),
                                    _buildFeatureRow(Icons.hot_tub, "Hot Tub"),
                                    SizedBox(height: 2.h),

                                    // Date / Time / Location / Guests
                                    Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Icon(Icons.calendar_month,
                                                    size: 4.w),
                                                SizedBox(width: 1.w),
                                                Text(
                                                  "5-5-2023",
                                                  style: TextStyle(
                                                    color: primaryDark,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  "11:00 PM",
                                                  style: TextStyle(
                                                    color: primaryDark,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                                SizedBox(width: 1.w),
                                                Icon(Icons.access_time,
                                                    size: 4.w),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 1.h),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                // Request to see location action
                                              },
                                              child: Row(
                                                children: [
                                                  Icon(Icons.map, size: 4.w),
                                                  SizedBox(width: 1.w),
                                                  Text(
                                                    "Request to see location",
                                                    style: TextStyle(
                                                      color:
                                                          Colors.grey.shade700,
                                                      fontSize: 16.sp,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                SizedBox(width: 1.w),
                                                Text(
                                                  "119\\150",
                                                  style: TextStyle(
                                                    color: primaryDark,
                                                    fontSize: 16.sp,
                                                  ),
                                                ),
                                                Icon(Icons.group, size: 4.w),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 2.h),
                              Divider(
                                thickness: 1,
                                color: Colors.grey.shade300,
                              ),
                              SizedBox(height: 2.h),

                              // Hosted By
                              Text(
                                "Hosted By",
                                style: TextStyle(
                                  fontSize: 17.sp,
                                  fontWeight: FontWeight.bold,
                                  color: primaryDark,
                                ),
                              ),
                              SizedBox(height: 1.h),

                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    )
                                  ],
                                ),
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      backgroundImage: NetworkImage(
                                        "https://images.unsplash.com/photo-1607746882042-944635dfe10e?fit=crop&w=100&q=80",
                                      ),
                                      radius: 30,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                "George Papvasiliou",
                                                style: TextStyle(
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: primaryDark,
                                                ),
                                              ),
                                              const SizedBox(width: 5),
                                              Icon(
                                                Icons.verified,
                                                color: Colors.green,
                                                size: 16.sp,
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 0.5.h),
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person_add_alt_1,
                                                color: Colors.blue,
                                                size: 16.sp,
                                              ),
                                              SizedBox(width: 1.w),
                                              Text(
                                                "Follow",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 12.sp,
                                                ),
                                              ),
                                              SizedBox(width: 3.w),
                                              Icon(
                                                Icons.call,
                                                color: Colors.red,
                                                size: 16.sp,
                                              ),
                                              SizedBox(width: 1.w),
                                              Text(
                                                "+31 6955645845",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: primaryDark,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 1.h),
                                          Row(
                                            children: [
                                              Text(
                                                "Reviews",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: primaryDark,
                                                ),
                                              ),
                                              SizedBox(width: 1.w),
                                              Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 16.sp,
                                              ),
                                              Text(
                                                "4.9",
                                                style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: primaryDark,
                                                ),
                                              ),
                                              SizedBox(width: 3.w),
                                              // Guests profile images
                                              Stack(
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                      "https://images.unsplash.com/photo-1544723795-3fb6469f5b39?fit=crop&w=100&q=80",
                                                    ),
                                                    radius: 12,
                                                  ),
                                                  Positioned(
                                                    left: 18,
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        "https://images.unsplash.com/photo-1544723795-3e5b03c240f2?fit=crop&w=100&q=80",
                                                      ),
                                                      radius: 12,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 36,
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          NetworkImage(
                                                        "https://images.unsplash.com/photo-1527980965255-d3b416303d12?fit=crop&w=100&q=80",
                                                      ),
                                                      radius: 12,
                                                    ),
                                                  ),
                                                  Positioned(
                                                    left: 54,
                                                    child: CircleAvatar(
                                                      backgroundColor:
                                                          Colors.grey.shade300,
                                                      radius: 12,
                                                      child: Text(
                                                        "200+",
                                                        style: TextStyle(
                                                          fontSize: 8.sp,
                                                          color: primaryDark,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 7.h),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Request Button
          SafeArea(
            minimum: EdgeInsets.only(
              left: 25.w,
              right: 25.w,
              top: 95.h,
              bottom: -10.h,
            ),
            left: true,
            right: true,
            child: GradientButton(
              onPressed: () {
                // Handle Request
              },
              textColor: primaryDark,
              height: 5.h,
              text: "Request",
              padding: const EdgeInsets.all(0),
              radius: const BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 0.8.h),
      child: Row(
        children: [
          Icon(icon, size: 16.sp, color: Colors.black87),
          SizedBox(width: 2.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16.sp, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
