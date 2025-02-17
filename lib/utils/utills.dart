// utils.dart
import 'dart:typed_data';

import 'package:another_flushbar/flushbar.dart';
import 'package:another_flushbar/flushbar_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Make sure to import this

import 'package:path_provider/path_provider.dart' as path_provider;

class Utills {
  String formatDate(String date) {
  // Parse the input date string into a DateTime object
  DateTime parsedDate = DateTime.parse(date);

  // Format the date to only include the year, month, and day
  return DateFormat('yyyy-MM-dd').format(parsedDate);
}

static String convertTo24Hour(String timeStr) {
  // Parse the AM/PM time string using DateFormat from intl package
  try {
    final DateFormat inputFormat = DateFormat("hh:mm a");
    final DateFormat outputFormat = DateFormat("HH:mm");

    // Convert to DateTime and format to 24-hour format
    DateTime dateTime = inputFormat.parse(timeStr);
    return outputFormat.format(dateTime);
  } catch (e) {
    return "Invalid time format";
  }
}

  static Future<void> selectDate(
      BuildContext context, TextEditingController controller) async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (selectedDate != null) {
      // Format the selected date to mm/dd/yyyy
      String formattedDate = DateFormat('MM/dd/yyyy').format(selectedDate);
      controller.text = formattedDate; // Update the controller text
    }
  }
  static void flushBarErrorMessage(String message, BuildContext context) {
    showFlushbar(
      context: context,
      flushbar: Flushbar(
        forwardAnimationCurve: Curves.decelerate,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        padding: const EdgeInsets.all(15),
        message: message,
        duration: const Duration(seconds: 5),
        borderRadius: BorderRadius.circular(8),
        flushbarPosition: FlushbarPosition.TOP,
        // backgroundColor: const Color.fromARGB(255, 90, 89, 89),
        backgroundColor: Colors.red,
        reverseAnimationCurve: Curves.easeInOut,
        positionOffset: 20,
        icon: const Icon(
          Icons.error,
          size: 28,
          color: Colors.white,
        ),
      )..show(context),
    );
  }
   static Future<Uint8List?> pickImage() async {
    //    ImagePicker picker=ImagePicker();
    ImagePicker picker = ImagePicker();
    XFile? file = await picker.pickImage(source: ImageSource.gallery);

    if (file != null) {
      XFile compressedImage = await compressImage(file);
      return compressedImage.readAsBytes();
    }
    return null;
  }
   static Future<XFile> compressImage(XFile image) async {
    final dir = await path_provider.getTemporaryDirectory();
    final targetPath = '${dir.absolute.path}/temp.jpg';

    // converting original image to compress it
    final result = await FlutterImageCompress.compressAndGetFile(
      image.path,
      targetPath,
      minHeight: 1080, //you can play with this to reduce siz
      minWidth: 1080,
      quality: 90, // keep this high to get the original quality of image
    );
    return result!;
  }
}
