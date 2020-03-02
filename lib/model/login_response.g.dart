// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) {
  return LoginResponse(
      json['access_token'] as String,
      json['douban_user_name'] as String,
      json['douban_user_id'] as String,
      json['expires_in'] as int,
      json['refresh_token'] as String);
}

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'access_token': instance.accessToken,
      'douban_user_name': instance.doubanUserName,
      'douban_user_id': instance.doubanUserId,
      'expires_in': instance.expiresIn,
      'refresh_token': instance.refreshToken
    };
