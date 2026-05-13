import 'package:flutter/cupertino.dart';

class AppBackground extends StatelessWidget{
  final Widget child;

  const AppBackground({super.key, required this.child});
  @override
  Widget build(BuildContext context){
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xFF000000),
            Color(0xFF0A0F2C),
            Color(0xFF1A0033),
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        )
      ),
      child: child,
    );
  }
}