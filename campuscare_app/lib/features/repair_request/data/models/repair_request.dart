import 'repair_category.dart';
import 'repair_priority.dart';
import 'repair_request_creator.dart';
import 'repair_request_status.dart';

class RepairRequest {
  const RepairRequest({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    required this.campus,
    required this.location,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.creator,
    this.imageUrl,
    this.managerNote,
  });

  final int id;
  final String title;
  final String description;
  final RepairCategory category;
  final RepairPriority priority;
  final String campus;
  final String location;
  final String? imageUrl;
  final RepairRequestStatus status;
  final String? managerNote;
  final DateTime createdAt;
  final DateTime updatedAt;
  final RepairRequestCreator creator;

  factory RepairRequest.fromJson(Map<String, dynamic> json) {
    return RepairRequest(
      id: json['id'] as int,
      title: json['title'] as String,
      description: json['description'] as String,
      category: RepairCategory.fromJson(json['category'] as String),
      priority: RepairPriority.fromJson(json['priority'] as String),
      campus: json['campus'] as String,
      location: json['location'] as String,
      imageUrl: json['imageUrl'] as String?,
      status: RepairRequestStatus.fromJson(json['status'] as String),
      managerNote: json['managerNote'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      creator: RepairRequestCreator.fromJson(
        json['creator'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category.toJson(),
      'priority': priority.toJson(),
      'campus': campus,
      'location': location,
      'imageUrl': imageUrl,
      'status': status.toJson(),
      'managerNote': managerNote,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'creator': creator.toJson(),
    };
  }
}
