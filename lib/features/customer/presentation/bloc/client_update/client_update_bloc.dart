import 'dart:developer';

import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/client_model.dart';
import '../../../data/client_model_response.dart';
import '../../../domain/client_update_repo.dart';

part 'client_update_event.dart';
part 'client_update_state.dart';

class ClientUpdateBloc extends Bloc<ClientUpdateEvent, ClientUpdateState> {
  late ClientModelResponse _clientModelResponse;
  final UpdateClientListRepo updateClientListRepo;
  ClientUpdateBloc(this.updateClientListRepo) : super(ClientUpdateInitial()) {
    on<UpdateClient>(_onUpdate);
    on<ClientUpdateResetEvent>(_onResetState);
  }
  Future _onUpdate(
    UpdateClient event,
    Emitter<ClientUpdateState> emit,
  ) async {
    emit((ClientUpdateLoading()));
    try {
      final response =
          await updateClientListRepo.updateClientListRepo(event.clientModel);

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        String responseBody = response.data.toString();

        _clientModelResponse = ClientModelResponse.fromJson(response.data);

        if (_clientModelResponse.result == true) {
          await _storeUpdatedClient(event.clientModel);
          emit(ClientUpdateLoaded(event.clientModel));
          log("Success");
        } else {
          emit(ClientUpdateError('Unexpected response message: $responseBody'));
        }
      } else {
        emit(ClientUpdateError(
            'Failed to create customer. Status code: ${response?.statusCode ?? 'Unknown'}'));
      }
    } catch (e) {
      emit(ClientUpdateError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> _storeUpdatedClient(ClientModel submittedClient) async {
    final db = LocalDbHelper();
    final responseClients = _clientModelResponse.mobileAppClientsLists;

    if (responseClients?.isNotEmpty == true) {
      await db.insertClients(responseClients!);
      return;
    }

    // A successful update may not return the updated customer record. Persist
    // the submitted values locally while retaining fields that are not present
    // on the edit form (balance, status, sort order and profile image).
    final clientId = submittedClient.id;
    final existing = clientId == null ? null : await db.getClientById(clientId);
    final mergedClient = ClientModel(
      companyId: submittedClient.companyId ?? existing?.companyId,
      id: clientId ?? existing?.id,
      name: submittedClient.name ?? existing?.name,
      contactPersonName:
          submittedClient.contactPersonName ?? existing?.contactPersonName,
      routeId: submittedClient.routeId ?? existing?.routeId,
      routeName: submittedClient.routeName ?? existing?.routeName,
      amount: existing?.amount ?? submittedClient.amount,
      mobile: submittedClient.mobile ?? existing?.mobile,
      salesmanId: submittedClient.salesmanId ?? existing?.salesmanId,
      salesmanName: submittedClient.salesmanName ?? existing?.salesmanName,
      latitude: submittedClient.latitude ?? existing?.latitude,
      longitude: submittedClient.longitude ?? existing?.longitude,
      transactionYear:
          submittedClient.transactionYear ?? existing?.transactionYear,
      clientSortOrder:
          existing?.clientSortOrder ?? submittedClient.clientSortOrder,
      isActive: existing?.isActive ?? submittedClient.isActive,
      createdDate: existing?.createdDate ?? submittedClient.createdDate,
      profilePicUrl: existing?.profilePicUrl ?? submittedClient.profilePicUrl,
      localProfileImagePath: existing?.localProfileImagePath ??
          submittedClient.localProfileImagePath,
    );
    await db.insertClients([mergedClient]);
  }

  void _onResetState(
    ClientUpdateResetEvent event,
    Emitter<ClientUpdateState> emit,
  ) {
    emit(ClientUpdateInitial());
  }
}
