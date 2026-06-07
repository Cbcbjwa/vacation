/*
*Ella Muro
*3 June 2026
*Class to Handle Site Constraints
*/

//Imports section
import 'package:my_app/selection.dart';

import 'siteService.dart';
import 'userRepository.dart';
import 'siteRepository.dart';
import 'selectionService.dart';
import 'site.dart';
import 'week.dart';
import 'selection.dart';
import 'weekRepository.dart';
import 'user.dart';

class SiteConstraintsChecker {

  //Fields of the class
  bool tooManyDocsFromSameSitePickedWeek = false;
  int repeatWeeksCount = 0;

  //Instantiating SiteRepository into an object
  SiteRepository siteRepository = SiteRepository();

  //Instantiating UserRepository into an object
  UserRepository userRepository = UserRepository();

  //Instantiating SelectionService into an object
  SelectionService selectionService = SelectionService();

  //Instantiating WeekRepository into an object
  WeekRepository weekRepository = WeekRepository();

  //List of sites
  List<Site> sites = [];

  //List of selections
  List<Selection> selections = [];

  //List of users
  List<User> users = [];

  //Load method
  Future<void> load () async {

    //Loading selections
    selections = await selectionService.getSelections();

    //Loading sites
    sites = await siteRepository.loadSiteRecords();

    //Loading users
    users = await userRepository.loadRecords();

  }

  //Method to determine if too many docs from the same site have selected the same week
  Future<String?> canSelectWeek(
    int weekId,
    String siteName,
    {int? selectionIdToIgnore}
    
  ) async {
    
    await load();

    int siteCountForWeek = 0;
    List<String> violatingSites = [];

    for(final selection in selections) {

      if(selection.selectionId == selectionIdToIgnore) {
        continue;
      }

      if(selection.weekId != weekId) {
        continue;
      }

      final user = users.firstWhere((user) => user.id == selection.userId);

      if(user.label == siteName) {
        siteCountForWeek++;
        violatingSites.add(user.label ?? "Unknown");
      }
    }

    final site = sites.firstWhere((site) => site.siteName == siteName,
    );

    //Selection permitted
    if(siteCountForWeek < site.maxDocsOffPerWeek) {
      return null;      
    }

    final uniqueSites = violatingSites.toSet().toList();

    if(uniqueSites.length == 1) {
      return "Too many docs off from ${uniqueSites.first} this week";
    } else {
      return "Too many docs off from ${uniqueSites.join(" and ")} this week";
    }
  }
}