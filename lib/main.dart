import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'domain/rules.dart';

void main() {
  runApp(const TransitlyApp());
}

class TransitlyApp extends StatelessWidget {
  const TransitlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DeskModel(),
      child: MaterialApp(
        title: 'Transitly',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0F172A),
            primary: const Color(0xFF0F172A),
            background: const Color(0xFFF8FAFC),
          ),
          appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
          cardTheme: CardTheme(
            elevation: 0,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          ),
        ),
        home: const Gate(),
      ),
    );
  }
}

class DeskModel extends ChangeNotifier {
  bool signedIn = false;
  String? error;
  int metric = 0;
  final List<String> items = const [
    'Bus 12',
    'Ferry',
    'Walk',
  ];

  void signIn(String email, String password) {
    if (email.trim() == 'guest@transitly.dev' && password == 'demo1234') {
      signedIn = true;
      error = null;
    } else {
      error = 'Use the demo profile printed on this screen.';
    }
    notifyListeners();
  }

  void bump() {
    metric = capped(metric, 12);
    notifyListeners();
  }
}

class Gate extends StatelessWidget {
  const Gate({super.key});

  @override
  Widget build(BuildContext context) {
    final signedIn = context.watch<DeskModel>().signedIn;
    return signedIn ? const HomePage() : const SignInPage();
  }
}

class SignInPage extends StatefulWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _email = TextEditingController(text: 'guest@transitly.dev');
  final _password = TextEditingController(text: 'demo1234');

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final error = context.watch<DeskModel>().error;
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: scheme.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.directions_transit, color: Colors.white, size: 36),
                  SizedBox(height: 16),
                  Text(
                    'Transitly',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 6),
                  Text(
                    'Rides for the portfolio. Sample data stays on this device.',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            if (error != null) ...[
              const SizedBox(height: 8),
              Text(error, style: TextStyle(color: scheme.error)),
            ],
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () =>
                  context.read<DeskModel>().signIn(_email.text, _password.text),
              child: const Text('Open Transitly'),
            ),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final model = context.watch<DeskModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Trip')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Theme.of(context).colorScheme.primaryContainer,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  const Icon(Icons.directions_transit),
                  const SizedBox(width: 12),
                  Expanded(child: Text('legs ${model.metric}')),
                  FilledButton(
                    onPressed: context.read<DeskModel>().bump,
                    child: const Text('Add leg'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final item in model.items)
            Card(
              child: ListTile(
                leading: const Icon(Icons.directions_transit),
                title: Text(item),
                subtitle: const Text('Rides sample'),
              ),
            ),
        ],
      ),
    );
  }
}
