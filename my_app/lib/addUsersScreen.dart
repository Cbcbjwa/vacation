/*
*Ella Muro
*1 May 2026
*UI for Adding Physician Records
*/

//Imports section
import 'package:flutter/material.dart';
import 'package:my_app/role.dart';
import 'package:my_app/userRepository.dart';
import 'userService.dart';

class AddUsersScreen extends StatefulWidget {
  const AddUsersScreen({super.key, required this.onAdd});

   @override
  State<AddUsersScreen> createState() => _AddUsersScreenState();

  final Future<void> Function() onAdd;

}

  class _AddUsersScreenState extends State<AddUsersScreen>{

    //Controller fields
    final TextEditingController nameController = TextEditingController();
    final TextEditingController displayNameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController roleController = TextEditingController();
    final TextEditingController labelController = TextEditingController();
    final TextEditingController weeksController = TextEditingController();
    final TextEditingController prepicksController = TextEditingController();
    final TextEditingController numberController = TextEditingController();
    final TextEditingController prepicksNumberController = TextEditingController();

    //Default drop down menu selection
    Role selectedRole = Role.physician;

    //Instantiating UserService class into an object
    UserService userService = UserService();

    //Instantiating the UserRepository class into an object
    UserRepository userRepository = UserRepository();

    //Temporary password
    String temporaryPassword = "Temp123!";

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text("Add a New User",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          )
        ),

        body: Container(
          color: Colors.black,
          
          child: Padding (
            padding: const EdgeInsets.only(
              top: 30,
              left: 20,
              right: 20,
            ),
            
            child: Column(
              mainAxisSize: MainAxisSize.min,
              
              children: [

                //Name text field
                TextField(
                  controller: nameController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Name",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),


                //Spacing the text fields
                SizedBox(height: 20),

                //Display name text field
                TextField(
                  controller: displayNameController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Display Name",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),


                //Spacing the text fields
                SizedBox(height: 20),

                //Email text field
                TextField(
                  controller: emailController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Email",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                //Spacing the text fields
                SizedBox(height: 20),

                //Role text field
                DropdownMenu<Role> (
                  initialSelection: selectedRole,

                  label: const Text("Role",
                  style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),),
                  textStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold),

                  dropdownMenuEntries: Role.values.map((role) {
                    return DropdownMenuEntry<Role>(
                      value: role,
                      label: role.label,
                    );
                  }).toList(),

                  onSelected: (Role? value) {
                    if(value == null) return;
                    setState(() {
                      selectedRole = value;
                    });
                  }
                ),

                //Spacing the text fields
                SizedBox(height: 20),

                //Label text field
                TextField(
                  controller: labelController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Site(s)",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                //Spacing the text fields
                SizedBox(height: 20),

                //Weeks allowed text field
                TextField(
                  controller: weeksController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Weeks Allowed",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                //Spacing the text fields
                SizedBox(height: 20),

                //Prepicks allowed text field
                TextField(
                  controller: prepicksController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Prepicks Allowed",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                //Spacing the text fields
                SizedBox(height: 20),

                //Priority number text field
                TextField(
                  controller: numberController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Priority Number",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                //Spacing the text fields
                SizedBox(height: 20),

                //Prepicks priority number text field
                TextField(
                  controller: prepicksNumberController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Prepicks Priority Number",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                //Spacing
                SizedBox(height: 15),

                //Add Button
                ElevatedButton(
                  onPressed: () async {
                    final success = await userService.createUser(userName: nameController.text, email: emailController.text, password: temporaryPassword, docRole: selectedRole.name, weeksAllowed: int.tryParse(weeksController.text) ?? 0, prepicksAllowed: int.tryParse(prepicksController.text) ?? 0, priorityNumber: int.tryParse(numberController.text) ?? 0, prepicksPriorityNumber: int.tryParse(prepicksNumberController.text) ?? 0, label: labelController.text, displayName: displayNameController.text);
                    
                    print("CREATE USER RESULT: $success");

                    if(success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("User Added")),
                      );

                     await widget.onAdd();

                      //Closing add user screen
                      //Navigator.pop(context, true);

                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Add Failed")),
                      );
                    }
                  },
                  child: Text("Add"),
                )
              ]
            )
                 
          ),
        
              
        )
      );
    }
}

  
