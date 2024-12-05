import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

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
