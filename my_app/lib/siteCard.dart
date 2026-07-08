/*
*Ella Muro
*25 May 2026
*Class to Represent Site Record Cards
*/

//Imports section
import 'package:flutter/material.dart';
import 'site.dart';
import 'siteRepository.dart';
import 'siteService.dart';

class SiteCard extends StatefulWidget {
  const SiteCard({super.key, required this.site, required this.onDelete});

  @override
  State<SiteCard> createState() => _SiteCardState();

  //Fields of the class
  final Site site;
  final Future<void> Function() onDelete;
}

class _SiteCardState extends State<SiteCard> {

  //Instantiating SiteService into an object
  SiteService siteService = SiteService();

  //Instantiating SiteRepository into an object
  SiteRepository siteRepository = SiteRepository();

  //Controllers
  late TextEditingController siteNameController;
  late TextEditingController maxDocsOffController;

  //Flag to represent whether a card is in editing mode
  bool isEditing = false;

  @override
  void initState() {
    super.initState();

    siteNameController =
      TextEditingController(text: widget.site.siteName);

    maxDocsOffController =
      TextEditingController(text: widget.site.maxDocsOffPerWeek.toString());
  }

  //Method to enable editing
  void enableEditing() {
    setState(() {
      isEditing = true;
    });
  }

   //Method for saving changes to a record
  void saveChanges() async {

    widget.site.siteName = siteNameController.text;
    widget.site.maxDocsOffPerWeek = int.parse(maxDocsOffController.text);

    //Pushing changes to backend to be updated in the MySQL table
    final success = await siteService.updateSite(siteId: widget.site.siteId, siteName: widget.site.siteName, maxDocsOffPerWeek: widget.site.maxDocsOffPerWeek);
    print("UPDATE SITE RESULT: $success");

    if(!mounted) {
      return;
    }

    if(success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Site Updated")),
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
    siteNameController.text = widget.site.siteName;
    maxDocsOffController.text = widget.site.maxDocsOffPerWeek.toString();

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
          content: Text("Are you sure you want to delete the ${widget.site.siteName} site?"),
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
    final success = await siteService.deleteSiteRecord(siteId: widget.site.siteId);

    print("DELETE SITE RESULT: $success");

    await widget.onDelete();

    if(!mounted) {
      return;
    }

    if(success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Site Deleted")),
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

              //Site name
              TextField(
                enableInteractiveSelection: false,
                cursorColor: Colors.blueGrey,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
                controller: siteNameController,

              decoration: InputDecoration(
                labelText: "Site Name",

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

            //Max docs off per week
            TextField(
              enableInteractiveSelection: false,
              cursorColor: Colors.blueGrey,
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
              ),
              controller: maxDocsOffController,

              decoration: InputDecoration(
                labelText: "Max. Docs off per Week",

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