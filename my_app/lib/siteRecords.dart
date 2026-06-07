/*
*Ella Muro
*25 May 2026
*Site Records UI
*/

//Imports section
import 'package:flutter/material.dart';
import 'site.dart';
import 'siteRepository.dart';
import 'siteService.dart';
import 'siteCard.dart';
import 'addSitesScreen.dart';

class SitesRecords extends StatefulWidget {
  const SitesRecords({super.key});

  @override
  State<SitesRecords> createState() => _SitesRecordsState();
}

class _SitesRecordsState extends State<SitesRecords> {

  //Instantiating the SiteService class into an object
  SiteService siteService = SiteService();

  //Instantiating the SiteRepository class into an object
  SiteRepository siteRepository = SiteRepository();

  //Controller for the search query for the search dialog
  final searchController = TextEditingController();

  //List to hold searched sites
  List<Site> searchedSites = [];

  //Variable to show a search error if a searched for site wasn't found
  String searchError = "";

  //Variable to hold the search query
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    load();
  }

  //Method to load sites
  Future<void> load() async {
    await siteRepository.loadSiteRecords();
    setState(() {});
  }

  //Method to search for sites
  bool search(void Function(void Function()) setDialogState) {

    //Clearing searched sites list
    searchedSites = [];

    //Getting the search query for the search dialog
    searchQuery = searchController.text;

    //Preventing the user from searching for nothing
    if(searchQuery.isEmpty) {
      searchedSites = [];
      searchError = "";
      setState(() {});
      setDialogState(() {});
      return false;
    }

    //Search results
    List<Site> results = [];
    
    //Searching the master list of sites for a match
    for(Site site in siteRepository.sites) {
      if(site.siteName.toLowerCase().trim() == searchQuery.toLowerCase().trim()) {
        results.add(site);
      }
    }

    final found  = results.isNotEmpty;

    setDialogState(() {

    if(results.isEmpty) {
      searchError = "Site Not Found";
    } else {
      searchError = "";
    }
    });

    if(found) {
      searchedSites = results;
      searchError = "";
    } else {
      searchedSites = [];
    }

    setState(() {});
    setDialogState(() {});
    return found;
  }

  //Method to show a dialog box for searching for records
  Future<void> showSearchDialog() async {

    await showDialog(
      context: context,
      builder: (BuildContext context) {

        return StatefulBuilder(

          builder: (context, setDialogState) {

            return AlertDialog(

              title: Text("Search"),

              content: Column(
                mainAxisSize: MainAxisSize.min,

                children: [

                  Text(
                    searchError,
                    style: TextStyle(color: Colors.red),
                  ),

                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Site Name..",
                    ),
                  ),
                ],
              ),

              actions: [

                //Search button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                  ),
                  onPressed: () {

                    final found = search(setDialogState);

                    if(found) {
                      Navigator.pop(context);
                    }

                  },

                  child: Text("Search"),
                ),

                // Cancel button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color.fromARGB(255, 40, 89, 113),
                  ),
                  onPressed: () {

                    Navigator.pop(context);

                  },

                  child: Text("Cancel"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.grey),
        backgroundColor: Colors.black,
        centerTitle: true,
        title: Text("Sites",
          style: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),

        actions: [
          
          //Search button
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              showSearchDialog();
            }
          ),                    

          //Add new record button
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => AddSitesScreen(
                onAdd: () async {
                  await siteRepository.loadSiteRecords();
                  setState(() {});
                },
              )
              ));
            }
          )
        ]
      ),

      body: Builder(
        builder: (context) {
          var list = searchedSites.isNotEmpty ? searchedSites : siteRepository.sites;

          return ListView.builder(
            itemCount: list.length,

            itemBuilder: (context, index) {
              final site = list[index];

              return SiteCard(
                key: ValueKey(site.siteId),
                site: site,

                onDelete: () async {
                await siteRepository.loadSiteRecords();
                setState(() {});
              },
            );
            }
          );
        },
      ),
    );
  }
}