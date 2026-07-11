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
  static String? phoneNumber;
  static String? site2Name;

  //Helper methods
  static void load(User user) {
    userId = user.id;
    userName = user.userName;
    displayName = user.displayName;
    email = user.email;
    prepicksAllowed = user.prepicksAllowed;
    weeksAllowed = user.weeksAllowed;
    siteName = user.label;
    priorityNumber = user.priorityNumber;
    prepicksPriorityNumber = user.prepicksPriorityNumber;
    phoneNumber = user.phoneNumber;
    site2Name = user.label2;
  }

  static void clear() {
    userId = null;
    userName = null;
    displayName = null;
    email = null;
    weeksAllowed = null;
    prepicksAllowed = null;
    weeksAllowed = null;
    siteName = null;
    priorityNumber = null;
    prepicksPriorityNumber = null;
    phoneNumber = null;
    site2Name = null;
  }
}