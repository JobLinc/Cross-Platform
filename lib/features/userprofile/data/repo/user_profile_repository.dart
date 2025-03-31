// user_profile_repository.dart
import '../models/user_profile_model.dart';
import '../service/my_user_profile_api.dart';

class UserProfileRepository {
  final UserProfileApiService _apiService;
  
  // Optional in-memory cache
  UserProfile? _cachedProfile;
  
  UserProfileRepository(this._apiService);
  
  /// Gets the user profile from the API or cache if available and not expired
  Future<UserProfile> getUserProfile({bool forceRefresh = false}) async {
    
    if (!forceRefresh && _cachedProfile != null) {
      print('Returning cached user profile');
      return _cachedProfile!;
    }
    
    try {
      // Fetch fresh data from API
      final profile = await _apiService.getUserProfile();
      
      // Update cache
      _cachedProfile = profile;
      
      return profile;
    } catch (e) {
      // If we have cached data, return it on error even if expired
      if (_cachedProfile != null && !forceRefresh) {
        print('Error fetching user profile, using cached data: $e');
        return _cachedProfile!;
      }

      rethrow;
    }
  }

  void clearCache() {
    _cachedProfile = null;
  }
}