import 'package:get/get.dart';

import '../controllers/add_category_product_controller.dart';

class AddCategoryProductBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddCategoryProductController>(
      () => AddCategoryProductController(),
    );
  }
}
