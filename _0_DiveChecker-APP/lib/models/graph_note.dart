// Copyright (C) 2025 Kim DaeHyun (kernalix7@kodenet.io)
// Licensed under the Apache License, Version 2.0. See LICENSE file in the project root for terms.

/// Graph Note Model
/// 
/// Data model for notes attached to specific time points on a graph.
library;

/// 그래프 메모 데이터 모델
class GraphNote {
  final int? id;
  final double x;
  final String note;
  
  GraphNote({this.id, required this.x, required this.note});
  
  Map<String, dynamic> toMap(int sessionId) {
    return {
      'session_id': sessionId,
      'time_point': x,
      'note': note,
    };
  }
  
  factory GraphNote.fromMap(Map<String, dynamic> map) {
    return GraphNote(
      id: map['id'],
      x: map['time_point'],
      note: map['note'],
    );
  }
  
  GraphNote copyWith({
    int? id,
    double? x,
    String? note,
  }) {
    return GraphNote(
      id: id ?? this.id,
      x: x ?? this.x,
      note: note ?? this.note,
    );
  }
  
  @override
  String toString() => 'GraphNote(id: $id, x: $x, note: $note)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GraphNote &&
        other.id == id &&
        other.x == x &&
        other.note == note;
  }
  
  @override
  int get hashCode => id.hashCode ^ x.hashCode ^ note.hashCode;
}
