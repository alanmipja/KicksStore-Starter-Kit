import 'package:get/get.dart';

import '../../../data/local/product_local_datasource.dart';
import '../../../data/repository/product_repository.dart';
import '../../../data/remote/product_remote_datasource.dart';
import '../../home/bindings/home_binding.dart';
import '../controllers/wishlist_controller.dart';
import '../../../core/network/dio_client.dart';

class WishlistBinding extends Bindings {
  @override
  void dependencies() {
    HomeBinding.registerDependencies();
    if (!Get.isRegistered<DioClient>()) {
      Get.lazyPut<DioClient>(() => DioClient());
    }
    if (!Get.isRegistered<ProductRemoteDataSource>()) {
      Get.lazyPut<ProductRemoteDataSource>(
        () => ProductRemoteDataSourceImpl(Get.find<DioClient>()),
      );
    }
    if (!Get.isRegistered<ProductLocalDataSource>()) {
      Get.lazyPut<ProductLocalDataSource>(() => ProductLocalDataSourceImpl());
    }
    if (!Get.isRegistered<ProductRepository>()) {
      Get.lazyPut<ProductRepository>(
        () => ProductRepositoryImpl(
          Get.find<ProductRemoteDataSource>(),
          Get.find<ProductLocalDataSource>(),
        ),
      );
    }
    Get.lazyPut<WishlistController>(() => WishlistController());
  }
}
