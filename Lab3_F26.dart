// lab3.dart - Campus Cafe Order System
// Name: Humaira Nadeem
//Roll no: 04072313009

const String rollNo = '04072313009';


final int seed = int.parse(rollNo.substring(rollNo.length - 2));
final int t = seed ~/ 10;
final int u = seed % 10;

const List<String> menu = [
  'Chai',
  'Latte',
  'Mocha',
  'Samosa',
  'Brownie',
  'Sandwich',
  'Cold Coffee',
  'Fries',
  'Pakora',
  'Zinger Wrap',
];

int priceOf(int i) => 100 + 7 * i + 3 * t;

final int priceFloor = 60 + 5 * t;
final int taxPercent = 5 + t;
final int bigOrderLimit = 450 + 20 * t;
final int balanceCap = 600 + 20 * t;
final int couponPercent = 5 + t + u;

//step1

class Dish {
  late String name;
  late int price;
}

//step2

class MenuItem {
  String name;
  int price;

  MenuItem(this.name, this.price) {
    if (this.price < priceFloor) {
      this.price = priceFloor;
    }
  }

  // step3
  MenuItem.free(this.name) : price = 0;

  MenuItem.fromString(String text)
      : name = text.split(':')[0],
        price = int.parse(text.split(':')[1]);

  // Think:
  // MenuItem.free() is a separate named constructor. It directly
  // initializes price to 0, so the main MenuItem constructor body
  // containing the price-floor logic does not run.

  @override
  String toString() => '$name (Rs $price)';
}


// ================================ STEP 4 ====================================

class OrderLog {
  static OrderLog? _instance;

  final List<String> entries = [];

  OrderLog._internal();

  factory OrderLog() {
    return _instance ??= OrderLog._internal();
  }

  void add(String msg) => entries.add(msg);

  // Think:
  // _instance and _internal start with an underscore because Dart
  // uses an underscore for library-private names. This prevents them
  // from being directly accessed from other libraries.
}


// ================================ STEP 5 ====================================

class OrderLine {
  final MenuItem item;
  final int qty;
  final int total;
  final int tax;

  OrderLine(this.item, this.qty)
      : total = item.price * qty,
        tax = item.price * qty * taxPercent ~/ 100,
        assert(qty > 0, 'qty must be positive');

  // Think:
  // An initializer list runs before the constructor body and is used
  // to initialize final fields. It cannot read another field of the
  // same object while that object is still being initialized, so the
  // expression must be calculated again from the constructor parameters.

  // ============================== STEP 6 ====================================

  int get grand => total + tax;

  bool get isBigOrder => grand > bigOrderLimit;

  String get label => '${item.name} x$qty';

  // Think:
  // line.grand = 5 fails because grand is a getter with no setter.
  // To make assignment legal, a setter such as set grand(int value)
  // would have to be provided, although it would need appropriate
  // validation.
}


//step7
class StudentCard {
  final String owner;
  int _balance;

  StudentCard(this.owner) : _balance = 0;

  int get balance => _balance;

  set balance(int v) {
    if (v < 0) {
      _balance = 0;
    } else if (v > balanceCap) {
      _balance = balanceCap;
    } else {
      _balance = v;
    }
  }

  // Think:
  // Instead of silently clamping an invalid value, a setter could
  // throw an exception or otherwise reject the invalid value.
}


// ================================ STEP 10 ===================================

class Coupon {
  static final Map<String, Coupon> _cache = {};

  final String code;
  final int percent;
  final int minSpend;

  Coupon(this.code, this.percent)
      : minSpend = percent * 70,
        assert(
          percent >= 1 && percent <= 50,
          'percent must be between 1 and 50',
        );

  factory Coupon.fromCode(String code) {
    return _cache.putIfAbsent(
      code,
      () => Coupon(code, couponPercent),
    );
  }

  int discountOn(int amount) {
    if (amount >= minSpend) {
      return amount * percent ~/ 100;
    }

    return 0;
  }
}


// ============================ HELPER FUNCTIONS ===============================

// Used in Step 5 and later steps.
OrderLine mainOrder() {
  return OrderLine(
    MenuItem(menu[u], priceOf(u)),
    2 + (t + u) % 5,
  );
}


// Used in Step 8, Step 9 and Step 10.
List<MenuItem> buildMenu() {
  return [
    for (int k = 0; k < 4; k++)
      MenuItem.fromString(
        '${menu[(u + 3 * k) % 10]}:${priceOf((u + 3 * k) % 10)}',
      ),
  ];
}


// Used in Step 9 and Step 10.
List<OrderLine> buildReceipt() {
  final items = buildMenu();

  return [
    for (int k = 0; k < 3; k++)
      OrderLine(
        items[k],
        1 + (t + k) % 4,
      ),
  ];
}


// ================================ STEP 1 ====================================

void step1() {
  print('--- Step 1 ---');

  final item1 = Dish();
  item1.name = menu[u];
  item1.price = priceOf(u);

  final item2 = Dish();

  final int secondIndex = (u + 1) % 10;

  item2.name = menu[secondIndex];
  item2.price = priceOf(secondIndex);

  item2.price = item2.price - u;

  print('Step 1: ${item1.name} Rs ${item1.price}');
  print('Step 1: ${item2.name} Rs ${item2.price}');
}


// ================================ STEP 2 ====================================

