/*
*Ella Muro
*July 9 2026
*Class to Handle Slot Control
*/

//Imports section
import 'weekService.dart';
import 'weekRepository.dart';
import 'selectionService.dart';
import 'selection.dart';
import 'week.dart';

class SlotControl {

  //Class instantiations
  WeekService weekService = WeekService();
  WeekRepository weekRepository = WeekRepository();
  SelectionService selectionService = SelectionService();

  //List of selections
  List<Selection> allSelections = [];

  //List of weeks
  List<Week> allWeeks = [];

  //Method to load data
  Future<void> load() async {

    //Loading selections
    allSelections = await selectionService.getSelections();

    //Loading weeks
    allWeeks = await weekRepository.loadWeekRecords();
  }

  //Method to ensure that available slots stays correct
  Future<void> ensureAvailableSlotsAccuracy(int weekId, int oldTotalSlots, int newTotalSlots) async {

    //Loading data
    await load();

    //Taken slots counter
    int takenSlots = 0;

    //Flag to represent whether oldTotalSlots is different than newTotalSlots
    bool oldAndNewTotalSlotsAreDiff = false;

    //Variable to represent the new number of available slots
    int newAvailableSlots = 0;

    //Looping through selections to determine how many slots have been taken in a week
    for(Selection selection in allSelections) {
      if(selection.weekId == weekId){
        takenSlots++;
      }
    }

    //Checking to see if newTotalSlots is different than oldTotalSlots
    if(oldTotalSlots != newTotalSlots) {
      oldAndNewTotalSlotsAreDiff = true;
    }

    //Calculating the new number of available slots if old and new total slots are different
    if(oldAndNewTotalSlotsAreDiff) {
      newAvailableSlots = newTotalSlots - takenSlots;
    }

    //Updating the number of available slots in the database
    await weekService.updateAvailableSlots(weekId: weekId, availableSlots: newAvailableSlots);
  }
}