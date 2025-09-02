# Maverick Assessment — Flutter 

## Full Name

**Felix Ngugi**

## 🎯 Target User Segment

This app is designed for **student groups and SACCOs pooling funds**.
The goal is to provide an easy way for groups to manage shared money, keep track of contributions, and allow members to send and receive funds securely.

## ✨ Summary of Features Implemented

* **Authentication**: Sign up and login using Supabase (email + password).
* **Wallet Dashboard**: Displays group balance, account info, and recent transactions.
* **Multi-Currency Support**: Balances available in KES and USD.
* **Send & Receive Simulation**: Users can send funds to other members and simulate receiving contributions.
* **CRUD Operations for Groups**: Create groups, add members, and manage contributions.
* **Transaction History**: Full transaction list with filters for type and date.
* **Profile & Settings**: Update user profile info, reset PIN, and toggle light/dark mode.
* **Local Storage**: Wallet and transaction history stored locally for offline access.

## 🛠 Tech Stack and Libraries Used

* **Framework:** Flutter (latest stable SDK)
* **Language:** Dart
* **Routing:** Navigator for clean navigation handling.
* **Local Storage:** Hive (lightweight and fast for offline storage).
* **Backend/Auth:** Supabase (for authentication).

## 🏗 Architecture of Choice

I followed a **feature-first modular architecture** combined with **MVVM principles**:

```
lib/
├── core/              # themes, constants, helpers
├── models/            # data models (user, group, transaction)
├── services/          # supabase auth, local db (Hive), storage
├── features/
│   ├── auth/          # login, register, PIN setup
│   ├── dashboard/     # wallet and home screens
│   ├── transactions/  # transaction history & filters
│   └── profile/       # settings and profile
├── widgets/           # reusable UI components
```

This separation ensures:

* **Scalability**: Easy to extend features (new wallets, new group types).
* **Testability**: Logic separated from UI for unit testing.
* **Maintainability**: Clean separation of concerns.

## 🚀 Setup Instructions to Run the App

1. **Prerequisites**

    * Install [Flutter SDK](https://docs.flutter.dev/get-started/install)
    * Install [Android Studio](https://developer.android.com/studio) or [VSCode](https://code.visualstudio.com/)
    * Ensure you have an emulator/device ready

2. **Clone the Repository**

   ```bash
   git clone https://github.com/felixkamau/maverick_assesment.git
   cd maverick_assesment
   ```

3. **Install Dependencies**

   ```bash
   flutter pub get
   ```

4. **Run the App**

   ```bash
   flutter run
   ```

## 💡 Product Thinking

In underserved markets like student groups and SACCOs, managing shared funds is often manual and lacks transparency.
This prototype simulates:

* **Transparency** with group transaction history and balances.
* **Inclusivity** by supporting multiple currencies for local and international contributions.
The aim is to show how a **mobile-first financial tool** can help small groups build trust, manage funds, and grow their communities.

