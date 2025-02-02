import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({
    super.key,
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center, 
      child: Padding(
        padding: const EdgeInsets.only(top: 64.0),
        child: Column(
          children: [
            Image.asset('assets/images/error.png', width: 120,),
            const SizedBox(height: 24,),
            Text("Oops, ada yang salah!", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),),
            const SizedBox(height: 12,),
            Text(message),
          ],
        ),
      ),
    );
  }
}
