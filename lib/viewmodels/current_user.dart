import 'package:flutter_tipsy/viewmodels/user_model.dart';

class CurrentUser {
  static final CurrentUser _instance = CurrentUser._internal();
  UserDataModel? user;

  factory CurrentUser() {
    return _instance;
  }

  CurrentUser._internal();
}
