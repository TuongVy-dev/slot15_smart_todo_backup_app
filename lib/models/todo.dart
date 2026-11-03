class Todo {
  String title;
  bool done;

  Todo({required this.title, this.done = false});

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'done': done,
    };
  }

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      title: json['title'] as String,
      // JSON thiếu "done" thì coi như chưa xong, tránh crash khi import
      done: (json['done'] as bool?) ?? false,
    );
  }
}
