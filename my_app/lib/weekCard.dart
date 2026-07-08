/*
*Ella Muro
*7 May 2026
*Class to Represent Week Record Cards
*/

//Imports section
import 'package:flutter/material.dart';
import 'package:my_app/weekRepository.dart';
import 'week.dart';
import 'weekService.dart';

class WeekCard extends StatefulWidget {
  const WeekCard({super.key, required this.week, required this.onDelete});

  @override
  State<WeekCard> createState() => _WeekCardState();

  //Fields of the class
  final Week week;
  final Future<void> Function() onDelete;
}

class _WeekCardState extends State<WeekCard> {

  //Instantiating WeekService into an object
  WeekService weekService = WeekService();

  //Instantiating WeekRepository class into an object
  WeekRepository weekRepository = WeekRepository();

  //Controllers
  late TextEditingController weekNumberController;
  late TextEditingController weekDateController;
  late TextEditingController specialSpecController;
  late TextEditingController totalSlotsController;

  //Flag to represent whether a card is in editing mode
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    weekNumberController =
      TextEditingController(text: widget.week.weekNumber.toString());

    weekDateController =
      TextEditingController(text: widget.week.weekDate);

    specialSpecController = 
      TextEditingController(text: widget.week.specialSpecification ?? "");

    totalSlotsController = 
      TextEditingController(text: widget.week.totalSlots.toString());
  }

  //Method to enable editing
  void enableEditing() {
    setState(() {
      isEditing = true;
    });
  }

  //Method for saving changes to a record
  void saveChanges() async {

    widget.week.weekNumber = int.parse(weekNumberController.text);
    widget.week.weekDate = weekDateController.text;
    widget.week.specialSpecification = specialSpecController.text;
    widget.week.totalSlots = int.parse(totalSlotsController.text);

    //Pushing changes to backend to be updated in the MySQL table
    final success = await weekService.updateWeek(weekId: widget.week.weekId, weekNumber: widget.week.weekNumber, weekDate: widget.week.weekDate, specialSpecification: widget.week.specialSpecification, totalSlots: widget.week.totalSlots);

    print("UPDATE WEEK RESULT: $success");

    if(!mounted) {
      return;
    }

    if(success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Week Updated")),
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

  //Method for cancelling changes
  void cancelChanges() {
    weekNumberController.text = widget.week.weekNumber.toString();
    weekDateController.text = widget.week.weekDate;
    specialSpecController.text = widget.week.specialSpecification ?? "";
    totalSlotsController.text = widget.week.totalSlots.toString();

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
          content: Text("Are you sure you want to delete week ${widget.week.weekNumber}, ${widget.week.weekDate}?"),
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
    final success = await weekService.deleteWeekRecord(weekId: widget.week.weekId);

    print("DELETE WEEK RESULT: $success");

    await widget.onDelete();

    if(!mounted) {
      return;
    }

    if(success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Week Deleted")),
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

              //Week number
              TextField(
                enableInteractiveSelection: false,
                cursorColor: Colors.blueGrey,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
                controller: weekNumberController,

              decoration: InputDecoration(
                labelText: "Week Number",

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

            //Week date
            TextField(
              enableInteractiveSelection: false,
              cursorColor: Colors.blueGrey,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
              controller: weekDateController,

              decoration: InputDecoration(
                labelText: "Date",

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

            //Special week specification
            TextField(
              enableInteractiveSelection: false,
              cursorColor: Colors.blueGrey,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
              controller: specialSpecController,

              decoration: InputDecoration(
                labelText: "Label",

                labelStyle: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                hintText: "N/A",

                border: InputBorder.none,

                hintStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),

              readOnly: !isEditing,
            ),

            //Total slots
            TextField(
              enableInteractiveSelection: false,
              cursorColor: Colors.blueGrey,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
              controller: totalSlotsController,

              decoration: InputDecoration(
                labelText: "Total Slots",

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
            SizedBox(height: 15),

            //Buttons
            isEditing

              //Save/cancel
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
          ]
        )
      )
    );
  }
}