import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String formatDate(BuildContext context, DateTime date) {
  final String locale = Localizations.localeOf(context).languageCode;

  return DateFormat.yMMMd(locale).format(date);
}

String formatFullDate(BuildContext context, DateTime date) {
  final String locale = Localizations.localeOf(context).languageCode;
  return DateFormat.yMMMMEEEEd(locale).format(date);
}
