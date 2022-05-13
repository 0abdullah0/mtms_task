import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtm/notifiers/destination_notifier.dart';
import 'package:mtm/notifiers/map_notifier.dart';
import 'package:mtm/repositories/destination_repo.dart';

final destinationRepositoryProvider = Provider((ref) {
  return FakeDestinationRepository();
});

final destinationNotifierProvider = StateNotifierProvider((ref) {
  return DestinationNotifier(ref.watch(destinationRepositoryProvider));
});

final mapNotifierProvider = StateNotifierProvider((ref) {
  return MapNotifier();
});
