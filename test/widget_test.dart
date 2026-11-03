import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:slot15_smart_todo_backup_app/main.dart';
import 'package:slot15_smart_todo_backup_app/models/todo.dart';
import 'package:slot15_smart_todo_backup_app/services/json_service.dart';

void main() {
  test('export → decode → fromJson khôi phục đúng dữ liệu', () {
    final json = JsonService.exportTodos([
      Todo(title: 'Buy milk'),
      Todo(title: 'Study Flutter', done: true),
    ]);
    expect(json,
        '[{"title":"Buy milk","done":false},{"title":"Study Flutter","done":true}]');

    final restored = (jsonDecode(json) as List)
        .map((e) => Todo.fromJson(e as Map<String, dynamic>))
        .toList();
    expect(restored[1].title, 'Study Flutter');
    expect(restored[1].done, isTrue);
    expect(Todo.fromJson({'title': 'x'}).done, isFalse);
  });

  testWidgets('Add → toggle (gạch ngang) → Save in JSON', (tester) async {
    final logs = <String?>[];
    final original = debugPrint;
    debugPrint = (message, {wrapWidth}) => logs.add(message);

    await tester.pumpWidget(const MyApp());

    for (final title in ['Buy milk', 'Study Flutter', '   ']) {
      await tester.enterText(find.byType(TextField), title);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();
    }
    expect(find.byType(ListTile), findsNWidgets(2)); // chuỗi trắng bị bỏ qua

    await tester.tap(find.text('Study Flutter'));
    await tester.pump();
    final style = tester.widget<Text>(find.text('Study Flutter')).style;
    expect(style?.decoration, TextDecoration.lineThrough);

    await tester.tap(find.byIcon(Icons.save));
    debugPrint = original; // phải trả lại trước khi test kết thúc
    expect(logs.last,
        '[{"title":"Buy milk","done":false},{"title":"Study Flutter","done":true}]');
  });
}
