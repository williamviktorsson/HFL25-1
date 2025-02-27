import 'dart:math' as math;

// Pattern matching med sealed klasser
sealed class Shape {}

class Square implements Shape {
  final double length;
  Square(this.length);
}

class Circle implements Shape {
  final double radius;
  Circle(this.radius);
}

// Komplett matchning garanterad av kompilatorn
double calculateArea(Shape shape) => switch (shape) {
      Square(length: var l) => l * l,
      Circle(radius: var r) => math.pi * r * r,
    };

main() {
  Shape shape = Square(10);

// Logical-OR pattern med delad guard
  switch (shape) {
    case Square(length: var x) || Circle(radius: var x) when x > 0:
      print('Non-empty symmetric shape');
    case _:
      print('Unknown shape');
  }
}
