import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Utils {
  static String getInitial(String? name) {
    if (name == null || name.trim().isEmpty) return "?";
    return name.trim().substring(0, 1).toUpperCase();
  }

  static String formatTimeStamp(Timestamp timestamp) {
    final datetime = timestamp.toDate();
    return DateFormat('hh:m a').format(datetime);
  }
}
