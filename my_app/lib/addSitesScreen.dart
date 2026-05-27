/*
*Ella Muro
*25 May 2026
*UI for Adding Site Records
*/

//Imports section
import 'package:flutter/material.dart';
import 'siteService.dart';

class AddSitesScreen extends StatefulWidget {
  const AddSitesScreen({super.key, required this.onAdd});

  @override
  State<AddSitesScreen> createState() => _AddSitesScreenState();

  //Field of the class
  final Future<void> Function() onAdd;
}

class _AddSitesScreenState extends State<AddSitesScreen> {

  //Controllers
  final TextEditingController siteNameController = TextEditingController();
  final TextEditingController maxDocsOffController = TextEditingController();

  //Instantiating the SiteService class into an object
  SiteService siteService = SiteService();

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.grey),
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text("Add a New Site",
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

                //Site name text field
                TextField(
                  controller: siteNameController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Site Name",
                    labelStyle: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.bold,),
                    hintStyle: TextStyle(
                      color: Color.fromARGB(255, 75, 75, 75),
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),


                //Spacing the text fields
                SizedBox(height: 20),

                //Max docs off per week text field
                TextField(
                  controller: maxDocsOffController,
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                  decoration: InputDecoration(
                    labelText: "Max. Docs off per Week",
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
                    final success = await siteService.createSite(siteName: siteNameController.text, maxDocsOffPerWeek: int.tryParse(maxDocsOffController.text) ?? 0);
                    print("CREATE SITE RESULT: $success");

                    if(success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Week Added")),
                      );

                      await widget.onAdd();

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
          ),
        )
      );
    }
}