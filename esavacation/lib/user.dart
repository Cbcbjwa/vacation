/*
*Ella Muro
*23 April 2026
*Class to Represent App Users
*/

//Imports section
import 'role.dart';

class User {

  //**Fields of the Class**\\
  int id;
  String userName;
  String email;
  Role docRole;
  int weeksAllowed;
  int prepicksAllowed;
  int? priorityNumber;
  int? prepicksPriorityNumber;
  String? label;
  String displayName;
  String phoneNumber;
  String? label2;

  //**Constructor Section**\\
  
  //Full constructor
  User.full({required this.id, required this.userName, required this.email, required this.docRole, required this.weeksAllowed, required this.prepicksAllowed, this.priorityNumber, this.prepicksPriorityNumber, this.label, required this.displayName, required this.phoneNumber, this.label2});

  factory User.fromJson(Map<String, dynamic> json) {
    return User.full(
      id: json["id"],
      userName: json["userName"],
      email: json["email"],
      docRole: Role.values.firstWhere((e) => e.toString().split('.').last == json["docRole"],),
      weeksAllowed: json["weeksAllowed"],
      prepicksAllowed: json["prepicksAllowed"],
      priorityNumber: json["priorityNumber"],
      prepicksPriorityNumber: json["prepicksPriorityNumber"],
      label: json["label"],
      displayName: json["displayName"],
      phoneNumber: json["phoneNumber"],
      label2: json["label2"]
    );
  }
}