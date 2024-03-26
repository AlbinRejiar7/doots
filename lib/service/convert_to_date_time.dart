String formatMillisecondsSinceEpoch(int millisecondsSinceEpoch) {
  DateTime dateTime =
      DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
  String period = (dateTime.hour < 12) ? 'AM' : 'PM';
  int hour = (dateTime.hour > 12) ? dateTime.hour - 12 : dateTime.hour;

  String formattedDateTime =
      '${dateTime.year}-${_twoDigits(dateTime.month)}-${_twoDigits(dateTime.day)} '
      '${_twoDigits(hour)}:${_twoDigits(dateTime.minute)}:${_twoDigits(dateTime.second)} $period';
  return formattedDateTime;
}

String _twoDigits(int n) {
  if (n >= 10) return '$n';
  return '0$n';
}
