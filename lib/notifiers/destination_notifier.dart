import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mtm/models/destination_model.dart';
import 'package:mtm/repositories/destination_repo.dart';

abstract class DestinationState {
  const DestinationState();
}

class DestinationIntial extends DestinationState {
  const DestinationIntial();
}

class DestinationLoading extends DestinationState {
  const DestinationLoading();
}

class DestinationLoaded extends DestinationState {
  List<Destination> destinations;
  DestinationLoaded(this.destinations);
}

class DestinationError extends DestinationState {
  final String message;
  const DestinationError(this.message);
}

class DestinationNotifier extends StateNotifier<DestinationState> {
  final FakeDestinationRepository fakeDestinationRepository;
  DestinationNotifier(this.fakeDestinationRepository)
      : super(const DestinationIntial());

  Future<void> getDestinations() async {
    try {
      state = const DestinationLoading();
      final dest = await fakeDestinationRepository.fetchDestinations();
      state = DestinationLoaded(dest);
    } catch (e) {
      state = const DestinationError("There is something wrong 😥");
      rethrow;
    }
  }

  @override
  void dispose() {
    super.dispose();
  }
}
