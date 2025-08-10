class UpdateProfileModel {
  final String firstName;
  final String lastName;
  final String? profilePicture;

  UpdateProfileModel({
    required this.firstName,
    required this.lastName,
    this.profilePicture,
  });

  Map<String, dynamic> toJson() => {
    'firstName': firstName,
    'lastName': lastName,
    'profilePicture': profilePicture,
  };
}