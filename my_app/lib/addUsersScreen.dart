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
import 'site.dart';
import 'siteService.dart';
import 'emailService.dart';

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
    final TextEditingController phoneNumberController = TextEditingController();
    final TextEditingController roleController = TextEditingController();
    final TextEditingController siteController = TextEditingController();
    final TextEditingController weeksController = TextEditingController();
    final TextEditingController prepicksController = TextEditingController();
    final TextEditingController numberController = TextEditingController();
    final TextEditingController prepicksNumberController = TextEditingController();
    final TextEditingController site2Controller = TextEditingController();


    //Default drop down menu selection
    Role selectedRole = Role.physician;

    //Default drop down menu selection
    String selectedSiteName = "N/A";
    String selectedSiteName2 = "N/A";

    //Instantiating UserService class into an object
    UserService userService = UserService();

    //Instantiating SiteService into an object
    SiteService siteService = SiteService();

    //Instantiating the UserRepository class into an object
    UserRepository userRepository = UserRepository();

    //Instantiating EmailService into an object
    EmailService emailService = EmailService();

    //Temporary password
    String temporaryPassword = "Temp123!";

    //Flag to represent add/insert state of a record
    bool isAdding = false;

    //List of sites
    List<Site> sites = [];

    //Flag to represent screen loading state
    bool isLoading = true;

    //Method to load sites
    Future<void> load() async {
      sites = await siteService.getSites();
      setState(() {
        selectedSiteName = "N/A";
        selectedSiteName2 = "N/A";
        siteController.text = selectedSiteName;
        site2Controller.text = selectedSiteName2;
        isLoading = false;
      });
    }

    @override
    void initState() {
      super.initState();
      load();
    }

    @override
    Widget build(BuildContext context) {

      if(isLoading) {
      return Scaffold(
        backgroundColor: Colors.black,
  
        body: Center(
        child: CircularProgressIndicator(
          color: const Color.fromARGB(255, 40, 89, 113),
        ),
        )
      );
    }

      print("selectedSiteName = $selectedSiteName");
      print("selectedSiteName2 = $selectedSiteName2");
      print("sites loaded = ${sites.length}");

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

        body: SingleChildScrollView(
          child: Container(
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
                    cursorColor: Colors.blueGrey,
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 2,
                        ),
                      ),
                    ),
                  ),


                  //Spacing the text fields
                  SizedBox(height: 20),

                  //Display name text field
                  TextField(
                    cursorColor: Colors.blueGrey,
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 2,
                        ),
                      ),
                    ),
                  ),


                  //Spacing the text fields
                  SizedBox(height: 20),

                  //Email text field
                  TextField(
                    cursorColor: Colors.blueGrey,
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  //Spacing the text fields
                  SizedBox(height: 20),

                  //Phone number text field
                  TextField(
                    cursorColor: Colors.blueGrey,
                    controller: phoneNumberController,
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                      hintStyle: TextStyle(
                        color: Color.fromARGB(255, 75, 75, 75),
                      ),
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  //Spacing the text fields
                  SizedBox(height: 20),

                  //Role dropdown
                  DropdownMenu<Role> (
                    initialSelection: selectedRole,

                    label: Text("Role",
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

                  //Site dropdown
                  DropdownMenu<String> (
                    controller: siteController,

                    label: Text("Site",
                    style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),),
                    textStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold),

                    dropdownMenuEntries: sites.map((site) {
                      return DropdownMenuEntry<String>(
                        value: site.siteName,
                        label: site.siteName,
                      );
                    }).toList(),

                    onSelected: (value) {
                      if(value != null){
                        setState(() {
                          selectedSiteName = value;
                        });
                      }
                    }
                  ),

                  //Spacing the text fields
                  SizedBox(height: 20),

                  //Site 2 dropdown
                  DropdownMenu<String> (
                    controller: site2Controller,

                    label: Text("Site 2",
                    style: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),),
                    textStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold),

                    dropdownMenuEntries: sites.map((site) {
                      return DropdownMenuEntry<String>(
                        value: site.siteName,
                        label: site.siteName,
                      );
                    }).toList(),

                    onSelected: (value) {
                      if(value != null){
                        setState(() {
                          selectedSiteName2 = value;
                        });
                      }
                    }
                  ),

                  //Spacing the text fields
                  SizedBox(height: 20),

                  //Weeks allowed text field
                  TextField(
                    cursorColor: Colors.blueGrey,
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  //Spacing the text fields
                  SizedBox(height: 20),

                  //Prepicks allowed text field
                  TextField(
                    cursorColor: Colors.blueGrey,
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  //Spacing the text fields
                  SizedBox(height: 20),

                  //Priority number text field
                  TextField(
                    cursorColor: Colors.blueGrey,
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  //Spacing the text fields
                  SizedBox(height: 20),

                  //Prepicks priority number text field
                  TextField(
                    cursorColor: Colors.blueGrey,
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
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.blueGrey,
                          width: 2,
                        ),
                      ),
                    ),
                  ),

                  //Spacing
                  SizedBox(height: 15),

                  //Add Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                    ),
                    onPressed: isAdding
                    ? null
                    : () async {

                      setState(() {
                        isAdding = true;
                      });

                      try {

                        final success = await userService.createUser(userName: nameController.text, email: emailController.text, password: temporaryPassword, docRole: selectedRole.name, weeksAllowed: int.tryParse(weeksController.text) ?? 0, prepicksAllowed: int.tryParse(prepicksController.text) ?? 0, priorityNumber: int.tryParse(numberController.text) ?? 0, prepicksPriorityNumber: int.tryParse(prepicksNumberController.text) ?? 0, label: siteController.text, displayName: displayNameController.text, phoneNumber: phoneNumberController.text, label2: site2Controller.text);
                          
                        print("CREATE USER RESULT: $success");

                        await widget.onAdd();

                        await emailService.sendEmail(to: emailController.text, subject: "ESA Vacation Lottery", text: "You have been registered for the 2027 ESA Vacation Lottery.\n\nUsername: ${emailController.text}\nTemporary Password: Temp123!\n\nIf you have not done so already, please download the ESA Vacation Lottery App, sign in, and change your password under the account menu. The app can be found in the App Store or the Google Play Store. Please review your account information, including your name, email address, mobile phone number, allocated vacation weeks, round participation, and pick priority number. If you feel there are any errors, please contact Mike Muro or Joy Patel promptly.");

                        if(!mounted) {
                          return;
                        }

                        if(success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("User Added")),
                          );

                         
                        }  else {

                          if(!mounted) {
                            return;
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Add Failed")),
                          );
                          
                        } 

                      } catch (error) {
                        if(!mounted) {
                          return;
                        }
                        
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Add Failed $error")),
                        );

                      } finally {
                        setState(() {
                          isAdding = false;
                        });
                      }
                    },
                    child: isAdding
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Add"),
                  )
                ]
              )
            ),
          )
        )
      );
    }
}

  
