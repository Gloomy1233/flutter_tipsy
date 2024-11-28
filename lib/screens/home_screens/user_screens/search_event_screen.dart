import 'package:flutter/material.dart';

class SearchEventScreen extends StatefulWidget {
  const SearchEventScreen({super.key});

  @override
  State<SearchEventScreen> createState() => _SearchEventScreenState();
}

class _SearchEventScreenState extends State<SearchEventScreen> {
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
              Slider(
                value: 10,
                min: 0,
                max: 50,
                onChanged: (value) {},
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
