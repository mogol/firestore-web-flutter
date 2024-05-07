import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firestore_bug/firebase_options.dart';
import 'package:flutter/material.dart';

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.signInAnonymously();

  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final ref = FirebaseFirestore.instance
        .collection('test-collection')
        .doc('test-doc');

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => ref.set({'value': FieldValue.increment(1)},
                        SetOptions(merge: true)),
                    icon: const Icon(Icons.add),
                  ),
                  IconButton(
                    onPressed: () => ref.delete(),
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
              const SizedBox(height: 40),
              StreamBuilder(
                  stream: ref.snapshots(),
                  builder: (_, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text(snapshot.error!.toString());
                    }
                    final doc = snapshot.requireData;
                    if (doc.exists) {
                      return Text(doc.data().toString());
                    }
                    return const Text('Ooops. I do not exist');
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
