import 'package:get/get.dart';
import 'package:getx_constants/common/data/app_urls.dart';

import '../common/data/api/api_client.dart';

class DashboardRepository extends GetxService {
  ApiClient apiClient;

  DashboardRepository({required this.apiClient});

  // Future<Response> getLoginData() async {
  //   return await apiClient.getData(AppUrls.loginUrl);
  // }

  Future<Response> postUserTicketStatus(dynamic body) async {
    return await apiClient.postData(AppUrls.ticketData, body);
  }
 
  Future<Response> postPartyTicketStatus(dynamic body) async {
    return await apiClient.postData(AppUrls.partyTicketData, body);
  }
  
  Future<Response> postUpdatedStatus(dynamic body) async {
    return await apiClient.postData(AppUrls.ticketUpdate, body);
  }
}
