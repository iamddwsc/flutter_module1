import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_module3_shared/shared_communicator.dart';
import 'package:flutter_module3_shared/shared_object.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  int counter = 0;
  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  // Subscriptions for state updates
  StreamSubscription? _uiStateSubscription;
  StreamSubscription? _messageSubscription;

  // State variables
  Map<String, dynamic>? _uiState;
  String _message = "No message from Screen 2 yet";
  Color _backgroundColor = Colors.white; // Default background color

  @override
  void initState() {
    super.initState();

    // Subscribe to UI state updates
    final uiState = SharedCommunicator().get<SharedUIState>('uiState');
    if (uiState != null) {
      _uiStateSubscription = uiState.stream.listen((newState) {
        setState(() {
          _uiState = newState;

          // Update background color if it exists in the state
          if (newState.containsKey('backgroundColor')) {
            _backgroundColor = newState['backgroundColor'];
          }
        });
      });
      _uiState = uiState.value;

      // Initialize background color if already set
      if (_uiState != null && _uiState!.containsKey('backgroundColor')) {
        _backgroundColor = _uiState!['backgroundColor'];
      }
    }

    // Subscribe to message updates
    final messageShared = SharedCommunicator().get<SharedMessage>('messages');
    if (messageShared != null) {
      _messageSubscription = messageShared.stream.listen((newMessage) {
        setState(() {
          _message = newMessage;
        });
      });

      // Initialize message if already set
      if (messageShared.value != null) {
        _message = messageShared.value!;
      }
    }
  }

  @override
  void dispose() {
    _uiStateSubscription?.cancel();
    _messageSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _backgroundColor,
      appBar: AppBar(
        title: const Text('Screen 1'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Press the button to increment the counter:',
            ),
            // Display the counter value
            Text(
              '$counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 40),

            // Message from Screen 2
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  const Text(
                    'Message from Screen 2:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _message,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // // Background color indicator
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     border: Border.all(color: Colors.grey),
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: Column(
            //     children: [
            //       const Text(
            //         'Current Background Color:',
            //         style: TextStyle(fontWeight: FontWeight.bold),
            //       ),
            //       const SizedBox(height: 8),
            //       Container(
            //         width: 100,
            //         height: 30,
            //         decoration: BoxDecoration(
            //           color: _backgroundColor,
            //           border: Border.all(color: Colors.black),
            //           borderRadius: BorderRadius.circular(4),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Increment the counter
          incrementCounter();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
