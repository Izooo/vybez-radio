class VybezUser {
  VybezUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.photoUrl,
  });

  int id;
  String name;
  String email;
  String phone;
  String? photoUrl;

  factory VybezUser.fromJson(Map<String, dynamic> json) => VybezUser(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    phone: json["phone"],
    photoUrl: json["photoUrl"],

  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "phone": phone,
    "photoUrl": photoUrl,
  };
}
