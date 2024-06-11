import 'package:get/get.dart';
import 'package:qrcode/app/modules/home/views/home_view.dart';

import '../modules/add_category_product/bindings/add_category_product_binding.dart';
import '../modules/add_category_product/views/add_category_product_view.dart';
import '../modules/add_product/bindings/add_product_binding.dart';
import '../modules/add_product/views/add_product_view.dart';
import '../modules/add_user/bindings/add_user_binding.dart';
import '../modules/add_user/views/add_user_view.dart';
import '../modules/category_product/bindings/category_product_binding.dart';
import '../modules/category_product/views/category_product_view.dart';
import '../modules/detail_product/bindings/detail_product_binding.dart';
import '../modules/detail_product/views/detail_product_view.dart';
import '../modules/detail_user/bindings/detail_user_binding.dart';
import '../modules/detail_user/views/detail_user_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home_admin/bindings/home_admin_binding.dart';
import '../modules/home_admin/views/home_admin_view.dart';
import '../modules/products/bindings/products_binding.dart';
import '../modules/products/views/products_view.dart';
import '../modules/signin/bindings/signin_binding.dart';
import '../modules/signin/views/signin_view.dart';
import '../modules/users/bindings/users_binding.dart';
import '../modules/users/views/users_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.home;

  static final routes = [
    GetPage(
      name: _Paths.home,
      page: () => HomeView(),
      // page: () => HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.signin,
      page: () => SigninView(),
      binding: SigninBinding(),
    ),
    GetPage(
      name: _Paths.detailProduct,
      page: () => DetailProductView(),
      binding: DetailProductBinding(),
    ),
    GetPage(
      name: _Paths.homeAdmin,
      page: () => HomeAdminView(),
      binding: HomeAdminBinding(),
    ),
    GetPage(
      name: _Paths.users,
      page: () => UsersView(),
      binding: UsersBinding(),
    ),
    GetPage(
      name: _Paths.addProduct,
      page: () => AddProductView(),
      binding: AddProductBinding(),
    ),
    GetPage(
      name: _Paths.categoryProduct,
      page: () => CategoryProductView(),
      binding: CategoryProductBinding(),
    ),
    GetPage(
      name: _Paths.products,
      page: () => ProductsView(),
      binding: ProductsBinding(),
    ),
    GetPage(
      name: _Paths.addUser,
      page: () => AddUserView(),
      binding: AddUserBinding(),
    ),
    GetPage(
      name: _Paths.detailUser,
      page: () => DetailUserView(),
      binding: DetailUserBinding(),
    ),
    GetPage(
      name: _Paths.addCategoryProduct,
      page: () => AddCategoryProductView(),
      binding: AddCategoryProductBinding(),
    ),
  ];
}
