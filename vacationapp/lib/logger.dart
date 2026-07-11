/*
*Ella Muro
*24 April 2026
*Logger Class
*/

//Imports section
import 'package:logger/logger.dart';

class AppLogger {
  
  //Field of the class
  final Logger logger = Logger();

  //Methods for handling logger messages
  
  //Method to show a standard message
  void info(String message) {
    logger.i(message);
  }

  //Method for logging errors
  void error(String message) {
    logger.e(message);
  }

  //Method for logging warnings
  void warning(String message) {
    logger.w(message);
  }
}