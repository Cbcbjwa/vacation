/*
*Ella Muro
*24 May 2026
*UI for Adding Week Records
*/

//Imports section
import 'package:flutter/material.dart';
import 'weekService.dart';

class AddWeeksScreen extends StatefulWidget {
  const AddWeeksScreen({super.key, required this.onAdd});

  @override
  State<AddWeeksScreen> createState() => _AddWeeksScreenState();

  //Field of the class
  final Future<void> Function() onAdd;
}

class _AddWeeksScreenState extends State<AddWeeksScreen> {

  //Controller fields
  final TextEditingController weekNumberController = TextEditingController();
  final TextEditingController weekDateController = TextEditingController();
  final TextEditingController specialSpecController = TextEditingController();
  final TextEditingController totalSlotsController = TextEditingController();

  //Instantiating WeekService class into an object
  WeekService weekService = WeekService();

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text("Add a New Week",
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          )
        ),

        body: Container(
          color: Colors.black,

          child: Padding(
            padding: const EdgeInsets.only(
              top: 30,
              left: 20,
              right: 20
            ),

            child: Column(
              mainAxisSize: MainAxisSize.min,

              children: [

                //Week number text field
                TextField(
                  controller: weekNumberController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Week Number",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),


                //Spacing the text fields
                SizedBox(height: 20),

                //Week date text field
                TextField(
                  controller: weekDateController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Week Date",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),


                //Spacing the text fields
                SizedBox(height: 20),

                //Special specification text field
                TextField(
                  controller: specialSpecController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Special spec.",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),


                //Spacing the text fields
                SizedBox(height: 20),

                //Total slots text field
                TextField(
                  controller: totalSlotsController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Total Slots",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),

                //Spacing
                SizedBox(height: 15),

                //Add button
                 ElevatedButton(
                  onPressed: () async {
                    final success = await weekService.createWeek(weekNumber: int.tryParse(weekNumberController.text) ?? 0, weekDate: weekDateController.text, specialSpecification: specialSpecController.text, totalSlots: int.tryParse(totalSlotsController.text) ?? 0);
                    print("CREATE WEEK RESULT: $success");

                    if(success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Week Added")),
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
              ],
            ),
          )
        )
      );  
    }
  

}