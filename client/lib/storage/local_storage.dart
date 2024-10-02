import 'package:get_storage/get_storage.dart';

mixin LocalStorage {
  // USER TYPE
  void setUserType(String userType) {
    final box = GetStorage();
    box.write('userType', userType);
  }

  String? getUserType() {
    final box = GetStorage();
    return box.read('userType');
  }

  Future<void> removeToken() async {
    final box = GetStorage();
    await box.remove('userType');
  }

  // SET USER ID
  void setUserId(String id) {
    final box = GetStorage();
    box.write('id', id);
  }

  String? getUserId() {
    final box = GetStorage();
    return box.read('id');
  }

  Future<void> removeUserId() async {
    final box = GetStorage();
    await box.remove('id');
  }
}
