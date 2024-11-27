import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackgroundWidget extends StatelessWidget {
  final String svgString = '''
<svg width="360" height="800" viewBox="0 0 360 800" fill="none" xmlns="http://www.w3.org/2000/svg">
  <ellipse cx="325" cy="686" rx="200" ry="191" fill="url(#paint0_radial)"/>
  <ellipse cx="31" cy="115" rx="74" ry="125" fill="url(#paint1_radial)"/>
  <ellipse cx="28" cy="671.5" rx="89" ry="139.5" fill="url(#paint2_radial)"/>
  <ellipse cx="335" cy="172.5" rx="225" ry="214.5" fill="url(#paint3_radial)"/>
  <defs>
    <radialGradient id="paint0_radial" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(540.385 808.642) rotate(-143.534) scale(433.139 319.464)">
      <stop stop-color="#E8827C" stop-opacity="0.76"/>
      <stop offset="1" stop-color="#E8827C" stop-opacity="0"/>
    </radialGradient>
    <radialGradient id="paint1_radial" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(-107 23) rotate(31.7819) scale(258.217 428.836)">
      <stop stop-color="#EC920C" stop-opacity="0.31"/>
      <stop offset="1" stop-color="#EC920C" stop-opacity="0"/>
    </radialGradient>
    <radialGradient id="paint2_radial" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(-290 653.5) rotate(-5.54923) scale(423.987 655.052)">
      <stop stop-color="#10EC0C" stop-opacity="0.31"/>
      <stop offset="1" stop-color="#10EC0C" stop-opacity="0"/>
    </radialGradient>
    <radialGradient id="paint3_radial" cx="0" cy="0" r="1" gradientUnits="userSpaceOnUse" gradientTransform="translate(460.294 11.8353) rotate(110.447) scale(392.559 407.155)">
      <stop stop-color="#63FFDA" stop-opacity="0.29"/>
      <stop offset="1" stop-color="#63FFDA" stop-opacity="0"/>
    </radialGradient>
  </defs>
</svg>
''';

  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      height: double.maxFinite,
      child: SvgPicture.string(
        svgString,
        fit: BoxFit.fill,
      ),
    );
  }
}
