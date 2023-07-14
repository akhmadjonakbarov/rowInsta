class GetUserProfile {
  final bool? success;
  final Instagram? instagram;
  const GetUserProfile({this.success, this.instagram});
  GetUserProfile copyWith({bool? success, Instagram? instagram}) {
    return GetUserProfile(
        success: success ?? this.success,
        instagram: instagram ?? this.instagram);
  }

  Map<String, Object?> toJson() {
    return {'success': success, 'instagram': instagram?.toJson()};
  }

  static GetUserProfile fromJson(Map<String, Object?> json) {
    return GetUserProfile(
        success: json['success'] == null ? null : json['success'] as bool,
        instagram: json['instagram'] == null
            ? null
            : Instagram.fromJson(json['instagram'] as Map<String, Object?>));
  }

  @override
  String toString() {
    return '''GetUserProfile(
                success:$success,
instagram:${instagram.toString()}
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is GetUserProfile &&
        other.runtimeType == runtimeType &&
        other.success == success &&
        other.instagram == instagram;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, success, instagram);
  }
}

class Instagram {
  final String? id;
  final String? instaID;
  final String? profilePic;
  final String? usrName;
  final String? fullName;
  final int? follower;
  final int? following;
  final String? createdAt;
  final String? updatedAt;
  final int? V;
  const Instagram(
      {this.id,
      this.instaID,
      this.profilePic,
      this.usrName,
      this.fullName,
      this.follower,
      this.following,
      this.createdAt,
      this.updatedAt,
      this.V});
  Instagram copyWith(
      {String? id,
      String? instaID,
      String? profilePic,
      String? usrName,
      String? fullName,
      int? follower,
      int? following,
      String? createdAt,
      String? updatedAt,
      int? V}) {
    return Instagram(
        id: id ?? this.id,
        instaID: instaID ?? this.instaID,
        profilePic: profilePic ?? this.profilePic,
        usrName: usrName ?? this.usrName,
        fullName: fullName ?? this.fullName,
        follower: follower ?? this.follower,
        following: following ?? this.following,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        V: V ?? this.V);
  }

  Map<String, Object?> toJson() {
    return {
      '_id': id,
      'instaID': instaID,
      'profilePic': profilePic,
      'usrName': usrName,
      'fullName': fullName,
      'follower': follower,
      'following': following,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      '__v': V
    };
  }

  static Instagram fromJson(Map<String, Object?> json) {
    return Instagram(
        id: json['_id'] == null ? null : json['_id'] as String,
        instaID: json['instaID'] == null ? null : json['instaID'] as String,
        profilePic:
            json['profilePic'] == null ? null : json['profilePic'] as String,
        usrName: json['usrName'] == null ? null : json['usrName'] as String,
        fullName: json['fullName'] == null ? null : json['fullName'] as String,
        follower: json['follower'] == null ? null : json['follower'] as int,
        following: json['following'] == null ? null : json['following'] as int,
        createdAt:
            json['createdAt'] == null ? null : json['createdAt'] as String,
        updatedAt:
            json['updatedAt'] == null ? null : json['updatedAt'] as String,
        V: json['__v'] == null ? null : json['__v'] as int);
  }

  @override
  String toString() {
    return '''Instagram(
                id:$id,
instaID:$instaID,
profilePic:$profilePic,
usrName:$usrName,
fullName:$fullName,
follower:$follower,
following:$following,
createdAt:$createdAt,
updatedAt:$updatedAt,
V:$V
    ) ''';
  }

  @override
  bool operator ==(Object other) {
    return other is Instagram &&
        other.runtimeType == runtimeType &&
        other.id == id &&
        other.instaID == instaID &&
        other.profilePic == profilePic &&
        other.usrName == usrName &&
        other.fullName == fullName &&
        other.follower == follower &&
        other.following == following &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.V == V;
  }

  @override
  int get hashCode {
    return Object.hash(runtimeType, id, instaID, profilePic, usrName, fullName,
        follower, following, createdAt, updatedAt, V);
  }
}
