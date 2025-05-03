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
      final response = await _dio.get(
        '/companies',
        queryParameters: {
          'search': query,
          'fields': 'name,industry,followers',
          'sort': '-followers,employees',
          'industry': 'Technology',
          'followers[gte]': '8000',
          'page': '1',
          'limit': '5',
        },
      );

      if (response.statusCode != 200) {
        return [];
      }

      List<TaggedCompany> suggestions = [];
      final companies = response.data['data'] as List;

      for (var company in companies) {
        suggestions.add(TaggedCompany(
            id: company['_id'],
            index: 0, // Will be set later when inserted
            name: company['name']));
      }

      return suggestions;
    } catch (e) {
      print('Error fetching company suggestions: $e');
      return [];
    }
  }
}
