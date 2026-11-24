import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 05 - DataTable Sorting',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CarTableScreen(),
    );
  }
}

class Car {
  final String make;
  final String model;
  final double price;

  const Car({required this.make, required this.model, required this.price});
}

class CarTableScreen extends StatefulWidget {
  const CarTableScreen({super.key});

  @override
  State<CarTableScreen> createState() => _CarTableScreenState();
}

class _CarTableScreenState extends State<CarTableScreen> {
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  final List<Car> _cars = [
    const Car(make: 'Toyota', model: 'Vios', price: 89000),
    const Car(make: 'Honda', model: 'Civic', price: 145000),
    const Car(make: 'Perodua', model: 'Myvi', price: 50000),
    const Car(make: 'Proton', model: 'X50', price: 86000),
    const Car(make: 'Mazda', model: 'CX-5', price: 145000),
    const Car(make: 'BMW', model: '320i', price: 260000),
  ];

  void _sort<T>(
    Comparable<T> Function(Car car) getField,
    int columnIndex,
    bool ascending,
  ) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;

      _cars.sort((a, b) {
        final result = Comparable.compare(getField(a), getField(b));

        return ascending ? result : -result;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Car Information'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Car List',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                sortColumnIndex: _sortColumnIndex,
                sortAscending: _sortAscending,
                columns: [
                  DataColumn(
                    label: const Text('Car Make'),
                    onSort: (columnIndex, ascending) {
                      _sort((car) => car.make, columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: const Text('Model'),
                    onSort: (columnIndex, ascending) {
                      _sort((car) => car.model, columnIndex, ascending);
                    },
                  ),
                  DataColumn(
                    label: const Text('Price (RM)'),
                    numeric: true,
                    onSort: (columnIndex, ascending) {
                      _sort((car) => car.price, columnIndex, ascending);
                    },
                  ),
                ],
                rows: _cars.map((car) {
                  return DataRow(
                    cells: [
                      DataCell(Text(car.make)),
                      DataCell(Text(car.model)),
                      DataCell(Text(car.price.toStringAsFixed(2))),
                    ],
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
