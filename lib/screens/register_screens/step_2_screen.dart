// screens/step2_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_tipsy/widgets/app_theme_text_form_field.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:provider/provider.dart';

import '../../utils/constants.dart';
import '../../viewmodels/registration_viewmodel.dart';

class Step2Screen extends StatefulWidget {
  const Step2Screen({super.key});

  @override
  _Step2ScreenState createState() => _Step2ScreenState();
}

class _Step2ScreenState extends State<Step2Screen> {
  final _formKey = GlobalKey<FormState>();

  // State variables to manage password visibility
  bool _passwordVisible = false;
  bool _repeatPasswordVisible = false;

  // Controllers for password fields
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController =
      TextEditingController();

  // Key for the "Repeat Password" field to access its FormFieldState
  final _repeatPasswordKey = GlobalKey<FormFieldState>();

  @override
  void initState() {
    super.initState();

    // Obtain the viewModel without listening to changes
    final viewModel =
        Provider.of<RegistrationViewModel>(context, listen: false);

    // Initialize the controllers with existing values
    _passwordController.text = viewModel.password;
    _repeatPasswordController.text = viewModel.repeatPassword;

    // Listener for the password field
    _passwordController.addListener(() {
      viewModel.password = _passwordController.text;
      // Re-validate the "Repeat Password" field whenever the password changes
      _repeatPasswordKey.currentState?.validate();
    });

    // Listener for the repeat password field
    _repeatPasswordController.addListener(() {
      viewModel.repeatPassword = _repeatPasswordController.text;
    });
  }

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed
    _passwordController.dispose();
    _repeatPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<RegistrationViewModel>(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        onChanged: () {
          // Notify viewModel when form changes
          viewModel.notify();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Some important info to complete your registration",
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 16.0),
            // Full Name Field
            AppThemeTextFormField(
              controller: TextEditingController(text: viewModel.fullName),
              labelText: 'Full Name*',
              onChanged: (value) => viewModel.setFullName(value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your full name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            // Email Field
            AppThemeTextFormField(
              controller: TextEditingController(text: viewModel.email),
              labelText: 'E-mail*',
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => viewModel.setEmail(value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@"
                        r"[a-zA-Z0-9]+\.[a-zA-Z]+")
                    .hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            // Password Field
            AppThemeTextFormField(
              controller: _passwordController,
              labelText: 'Password*',
              obscureText: !_passwordVisible,
              onChanged: (value) => viewModel.setPassword(value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _passwordVisible ? Icons.visibility : Icons.visibility_off,
                  color: primaryDark,
                ),
                onPressed: () {
                  setState(() {
                    _passwordVisible = !_passwordVisible;
                  });
                },
              ),
            ),
            const SizedBox(height: 16.0),
            // Repeat Password Field
            AppThemeTextFormField(
              controller: _repeatPasswordController,
              labelText: 'Repeat Password*',
              obscureText: !_repeatPasswordVisible,
              onChanged: (value) => viewModel.setRepeatPassword(value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please repeat your password';
                } else if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _repeatPasswordVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: primaryDark,
                ),
                onPressed: () {
                  setState(() {
                    _repeatPasswordVisible = !_repeatPasswordVisible;
                  });
                },
              ),
              key: _repeatPasswordKey,
            ),
            const SizedBox(height: 16.0),
            // Phone Number Field
            AppThemeTextFormField(
              controller: TextEditingController(text: viewModel.phone),
              labelText: 'Phone*',
              keyboardType: TextInputType.phone,
              onChanged: (value) => viewModel.setPhone(value),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            // Switch for Phone Visibility
            PhoneInputField(
              onChanged: (phone) {
                viewModel.setPhone(
                    phone); // Update the phone number in your ViewModel
              },
            ),
            SwitchListTile(
              title: const Text(
                "Do you want the number to be visible?\n(You can change this later)",
                style: TextStyle(fontSize: 12.0),
              ),
              value: viewModel.isPhoneVisible,
              onChanged: (value) {
                //viewModel.setPhoneVisibility(value);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PhoneInputField extends StatefulWidget {
  final Function(String)? onChanged;

  const PhoneInputField({super.key, this.onChanged});

  @override
  _PhoneInputFieldState createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  String initialCountry = 'US';
  PhoneNumber phoneNumber = PhoneNumber(isoCode: 'US');
  String countryCode = '+1'; // Default country code
  String selectedCountry = 'US'; // Default ISO code for Nigeria
// Default country code
  final TextEditingController phoneController = TextEditingController();
  Future<void> parsePhoneNumber(String phoneNumber) async {
    print('Failed to parse phone adasda: ${phoneNumber.toString()}');
    try {
      PhoneNumber number =
          await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);
      setState(() {
        countryCode = number.dialCode ?? ''; // Extract country code
        selectedCountry = number.isoCode ?? ''; // Extract country ISO
      });

      // Set the parsable number back to the controller
      print('Failed to parse phone adasda: ${number.toString()}');
      phoneController.text =
          number.parseNumber(); // Parsed number without the country code
    } catch (e) {
      print('Failed to parse phone number: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      onInputChanged: (PhoneNumber value) async {
        if (widget.onChanged != null) {
          widget.onChanged!(value.phoneNumber ?? '');
          print(
              'Failed to parse phone adasda: ${value.phoneNumber!.allMatches("+").length}');

          if (value.phoneNumber != null &&
              value.phoneNumber!.split("+").length > 1) {
            await parsePhoneNumber(value.phoneNumber?.substring(
                    value.phoneNumber!.lastIndexOf('+'),
                    value.phoneNumber?.length) ??
                ""); // Parse on submission
          }

          // Full phone number
        }
      },
      onInputValidated: (bool isValid) {
        print('Is phone number valid: $isValid');
      },
      selectorConfig: const SelectorConfig(
        selectorType: PhoneInputSelectorType.DROPDOWN, // Dropdown or sheet
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      initialValue: phoneNumber,
      textFieldController: phoneController,
      textStyle: TextStyle(
          foreground: Paint()
            ..shader = gradient.createShader(
              const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
            )),
      inputDecoration: InputDecoration(
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryDark),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: primaryOrange, width: 2.0),
        ),
        labelText: 'Phone*',
        labelStyle: TextStyle(
          foreground: Paint()
            ..shader = gradient.createShader(
              const Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
            ),
          backgroundColor: primaryDarkLighter,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        fillColor: primaryDarkLighter,
      ),
    );
  }
}
