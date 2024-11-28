import 'package:flutter/material.dart';
import 'package:flutter_xlider/flutter_xlider.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  double distance = 10.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Search Event"),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Handle menu button press
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Time Display
              Text(
                "Current Time: ${TimeOfDay.now().format(context)}",
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),

              // Scrollable Gallery Group
              const Text("Ongoing Parties",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    _buildScrollGalleryItem(
                      title: "Ongoing Party 1",
                      subtitle: "DJ Night at Club XYZ",
                      imageUrl: "https://file.rendit.io/n/A36fGa3nsC.png",
                    ),
                    _buildScrollGalleryItem(
                      title: "Ongoing Party 2",
                      subtitle: "Live Music at Rooftop Bar",
                      imageUrl: "https://file.rendit.io/n/3Sz3FTq5fl.png",
                    ),
                    _buildScrollGalleryItem(
                      title: "Ongoing Party 2",
                      subtitle: "Live Music at Rooftop Bar",
                      imageUrl: "https://file.rendit.io/n/3Sz3FTq5fl.png",
                    ),
                    _buildScrollGalleryItem(
                      title: "Ongoing Party 2",
                      subtitle: "Live Music at Rooftop Bar",
                      imageUrl: "https://file.rendit.io/n/3Sz3FTq5fl.png",
                    ),
                    _buildScrollGalleryItem(
                      title: "Ongoing Party 2",
                      subtitle: "Live Music at Rooftop Bar",
                      imageUrl: "https://file.rendit.io/n/3Sz3FTq5fl.png",
                    ),
                    _buildScrollGalleryItem(
                      title: "Ongoing Party 2",
                      subtitle: "Live Music at Rooftop Bar",
                      imageUrl: "https://file.rendit.io/n/3Sz3FTq5fl.png",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Search Component
              TextField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: "Search for parties...",
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Filter by Distance
              const Text("Filter by Distance",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // Placeholder for a slider
              const SizedBox(height: 8),
              FlutterSlider(
                values: const [50], // Initial value of the slider
                max: 100, // Maximum value
                min: 0, // Minimum value
                handlerHeight: 24,
                handlerWidth: 24,

                // Slider track gradient
                trackBar: FlutterSliderTrackBar(
                  activeTrackBarHeight: 8,
                  inactiveTrackBarHeight: 8,
                  activeTrackBar: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFD4A5FF), Color(0xFFFFD59E)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  inactiveTrackBar: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),

                // Tooltip customization
                tooltip: FlutterSliderTooltip(
                  alwaysShowTooltip: true,
                  positionOffset: FlutterSliderTooltipPositionOffset(
                    top: -30, // Adjust tooltip position
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  boxStyle: FlutterSliderTooltipBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  format: (String value) {
                    return "$value km"; // Add 'km' suffix
                  },
                ),

                // Custom handler (thumb)
                // Custom handler (thumb) without '>'
                handler: FlutterSliderHandler(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Color(0xFF3C3A5A),
                  ),
                  child:
                      const SizedBox.shrink(), // Removes the default '>' icon
                ),
                // Slider step and divisions
                step: const FlutterSliderStep(step: 1),
                onDragging: (handlerIndex, lowerValue, upperValue) {
                  print("Value: $lowerValue km");
                },
              ),

              const SizedBox(height: 16),

              // Upcoming Parties
              const Text("Upcoming Parties",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildSmallInfoCard(
                    title: "Beach Party",
                    subtitle: "Saturday, 5 PM",
                    imageUrl: "https://file.rendit.io/n/g8WQ25WlWn.png",
                  ),
                  _buildSmallInfoCard(
                    title: "Techno Rave",
                    subtitle: "Friday, 10 PM",
                    imageUrl: "https://file.rendit.io/n/YzzPLqLWgk.png",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScrollGalleryItem({
    required String title,
    required String subtitle,
    required String imageUrl,
  }) {
    return Container(
      width: 150,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 100,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallInfoCard({
    required String title,
    required String subtitle,
    required String imageUrl,
  }) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
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
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
            child: Image.network(
              imageUrl,
              height: 80,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
