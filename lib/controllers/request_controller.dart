import 'package:get/get.dart';
import 'package:refill_mate/database/db_helper.dart';
import 'package:refill_mate/models/request_modal.dart';
import 'package:refill_mate/models/gallon_model.dart';

class RequestController extends GetxController {
  static RequestController controller = Get.find();

  final DBHelper dbHelper = DBHelper();
  RxList<Request> myRequests = <Request>[].obs;
  RxList<Gallon> gallons = <Gallon>[].obs;
  RxBool isLoading = false.obs;

  Future<void> fetchGallons() async {
    isLoading.value = true;
    gallons.value = await dbHelper.getGallons();
    isLoading.value = false;
  }

  Future<void> fetchRequests(int userId) async {
    isLoading.value = true;
    myRequests.value = await dbHelper.getRequestsByUser(userId);
    // Optionally fetch items for each request
    for (var req in myRequests) {
      req.items = await dbHelper.getRequestItems(req.id!);
    }
    isLoading.value = false;
  }

  Future<bool> createRequest(Request request, List<RequestItem> items) async {
    isLoading.value = true;
    try {
      int reqId = await dbHelper.insertRequest(request);
      for (var item in items) {
        await dbHelper.insertRequestItem(RequestItem(
          requestId: reqId,
          gallonId: item.gallonId,
          quantity: item.quantity,
        ));
      }
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> updateRequest(Request request) async {
    isLoading.value = true;
    try {
      await dbHelper.updateRequest(request);
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> deleteRequest(int requestId) async {
    isLoading.value = true;
    try {
      await dbHelper.deleteRequest(requestId);
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }
}