import '../../Data/models/Update_profile.dart';
import '../repositories/user_repository.dart';

class UpdateProfile {
  final UserRepository repository;
  UpdateProfile(this.repository);

  Future<String> call(UpdateProfileModel profile) async {
    return await repository.updateProfile(profile);
  }
}