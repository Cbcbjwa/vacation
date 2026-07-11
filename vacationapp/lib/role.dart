/*
*Ella Muro
*23 April 2026
*Enum to Represent User Roles
*/

enum Role {
  admin,
  physician
}

extension RoleLabel on Role {
  String get label {
    switch(this) {
      case Role.admin:
        return "Admin";
      case Role.physician:
        return "Physician";
    }
  }
}