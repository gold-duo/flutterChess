// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.
import 'package:chess/chess/piece.dart';
import 'package:chess/chess/motion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chess/main.dart';

void main() {
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   // await tester.pumpWidget(const MyApp());
  //
  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);
  //
  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();
  //
  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });
  // test("_test0", () async {
  //   expect(await _test0.isolate(), -1000);
  // });
  // testAxisXY();
  // testMan();
  testMovement();
  // testMan();
}

void testMan(){
  for(int i=0;i<Piece.names.length; i++) {
    for (int x = 0; x < 9; x++) {
      for (int y = 0; y < 10; y++) {
        const color= ChessColor.red;
        const isKilled= true;
        const isSelected= true;
        final piece=Piece(i, x, y,color: color,isKilled: isKilled,isSelected: isSelected);
        print('test($i):$piece');

        test('${Piece.names[i]}-$x:$y', () {
          expect(piece.key, Piece.names[i]);
          expect(piece.x, x);
          expect(piece.y, y);
          expect(piece.key, i);
          expect(piece.color, color);
          expect(piece.isKilled, isKilled);
          expect(piece.isSelected, isSelected);
        });
      }
    }
  }
}

void testMovement(){
  for (int i = 0; i < Piece.names.length; i++) {
    for (int x = 0; x < 9; x++) {
      for (int y = 0; y < 10; y++) {
        final Motion m = motion(x, y, x, y,key:i,oldKey: i);
        print('test:${m.strMotion}');
        test('${m.strMotion}', () {
          expect(m.key, i);
          expect(m.oldKey, i);
          expect(m.oldX, x);
          expect(m.oldY, y);
          expect(m.newX, x);
          expect(m.newY, y);
        });
      }
    }
  }
}

void testAxisXY(){
    for (int x = 0; x < 9; x++) {
      for (int y = 0; y < 10; y++) {
        final xy=axisXY( x, y);
        print('testAxisXY:$xy');
        test('$xy-$x:$y', () {
          expect(xy.x, x);
          expect(xy.y, y);
        });
      }
    }
}