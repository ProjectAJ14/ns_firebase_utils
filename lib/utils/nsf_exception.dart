import 'package:flutter/material.dart';

class NSFException implements Exception {
  NSFException({
    @required this.code,
    this.message,
    this.details,
  }) : assert(code != null);

  factory NSFException.defaultException(dynamic details) => NSFException(
        code: 'something_went_wrong',
        message: 'Something went wrong',
        details: details,
      );

  /// An error code.
  final String code;

  /// A human-readable error message, possibly null.
  final String message;

  /// Error details, possibly null.
  final dynamic details;

  @override
  String toString() => 'NSFException($code, $message, $details)';
}
