import 'package:get/get.dart';

class LoadingController extends GetxController {
  final RxBool _loading = false.obs;

  ///get value
  bool get loading => _loading.value;

  isLoading(bool value) => _loading.value = value;
}
