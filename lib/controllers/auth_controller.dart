import 'package:get/get.dart';
import 'package:refill_mate/database/db_helper.dart';
import 'package:refill_mate/models/user_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthController extends GetxController {
  // Returns true if a user is logged in
  RxBool get isAuthenticated => (currentUser.value != null).obs;
  static AuthController controller = Get.find();

  final Rxn<User> currentUser = Rxn<User>();
  final DBHelper dbHelper = DBHelper();
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  RxBool isLoading = false.obs;

  Future<bool> register(String name, String email, String password) async {
    isLoading.value = true;
    try {
      final hashed = User.hashPassword(password);
      final user = User(name: name, email: email, password: hashed);
      await dbHelper.insertUser(user);
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }

  Future<bool> login(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await dbHelper.getUserByEmail(email);
      if (user == null) {
        isLoading.value = false;
        return false;
      }
      if (user.password != User.hashPassword(password)) {
        isLoading.value = false;
        return false;
      }
      currentUser.value = user;
      await storage.write(key: 'user_id', value: user.id.toString());
      isLoading.value = false;
      return true;
    } catch (e) {
      isLoading.value = false;
      return false;
    }
  }

  Future<void> logout() async {
    currentUser.value = null;
    await storage.delete(key: 'user_id');
  }

  Future<void> loadSession() async {
    final userId = await storage.read(key: 'user_id');
    if (userId != null) {
      final user = await dbHelper.getUserById(int.parse(userId));
      if (user != null) {
        currentUser.value = user;
      }
    }
  }

  Future<bool> updateProfile(String name, String email, String? profilePhotoPath) async {
    if (currentUser.value == null) return false;
    final updated = User(
      id: currentUser.value!.id,
      name: name,
      email: email,
      password: currentUser.value!.password,
      profilePhotoPath: profilePhotoPath,
    );
    final result = await dbHelper.updateUser(updated);
    if (result > 0) {
      currentUser.value = updated;
      return true;
    }
    return false;
  }
}