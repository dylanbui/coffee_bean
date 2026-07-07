import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

/// A converter that handles List<String> which might be returned as:
/// 1. A real JSON List: ["a", "b"]
/// 2. A JSON stringified List: "[\"a\", \"b\"]"
/// 3. A comma-separated string: "a, b"
class SmartListStringConverter implements JsonConverter<List<String>, Object?> {
  const SmartListStringConverter();

  @override
  List<String> fromJson(Object? json) {
    if (json == null) return [];
    
    // Case 1: Already a List
    if (json is List) return json.map((e) => e.toString()).toList();
    
    // Case 2: String
    if (json is String && json.isNotEmpty) {
      final trimmed = json.trim();
      
      // If it looks like a JSON array: "["url1","url2"]"
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        try {
          final decoded = jsonDecode(trimmed);
          if (decoded is List) return decoded.map((e) => e.toString()).toList();
        } catch (_) {
          // Fallback to comma split if decode fails
        }
      }
      
      // If it's a comma-separated string or just a single URL
      return trimmed.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList();
    }

    return [];
  }

  @override
  Object? toJson(List<String> object) => object;
}

class SmartListIntConverter implements JsonConverter<List<int>, Object?> {
  const SmartListIntConverter();

  @override
  List<int> fromJson(Object? json) {
    if (json == null) return [];
    
    if (json is List) return json.map((e) => int.tryParse(e.toString()) ?? 0).toList();
    
    if (json is String && json.isNotEmpty) {
      final trimmed = json.trim();
      if (trimmed.startsWith('[') && trimmed.endsWith(']')) {
        try {
          final decoded = jsonDecode(trimmed);
          if (decoded is List) return decoded.map((e) => int.tryParse(e.toString()) ?? 0).toList();
        } catch (_) {}
      }
      return trimmed.split(',').map((s) => int.tryParse(s.trim()) ?? 0).toList();
    }
    return [];
  }

  @override
  Object? toJson(List<int> object) => object;
}
