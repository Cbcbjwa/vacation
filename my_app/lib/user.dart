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

  //**Constructor Section**\\

  //Default constructor
  User() 
    :  id = 1,
      userName = "Hannibal Lecter",
      email = "hanniballecter@gmail.com",
      docRole = Role.admin,
      weeksAllowed = 4,
      prepicksAllowed = 2,
      priorityNumber = 1,
      prepicksPriorityNumber = 1,
      label = "Emory Johns Creek";
  

  //Full constructor
  User.full({required this.id, required this.userName, required this.email, required this.docRole, required this.weeksAllowed, required this.prepicksAllowed, this.priorityNumber, this.prepicksPriorityNumber, this.label});

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
      label: json["label"]
    );
  }

  //**Getters and Setters**\\
  String getUserName() {
    return userName;
  }

  void setUserName(String userName) {
    this.userName = userName;
  }

  String getEmail() {
    return email;
  }

  void setEmail(String email) {
    this.email = email;
  }

  Role getDocRole() {
    return docRole;
  }

  void setRole(Role docRole) {
    this.docRole = docRole;
  }


}