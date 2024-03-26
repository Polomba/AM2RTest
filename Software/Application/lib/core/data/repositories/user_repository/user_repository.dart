import '../../../../core/data/models/user/user_model.dart';

abstract class UserRepository {
  Future<UserModel?> registerWithEmailAndPassword(String name, String email,
      String password, String phoneNumber, String emergencyContact);
  Future<UserModel> getUser(String userId);
  Future<void> editUser(String userId, Map<String, dynamic> data);
  Future<void> deleteUser(String userId);
  Future<UserModel> loginWithEmailAndPassword(String email, String password);
}
