import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:mtm/const/app_const.dart';
import 'package:mtm/models/destination_model.dart';

abstract class DestinationRepository {
  Future<List<Destination>> fetchDestinations();
}

class FakeDestinationRepository implements DestinationRepository {
  List<Destination> destinations = [];
  @override
  Future<List<Destination>> fetchDestinations() async {
    final dio = Dio();

    try {
      final res = await dio.get(AppConstants.URL);

      destinations = (jsonDecode(res.data.toString()) as List).map((dest) {
        return Destination.fromJson(dest as Map<String, dynamic>);
      }).toList();

      dio.close();
      return destinations;
    } catch (e) {
      dio.close();
      rethrow;
    }
  }
}

class NetworkException implements Exception {}
