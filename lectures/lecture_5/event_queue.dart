import 'dart:async';

void main() {
  print('1. Synkron kod körs först');
  
  // Event queue (lägre prioritet)
  Future(() {
    print('4. Event queue task');
  });
  
  Future.delayed(Duration(milliseconds: 50), () {
    print('5. Delayed event körs sist');
  });
  
  // Microtask queue (högre prioritet)
  scheduleMicrotask(() {
    print('3. Microtask körs före alla event queue tasks');
  });
  
  print('2. Mer synkron kod');

  
  // Utskrift:
  // 1. Synkron kod körs först
  // 2. Mer synkron kod
  // 3. Microtask körs före alla event queue tasks
  // 4. Event queue task
  // 5. Delayed event körs sist
}