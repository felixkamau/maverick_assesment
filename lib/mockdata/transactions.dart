final List<Map<String, dynamic>> transactions = [
  {
    "name": "Rose Mwangi",
    "date": DateTime.now(),
    "amount": 45.55,
    "currency": "USD",
    "isCredit": true,
  },
  {
    "name": "John Doe",
    "date": DateTime.now().subtract(Duration(days: 1)),
    "amount": 120.00,
    "currency": "KSH",
    "isCredit": false,
  },
  {
    "name": "Rose Mwangi",
    "date": DateTime.now(),
    "amount": 45.55,
    "currency": "USD",
    "isCredit": true,
  },
  {
    "name": "John Doe",
    "date": DateTime.now().subtract(Duration(days: 1)),
    "amount": 120.00,
    "currency": "KSH",
    "isCredit": false,
  },
  {
    "name": "Rose Mwangi",
    "date": DateTime.now(),
    "amount": 45.55,
    "currency": "USD",
    "isCredit": true,
  },
  {
    "name": "John Doe",
    "date": DateTime.now().subtract(Duration(days: 1)),
    "amount": 120.00,
    "currency": "KSH",
    "isCredit": false,
  },
];

final List<Map<String, dynamic>> incomingOutgoingTx = [
  {
    "name": "Jane Doe",
    "amount": 50.45,
    "currency": "USD",
    // "txType": "Incoming",
    "isCredit": false
  },
  {
    "name": "Benjamin Doe",
    "amount": 100,
    "currency": "KSH",
    "isCredit": true,
  },
];
