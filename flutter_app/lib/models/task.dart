class Task {
  final int? id;
  final String title;
  final String description;
  final String dueDate;
  final String status;
  final int? blockedBy;
  final bool isBlocked;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    this.blockedBy,
    this.isBlocked = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: json['dueDate'] ?? '',
      status: json['status'] ?? 'To-Do',
      blockedBy: json['blockedBy'],
      isBlocked: json['isBlocked'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'dueDate': dueDate,
      'status': status,
      'blockedBy': blockedBy,
    };
  }
}