void step2() {
  print('--- Step 2 ---');

  final a = MenuItem(
    menu[u],
    priceOf(u),
  );

  final b = MenuItem(
    'Test Special',
    15 * u,
  );

  print('Step 2: ${a.name} Rs ${a.price}');
  print('Step 2: ${b.name} Rs ${b.price}');
}


// ================================ STEP 3 ====================================

void step3() {
  print('--- Step 3 ---');

  final freebie = MenuItem.free('Water');

  final int i = (u + 2) % 10;

  final parsed = MenuItem.fromString(
    '${menu[i]}:${priceOf(i)}',
  );

  print('Step 3: ${freebie.name} Rs ${freebie.price}');
  print('Step 3: ${parsed.name} Rs ${parsed.price}');
  print(
    'Step 3: floor=$priceFloor, free price=${freebie.price}',
  );
}


// ================================ STEP 4 ====================================

void step4() {
  print('--- Step 4 ---');

  final log1 = OrderLog();
  final log2 = OrderLog();

  for (int i = 1; i <= u + 2; i++) {
    final message = 'order #${100 * t + i}';

    if (i % 2 == 1) {
      log1.add(message);
    } else {
      log2.add(message);
    }
  }

  print('Step 4: same object? ${identical(log1, log2)}');
  print('Step 4: entries = ${log1.entries.length}');
  print('Step 4: last = ${log2.entries.last}');
}


// ================================ STEP 5 ====================================

void step5() {
  print('--- Step 5 ---');

  final line = mainOrder();

  print('Step 5: ${line.item.name} x${line.qty}');
  print('Step 5: total=${line.total} tax=${line.tax}');

  try {
    OrderLine(line.item, 0);
    print('Step 5: assert did NOT fire');
  } on AssertionError {
    print('Step 5: assert fired');
  }
}


// ================================ STEP 6 ====================================

void step6() {
  print('--- Step 6 ---');

  final line = mainOrder();

  print('Step 6: grand=${line.grand}');
  print(
    'Step 6: big order? ${line.isBigOrder} (limit $bigOrderLimit)',
  );
  print('Step 6: label=${line.label}');
}


// ================================ STEP 7 ====================================

void step7() {
  print('--- Step 7 ---');

  final card = StudentCard('S$seed');

  card.balance = seed * 10 + 50;
  print('Step 7: topped up -> ${card.balance}');

  card.balance = -seed - 1;
  print('Step 7: bad value -> ${card.balance}');

  card.balance = balanceCap - u;
  print('Step 7: reset -> ${card.balance}');

  card.balance = card.balance - mainOrder().grand;
  print('Step 7: paid order -> ${card.balance}');
}


// ================================ STEP 8 ====================================

void step8() {
  print('--- Step 8 ---');

  final items = buildMenu();

  final priciest = items.reduce(
    (a, b) => a.price > b.price ? a : b,
  );

  final sum = items.fold(
    0,
    (total, item) => total + item.price,
  );

  print('Step 8: menu = $items');
  print('Step 8: priciest = ${priciest.name}');
  print('Step 8: sum = $sum');
}


// ================================ STEP 9 ====================================

void step9() {
  print('--- Step 9 ---');

  final receipt = buildReceipt();
  final log = OrderLog();

  int receiptTotal = 0;

  for (final line in receipt) {
    print('Step 9: ${line.label} = ${line.grand}');

    receiptTotal += line.grand;

    log.add('receipt: ${line.label}');
  }

  print('Step 9: receipt total = $receiptTotal');
  print('Step 9: log size = ${log.entries.length}');
}


// ================================ STEP 10 ===================================

void step10() {
  print('--- Step 10 ---');

  final code = 'CAFE${seed.toString().padLeft(2, '0')}';

  final c1 = Coupon.fromCode(code);
  final c2 = Coupon.fromCode(code);

  final receipt = buildReceipt();

  int receiptTotal = 0;

  for (final line in receipt) {
    receiptTotal += line.grand;
  }

  final discount = c1.discountOn(receiptTotal);
  final payable = receiptTotal - discount;

  print(
    'Step 10: ${c1.code} gives ${c1.percent}% off, '
    'min spend ${c1.minSpend}',
  );

  print('Step 10: cached? ${identical(c1, c2)}');

  print(
    'Step 10: receipt $receiptTotal, '
    'discount $discount, '
    'payable $payable',
  );
}


// ================================= MAIN ======================================

void main() {
  print('Seed: $seed (t=$t, u=$u)');

  step1();
  step2();
  step3();
  step4();
  step5();
  step6();
  step7();
  step8();
  step9();
  step10();
}


// ============================== WRAP-UP =====================================

// Q1:
// The this. shorthand saves constructor boilerplate because it automatically
// assigns the constructor parameters to fields with the same names.

// Q2:
// A named constructor is useful when a class needs different ways to create
// an object, such as MenuItem.free() or MenuItem.fromString(). A factory
// constructor is useful when object creation needs special control, such as
// returning an existing cached or shared object.

// Q3:
// An initializer list runs before the constructor body and is used to
// initialize final fields or compute values before the body executes.
// A constructor body runs afterward and can perform additional logic or
// modify non-final fields.

// Q4:
// A getter is useful when a value is computed from other data instead of
// being stored separately. A setter is useful when assignment needs
// validation or control before changing the stored value.
