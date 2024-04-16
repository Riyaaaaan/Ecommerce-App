import 'package:ecommerce_app/view/home.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieAnime extends StatefulWidget {
  const LottieAnime({Key? key}) : super(key: key);

  @override
  State<LottieAnime> createState() => _LottieAnimeState();
}

class _LottieAnimeState extends State<LottieAnime>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.stop();
        }
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) {
            return HomePage(
              username: '',
              password: '',
            );
          },
        ),
      ),
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Lottie.network(
                'https://lottie.host/0844b20e-bb5d-4b1f-b78a-bda4d05337d6/CCfB1wIa5U.json',
                controller: _controller,
                onLoaded: (composition) {
                  _controller
                    ..duration = composition.duration
                    ..forward();
                },
              ),
            ),
            const SizedBox(height: 30),
            Text(
              'Order Placed Successfully !',
              style: TextStyle(
                fontFamily: 'Montserrat',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            )
          ],
        ),
      ),
    );
  }
}
