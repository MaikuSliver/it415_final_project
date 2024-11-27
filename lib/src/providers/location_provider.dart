import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:babysitterapp/src/controllers.dart';
import 'package:babysitterapp/src/providers.dart';
import 'package:babysitterapp/src/services.dart';
import 'package:babysitterapp/src/models.dart';

final Provider<LocationRepository> locationRepositoryProvider =
    Provider<LocationRepository>((ProviderRef<LocationRepository> ref) {
  final LoggerService logger = ref.watch(loggerService);
  final HttpApiService httpApi = ref.watch(httpApiServiceProvider);
  return LocationRepository(logger, httpApi);
});

final StateNotifierProvider<LocationController, LocationState>
    locationControllerProvider =
    StateNotifierProvider<LocationController, LocationState>(
        (StateNotifierProviderRef<LocationController, LocationState> ref) {
  final LocationRepository locationService =
      ref.watch(locationRepositoryProvider);
  return LocationController(locationService);
});

final StateProvider<double> distanceService =
    StateProvider<double>((StateProviderRef<double> ref) => 1);