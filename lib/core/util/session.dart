import 'package:Yadhava/features/auth/data/login_model.dart';
import 'package:Yadhava/features/auth/data/refresh_model.dart';
import 'package:Yadhava/features/auth/domain/login_repo.dart';
import 'package:Yadhava/features/auth/domain/refresh_repo.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decode_full/jwt_decode_full.dart';

import '../../features/splash/domain/repository.dart';

// class Session {
//   String accessToken = '';
//   String refreshToken = '';
//
//   bool firstTokenExpired = false;
//   bool secondTokenExpired = false;
//
//   final GetLoginRepo userRepo = GetLoginRepo();
//   final RefreshRepo refreshRepo = RefreshRepo();
//   final GetCompanyListRepo companyListRepo = GetCompanyListRepo();
//
//   Future<int?> getFirstCompanyId() async {
//     List<GetAllCompanyModel> companies = await companyListRepo.getStoredCompanyDetails();
//     return companies.isNotEmpty ? companies.first.companyId : null;
//   }
//
//   Future<String> tokenExpired() async {
//     try {
//       LoginModel? responseModel = await userRepo.getUserLoginResponse();
//       if (responseModel == null) {
//         throw Exception("No stored user login response found.");
//       }
//
//       accessToken = responseModel.tokken;
//       refreshToken = responseModel.refreshToken;
//
//       firstTokenExpired = jwtDecode(accessToken).isExpired ?? false;
//
//       if (!firstTokenExpired) {
//         return accessToken;
//       }
//
//       RefreshModel? refreshModel = await refreshRepo.getTokenResponse();
//       if (refreshModel != null) {
//         refreshToken = refreshModel.refreshToken;
//         accessToken = refreshModel.accessToken;
//         secondTokenExpired = jwtDecode(accessToken).isExpired ?? false;
//       }
//
//       final data = {
//         "userId": responseModel.userId,
//         "userType": responseModel.userType,
//         "companyId": responseModel.companyId,
//         "refreshToken": refreshToken
//       };
//
//       if (firstTokenExpired || secondTokenExpired) {
//         Response? response = await refreshRepo.refreshRepo(data);
//         if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
//           RefreshModel newRefreshModel = RefreshModel.fromJson(response.data);
//           await refreshRepo.storeToken(newRefreshModel);
//           return newRefreshModel.accessToken;
//         } else {
//           throw Exception("Failed to refresh token. Please login again.");
//         }
//       }
//
//       return accessToken;
//     } catch (e) {
//       throw Exception("Token processing error: ${e.toString()}");
//     }
//   }
//
// }

// class Session{
//   String accessToken = '';
//   String refreshToken = '';
//
//   String refreshAccessToken='';
//   String refreshRefreshToken='';
//
//   bool  firstTokenExpired=false;
//   bool   secondTokenExpired=false;
//
//   final GetLoginRepo userRepo = GetLoginRepo();
//   final RefreshRepo refreshRepo = RefreshRepo();
//   final GetCompanyListRepo companyListRepo = GetCompanyListRepo();
//
//   Future<String> tokenExpired()async{
//     try{
//
//       LoginModel? responseModel = await userRepo.getUserLoginResponse();
//       RefreshModel? refreshModel = await refreshRepo.getTokenResponse();
//
//       if (responseModel == null) {
//         throw Exception("No stored user login response found.");
//       }
//
//       accessToken = responseModel.tokken;
//       refreshToken = responseModel.refreshToken;
//
//       if (!firstTokenExpired) {
//         return accessToken;
//       }
//
//       if (refreshModel != null) {
//         refreshRefreshToken = refreshModel.refreshToken;
//         refreshAccessToken = refreshModel.accessToken;
//         secondTokenExpired = jwtDecode(accessToken).isExpired ?? false;
//       }
//
//       print(firstTokenExpired);
//       print(secondTokenExpired);
//
//       if(refreshAccessToken==''||refreshAccessToken.isEmpty||refreshAccessToken==null) {
//          if(firstTokenExpired){
//
//                  final data = {
//         "userId": responseModel.userId,
//         "userType": responseModel.userType,
//         "companyId": responseModel.companyId,
//         "refreshToken": refreshToken
//       };
//                  Response? response = await refreshRepo.refreshRepo(data);
//         if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
//           RefreshModel newRefreshModel = RefreshModel.fromJson(response.data);
//           await refreshRepo.storeToken(newRefreshModel);
//           return newRefreshModel.accessToken;
//         } else {
//           throw Exception("Failed to refresh token. Please login again.");
//         }
//
//          }else{
//            // if(secondTokenExpired) {
//            //   final data = {
//            //     "userId": responseModel.userId,
//            //     "userType": responseModel.userType,
//            //     "companyId": responseModel.companyId,
//            //     "refreshToken": refreshRefreshToken
//            //   };
//            //
//            //   Response? response = await refreshRepo.refreshRepo(data);
//            //   if (response != null &&
//            //       (response.statusCode == 200 || response.statusCode == 201)) {
//            //     RefreshModel newRefreshModel = RefreshModel.fromJson(
//            //         response.data);
//            //     await refreshRepo.storeToken(newRefreshModel);
//            //     return newRefreshModel.accessToken;
//            //   } else {
//            //     return refreshAccessToken;
//            //     throw Exception("Failed to refresh token. Please login again.");
//            //
//            //   }
//            // }
//            // return refreshAccessToken;
//            return accessToken;
//          }
//       }else{
//         if(secondTokenExpired) {
//           final data = {
//             "userId": responseModel.userId,
//             "userType": responseModel.userType,
//             "companyId": responseModel.companyId,
//             "refreshToken": refreshRefreshToken
//           };
//
//           Response? response = await refreshRepo.refreshRepo(data);
//           if (response != null &&
//               (response.statusCode == 200 || response.statusCode == 201)) {
//             RefreshModel newRefreshModel = RefreshModel.fromJson(
//                 response.data);
//             await refreshRepo.storeToken(newRefreshModel);
//             return newRefreshModel.accessToken;
//           } else {
//             throw Exception("Failed to refresh token. Please login again.");
//
//           }
//         }else{
//           return refreshAccessToken;
//         }
//       }
//       }catch(ex){
//       Exception(ex);
//     }
//   }
// }

