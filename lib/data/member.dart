import 'dart:convert';

class Member {
  String key;
  String name;
  String gender;
  String phone;
  String hint;
  String code;

  Member(
    this.key,
    this.name,
    this.gender,
    this.phone,
    this.hint,
    this.code,
  );

  Member copyWith({
    String? key,
    String? name,
    String? gender,
    String? phone,
    String? hint,
    String? code,
  }) {
    return Member(
      key ?? this.key,
      name ?? this.name,
      gender ?? this.gender,
      phone ?? this.phone,
      hint ?? this.hint,
      code ?? this.code,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'key': key,
      'name': name,
      'gender': gender,
      'phone': phone,
      'hint': hint,
      'code': code,
    };
  }

  factory Member.fromMap(Map<String, dynamic> map) {
    return Member(
      map['key'] ?? '',
      map['name'] ?? '',
      map['gender'] ?? '',
      map['phone'] ?? '',
      map['hint'] ?? '',
      map['code'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory Member.fromJson(String source) => Member.fromMap(json.decode(source));
  factory Member.fromFirebase(String key, Map<dynamic, dynamic> map) => Member(
        key,
        map['name'] ?? '',
        map['gender'] ?? '',
        map['phone'] ?? '',
        map['hint'] ?? '',
        map['code'] ?? '',
      );

  @override
  String toString() {
    return 'Member(key: $key, name: $name, gender: $gender, phone: $phone, hint: $hint, code: $code)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Member &&
        other.key == key &&
        other.name == name &&
        other.gender == gender &&
        other.phone == phone &&
        other.hint == hint &&
        other.code == code;
  }

  @override
  int get hashCode {
    return key.hashCode ^
        name.hashCode ^
        gender.hashCode ^
        phone.hashCode ^
        hint.hashCode ^
        code.hashCode;
  }
}
