import 'package:flutter/material.dart';
import 'package:joblinc/features/posts/data/models/tagged_entity_model.dart';

class TaggedTextEditingController extends TextEditingController {
  final List<TaggedUser> taggedUsers = [];
  final List<TaggedCompany> taggedCompanies = [];

  // Track the current @ selection if any
  int? currentTagStartIndex;

  // Add a tagged user to the text
  void addTaggedUser(TaggedUser user, int indexPosition) {
    // Create a formatted mention text
    String mentionText = '@${user.name}';

    // Store the current selection
    final currentSelection = selection;
    final selectionIndex = selection.baseOffset;

    // Calculate the end of the current tag
    int tagEndIndex = indexPosition;
    while (tagEndIndex < text.length &&
        text[tagEndIndex] != ' ' &&
        text[tagEndIndex] != '\n') {
      tagEndIndex++;
    }

    // Create new text by replacing the tag text
    final beforeTag = text.substring(0, indexPosition);
    final afterTag = text.substring(tagEndIndex);

    // Replace the text
    final newText = beforeTag + mentionText + ' ' + afterTag;
    value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: indexPosition + mentionText.length + 1,
      ),
    );

    // Update the user's index to match actual position in text
    user = TaggedUser(
      id: user.id,
      index: indexPosition,
      name: user.name,
    );

    // Add to tagged users list
    taggedUsers.add(user);

    // Reset current tag tracking
    currentTagStartIndex = null;
  }

  // Add a tagged company to the text
  void addTaggedCompany(TaggedCompany company, int indexPosition) {
    // Create a formatted mention text
    String mentionText = '@${company.name}';

    // Store the current selection
    final currentSelection = selection;
    final selectionIndex = selection.baseOffset;

    // Calculate the end of the current tag
    int tagEndIndex = indexPosition;
    while (tagEndIndex < text.length &&
        text[tagEndIndex] != ' ' &&
        text[tagEndIndex] != '\n') {
      tagEndIndex++;
    }

    // Create new text by replacing the tag text
    final beforeTag = text.substring(0, indexPosition);
    final afterTag = text.substring(tagEndIndex);

    // Replace the text
    final newText = beforeTag + mentionText + ' ' + afterTag;
    value = TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(
        offset: indexPosition + mentionText.length + 1,
      ),
    );

    // Update the company's index to match actual position in text
    company = TaggedCompany(
      id: company.id,
      index: indexPosition,
      name: company.name,
    );

    // Add to tagged companies list
    taggedCompanies.add(company);

    // Reset current tag tracking
    currentTagStartIndex = null;
  }

  // Check if the cursor is currently after an @ symbol
  bool isTagging() {
    return currentTagStartIndex != null;
  }

  // Returns the current text being typed after @ for suggestion filtering
  String getCurrentTagText() {
    if (currentTagStartIndex == null ||
        selection.baseOffset <= currentTagStartIndex!) {
      return '';
    }

    return text.substring(currentTagStartIndex! + 1, selection.baseOffset);
  }

  // Start tracking a new tag at current cursor position
  void startTagging() {
    currentTagStartIndex =
        selection.baseOffset - 1; // -1 to account for @ symbol
  }

  // Stop tracking the current tag
  void stopTagging() {
    currentTagStartIndex = null;
  }

  // Check if a new character is a potential tag start
  void checkForTagStart(String value) {
    if (value.length > text.length && value[selection.baseOffset - 1] == '@') {
      startTagging();
    }
  }

  // Prepare tagged entities for API submission
  List<Map<String, dynamic>> getTaggedUsersForSubmission() {
    return taggedUsers.map((user) => user.toJson()).toList();
  }

  List<Map<String, dynamic>> getTaggedCompaniesForSubmission() {
    return taggedCompanies.map((company) => company.toJson()).toList();
  }

  // Clear all tagged entities
  void clearTags() {
    taggedUsers.clear();
    taggedCompanies.clear();
    currentTagStartIndex = null;
  }
}
