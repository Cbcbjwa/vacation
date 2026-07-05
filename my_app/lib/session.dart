/*
*Ella Muro
*26 May 2026
*Class to Represent Sessions
*/

import 'user.dart';

class Session {
  static int? userId;
  static String? userName;
  static String? displayName;
  static String? email;
  static int? prepicksAllowed;
  static int? weeksAllowed;
  static String? siteName;
  static int? priorityNumber;
  static int? prepicksPriorityNumber;

  //Helper methods
  static void load(User user) {
    userId = user.id;
    displayName = user.displayName;
    email = user.email;
    weeksAllowed = user.weeksAllowed;
    prepicksAllowed = user.prepicksAllowed;
    siteName = user.label;
  }

  static void clear() {
    userId = null;
    displayName = null;
    email = null;
    weeksAllowed = null;
    prepicksAllowed = null;
    siteName = null;
  }
}