import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse extends Object {
  @JsonKey(name: 'access_token')
  String accessToken;

  @JsonKey(name: 'douban_user_name')
  String doubanUserName;

  @JsonKey(name: 'douban_user_id')
  String doubanUserId;

  @JsonKey(name: 'expires_in')
  int expiresIn;

  @JsonKey(name: 'refresh_token')
  String refreshToken;

  LoginResponse(
    this.accessToken,
    this.doubanUserName,
    this.doubanUserId,
    this.expiresIn,
    this.refreshToken,
  );

  factory LoginResponse.fromJson(Map<String, dynamic> srcJson) =>
      _$LoginResponseFromJson(srcJson);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
