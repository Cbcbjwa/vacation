/*
*Ella Muro
*7 May 2026
*Class to Represent User Record Cards
*/

//Imports section
import 'package:flutter/material.dart';
import 'role.dart';
import 'user.dart';
import 'userService.dart';
import 'userRepository.dart';
import 'site.dart';
import 'siteService.dart';

class UserCard extends StatefulWidget {
  const UserCard({super.key, required this.user, required this.onDelete, required this.sites});

  @override
  State<UserCard> createState() => _UserCardState();

  //Fields of the class
  final User user;
  final Future<void> Function() onDelete;
  final List<Site> sites;

}

class _UserCardState extends State<UserCard> {

  //Instantiating UserService into an object
  UserService userService = UserService();

  //Instantiating UserRepository class into an object
  UserRepository userRepository = UserRepository();

  //Instantiating SiteService into an object
  SiteService siteService = SiteService();

  //Controllers
  late TextEditingController nameController;
  late TextEditingController displayNameController;
  late TextEditingController emailController;
  late TextEditingController labelController;
  late TextEditingController weeksController;
  late TextEditingController prepicksController;
  late TextEditingController priorityNumberController;
  late TextEditingController prepicksPriorityController;
  late TextEditingController phoneNumberController;
  late TextEditingController label2Controller;

  //Role enum
  late Role selectedRole;

  //Sites
  String? selectedSiteName;
  String? selectedSiteName2;

  //Flag to represent whether a card is in editing mode
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    nameController =
      TextEditingController(text: widget.user.userName);

    displayNameController = 
      TextEditingController(text: widget.user.displayName);

    emailController =
      TextEditingController(text: widget.user.email);

    weeksController =
        TextEditingController(
            text: widget.user.weeksAllowed.toString());

    prepicksController =
        TextEditingController(
            text: widget.user.prepicksAllowed.toString());

    priorityNumberController =
        TextEditingController(
            text: widget.user.priorityNumber?.toString() ?? "");

    prepicksPriorityController =
        TextEditingController(
            text: widget.user.prepicksPriorityNumber?.toString() ?? "");

    phoneNumberController = 
      TextEditingController(text: widget.user.phoneNumber);

    selectedRole = widget.user.docRole;

