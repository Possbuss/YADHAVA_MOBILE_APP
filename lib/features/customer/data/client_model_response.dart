import 'package:Yadhava/features/customer/data/client_model.dart';

class ClientModelResponse {
  final String? message;
  final bool? result;
  final String? iDs;
  final List<ClientModel>?  mobileAppClientsLists;

  ClientModelResponse({
    this.message,
    this.result,
    this.iDs,
    this.mobileAppClientsLists
  });

  // Factory method to create a Client from JSON
  factory ClientModelResponse.fromJson(Map<String, dynamic> json) {
    return ClientModelResponse(
        message: json['message'],
        result: json['result'],
        iDs: json['iDs']??"",
        mobileAppClientsLists: (json['mobileAppClientsLists'] as List?)
            ?.map((e) => ClientModel.fromJson(e))
            .toList(),

    );
  }

  // Method to convert a Client instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'message':message,
      'result': result,
      'iDs': iDs,
      'mobileAppClientsLists':
      mobileAppClientsLists
          ?.map((e) => e.toJson())
          .toList(),
    };
  }
}

