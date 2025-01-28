// screens/register_screen.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../../../utils/constants.dart';
import '../../../../utils/sdp.dart';
import '../../../../viewmodels/create_event_view_model.dart';
import '../../../../widgets/background_widget.dart';
import '../../../../widgets/loading_indicator.dart';
import '../../../common_screens/party_details_screen.dart';
import '../../widgets_home/back_to_home_screen_button.dart';
import 'event_step_1_screen.dart';
import 'event_step_2_screen.dart';
import 'event_step_3_screen.dart';
import 'event_step_4_screen.dart';

class CreateEventScreen extends StatefulWidget {
  const CreateEventScreen({super.key});

  @override
  _CreateEventScreenState createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final PageController _pageController = PageController();
  final int _totalPages = 5;
  int _currentPage = 0;
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Access the CreateEventViewModel
  late CreateEventViewModel _createEventScreenViewModel;

  @override
  void initState() {
    super.initState();
    _createEventScreenViewModel = CreateEventViewModel();
  }

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    return ChangeNotifierProvider<CreateEventViewModel>(
      create: (_) => _createEventScreenViewModel,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Consumer<CreateEventViewModel>(
          builder: (context, registrationViewModel, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Back Button
                Padding(
                  padding: EdgeInsets.only(left: 7.w),
                  child: FloatingActionButton(
                    shape: const CircleBorder(),
                    backgroundColor:
                        _currentPage > 0 ? primaryOrange : Colors.grey,
                    onPressed: _currentPage > 0 ? _handleBack : null,
                    child: const Icon(
                      Icons.keyboard_arrow_left_sharp,
                      color: primaryDark,
                    ),
                  ),
                ),
                // Next Button
                FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor:
                      registrationViewModel!.isNextEnabled(_currentPage)
                          ? primaryOrange
                          : Colors.grey,
                  onPressed: registrationViewModel!.isNextEnabled(_currentPage)
                      ? _handleNext
                      : null,
                  child: Icon(
                    _currentPage == _totalPages - 1
                        ? Icons.check
                        : Icons.keyboard_arrow_right_sharp,
                    color: primaryDark,
                  ),
                ),
              ],
            );
          },
        ),
        bottomNavigationBar: SizedBox(
          height: 50,
          child: BottomAppBar(
            color: primaryDark,
            shape: _currentPage != 1
                ? const DoubleCircularNotchedButton()
                : RectangleNotchedShape(),
            notchMargin: 5.0,
            clipBehavior: Clip.antiAlias,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: false //_createEventScreenViewModel.isPaidEvent
                      ? _totalPages + 1
                      : _totalPages,
                  effect: ExpandingDotsEffect(
                      dotColor: gradientOrange,
                      activeDotColor: primaryPink,
                      dotHeight: 5,
                      dotWidth: 5,
                      spacing: SDP.sdp(10),
                      expansionFactor: 5),
                ),
              ],
            ),
          ),
        ),
        body: RepaintBoundary(
          child: Stack(
            children: [
              const BackgroundWidget(),
              PageView.builder(
                controller: _pageController,
                physics: const BouncingScrollPhysics(),
                itemCount: _totalPages,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
                  });
                },
                itemBuilder: (context, index) {
                  return _buildPage(index);
                },
              ),
              if (_isLoading) const LoadingIndicator(),
              Positioned(
                top: 20,
                left: 0,
                right: 0,
                child: Center(
                  child: BackToHostHomeScreenButton(
                    initialIndex: 3, // Jump to 4th tab
                    isHostInitially: true, // Ensure Host mode
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return EventStep1Screen();
      case 1:
        return EventStep2Screen();
      case 2:
        return EventStep3Screen();
      case 3:
        return EventStep4Screen();
      case 4:
        return PartyDetailPage(
          isPreview: true,
        );
      default:
        return Container();
    }
  }

  void _handleBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    }
  }

  void _handleNext() async {
    if (_currentPage < _totalPages - 1) {
      print("email: asas");
      _pageController.nextPage(
          duration: const Duration(milliseconds: 300), curve: Curves.ease);
    } else {
      // Save data to Firebase
      setState(() {
        _isLoading = true;
      });
      try {
        await _createEventScreenViewModel.savePartyToFirestore();
        setState(() {
          _isLoading = false;
        });
        // Navigate to the next screen or show success message
        if (context.mounted) {
          Navigator.pushNamed(context, '/login');
        }
      } catch (e) {
        print("email: " + e.toString());
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
}

class RectangleNotchedShape extends NotchedShape {
  const RectangleNotchedShape();

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    // Simply return the rectangle of the host, ignoring the guest rectangle
    return Path()..addRect(host);
  }
}

class DoubleCircularNotchedButton extends NotchedShape {
  const DoubleCircularNotchedButton();

  @override
  Path getOuterPath(Rect host, Rect? guest) {
    if (guest == null || !host.overlaps(guest)) return Path()..addRect(host);

    final double notchRadius = guest.height / 2.0;

    const double s1 = 15.0;
    const double s2 = 1.0;

    final double r = notchRadius;
    final double a = -1.0 * r - s2;
    final double b = host.top - 0;

    final double n2 = math.sqrt(b * b * r * r * (a * a + b * b - r * r));
    final double p2xA = ((a * r * r) - n2) / (a * a + b * b);
    final double p2xB = ((a * r * r) + n2) / (a * a + b * b);
    final double p2yA = math.sqrt(r * r - p2xA * p2xA);
    final double p2yB = math.sqrt(r * r - p2xB * p2xB);

    // Cut-out 1
    final List<Offset> px = List.filled(6, const Offset(0, 0));

    px[0] = Offset(a - s1, b);
    px[1] = Offset(a, b);
    final double cmpx = b < 0 ? -1.0 : 1.0;
    px[2] = cmpx * p2yA > cmpx * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    px[3] = Offset(-1.0 * px[2].dx, px[2].dy);
    px[4] = Offset(-1.0 * px[1].dx, px[1].dy);
    px[5] = Offset(-1.0 * px[0].dx, px[0].dy);

    for (int i = 0; i < px.length; i += 1) {
      px[i] += Offset(0 + (notchRadius + 12), 0); // Cut-out 1 positions
    }

    // Cut-out 2
    final List<Offset> py = List.filled(6, const Offset(0, 0));

    py[0] = Offset(a - s1, b);
    py[1] = Offset(a, b);
    final double cmpy = b < 0 ? -1.0 : 1.0;
    py[2] = cmpy * p2yA > cmpy * p2yB ? Offset(p2xA, p2yA) : Offset(p2xB, p2yB);

    py[3] = Offset(-1.0 * py[2].dx, py[2].dy);
    py[4] = Offset(-1.0 * py[1].dx, py[1].dy);
    py[5] = Offset(-1.0 * py[0].dx, py[0].dy);

    for (int i = 0; i < py.length; i += 1) {
      py[i] +=
          Offset(host.width - (notchRadius + 12), 0); // Cut-out 2 positions
    }

    return Path()
      ..moveTo(host.left, host.top)
      ..lineTo(px[0].dx, px[0].dy)
      ..quadraticBezierTo(px[1].dx, px[1].dy, px[2].dx, px[2].dy)
      ..arcToPoint(
        px[3],
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(px[4].dx, px[4].dy, px[5].dx, px[5].dy)
      ..lineTo(py[0].dx, py[0].dy)
      ..quadraticBezierTo(py[1].dx, py[1].dy, py[2].dx, py[2].dy)
      ..arcToPoint(
        py[3],
        radius: Radius.circular(notchRadius),
        clockwise: false,
      )
      ..quadraticBezierTo(py[4].dx, py[4].dy, py[5].dx, py[5].dy)
      ..lineTo(host.right, host.top)
      ..lineTo(host.right, host.bottom)
      ..lineTo(host.left, host.bottom)
      ..close();
  }
}

// 1. Theme Selection Screen
class ThemeSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose Your Party Theme'),
        backgroundColor: Colors.pinkAccent,
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(16.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: 6,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.pinkAccent, Colors.orangeAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8.0,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  index == 0
                      ? 'Tropical'
                      : index == 1
                          ? 'Retro'
                          : 'Black & White',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// 4. RSVP Options Screen
class RSVPOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('RSVP Preferences'),
        backgroundColor: Colors.purpleAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Select Your Response',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: ['Attending', 'Not Attending', 'Maybe'].map((option) {
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 8,
                          offset: Offset(2, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      option,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

// 7. Food and Drink Options Screen
class FoodDrinkOptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food & Drinks'),
        backgroundColor: Colors.lightBlue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16.0,
                  mainAxisSpacing: 16.0,
                ),
                itemCount: 6,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {},
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.lightBlueAccent, Colors.blueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Center(
                        child: Text(
                          index == 0
                              ? 'Burger'
                              : index == 1
                                  ? 'Champagne'
                                  : 'Drink ${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 6. Music Playlist Screen
class MusicPlaylistScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Playlist'),
        backgroundColor: Colors.orangeAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Integrate with Music Services',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.music_note, color: Colors.orange),
                  iconSize: 48.0,
                  onPressed: () {},
                ),
                IconButton(
                  icon: Icon(Icons.play_arrow, color: Colors.orange),
                  iconSize: 48.0,
                  onPressed: () {},
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 5,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: Icon(Icons.music_note, color: Colors.orange),
                    title: Text('Song ${index + 1}'),
                    onTap: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetCalculatorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Plan Your Budget'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            BudgetInputField(label: 'Decorations'),
            BudgetInputField(label: 'Food'),
            BudgetInputField(label: 'Entertainment'),
            SizedBox(height: 24.0),
            Container(
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.tealAccent, Colors.green],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Text(
                'Total Cost: \$0.00',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BudgetInputField extends StatelessWidget {
  final String label;

  BudgetInputField({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }
}