    selectedSiteName = widget.user.label;
    selectedSiteName2 = widget.user.label2;
  }


  //Method to enable editing
  void enableEditing() {
    setState(() {
      isEditing = true;
    });
  }

  //Method for saving a change to a record
  void saveChanges() async {

    widget.user.userName = nameController.text;
    widget.user.displayName = displayNameController.text;
    widget.user.email = emailController.text;
    widget.user.phoneNumber = phoneNumberController.text;
    widget.user.label = selectedSiteName;
    widget.user.docRole = selectedRole;
    widget.user.label2 = selectedSiteName2;

    widget.user.weeksAllowed =
        int.parse(weeksController.text);

    widget.user.prepicksAllowed =
        int.parse(prepicksController.text);

    widget.user.priorityNumber =
        int.tryParse(priorityNumberController.text);

    widget.user.prepicksPriorityNumber =
        int.tryParse(prepicksPriorityController.text);

    final success = await userService.updateUser(id: widget.user.id, userName: widget.user.userName, email: widget.user.email, docRole: widget.user.docRole, weeksAllowed: widget.user.weeksAllowed, prepicksAllowed: widget.user.prepicksAllowed, priorityNumber: widget.user.priorityNumber, prepicksPriorityNumber: widget.user.prepicksPriorityNumber, label: widget.user.label ?? "", displayName: widget.user.displayName, phoneNumber: widget.user.phoneNumber, label2: widget.user.label2 ?? "");

    print("UPDATE USER RESULT: $success");

    if(!mounted) {
      return;
    }

    if(success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User Updated")),
      );
    } else {
      
      if(!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Update Failed")),
      );
    }

    setState(() {
      isEditing = false;
    });
  }

  //Method for cancelling changes to a record
  void cancelChanges() {

    nameController.text = widget.user.userName;
    displayNameController.text = widget.user.displayName;
    emailController.text = widget.user.email;
    phoneNumberController.text = widget.user.phoneNumber;

    weeksController.text =
        widget.user.weeksAllowed.toString();

    prepicksController.text =
        widget.user.prepicksAllowed.toString();

    priorityNumberController.text =
        widget.user.priorityNumber?.toString() ?? "";

    prepicksPriorityController.text =
        widget.user.prepicksPriorityNumber?.toString() ?? "";

    selectedRole = widget.user.docRole;

     selectedSiteName = widget.user.label;
     selectedSiteName2 = widget.user.label2;

    setState(() {
      isEditing = false;
    });
  }

  //Method for deleting a record
  void deleteRecord() async {
    final bool? confirmation = await showDialog<bool>(
      context: context,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text("Confirm Deletion"),
          contentTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          content: Text("Are you sure you want to delete the record for ${widget.user.userName}?"),
          actions: [

            //Cancel deletion button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 40, 89, 113),
              ),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),

            //Confirm deletion button
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color.fromARGB(255, 40, 89, 113),
              ),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text("Confirm"),
            ),
          ],
        );
      }
    );

    //Cancelling record deletion
    if(confirmation != true){
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Deletion Cancelled")),
      );
      return;
    }

    //Deleting the record
    final success = await userService.deleteUserRecord(id: widget.user.id);

    print("DELETE USER RESULT: $success");

    await widget.onDelete();

    if(!mounted) {
      return;
    }

    if(success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User Deleted")),
      );
      
      

    } else {
      if(!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Deletion Failed")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Card(
      shape: RoundedRectangleBorder(
        side: BorderSide(
          color: Colors.grey,
          width: 2.0,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: const Color.fromARGB(255, 18, 18, 18),

      margin: EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 30,
      ),

      child: Padding(
        padding: EdgeInsets.all(12),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          
          children: [

              //Name
              TextField(
                cursorColor: Colors.blueGrey,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
                controller: nameController,

              decoration: InputDecoration(
                labelText: "Name",

                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),

                border: InputBorder.none,

                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              readOnly: !isEditing,
            ),

              //Display name
              TextField(
                cursorColor: Colors.blueGrey,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
                controller: displayNameController,

              decoration: InputDecoration(
                labelText: "Display Name",

                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),

                border: InputBorder.none,

                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              readOnly: !isEditing,
            ),

            //Email
            TextField(
              cursorColor: Colors.blueGrey,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
              controller: emailController,

              decoration: InputDecoration(
                labelText: "Email",

                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),

                border: InputBorder.none,

                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              readOnly: !isEditing,
            ),

            //Spacing
            SizedBox(height: 10),

            //Phone number
            TextField(
              cursorColor: Colors.blueGrey,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
              controller: phoneNumberController,

              decoration: InputDecoration(
                labelText: "Phone Number",

                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),

                border: InputBorder.none,

                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              readOnly: !isEditing,
            ),

            //Spacing
            SizedBox(height: 10),


            //Role Dropdown
            DropdownMenu<Role>(
              initialSelection: selectedRole,

              label: Text(
                "Role",

                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              textStyle: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),

              onSelected: (value) {

                if (value != null) {
                  setState(() {
                    selectedRole = value;
                  });
                }
              },

              dropdownMenuEntries:
                  Role.values.map((role) {

                return DropdownMenuEntry<Role>(
                  value: role,
                  label: role.label,
                );

              }).toList(),
            ),

            //Spacing
            SizedBox(height: 18),

            //Site 1
            DropdownMenu<String>(
              initialSelection: selectedSiteName,

              label: Text(
                "Site",

                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              textStyle: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),

              onSelected: (value) {

                if (value != null) {
                  setState(() {
                    selectedSiteName = value;
                  });
                }
              },

              dropdownMenuEntries:
                  widget.sites.map((site) {

                return DropdownMenuEntry<String>(
                  value: site.siteName,
                  label: site.siteName,
                );

              }).toList(),
            ),

            //Spacing
            SizedBox(height: 18),

            //Site 2
            DropdownMenu<String>(
              initialSelection: selectedSiteName2,

              label: Text(
                "Site 2",

                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              textStyle: TextStyle(
                fontSize: 15,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),

              onSelected: (value) {

                if (value != null) {
                  setState(() {
                    selectedSiteName2 = value;
                  });
                }
              },

              dropdownMenuEntries:
                  widget.sites.map((site) {

                return DropdownMenuEntry<String>(
                  value: site.siteName,
                  label: site.siteName,
                );

              }).toList(),
            ),

            //Spacing
            SizedBox(height: 15),

            //Weeks Allowed
            TextField(
              cursorColor: Colors.blueGrey,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),

              controller: weeksController,

              decoration: InputDecoration(
                labelText: "Weeks Allowed",

                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,

                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              readOnly: !isEditing,
            ),

            //Prepicks Allowed
            TextField(
              cursorColor: Colors.blueGrey,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),

              controller: prepicksController,

              decoration: InputDecoration(
                labelText: "Prepicks Allowed",

                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                 border: InputBorder.none,

                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              readOnly: !isEditing,
            ),

            //Priority Number
            TextField(
              cursorColor: Colors.blueGrey,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),

              controller: priorityNumberController,

              decoration: InputDecoration(
                labelText: "Priority Number",

                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                 border: InputBorder.none,

                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              readOnly: !isEditing,
            ),


            //Prepicks Priority Number
            TextField(
              cursorColor: Colors.blueGrey,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),

              controller: prepicksPriorityController,

              decoration: InputDecoration(
                labelText: "Prepicks Priority Number",

                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                border: InputBorder.none,

                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              readOnly: !isEditing,
            ),

            SizedBox(height: 15),

            //Buttons
            isEditing

                //Save/Cancel
                ? OverflowBar(

                    alignment: MainAxisAlignment.center,
                    spacing: 10,

                    children: [

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                        ),
                        onPressed: saveChanges,
                        child: Text("Save"),
                      ),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                        ),
                        onPressed: cancelChanges,
                        child: Text("Cancel"),
                      ),
                    ],
                  )

                  //Edit/Delete
                : OverflowBar(

                    alignment: MainAxisAlignment.center,
                    spacing: 10,

                    children: [

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                        ),
                        onPressed: enableEditing,
                        label: Icon(Icons.edit),
                      ),

                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                        ),
                        onPressed: deleteRecord,
                        label: Icon(Icons.delete),
                      ),
                    ],
                  ),

                   ],
        ),
      ),
      );
  }

}
