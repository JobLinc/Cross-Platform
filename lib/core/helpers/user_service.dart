import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class UserService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  // Storage keys
  static const String _userIdKey = 'user_id';
  static const String _firstnameKey = 'firstname';
  static const String _lastnameKey = 'lastname';
  static const String _usernameKey = 'username';
  static const String _emailKey = 'email';
  static const String _headlineKey = 'headline';
  static const String _profilePictureKey = 'profile_picture';
  static const String _coverPictureKey = 'cover_picture';
  static const String _connectionStatusKey = 'connection_status';
  static const String _countryKey = 'country';
  static const String _cityKey = 'city';
  static const String _biographyKey = 'biography';
  static const String _phoneNumberKey = 'phone_number';
  static const String _numberOfConnectionsKey = 'number_of_connections';
  static const String _matualConnectionsKey = 'matual_connections';
  static const String _isFollowingKey = 'is_following';
  static const String _visibilityKey = 'visibility';

  // Save complete user profile data
  static Future<void> saveUserData(
      {required String userId,
      required String firstname,
      required String lastname,
      String? username,
      required String email,
      String? headline,
      String? profilePicture,
      String? coverPicture,
      String? connectionStatus,
      String? country,
      String? city,
      String? biography,
      String? phoneNumber,
      int? numberOfConnections,
      int? matualConnections,
      bool? isFollowing,
      String? visibility}) async {
    await _storage.write(key: _userIdKey, value: userId);
    await _storage.write(key: _firstnameKey, value: firstname);
    await _storage.write(key: _lastnameKey, value: lastname);

    if (username != null)
      await _storage.write(key: _usernameKey, value: username);
    await _storage.write(key: _emailKey, value: email);
    if (headline != null)
      await _storage.write(key: _headlineKey, value: headline);
    if (profilePicture != null)
      await _storage.write(key: _profilePictureKey, value: profilePicture);
    if (coverPicture != null)
      await _storage.write(key: _coverPictureKey, value: coverPicture);
    if (connectionStatus != null)
      await _storage.write(key: _connectionStatusKey, value: connectionStatus);
    if (country != null) await _storage.write(key: _countryKey, value: country);
    if (city != null) await _storage.write(key: _cityKey, value: city);
    if (biography != null)
      await _storage.write(key: _biographyKey, value: biography);
    if (phoneNumber != null)
      await _storage.write(key: _phoneNumberKey, value: phoneNumber);

    if (numberOfConnections != null) {
      await _storage.write(
          key: _numberOfConnectionsKey, value: numberOfConnections.toString());
    }

    if (matualConnections != null) {
      await _storage.write(
          key: _matualConnectionsKey, value: matualConnections.toString());
    }

    if (isFollowing != null) {
      await _storage.write(key: _isFollowingKey, value: isFollowing.toString());
    }
    if (visibility != null) {
      await _storage.write(key: _visibilityKey, value: visibility);
    }
  }

  // Save user data from JSON
  static Future<void> saveUserDataFromJson(Map<String, dynamic> json) async {
    await saveUserData(
      userId: json['userId'] ?? '',
      firstname: json['firstname'] ?? '',
      lastname: json['lastname'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      headline: json['headline'] ?? '',
      profilePicture: json['profilePicture'] ?? '',
      coverPicture: json['coverPicture'] ?? '',
      connectionStatus: json['connectionStatus'] ?? 'NotConnected',
      country: json['country'] ?? '',
      city: json['city'] ?? '',
      biography: json['biography'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      numberOfConnections: json['numberOfConnections'] ?? 0,
      matualConnections: json['mutualConnections'] ?? 0,
      isFollowing: json['isFollowing'] ?? false,
      visibility: json['visibility'] ?? 'Public',
    );
  }

  // Get complete user profile data
  static Future<Map<String, dynamic>> getUserData() async {
    final userId = await _storage.read(key: _userIdKey) ?? '';
    final firstname = await _storage.read(key: _firstnameKey) ?? '';
    final lastname = await _storage.read(key: _lastnameKey) ?? '';
    final username = await _storage.read(key: _usernameKey) ?? '';
    final email = await _storage.read(key: _emailKey) ?? '';
    final headline = await _storage.read(key: _headlineKey) ?? '';
    final profilePicture = await _storage.read(key: _profilePictureKey) ?? '';
    final coverPicture = await _storage.read(key: _coverPictureKey) ?? '';
    final connectionStatus =
        await _storage.read(key: _connectionStatusKey) ?? '';
    final country = await _storage.read(key: _countryKey) ?? '';
    final city = await _storage.read(key: _cityKey) ?? '';
    final biography = await _storage.read(key: _biographyKey) ?? '';
    final phoneNumber = await _storage.read(key: _phoneNumberKey) ?? '';

    final numberOfConnectionsStr =
        await _storage.read(key: _numberOfConnectionsKey);
    final matualConnectionsStr =
        await _storage.read(key: _matualConnectionsKey);
    final isFollowingStr = await _storage.read(key: _isFollowingKey);
    final visibility = await _storage.read(key: _visibilityKey);

    return {
      'userId': userId,
      'firstname': firstname,
      'lastname': lastname,
      'username': username,
      'email': email,
      'headline': headline,
      'profilePicture': profilePicture,
      'coverPicture': coverPicture,
      'connectionStatus': connectionStatus,
      'country': country,
      'city': city,
      'biography': biography,
      'phoneNumber': phoneNumber,
      'numberOfConnections': numberOfConnectionsStr != null
          ? int.tryParse(numberOfConnectionsStr) ?? 0
          : 0,
      'matualConnections': matualConnectionsStr != null
          ? int.tryParse(matualConnectionsStr) ?? 0
          : 0,
      'isFollowing': isFollowingStr == 'true',
      'visibility': visibility
    };
  }

  // Individual getters for user data
  static Future<String> getUserId() async =>
      await _storage.read(key: _userIdKey) ?? '';
  static Future<String> getFirstname() async =>
      await _storage.read(key: _firstnameKey) ?? '';
  static Future<String> getLastname() async =>
      await _storage.read(key: _lastnameKey) ?? '';
  static Future<String> getUsername() async =>
      await _storage.read(key: _usernameKey) ?? '';
  static Future<String> getEmail() async =>
      await _storage.read(key: _emailKey) ?? '';
  static Future<String> getHeadline() async =>
      await _storage.read(key: _headlineKey) ?? '';
  static Future<String> getProfilePicture() async =>
      await _storage.read(key: _profilePictureKey) ?? '';
  static Future<String> getCoverPicture() async =>
      await _storage.read(key: _coverPictureKey) ?? '';
  static Future<String> getVisibilityPicture() async =>
      await _storage.read(key: _visibilityKey) ?? 'Public';

  // Clear all user data
  static Future<void> clearUserData() async {
    await _storage.deleteAll();
  }
}
