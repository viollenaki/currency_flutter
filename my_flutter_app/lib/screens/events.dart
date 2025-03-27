import 'package:flutter/material.dart';
import 'package:EXCHANGER/scripts/get_currencies.dart';

class EventsView extends StatefulWidget {
  const EventsView({Key? key}) : super(key: key);

  @override
  _EventsViewState createState() => _EventsViewState();
}

class _EventsViewState extends State<EventsView> {
  DateTime selectedDate = DateTime.now();
  List<String> currencyList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCurrencies();
  }

  Future<void> _loadCurrencies() async {
    setState(() {
      _isLoading = true;
    });

    // Use the existing currencies or load them if they're not loaded yet
    if (currencies.isEmpty) {
      await getCurrencies();
    }

    setState(() {
      currencyList = getCurrencyCodes();
      _isLoading = false;
    });
  }

  Widget _buildDateNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            setState(() {
              selectedDate = selectedDate.subtract(const Duration(days: 1));
            });
          },
        ),
        Text(
          '${selectedDate.day} ${_monthName(selectedDate.month)} ${selectedDate.year}',
          style: const TextStyle(fontSize: 16),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward),
          onPressed: () {
            setState(() {
              selectedDate = selectedDate.add(const Duration(days: 1));
            });
          },
        ),
      ],
    );
  }

  String _monthName(int month) {
    const months = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь',
    ];
    return months[month - 1];
  }

  Widget _buildCurrencyTable() {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black12),
        borderRadius: BorderRadius.circular(10),
      ),
      child:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                children: [
                  Row(
                    children: const [
                      SizedBox(width: 30),
                      Expanded(child: Text('Куплено')),
                      Expanded(child: Text('Курс покуп.')),
                      Expanded(child: Text('Продано')),
                      Expanded(child: Text('Курс Продаж')),
                      Expanded(child: Text('Остаток')),
                      Expanded(child: Text('Прибыль')),
                    ],
                  ),
                  ...currencyList.map(
                    (currency) => Row(
                      children: [
                        SizedBox(width: 35, child: Text(currency)),
                        ...List.generate(6, (index) {
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                                vertical: 4,
                              ),
                              child: Container(
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Colors.grey[300],
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildCashAndProfit() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [_buildInfoBox('Касса'), _buildInfoBox('Общая прибыль')],
      ),
    );
  }

  Widget _buildInfoBox(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        Container(
          width: 100,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.grey[300],
            borderRadius: BorderRadius.circular(5),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionTable() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color: Colors.black12)),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(child: Text('Валюта')),
              Expanded(child: Text('Сумма')),
              Expanded(child: Text('Курс')),
              Expanded(child: Text('Итого')),
            ],
          ),
          Container(height: 150),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          _NavItem(icon: Icons.compare_arrows, label: 'Продажа/покупка'),
          _NavItem(icon: Icons.history, label: 'История'),
          _NavItem(icon: Icons.bar_chart, label: 'Статистика'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // Navigate back to HomeView
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildDateNavigation(),
            _buildCurrencyTable(),
            _buildCashAndProfit(),
            _buildTransactionTable(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _NavItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Colors.blue),
        Text(label, style: const TextStyle(color: Colors.blue, fontSize: 12)),
      ],
    );
  }
}
