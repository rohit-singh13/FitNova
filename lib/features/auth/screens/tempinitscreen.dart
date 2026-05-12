import 'package:fitnova/features/auth/screens/Login.dart';
import 'package:fitnova/features/auth/registration/Measurement.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class TempInitScreen extends StatefulWidget {
  @override
  State<TempInitScreen> createState() => _InitialScreenState();
}

class _InitialScreenState extends State<TempInitScreen> {

  late VideoPlayerController _controller;
  bool isReady = false;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.asset('Assets/Videos/Intro.mp4')    //Initializes intro background video
      ..initialize().then((_) {   //when the video gets load it shows the screen and autoplay the video
        if (mounted) {
          setState(() {
            isReady = true;
          });
        }
        _controller.setLooping(true);   //video keeps play in loop
        _controller.play();
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: isReady ? 1 : 0,
          child: isReady
              ? Stack(
            children: [
              SizedBox.expand(
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: _controller.value.size.width,
                    height: _controller.value.size.height,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),

              Container(
                color: Colors.black.withValues(alpha: 0.4),
              ),

                Padding(
                  padding: EdgeInsets.only(bottom: 50),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: RichText(text: TextSpan(

                          style: TextStyle(fontSize: 21, color: Colors.white),
                          children: [
                            TextSpan(text: "It's "),
                            TextSpan(text: 'all '),
                            TextSpan(text: 'about '),
                            TextSpan(text: ' Consistency', style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold, color: Colors.red))
                          ]
                        )),
                      ),

                      SizedBox(height: 40,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
                          onPressed: () async {   //Pauses video before navigation and resume when back
                            _controller.pause();

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Measurement(),
                              ),
                            );

                            _controller.play();
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: Size(double.infinity, 50),
                            backgroundColor: Color(0xFF6C5CE7),
                          ),
                          child: Text('Join Now', style: TextStyle(color: Colors.white),),
                        ),
                      ),

                      SizedBox(height: 10,),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: OutlinedButton(
                          onPressed: () async {   //Pauses video before opening login screen
                            _controller.pause();

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LoginScreen(),
                              ),
                            );

                            _controller.play();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.white),
                            minimumSize: Size(double.infinity, 50),
                          ),
                          child: Text(
                            'Login',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                )

              ],
            )
          : Center(child: CircularProgressIndicator()),
        )
    );
  }

  //Disposes video controller to prevent memory leaks
  @override
  void dispose() {
    if (_controller.value.isInitialized) {
      _controller.dispose();
    }
    super.dispose();
  }
}
