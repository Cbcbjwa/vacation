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

class UserCard extends StatefulWidget {
  const UserCard({super.key, required this.user, required this.onDelete});

  @override
  State<UserCard> createState() => _UserCardState();

  //Fields of the class
  final User user;
  final Future<void> Function() onDelete;

}

class _UserCardState extends State<UserCard> {

  //Instantiating UserService into an object
  UserService userService = UserService();

  //Instantiating UserRepository class into an object
  UserRepository userRepository = UserRepository();

  //Controllers
  late TextEditingController nameController;
  late TextEditingController displayNameController;
  late TextEditingController emailController;
  late TextEditingController labelController;
  late TextEditingController weeksController;
  late TextEditingController prepicksController;
  late TextEditingController priorityNumberController;
  late TextEditingController prepicksPriorityController;

  //Role enum
  late Role selectedRole;

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

    labelController = 
      TextEditingController(text: widget.user.label);

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

    selectedRole = widget.user.docRole;
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
    widget.user.label = labelController.text;
    widget.user.docRole = selectedRole;

    widget.user.weeksAllowed =
        int.parse(weeksController.text);

    widget.user.prepicksAllowed =
        int.parse(prepicksController.text);

    widget.user.priorityNumber =
        int.tryParse(priorityNumberController.text);

    widget.user.prepicksPriorityNumber =
        int.tryParse(prepicksPriorityController.text);

    final success = await userService.updateUser(id: widget.user.id, userName: widget.user.userName, email: widget.user.email, docRole: widget.user.docRole, weeksAllowed: widget.user.weeksAllowed, prepicksAllowed: widget.user.prepicksAllowed, priorityNumber: widget.user.priorityNumber, prepicksPriorityNumber: widget.user.prepicksPriorityNumber, label: widget.user.label ?? "", displayName: widget.user.displayName);

    print("UPDATE USER RESULT: $success");

    if(success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User Updated")),
      );
    } else {
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
    labelController.text = widget.user.label ?? "";

    weeksController.text =
        widget.user.weeksAllowed.toString();

    prepicksController.text =
        widget.user.prepicksAllowed.toString();

    priorityNumberController.text =
        widget.user.priorityNumber?.toString() ?? "";

    prepicksPriorityController.text =
        widget.user.prepicksPriorityNumber?.toString() ?? "";

    selectedRole = widget.user.docRole;

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
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text("Cancel"),
            ),

            //Confirm deletion button
            TextButton(
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

    if(success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("User Deleted")),
      );
      
      await widget.onDelete();

    } else {
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
            SizedBox(height: 10),

            //Label
            TextField(
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
              controller: labelController,

              decoration: InputDecoration(
                labelText: "Site(s)",

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

            //Weeks Allowed
            TextField(
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
                        onPressed: saveChanges,
                        child: Text("Save"),
                      ),

                      ElevatedButton(
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
                        onPressed: enableEditing,
                        label: Icon(Icons.edit),
                      ),

                      ElevatedButton.icon(
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
