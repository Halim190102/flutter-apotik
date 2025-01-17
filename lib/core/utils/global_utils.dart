import 'package:apotik_online/core/network/dio_client.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

typedef Fr = Future<Response>;

typedef Fv = Future<void>;

typedef Fs = Future<String>;

typedef Ff = Future<FormData>;

typedef M = Map<String, dynamic>;
typedef Mf = Future<Map<String, dynamic>>;

enum GlobalState { none, loading, error }

final dioClientProvider = Provider<DioClient>((ref) => DioClient(ref));

abstract class BaseProvider extends ChangeNotifier {
  GlobalState _state = GlobalState.none;
  String _message = '';

  GlobalState get state => _state;
  String get message => _message;

  stateNone() {
    _state = GlobalState.none;
    notifyListeners();
  }

  changeGlobalState({
    required GlobalState s,
    String? message,
  }) {
    if (message != null) _message = message;

    _state = s;
    notifyListeners();
  }
}

String capitalizeEachWord(String input) {
  return input
      .split(' ')
      .map((word) => word.isNotEmpty
          ? word[0].toUpperCase() + word.substring(1).toLowerCase()
          : '')
      .join(' ');
}

String formatNumber(int value, bool currency) {
  final formatted = NumberFormat.decimalPattern('id').format(value);
  return currency ? 'Rp. $formatted' : formatted;
}
