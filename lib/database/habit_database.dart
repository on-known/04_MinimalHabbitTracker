import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:minimal_habbit_tracker/models/app_settings.dart';
import 'package:minimal_habbit_tracker/models/habit.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

/* // S E T U P */

//I N I T I A L I Z A T I O N -  D A T A B A S E

  static Future initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

//save first time data of app startup(for heatmap)
  Future saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();

    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();

      await isar.writeTxn(
        () => isar.appSettings.put(settings),
      );
    }
  }
//get first date of app startup(For heatmap)

  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();

    return settings?.firstLaunchDate;
  }

// C R U D X O P E R A T I O N

// List of habbits

  final List<Habit> currentHabits = [];

//CREATE - ADD A NEW habit

  Future addHabits(String habbitName) async {
    //create a new habbit

    final newhabits = Habit()..name = habbitName;

    //save to db

    await isar.writeTxn(
      () => isar.habits.put(newhabits),
    );

    //Fetch all the habbits from db

    // re-read from db
  }

  Future readHabits() async {
    List<Habit> fetchHabbits = await isar.habits.where().findAll();

//give to current habits

    currentHabits.clear();
    currentHabits.addAll(fetchHabbits);

//update ui

    notifyListeners();
  }

//U P D A T E - check habbit on and off

  Future updateHabbitCompletion(int id, bool isCompleted) async {
    //Find specif habit

    final habit = await isar.habits.get(id);

    //update completion status
    if (habit != null) {
      await isar.writeTxn(() async {
//if habit is completed => add the current data to the completeday list

        if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
          //today

          final today = DateTime.now();

          //add the current data if it's not already in the list

          habit.completedDays.add(DateTime(today.year, today.month, today.day));
        }

//if habit is not completed => remve the current date from list

        else {
          habit.completedDays.removeWhere((element) =>
              element.year == DateTime.now().year &&
              element.month == DateTime.now().month &&
              element.day == DateTime.now().day);
        }

        //Save the update of habits

        await isar.habits.put(habit);
      });
    }
//re-read from database
    readHabits();
  }

//U P D A T E - edit habit name

  Future updateHabbitName(int id, String newName) async {
    //find specif habit

    final habit = await isar.habits.get(id);

    if (habit != null) {
      await isar.writeTxn(
        () async {
          habit.name = newName;
        },
      );

      //update Name
    }
  }

//U P D A T E - delete habit

  Future deleteHabit(int id) async {
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
  }
}
