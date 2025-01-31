import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/utils/constants.dart';
import 'package:flutter_tipsy/viewmodels/current_user.dart';
import 'package:flutter_tipsy/widgets/setting_drawer_widget.dart';

import '../screens/common_screens/profile_screen.dart';

class HeaderAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent, // Match background color
      elevation: 0, // Remove shadow
      title: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween, // Keep items properly spaced
        crossAxisAlignment: CrossAxisAlignment.center, // Align vertically

        children: [
          // Menu Icon
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(
                  Icons.menu,
                  color: primaryDark,
                  size: 28, // or whatever size you like
                ),
                onPressed: () {
                  // ✅ Use a function inside onPressed
                  showSettingsDrawer(context);
                },

                // const SizedBox(width: 8), // spacing between icon and logo
                // Image.asset(
                //   'C:\\Users\\Administrator\\Desktop\\flutter_tipsy\\lib\\assets\\Logo.png', // Replace with your logo asset path
                //   height: 80, // match this to the Icon size for better alignment
                // ),showSettingsDrawer(context),
              ),
            ],
          ),

          Row(
            children: [
              // Notification Icon
              Icon(Icons.notifications, color: primaryDark),

              SizedBox(width: 15), // Space

              // Profile Picture (With Fallback Icon)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                        userData: CurrentUser().user!,
                      ),
                    ),
                  );
                },
                child: ClipOval(
                  child: SizedBox(
                    height: 38,
                    width: 38,
                    child: FastCachedImage(
                      url: CurrentUser().user?.profilePictureUrl ?? "",
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
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(60); // Adjust height
}
