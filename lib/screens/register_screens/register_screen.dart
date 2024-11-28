// screens/register_screen.dart
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_tipsy/screens/register_screens/step_1_screen.dart';
import 'package:flutter_tipsy/screens/register_screens/step_2_screen.dart';
import 'package:flutter_tipsy/screens/register_screens/step_3_screen.dart';
import 'package:flutter_tipsy/screens/register_screens/step_4_screen.dart';
import 'package:flutter_tipsy/widgets/background_widget.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../utils/constants.dart';
import '../../utils/sdp.dart';
import '../../viewmodels/registration_viewmodel.dart';
import '../../widgets/loading_indicator.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final PageController _pageController = PageController();
  final int _totalPages = 4;
  int _currentPage = 0;
  bool _isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Access the RegistrationViewModel
  late RegistrationViewModel _registrationViewModel;

  @override
  void initState() {
    super.initState();
    _registrationViewModel = RegistrationViewModel();
  }

  @override
  Widget build(BuildContext context) {
    SDP.init(context);
    return ChangeNotifierProvider<RegistrationViewModel>(
      create: (_) => _registrationViewModel,
      child: Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: true,
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        floatingActionButton: Consumer<RegistrationViewModel>(
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
                      registrationViewModel.isNextEnabled(_currentPage)
                          ? primaryOrange
                          : Colors.grey,
                  onPressed: registrationViewModel.isNextEnabled(_currentPage)
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
            shape: const DoubleCircularNotchedButton(),
            notchMargin: 5.0,
            clipBehavior: Clip.antiAlias,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SmoothPageIndicator(
                  controller: _pageController,
                  count: _registrationViewModel.isGuest ? 5 : 4,
                  effect: ExpandingDotsEffect(
                    dotColor: gradientOrange,
                    activeDotColor: primaryPink,
                    dotHeight: 15,
                    dotWidth: 15,
                    spacing: SDP.sdp(30),
                  ),
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const Step1Screen();
      case 1:
        return const Step2Screen();
      case 2:
        return const Step3Screen();
      case 3:
        return const Step4Screen();
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
        await _registrationViewModel.saveRegistrationDataToFirebase();
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
