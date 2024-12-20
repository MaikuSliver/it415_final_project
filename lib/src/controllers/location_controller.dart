import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'dart:async';

import 'package:babysitterapp/src/constants.dart';
import 'package:babysitterapp/src/services.dart';
import 'package:babysitterapp/src/models.dart';

class LocationController extends StateNotifier<LocationState> {
  LocationController(this.locationService) : super(const LocationState());

  final LocationRepository locationService;

  Future<void> handlePermission() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await locationService.handlePermission();
      state = state.copyWith(isLoading: false);
    } on LocationServiceException catch (e) {
      state = state.copyWith(
        error: e.message,
        isLoading: false,
      );
      rethrow;
    } on LocationPermissionException catch (e) {
      state = state.copyWith(
        error: e.message,
        isLoading: false,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        error: 'Unexpected error occurred while getting location permission',
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<Position> getCurrentLocation() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await handlePermission();

      final Position? position = await locationService.getCurrentLocation();
      if (position != null) {
        state = state.copyWith(
          position: position,
          isLoading: false,
        );
        return position;
      }
      throw Exception('Failed to get current location');
    } on LocationServiceException catch (e) {
      state = state.copyWith(
        error: e.message,
        isLoading: false,
      );
      rethrow;
    } on LocationPermissionException catch (e) {
      state = state.copyWith(
        error: e.message,
        isLoading: false,
      );
      rethrow;
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      rethrow;
    }
  }

  Future<void> getAddressFromPosition() async {
    if (state.position == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final String address = await locationService.getAddressFromCoordinates(
        LatLng(state.position!.latitude, state.position!.longitude),
      );

      state = state.copyWith(
        address: address,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  StreamSubscription<Position>? _locationSubscription;

  void startLocationUpdates() {
    _locationSubscription?.cancel();

    _locationSubscription = locationService.getLocationStream().listen(
      (Position position) async {
        state = state.copyWith(position: position);
        await getAddressFromPosition();
      },
      onError: (dynamic error) {
        state = state.copyWith(
          error: error.toString(),
          isLoading: false,
        );
      },
    );
  }

  void stopLocationUpdates() {
    _locationSubscription?.cancel();
    _locationSubscription = null;
  }

  @override
  void dispose() {
    stopLocationUpdates();
    super.dispose();
  }

  Future<NominatimAPI?> getLongitudeAndLatitude(LatLng? location,
      {String? address}) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final Object result = await locationService
          .getLongitudeAndLatitude(location, address: address);

      if (result is NominatimAPI) {
        state = state.copyWith(isLoading: false);
        return result;
      } else {
        state = state.copyWith(
          error: 'Failed to get location data',
          isLoading: false,
        );
        return null;
      }
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
      return null;
    }
  }
}

// Position? useLocationUpdates(WidgetRef ref) {
//   final StreamController<Position> streamController =
//       useStreamController<Position>();
//   final LoggerService logger = ref.watch(loggerService);
//   final LocationRepository locationService = ref.watch(locationService);

//   useEffect(() {
//     logger.info('Starting location updates stream');

//     final StreamSubscription<Position> subscription =
//         locationService.getLocationStream().listen(
//       (Position position) {
//         logger.debug(
//           'Location update received',
//           <String, double>{'lat': position.latitude, 'lng': position.longitude},
//         );
//         streamController.add(position);
//       },
//       onError: (dynamic error, dynamic stackTrace) {
//         logger.error('Location stream error', error, stackTrace as StackTrace?);
//       },
//     );

//     return () {
//       logger.info('Disposing location updates stream');
//       subscription.cancel();
//     };
//   }, <Object?>[]);

//   final AsyncSnapshot<Position> snapshot = useStream(streamController.stream);
//   return snapshot.data;
// }
