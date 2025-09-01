import 'package:currency_converter/currency.dart';
import 'package:currency_converter/currency_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:intl/intl.dart';
import 'package:maverick/models/transaction.dart';
import 'package:maverick/widgets/button.dart';
import 'package:maverick/widgets/not_found.dart';

import '../../mockdata/transactions.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final txBox = Hive.box<TransactionModel>('transactions');
  final _recipientController = TextEditingController();
  final _txAmountController = TextEditingController();

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
  String _selectedGroup = '';
  bool _isLoading = false;

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

  void _sendFunds() async {
    final messenger = ScaffoldMessenger.of(context);
    final modalFormKey = GlobalKey<FormState>();

    showModalBottomSheet(
      useSafeArea: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.white24,
          child: Form(
            key: modalFormKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 10),
                  TextFormField(
                    controller: _recipientController,
                    decoration: _buildInputDecoration("Recipient"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter recipient name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _txAmountController,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                    ],
                    decoration: _buildInputDecoration("Amount to send"),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Please enter amount";
                      }
                      final amount = double.tryParse(value);
                      if (amount == null || amount <= 0) {
                        return "Please enter a valid amount";
                      }
                      // Check if amount exceeds balance
                      if (amount > _displayBalance) {
                        return "Insufficient funds";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  _isLoading
                      ? CircularProgressIndicator()
                      : button(
                          buttonTxt: "Send",
                          buttonW: double.infinity,
                          onPressed: () async {
                            if (modalFormKey.currentState!.validate()) {
                              setState(() {
                                _isLoading = true;
                              });

                              try {
                                // Capture values BEFORE clearing or closing modal
                                final recipient = _recipientController.text
                                    .trim();
                                final amount =
                                    double.tryParse(
                                      _txAmountController.text.trim(),
                                    ) ??
                                    0;

                                // Save to Hive
                                await txBox.add(
                                  TransactionModel(
                                    recipient: recipient,
                                    dateTx: DateTime.now(),
                                    txAmount: amount,
                                    currency: _dropdownValue,
                                    isCredit:
                                        false, // This should be false for outgoing transactions
                                  ),
                                );

                                // Clear the form controllers
                                _recipientController.clear();
                                _txAmountController.clear();

                                // Close the modal
                                Navigator.pop(context);

                                // Show success message
                                messenger.showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Transaction sent successfully',
                                    ),
                                  ),
                                );
                              } catch (e) {
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Error processing transaction: $e',
                                    ),
                                  ),
                                );
                              } finally {
                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            }
                          },
                          buttonTxtStyle: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                          buttonColor: Color.fromRGBO(255, 144, 94, 1),
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _toggleBalVisibility() {
    setState(() {
      _balanceVisibility = !_balanceVisibility;
    });
  }

  @override
  void dispose() {
    _recipientController.dispose();
    _txAmountController.dispose();
    super.dispose();
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
                // CTA
                _buildCTASection(),
                const SizedBox(height: 10),

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
                // _buildTransactionList(),
                _buildTxHive(),
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
          contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          leading: Icon(Icons.money_rounded, color: Colors.green),
          title: Text(
            tx["name"],
            style: TextStyle(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: tx["isCredit"]
              ? Text("Incoming", style: TextStyle(color: Colors.grey))
              : Text("Outgoing", style: TextStyle(color: Colors.grey)),
          trailing: Container(
            constraints: BoxConstraints(maxWidth: 120),
            child: Text(
              "${tx['currency']} ${tx["amount"].toStringAsFixed(2)}",
              style: TextStyle(
                color: tx["isCredit"] ? Colors.green : Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
              textAlign: TextAlign.right,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }

  Widget _buildTxHive() {
    return ValueListenableBuilder(
      valueListenable: txBox.listenable(),
      builder:
          (BuildContext context, Box<TransactionModel> transactionsBox, _) {
            if (transactionsBox.isEmpty) {
              return notFound(
                context: context,
                assetImg: 'assets/animations/notfound.json',
                text: "No Recent Transactions",
              );
            }

            final transactions = transactionsBox.values.toList();

            return ListView.separated(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: transactions.length,
              separatorBuilder: (_, _) =>
                  Divider(color: Colors.grey, radius: BorderRadius.circular(4)),
              itemBuilder: (context, index) {
                final tx = transactions[index];

                return ListTile(
                  leading: CircleAvatar(child: Icon(Icons.person)),
                  title: Text(
                    tx.recipient,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(DateFormat.yMMMd().format(tx.dateTx)),
                  trailing: Text(
                    "${tx.currency} ${tx.txAmount.toStringAsFixed(2)}",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: tx.isCredit ? Colors.green : Colors.red,
                    ),
                  ),
                );
              },
            );
          },
    );
  }

  /// [refactor]  to buildList on listenable from our hive models
  //Recent Traction ListTile
  Widget _buildTransactionList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length - 2, // pagination
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

  InputDecoration _buildInputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(
          width: 2,
          color: Color.fromRGBO(255, 144, 95, 1),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: const BorderSide(width: 2, color: Colors.red),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildCTASection() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        button(
          buttonTxt: "Send",
          onPressed: _sendFunds,
          buttonTxtStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.white,
          ),
          buttonColor: Color.fromRGBO(255, 144, 94, 1),
        ),
        button(
          buttonTxt: "Withdraw",
          onPressed: () {
            showModalBottomSheet(
              useSafeArea: true,
              context: context,
              builder: (BuildContext context) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  color: Colors.white24,
                );
              },
            );
          },
          buttonTxtStyle: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
            color: Colors.white,
          ),
          buttonColor: Color.fromRGBO(255, 144, 94, 1),
        ),
      ],
    );
  }
}
