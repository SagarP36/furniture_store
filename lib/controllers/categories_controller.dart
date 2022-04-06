import 'package:furniture_store/utils/apis.dart';
import 'package:furniture_store/utils/commons.dart';
import 'package:furniture_store/utils/custom_http.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController {
  final http = CustomHttp();
  var categories = [].obs;

  @override
  void onInit() {
    super.onInit();
    getCategories();
  }

  getCategories() async {
    var response = await http.get(url: getCategoriesApi);
    if (response != null && response['success']) {
      categories.value = response['categories'];
    }
  }

  addCategory({required String category}) async {
    var response =
        await http.post(url: addCategoryApi, body: {'category': category});
    if (response != null && response['success']) {
      categories.value = response['categories'];
      Get.back();
      showMessage(message: response['message'], isError: false);
    } else {
      showMessage(
          message:
              response != null ? response["message"] : 'Something Went Wrong!',
          isError: true);
    }
  }

  updateCategory({required String category, required String id}) async {
    var response = await http
        .post(url: editCategoryApi, body: {'category': category, 'id': id});
    if (response != null && response['success']) {
      categories.value = response['categories'];
      Get.back();
      showMessage(message: response['message'], isError: false);
    } else {
      showMessage(
          message:
              response != null ? response["message"] : 'Something Went Wrong!',
          isError: true);
    }
  }
}
