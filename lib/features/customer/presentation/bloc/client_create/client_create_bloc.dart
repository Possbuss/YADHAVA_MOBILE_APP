import 'dart:developer';
import 'package:Yadhava/features/customer/data/client_model_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/client_model.dart';
import '../../../domain/client_repo.dart';
import '../../../domain/create_client.dart';
import 'package:Yadhava/core/util/local_db_helper.dart';

part 'client_create_event.dart';
part 'client_create_state.dart';

class ClientCreateBloc extends Bloc<ClientCreateEvent, ClientCreateState> {
  late ClientModelResponse _clientModelResponse;

  final CreateClientListRepo createClientListRepo;
  ClientCreateBloc(this.createClientListRepo) : super(ClientCreateInitial()) {
    on<PostClientCreate>(_onPostCreate);
    on<ClientResetEvent>(_onResetState);
  }

  Future _onPostCreate(
    PostClientCreate event,
    Emitter<ClientCreateState> emit,
  ) async {
    emit((ClientCreateLoading()));
    try {
      final response =
          await createClientListRepo.postClientListRepo(event.clientModel);

      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        _clientModelResponse = ClientModelResponse.fromJson(response.data);

        if (_clientModelResponse.result == true) {
          await _storeCreatedClient(event.clientModel);
          emit(ClientCreateLoaded(event.clientModel));
          log("Success");
        } else {
          emit(ClientCreateError(_clientModelResponse.message.toString()));
        }
      } else {
        emit(ClientCreateError(
            'Failed to create customer. Status code: ${response?.statusCode ?? 'Unknown'}'));
      }
    } catch (e) {
      emit(ClientCreateError('An error occurred: ${e.toString()}'));
    }
  }

  Future<void> _storeCreatedClient(ClientModel submittedClient) async {
    final db = LocalDbHelper();
    final responseClients = _clientModelResponse.mobileAppClientsLists;

    if (responseClients?.isNotEmpty == true) {
      await db.insertClients(responseClients!);
      return;
    }

    // Some API versions return only the newly generated customer ID.
    final idMatch = RegExp(r'\d+').firstMatch(_clientModelResponse.iDs ?? '');
    final createdClientId = int.tryParse(idMatch?.group(0) ?? '');
    if (createdClientId != null && createdClientId > 0) {
      await db.insertClients([
        ClientModel(
          companyId: submittedClient.companyId,
          id: createdClientId,
          name: submittedClient.name,
          contactPersonName: submittedClient.contactPersonName,
          routeId: submittedClient.routeId,
          routeName: submittedClient.routeName,
          amount: submittedClient.amount,
          mobile: submittedClient.mobile,
          salesmanId: submittedClient.salesmanId,
          salesmanName: submittedClient.salesmanName,
          latitude: submittedClient.latitude,
          longitude: submittedClient.longitude,
          transactionYear: submittedClient.transactionYear,
          clientSortOrder: submittedClient.clientSortOrder,
          isActive: submittedClient.isActive ?? 'Y',
          createdDate: submittedClient.createdDate,
          profilePicUrl: submittedClient.profilePicUrl,
          localProfileImagePath: submittedClient.localProfileImagePath,
        ),
      ]);
      return;
    }

    // Last-resort synchronization for a successful create response that does
    // not include either the created record or its server-generated ID.
    try {
      final response = await GetClientListRepo().getClientListAllRepo(
        submittedClient.companyId,
        submittedClient.routeId,
        0,
      );
      if (response != null &&
          (response.statusCode == 200 || response.statusCode == 201)) {
        final data = response.data as List<dynamic>;
        final clients = data.map((item) => ClientModel.fromJson(item)).toList();
        await db.insertClients(clients);
      }
    } catch (_) {
      // The server has already created the customer. Do not report the create
      // as failed and risk a duplicate retry; Home Manual Sync can recover it.
    }
  }

  void _onResetState(
    ClientResetEvent event,
    Emitter<ClientCreateState> emit,
  ) {
    emit(ClientCreateInitial());
  }
}
