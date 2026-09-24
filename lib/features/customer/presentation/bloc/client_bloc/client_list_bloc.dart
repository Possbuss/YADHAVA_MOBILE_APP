import 'dart:async';

import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';

import '../../../../auth/data/login_model.dart';
import '../../../../auth/domain/login_repo.dart';
import '../../../data/client_active_inactive_model.dart';
import '../../../data/client_model.dart';
import '../../../domain/client_repo.dart';

part 'client_list_event.dart';
part 'client_list_state.dart';

class ClientListBloc extends Bloc<ClientListEvent, ClientListState> {
  final GetClientListRepo clientListRepo;
  final GetLoginRepo _loginRepo = GetLoginRepo();
  List<ClientModel> _allClients = []; // Store the full client list

  ClientListBloc(this.clientListRepo) : super(ClientListInitial()) {
    on<ClientListGetEvent>(_onGetClientListEvent);
    on<SyncClientListEvent>(_onSyncClientListEvent);
    on<ClientListSearchEvent>(_onSearchClientListEvent);
    on<FetchClientLocationEvent>(_onFetchClientLocationEvent);

    on<GetActiveClientListEvent>(_onGetActiveClientList);
    on<GetInActiveClientListEvent>(_onGetInActiveClientList);
  }

  Future<void> _onGetActiveClientList(
    GetActiveClientListEvent event,
    Emitter<ClientListState> emit,
  ) async {
    emit(ClientListActiveLoading());
    try {
      final db = LocalDbHelper();
      LoginModel? loginModel = await _loginRepo.getUserLoginResponse();

      if (!event.forceRefresh) {
        final isLocalEmpty = await db.isEmptyActiveClients(loginModel?.routeId);
        if (!isLocalEmpty) {
          final localClients = await db.getActiveClients(loginModel?.routeId);
          emit(ClientListActiveLoaded(
              clientList: localClients, locations: const {}));
          return;
        }
      }

      final response = await clientListRepo.getClientListActive(
          loginModel?.companyId, loginModel?.routeId ?? 0, 0);
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final data = response.data as List<dynamic>;
        final clients =
            data.map((e) => ClientActiveInActiveModel.fromJson(e)).toList();

        await db.clearActiveClient();
        await db.insertActiveClients(clients);

        emit(ClientListActiveLoaded(clientList: clients, locations: const {}));
      } else {
        emit(ClientListError(
            message:
                'Failed to fetch company data. Status code: ${response?.statusCode}'));
      }
    } catch (ex) {
      emit(ClientListError(message: 'An error occurred: ${ex.toString()}'));
    }
  }

  Future<void> _onGetInActiveClientList(
    GetInActiveClientListEvent event,
    Emitter<ClientListState> emit,
  ) async {
    emit(ClientListInActiveLoading());
    try {
      final db = LocalDbHelper();
      LoginModel? loginModel = await _loginRepo.getUserLoginResponse();

      if (!event.forceRefresh) {
        final isLocalEmpty =
            await db.isEmptyInActiveClients(loginModel?.routeId);
        if (!isLocalEmpty) {
          final localClients = await db.getInActiveClients(loginModel?.routeId);
          emit(ClientListInActiveLoaded(
              clientList: localClients, locations: const {}));
          return;
        }
      }

      final response = await clientListRepo.getClientListInActive(
          loginModel?.companyId, loginModel?.routeId ?? 0, 0);
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final data = response.data as List<dynamic>;
        final clients =
            data.map((e) => ClientActiveInActiveModel.fromJson(e)).toList();

        await db.clearInActiveClient();
        await db.insertInActiveClients(clients);

        emit(
            ClientListInActiveLoaded(clientList: clients, locations: const {}));
      } else {
        emit(ClientListError(
            message:
                'Failed to fetch company data. Status code: ${response?.statusCode}'));
      }
    } catch (ex) {
      emit(ClientListError(message: 'An error occurred: ${ex.toString()}'));
    }
  }

  Future<void> _onSyncClientListEvent(
    SyncClientListEvent event,
    Emitter<ClientListState> emit,
  ) async {
    emit(ClientListLoading());
    try {
      final db = LocalDbHelper();
      LoginModel? loginModel = await _loginRepo.getUserLoginResponse();

      final response = await clientListRepo.getClientListAllRepo(
          loginModel?.companyId, loginModel?.routeId ?? 0, 0);
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final data = response.data as List<dynamic>;
        final clients = data.map((e) => ClientModel.fromJson(e)).toList();
        final allClients = await _mergeInactiveClients(
          clients,
          companyId: loginModel?.companyId,
          routeId: loginModel?.routeId ?? 0,
          db: db,
        );

        await db.clearClients();
        await db.insertClients(allClients);
        await db.updateClientSyncDateStamp(DateTime.now());

        _allClients = allClients;
        emit(ClientListLoaded(clientList: allClients, locations: const {}));
      } else {
        emit(ClientListError(
            message:
                'Failed to fetch company data. Status code: ${response?.statusCode}'));
      }
    } catch (ex) {
      emit(ClientListError(message: 'An error occurred: ${ex.toString()}'));
    }
  }

  Future<void> _onGetClientListEvent(
    ClientListGetEvent event,
    Emitter<ClientListState> emit,
  ) async {
    emit(ClientListLoading());
    try {
      LoginModel? loginModel = await _loginRepo.getUserLoginResponse();

      final db = LocalDbHelper();
      bool isLocalEmpty =
          await db.isEmptyClients(loginModel?.routeId, loginModel?.companyId);

      if (!event.forceRefresh && !isLocalEmpty) {
        final localClients =
            await db.getClients(loginModel?.routeId, loginModel?.companyId);
        final allClients = await _mergeInactiveClients(
          localClients,
          companyId: loginModel?.companyId,
          routeId: loginModel?.routeId ?? 0,
          db: db,
          fetchFromApi: false,
        );
        await db.insertClients(allClients);
        _allClients = allClients;
        emit(ClientListLoaded(clientList: allClients, locations: const {}));
        return;
      } else {
        final response = await clientListRepo.getClientListAllRepo(
            loginModel?.companyId, loginModel?.routeId ?? 0, 0);
        if (response != null &&
            (response.statusCode == 200 || response.statusCode == 201)) {
          final data = response.data as List<dynamic>;
          final clients = data.map((e) => ClientModel.fromJson(e)).toList();
          final allClients = await _mergeInactiveClients(
            clients,
            companyId: loginModel?.companyId,
            routeId: loginModel?.routeId ?? 0,
            db: db,
          );

          await db.clearClients();
          await db.insertClients(allClients);
          await db.updateClientSyncDateStamp(DateTime.now());

          _allClients = allClients;
          emit(ClientListLoaded(clientList: allClients, locations: const {}));
        } else {
          emit(ClientListError(
              message:
                  'Failed to fetch company data. Status code: ${response?.statusCode}'));
        }
      }
    } catch (ex) {
      emit(ClientListError(message: 'An error occurred: ${ex.toString()}'));
    }
  }

  Future<List<ClientModel>> _mergeInactiveClients(
    List<ClientModel> clients, {
    required int? companyId,
    required int routeId,
    required LocalDbHelper db,
    bool fetchFromApi = true,
  }) async {
    List<ClientActiveInActiveModel> inactiveClients = [];

    if (fetchFromApi) {
      try {
        final response =
            await clientListRepo.getClientListInActive(companyId, routeId, 0);
        if (response != null &&
            (response.statusCode == 200 || response.statusCode == 201)) {
          final data = response.data as List<dynamic>;
          inactiveClients = data
              .map((item) => ClientActiveInActiveModel.fromJson(item))
              .toList();
          await db.clearInActiveClient();
          await db.insertInActiveClients(inactiveClients);
        }
      } catch (_) {
        inactiveClients = await db.getInActiveClients(routeId);
      }
    }

    if (inactiveClients.isEmpty) {
      inactiveClients = await db.getInActiveClients(routeId);
    }

    final clientsById = <int, ClientModel>{
      for (final client in clients)
        if (client.id != null) client.id!: client,
    };

    for (final inactive in inactiveClients) {
      final clientId = inactive.clientId;
      if (clientId == null) {
        continue;
      }

      final existing = clientsById[clientId];
      clientsById[clientId] = ClientModel(
        companyId: existing?.companyId ?? companyId,
        id: clientId,
        name: existing?.name?.isNotEmpty == true
            ? existing!.name
            : inactive.clientName,
        contactPersonName: existing?.contactPersonName?.isNotEmpty == true
            ? existing!.contactPersonName
            : inactive.clientName,
        routeId: existing?.routeId ?? inactive.routeId ?? routeId,
        routeName: existing?.routeName,
        amount: existing?.amount ?? 0,
        mobile: existing?.mobile,
        salesmanId: existing?.salesmanId,
        salesmanName: existing?.salesmanName,
        latitude: existing?.latitude,
        longitude: existing?.longitude,
        transactionYear: existing?.transactionYear,
        clientSortOrder: existing?.clientSortOrder,
        isActive: 'N',
        createdDate: existing?.createdDate ?? inactive.invoiceDate,
        profilePicUrl: existing?.profilePicUrl,
        localProfileImagePath: existing?.localProfileImagePath,
      );
    }

    final result = clientsById.values.toList()
      ..sort((first, second) {
        final firstOrder = first.clientSortOrder;
        final secondOrder = second.clientSortOrder;
        if (firstOrder != null && secondOrder != null) {
          return firstOrder.compareTo(secondOrder);
        }
        if (firstOrder != null) return -1;
        if (secondOrder != null) return 1;
        return (first.name ?? '').compareTo(second.name ?? '');
      });
    return result;
  }

  Future<void> _onSearchClientListEvent(
    ClientListSearchEvent event,
    Emitter<ClientListState> emit,
  ) async {
    emit(ClientListSearchLoading()); // Emit a loading state for search
    try {
      final query = event.query.trim().toLowerCase();
      final filteredClients = _allClients.where((client) {
        return (client.name?.toLowerCase() ?? '').contains(query) ||
            (client.contactPersonName?.toLowerCase() ?? '').contains(query) ||
            (client.companyId?.toString() ?? '').contains(query) ||
            (client.id?.toString() ?? '').contains(query) ||
            (client.routeId?.toString() ?? '').contains(query) ||
            (client.amount?.toString() ?? '').contains(query) ||
            (client.mobile ?? '').contains(query) ||
            (client.createdDate ?? '').contains(query) ||
            (client.clientSortOrder ?? '').toString().contains(query);
      }).toList();

      emit(ClientListLoaded(
          clientList: filteredClients,
          locations: const {})); // Emit filtered list
    } catch (ex) {
      emit(ClientListError(
          message: 'An error occurred during search: ${ex.toString()}'));
    }
  }

  Future<void> _onFetchClientLocationEvent(
      FetchClientLocationEvent event, Emitter<ClientListState> emit) async {
    try {
      if (event.latitude == 0.0 || event.longitude == 0.0) {
        return;
      }

      List<Placemark> placemarks = await placemarkFromCoordinates(
        event.latitude,
        event.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        final address =
            '${place.subLocality}, ${place.locality}, ${place.postalCode}';

        if (state is ClientListLoaded) {
          final loadedState = state as ClientListLoaded;
          final updatedLocations =
              Map<String, String>.from(loadedState.locations);

          updatedLocations[event.clientId] = address;

          emit(ClientListLoaded(
            clientList: loadedState.clientList,
            locations: updatedLocations,
          ));
        }
      }
    } catch (_) {}
  }
}

