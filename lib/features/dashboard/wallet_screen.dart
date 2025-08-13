import 'package:currency_converter/currency.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../mockdata/transactions.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  static const List<String> _currencyList = <String>[
    'KSH',
    'USD',
    'TSH',
    'UGX',
  ];
  String _dropdownValue = _currencyList.first;

  bool _balanceVisibility = false;
  // Store the original balance in base currency (e.g., KSH)
  final double _baseBalance = 10000.345;
  // Store the converted balance for display
  double _displayBalance = 10000.345;
  final String _obscureCharacter = '*';
  // Convert currency codes to Currency enum
  Currency _getCurrencyFromString(String currencyCode) {
    switch (currencyCode) {
      case 'KSH':
        return Currency.kes; // Kenyan Shilling
      case 'USD':
        return Currency.usd; // US Dollar
      case 'TSH':
        return Currency.tzs; // Tanzanian Shilling
      case 'UGX':
        return Currency.ugx; // Ugandan Shilling
      default:
        return Currency.kes;
    }
  }

  Future<void> _convertCurrency(String newCurrency) async {
    final messenger = ScaffoldMessenger.of(context);
    if (newCurrency == _currencyList.first) {
      // If converting back to base currency, use original balance
      setState(() {
        _displayBalance = _baseBalance;
        _dropdownValue = newCurrency;
      });
      return;
    }

    try {
      Currency fromCurrency = _getCurrencyFromString(
        _currencyList.first,
      ); // Base currency
      Currency toCurrency = _getCurrencyFromString(newCurrency);

      double? convertedAmount = await CurrencyConverter.convert(
        from: fromCurrency,
        to: toCurrency,
        amount: _baseBalance,
      );

      if (convertedAmount != null) {
        setState(() {
          _displayBalance = convertedAmount;
          _dropdownValue = newCurrency;
        });
      } else {
        // Handle conversion failure
        messenger.showSnackBar(
          SnackBar(content: Text('Currency conversion failed')),
        );
      }
    } catch (e) {
      // Handle error
      messenger.showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
    }
  }

  void _toggleBalVisibility() {
    setState(() {
      _balanceVisibility = !_balanceVisibility;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Wallet")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wallet/info Widget
                _buildContainer(),
                const SizedBox(height: 20),

                // const Divider(color: Colors.grey, thickness: 2),
                // Incoming and outgoing transaction
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Transactions",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ],
                ),
                _buildTxTypeList(),

                // Recent transactions  section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Recent transaction",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),

                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.grey,
                      size: 18,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                _buildTransactionList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildContainer() {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 2),
        gradient: LinearGradient(
          colors: [Color(0xFF1E3C72), Color(0xFF2A5298)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "Wallet Balance",
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  IconButton(
                    onPressed: _toggleBalVisibility,
                    icon: _balanceVisibility
                        ? Icon(Icons.visibility, color: Colors.white70)
                        : Icon(Icons.visibility_off, color: Colors.white70),
                  ),
                ],
              ),
              // Currency picker
              Container(
                width: 100,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400.withOpacity(.4),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.grey),
                ),
                alignment: Alignment.center,
                child: _buildDropdownButton(),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "$_dropdownValue ${_balanceVisibility ? _displayBalance.toStringAsFixed(2) : _obscureCharacter * 8}",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  DropdownButton<String> _buildDropdownButton() {
    return DropdownButton<String>(
      value: _dropdownValue,
      icon: Icon(Icons.keyboard_arrow_down_rounded),
      style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      onChanged: (String? value) {
        if (value != null && value != _dropdownValue) {
          _convertCurrency(value);
        }
      },
      items: _currencyList.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(value: value, child: Text(value));
      }).toList(),
    );
  }

  Widget _buildTxTypeList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: incomingOutgoingTx.length,
      separatorBuilder: (_, _) => SizedBox(height: 4),
      itemBuilder: (context, index) {
        final tx = incomingOutgoingTx[index];
        return ListTile(
          leading: Icon(Icons.money_rounded, color: Colors.green),
          title: Text(
            tx["name"],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          // subtitle: Text(tx["txType"], style: TextStyle(color: Colors.grey)),
          subtitle: tx["isCredit"]
              ? Text("Incoming", style: TextStyle(color: Colors.grey))
              : Text("Outgoing", style: TextStyle(color: Colors.grey)),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // tx["type"] == "Incoming"
              //     ? Icon(Icons.arrow_downward, color: Colors.green)
              //     : Icon(Icons.arrow_upward, color: Colors.red),
              Text(
                "${tx['currency']} ${tx["amount"].toStringAsFixed(2)}",
                style: TextStyle(
                  // color: tx["type"] != "Incoming" ? Colors.red : Colors.green,
                  color: tx["isCredit"] ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //Recent Traction ListTile
  Widget _buildTransactionList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length - 2,
      separatorBuilder: (_, _) =>
          Divider(color: Colors.grey, radius: BorderRadius.circular(4)),
      itemBuilder: (context, index) {
        final tx = transactions[index];
        return ListTile(
          leading: CircleAvatar(child: Icon(Icons.person)),
          title: Text(
            tx["name"],
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(DateFormat.yMMMd().format(tx["date"])),
          trailing: Text(
            "${tx["currency"]} ${tx["amount"].toStringAsFixed(2)}",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: tx["isCredit"] ? Colors.green : Colors.red,
            ),
          ),
        );
      },
    );
  }
}
