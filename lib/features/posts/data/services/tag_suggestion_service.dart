import 'package:dio/dio.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';

class TagSuggestionService {
  final Dio _dio;
  // Caches to avoid redundant API calls
  final Map<String, String> _userNameCache = {};
  final Map<String, String> _companyNameCache = {};

  TagSuggestionService(this._dio);

  // Fetch users for tagging suggestions
  Future<List<TaggedUser>> getUserSuggestions(String query) async {
    try {
      final response = await _dio.get('/connection/connected');

      if (response.statusCode != 200) {
        return [];
      }

      List<TaggedUser> suggestions = [];
      final connections = response.data as List;

      for (var connection in connections) {
        final user = UserConnection.fromJson(connection);
        final fullName = '${user.firstname} ${user.lastname}'.toLowerCase();

        if (query.isEmpty || fullName.contains(query.toLowerCase())) {
          suggestions.add(TaggedUser(
              id: user.userId,
              index: 0, // Will be set later when inserted
              name: '${user.firstname} ${user.lastname}'));
          
          // Update cache while we're at it
          _userNameCache[user.userId] = '${user.firstname} ${user.lastname}';
        }

        // Limit to 5 suggestions
        if (suggestions.length >= 5) break;
      }

      return suggestions;
    } catch (e) {
      print('Error fetching user suggestions: $e');
      return [];
    }
  }

  // Fetch companies for tagging suggestions
  Future<List<TaggedCompany>> getCompanySuggestions(String query) async {
    try {
      final response = await _dio.get('/companies',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));

      if (response.statusCode != 200) {
        throw Exception('Request failed with status ${response.statusCode}');
      }

      if (response.data == null) {
        throw Exception('Response data is null');
      }

      List<TaggedCompany> suggestions = [];
      final companies = response.data as List;

      for (var company in companies) {
        final name = company['name'].toString().toLowerCase();
        if (query.isEmpty || name.contains(query.toLowerCase())) {
          suggestions.add(TaggedCompany(
              id: company['id'],
              index: 0, // Will be set later when inserted
              name: company['name']));
              
          // Update cache
          _companyNameCache[company['id']] = company['name'];
        }
      }

      return suggestions;
    } catch (e) {
      print('Error fetching company suggestions: $e');
      return [];
    }
  }

  // Get detailed information for a user by ID (with caching)
  Future<String?> getUserName(String userId) async {
    // Return from cache if available
    if (_userNameCache.containsKey(userId)) {
      return _userNameCache[userId];
    }
    
    try {
      final response = await _dio.get('/user/u/$userId/public');
      if (response.statusCode == 200) {
        final name = "${response.data['firstname'] ?? ''} ${response.data['lastname'] ?? ''}";
        // Update cache
        _userNameCache[userId] = name;
        return name;
      }
      return null;
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }

  Future<String?> getCompanyName(String companyId) async {
    // Return from cache if available
    if (_companyNameCache.containsKey(companyId)) {
      return _companyNameCache[companyId];
    }
    
    try {
      final response = await _dio.get('/companies?id=$companyId',
          options: Options(
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
          ));
      if (response.statusCode == 200 && response.data.isNotEmpty) {
        final name = response.data[0]['name'];
        // Update cache
        _companyNameCache[companyId] = name;
        return name;
      }
      return null;
    } catch (e) {
      print('Error fetching company details: $e');
      return null;
    }
  }
}
