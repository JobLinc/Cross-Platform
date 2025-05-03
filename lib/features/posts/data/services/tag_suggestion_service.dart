import 'package:dio/dio.dart';
import 'package:joblinc/features/connections/data/models/connectiondemoModel.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';

class TagSuggestionService {
  final Dio _dio;

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
      print('''
        === Received Response API All Companies ===
        Status: ${response.statusCode} ${response.statusMessage}
        Headers: ${response.headers}
        Data: ${response.data}
        ''');

      if (response.statusCode != 200) {
        throw Exception('Request failed with status ${response.statusCode}');
      }

      if (response.data == null) {
        throw Exception('Response data is null');
      }

      List<TaggedCompany> suggestions = [];
      final companies = response.data as List;

      for (var company in companies) {
        suggestions.add(TaggedCompany(
            id: company['id'],
            index: 0, // Will be set later when inserted
            name: company['name']));
      }
      print("=== Company Suggestions ===");
      print(suggestions);

      return suggestions;
    } catch (e) {
      print('Error fetching company suggestions: $e');
      return [];
    }
  }

  // Get detailed information for a user by ID
  Future<String?> getUserName(String userId) async {
    try {
      final response = await _dio.get('/user/u/$userId/public');
      if (response.statusCode == 200) {
        return "${response.data['firstname'] ?? ''} ${response.data['lastname'] ?? ''}";
      }
      return null;
    } catch (e) {
      print('Error fetching user details: $e');
      return null;
    }
  }
}
