import 'package:intl/intl.dart';

String getCurrentDate()
{
  var now = new DateTime.now();
  var formatter = new DateFormat('yyyy-MM-dd');
  String formattedDate = formatter.format(now);
  return formattedDate;
}

String getCurrentTime()
{
  var now = new DateTime.now();
  var formatter = new DateFormat('HH:mm');
  String formattedDate = formatter.format(now);
  return formattedDate;
}
