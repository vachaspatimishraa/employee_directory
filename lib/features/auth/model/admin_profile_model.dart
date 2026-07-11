class AdminProfileModel {
  final String email;
  final String? name;
  final String? phone;
  final String? company;
  final String? designation;
  final String? website;
  final String? street;
  final String? suite;
  final String? city;
  final String? zipcode;

  AdminProfileModel({
    required this.email,
    this.name,
    this.phone,
    this.company,
    this.designation,
    this.website,
    this.street,
    this.suite,
    this.city,
    this.zipcode,
  });

  factory AdminProfileModel.fromJson(Map<String, dynamic> json) {
    return AdminProfileModel(
      email: json['email'] as String,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      company: json['company'] as String?,
      designation: json['designation'] as String?,
      website: json['website'] as String?,
      street: json['street'] as String?,
      suite: json['suite'] as String?,
      city: json['city'] as String?,
      zipcode: json['zipcode'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'phone': phone,
      'company': company,
      'designation': designation,
      'website': website,
      'street': street,
      'suite': suite,
      'city': city,
      'zipcode': zipcode,
    };
  }

  AdminProfileModel copyWith({
    String? email,
    String? name,
    String? phone,
    String? company,
    String? designation,
    String? website,
    String? street,
    String? suite,
    String? city,
    String? zipcode,
  }) {
    return AdminProfileModel(
      email: email ?? this.email,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      company: company ?? this.company,
      designation: designation ?? this.designation,
      website: website ?? this.website,
      street: street ?? this.street,
      suite: suite ?? this.suite,
      city: city ?? this.city,
      zipcode: zipcode ?? this.zipcode,
    );
  }
}
