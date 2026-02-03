import 'dart:developer';
import 'package:Yadhava/features/customer/data/client_model_response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/client_model.dart';
import '../../../domain/create_client.dart';
import 'package:Yadhava/core/util/local_db_helper.dart';

import '../client_bloc/client_list_bloc.dart';

part 'client_create_event.dart';
part 'client_create_state.dart';

class ClientCreateBloc extends Bloc<ClientCreateEvent, ClientCreateState> {

  late ClientModelResponse  _clientModelResponse;


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
        String responseBody = response.data.toString();

        _clientModelResponse =
            ClientModelResponse.fromJson(response.data);

        if(_clientModelResponse.result == true){
          if (_clientModelResponse.mobileAppClientsLists?.isNotEmpty == true) {
            var db = LocalDbHelper();
            db.updateClients(_clientModelResponse.mobileAppClientsLists,event.clientModel.id ?? 0);
          }
          emit(ClientCreateLoaded(event.clientModel));
          log("Success");

        }
        else {
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

  void _onResetState(
    ClientResetEvent event,
    Emitter<ClientCreateState> emit,
  ) {
    emit(ClientCreateInitial());
  }
}
