import 'dart:developer';

import 'package:Yadhava/core/util/local_db_helper.dart';
import 'package:Yadhava/features/customer/presentation/bloc/client_bloc/client_list_bloc.dart';
import 'package:Yadhava/features/customer/presentation/bloc/client_create/client_create_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../../data/client_model.dart';
import '../../../data/client_model_response.dart';
import '../../../domain/client_update_repo.dart';

part 'client_update_event.dart';
part 'client_update_state.dart';

class ClientUpdateBloc extends Bloc<ClientUpdateEvent, ClientUpdateState> {

  late ClientModelResponse  _clientModelResponse;
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

        _clientModelResponse =
            ClientModelResponse.fromJson(response.data);

        if(_clientModelResponse.result == true){
          if (_clientModelResponse.mobileAppClientsLists?.isNotEmpty == true) {
            var db = LocalDbHelper();
            db.updateClients(_clientModelResponse.mobileAppClientsLists,event.clientModel.id ?? 0);
          }
          emit(ClientUpdateLoaded(event.clientModel));
          log("Success");

        }else {
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

  void _onResetState(
    ClientUpdateResetEvent event,
    Emitter<ClientUpdateState> emit,
  ) {
    emit(ClientUpdateInitial());
  }
}