// class ClientListBloc extends Bloc<ClientListEvent, ClientListState> {
//   final GetClientListRepo clientListRepo;
//   List<ClientModel> _allClients = []; // Store full client list
//   final Map<String, String> _locations = {}; // Store fetched locations
//   StreamSubscription? _refreshSubscription; // Auto-refresh support
//
//   ClientListBloc(this.clientListRepo) : super(ClientListInitial()) {
//     on<ClientListGetEvent>(_onGetClientListEvent);
//     on<ClientListSearchEvent>(_onSearchClientListEvent);
//     on<FetchClientLocationEvent>(_onFetchClientLocationEvent);
//
//     // Auto-refresh every 30s
//     _refreshSubscription = Stream.periodic(const Duration(seconds: 30)).listen((_) {
//       add(ClientListGetEvent());
//     });
//   }
//
//   Future<void> _onGetClientListEvent(
//       ClientListGetEvent event, Emitter<ClientListState> emit) async {
//     emit(ClientListLoading());
//     try {
//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       await prefs.reload(); // Ensure fresh data
//
//       String? savedRoute = prefs.getString('selected_route');
//       String? route = prefs.getString('route_id');
//
//       final response = await clientListRepo.getClientListRepo(
//         queryParams: {"timestamp": DateTime.now().millisecondsSinceEpoch.toString()},
//       );
//
//       if (response?.statusCode == 200 || response?.statusCode == 201) {
//         final data = response!.data as List<dynamic>;
//         final clients = data.map((e) => ClientModel.fromJson(e)).toList();
//
//         final filteredClients = (savedRoute != null && savedRoute.isNotEmpty)
//             ? clients.where((client) =>
//         client.routeName == savedRoute || client.routeId == route).toList()
//             : clients;
//
//         _allClients = filteredClients;
//         emit(ClientListLoaded(clientList: filteredClients, locations: _locations));
//       } else {
//         emit(ClientListError(
//             message: 'Failed to fetch client data. Status code: ${response?.statusCode}'));
//       }
//     } catch (ex) {
//       emit(ClientListError(message: 'An error occurred: ${ex.toString()}'));
//     }
//   }
//
//   Future<void> _onSearchClientListEvent(
//       ClientListSearchEvent event, Emitter<ClientListState> emit) async {
//     emit(ClientListSearchLoading());
//     try {
//       final query = event.query.trim().toLowerCase();
//       final filteredClients = _allClients.where((client) {
//         return (client.name?.toLowerCase() ?? '').contains(query) ||
//             (client.contactPersonName?.toLowerCase() ?? '').contains(query) ||
//             (client.companyId?.toString() ?? '').contains(query) ||
//             (client.id?.toString() ?? '').contains(query) ||
//             (client.routeId?.toString() ?? '').contains(query) ||
//             (client.amount?.toString() ?? '').contains(query) ||
//             (client.mobile ?? '').contains(query);
//       }).toList();
//
//       emit(ClientListLoaded(clientList: filteredClients, locations: _locations));
//     } catch (ex) {
//       emit(ClientListError(message: 'Search error: ${ex.toString()}'));
//     }
//   }
//
//   Future<void> _onFetchClientLocationEvent(
//       FetchClientLocationEvent event, Emitter<ClientListState> emit) async {
//     if (event.latitude == 0.0 || event.longitude == 0.0) {
//       print("⚠️ Skipping invalid coordinates for Client ID ${event.clientId}");
//       return;
//     }
//
//     try {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         event.latitude, event.longitude,
//       );
//
//       if (placemarks.isNotEmpty) {
//         Placemark place = placemarks.first;
//         final address = '${place.subLocality}, ${place.locality}, ${place.postalCode}';
//
//         print("✅ Fetched Address for Client ID ${event.clientId}: $address");
//
//         _locations[event.clientId] = address; // Update locations map
//
//         if (state is ClientListLoaded) {
//           final loadedState = state as ClientListLoaded;
//           emit(ClientListLoaded(clientList: loadedState.clientList, locations: _locations));
//         }
//       } else {
//         print("⚠️ No address found for Client ID ${event.clientId}");
//       }
//     } catch (e) {
//       print("❌ Error fetching address for Client ID ${event.clientId}: $e");
//     }
//   }
//
//   @override
//   Future<void> close() {
//     _refreshSubscription?.cancel(); // Cancel auto-refresh
//     return super.close();
//   }
// }
