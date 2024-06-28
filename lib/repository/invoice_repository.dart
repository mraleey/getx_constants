import 'package:get/get.dart';
import 'package:getx_constants/common/data/app_urls.dart';

import '../common/data/api/api_client.dart';

class InvoiceRepository extends GetxService {
  ApiClient apiClient;

  InvoiceRepository({required this.apiClient});

  Future<Response> getPartyData() async {
    return await apiClient.getData(AppUrls.partyData);
  }

  Future<Response> getServices() async {
    return await apiClient.getData(AppUrls.serviceType);
  }

  Future<Response> getInvoiceMaxNo() async {
    return await apiClient.getData(AppUrls.invoiceMaxNo);
  }

  Future<Response> postInvoiceData(dynamic body) async {
    return await apiClient.postData(AppUrls.invoiceSave, body);
  }
 
  Future<Response> postInvoiceStatus(dynamic body) async {
    return await apiClient.postData(AppUrls.invoiceStatus, body);
  }
  
  Future<Response> postUpdateStatus(dynamic body) async {
    return await apiClient.postData(AppUrls.updateInvoiceStatus, body);
  }
  Future<Response> postbillingtickets(dynamic body) async {
    return await apiClient.postData(AppUrls.billingtickets, body);
  }
}