class Session {
  String accessToken = '';
  String refreshToken = '';
  String refreshAccessToken = '';
  String refreshRefreshToken = '';

  bool firstTokenExpired = false;
  bool secondTokenExpired = false;

  final GetLoginRepo userRepo = GetLoginRepo();
  final RefreshRepo refreshRepo = RefreshRepo();
  final GetCompanyListRepo companyListRepo = GetCompanyListRepo();

  Future<String> tokenExpired() async {
    try {

      LoginModel? responseModel = await userRepo.getUserLoginResponse();
      RefreshModel? refreshModel = await refreshRepo.getTokenResponse();

      if (responseModel == null) {
        throw Exception("No stored user login response found.");
      }

      accessToken = responseModel.tokken;
      refreshToken = responseModel.refreshToken;
      firstTokenExpired = jwtDecode(accessToken).isExpired ?? false;

      if (!firstTokenExpired) {
        return accessToken;
      }

      if (refreshModel != null) {
        refreshRefreshToken = refreshModel.refreshToken;
        refreshAccessToken = refreshModel.accessToken;
        secondTokenExpired = jwtDecode(refreshAccessToken).isExpired ?? false;
      }

      print("First token expired: $firstTokenExpired");
      print("First token expired: $refreshRefreshToken");
      print("First token expired: $accessToken");
      print("First token expired: $refreshToken");
      print("Second token expired: $secondTokenExpired");

      if (refreshAccessToken.isEmpty) {
        if (firstTokenExpired) {
          return await _refreshToken(responseModel.userId,
              responseModel.userType, responseModel.companyId, refreshToken);
        } else {
          return accessToken;
        }
      } else {
        if (secondTokenExpired) {
          return await _refreshToken(
              responseModel.userId,
              responseModel.userType,
              responseModel.companyId,
              refreshRefreshToken);
        } else {
          return refreshAccessToken;
        }
      }
    } catch (ex) {
      print("Error in tokenExpired: $ex");
      throw Exception("Token handling failed: $ex");
    }
  }

  Future<String> _refreshToken(
      int userId, String userType, int companyId, String token) async {
    final data = {
      "userId": userId,
      "userType": userType,
      "companyId": companyId,
      "refreshToken": token
    };

    Response? response = await refreshRepo.refreshRepo(data);

    if (response != null &&
        (response.statusCode == 200 || response.statusCode == 201)) {
      RefreshModel newRefreshModel = RefreshModel.fromJson(response.data);
      await refreshRepo.storeToken(newRefreshModel);
      return newRefreshModel.accessToken;
    } else {
      throw Exception("Failed to refresh token. Please login again.");
    }
  }
}
