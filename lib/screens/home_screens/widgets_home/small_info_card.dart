import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
      child: Stack(
        children: [
          // Image as the background
          ClipRRect(
            borderRadius: BorderRadius.circular(3.w),
            child: Image.network(
              imageUrl,
              height: 30.h,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          // Text content overlaid on the image

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(3.w)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.black.withOpacity(0.6),
                      Colors.black.withOpacity(0.0),
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ), // Semi-transparent background
                ),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title and Subtitle
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          // Details
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            detail1,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 0.5.h),
                          Text(
                            detail2,
                            style: TextStyle(
                              fontSize: 13.sp,
                              color: Colors.white70,
                            ),
                          ),
                          SizedBox(height: 1.h),
                        ],
                      ),
                    ])),
          ),
        ],
      ),
    );
  }
}
