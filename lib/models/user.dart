class MyUser {
  final String uid;
  final String email;

  MyUser({required this.uid, required this.email});
}

class UserData {
  final String uid;
  final String email;
  final String displayName;
  final String bio;
  // final String username;
  // final int followers;
  // final int followings;

  UserData(
      {required this.uid,
      required this.email,
      required this.displayName,
      required this.bio});
}
