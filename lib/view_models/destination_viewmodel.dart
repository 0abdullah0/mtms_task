import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtm/providers/providers.dart';

class DestinationViewModel {
  Future<void> loadDestinations(BuildContext context) async {
    context.read(destinationNotifierProvider).getDestinations();
  }
}
