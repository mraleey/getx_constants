import 'package:get/get.dart';
import 'package:getx_constants/common/data/app_urls.dart';

import '../common/data/api/api_client.dart';

class TicketRepo extends GetxService {
  late ApiClient apiClient;
  TicketRepo({required this.apiClient});

  Future<Response> getClientInfo() async {
    return await apiClient.getData(AppUrls.partyData);
  }
 
  Future<Response> getTeamMemberData() async {
    return await apiClient.getData(AppUrls.teamMember);
  }

  Future<Response> postClientInfo(dynamic body) async {
    return await apiClient.postData(AppUrls.loginUrl, body);
  }

  Future<Response> generateTicket(dynamic body) async {
    return await apiClient.postData(AppUrls.generateTicket, body);
  }
}
