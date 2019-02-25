import 'package:flutter/material.dart';
import 'package:md_media_controls/md_media_controls.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: MDMediaControlsTest(),
      ),
    );
  }
}

const kUrl = "http://www.rxlabz.com/labz/audio2.mp3";
const kUrl2 = "http://www.rxlabz.com/labz/audio.mp3";

class MDMediaControlsTest extends StatelessWidget {
  final MdMediaControls mdMediaControls = MdMediaControls();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Material(
        elevation: 2.0,
        color: Colors.grey[200],
        child: Center(
          child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
            StreamBuilder<ControlsState>(
              initialData: ControlsState.STOPPED,
              stream: mdMediaControls.onPlayerStateChanged,
              builder: (BuildContext context, AsyncSnapshot<ControlsState> snapshot) {
                final ControlsState data = snapshot.data;

                return Row(mainAxisSize: MainAxisSize.min, children: [
                  IconButton(
                      onPressed: data == ControlsState.PLAYING ? null : () async {
                        await mdMediaControls.playNew(url: kUrl);
                        await mdMediaControls.rate(rate: 0.7);
                        await mdMediaControls.setInfo(title: 'Some title', artist: 'some artist',
                            imageUrl: 'https://pngimage.net/wp-content/uploads/2018/05/example-icon-png-4.png'
                        );
                      },
                      iconSize: 64.0,
                      icon: Icon(Icons.play_arrow),
                      color: Colors.cyan),
                  IconButton(
                      onPressed: data == ControlsState.PLAYING ? () {
                        mdMediaControls.pause();
                      } : null,
                      iconSize: 64.0,
                      icon: Icon(Icons.pause),
                      color: Colors.cyan),
                  IconButton(
                      onPressed: data == ControlsState.PLAYING || data == ControlsState.PAUSED ? () {
                        mdMediaControls.stop();
                      } : null,
                      iconSize: 64.0,
                      icon: Icon(Icons.stop),
                      color: Colors.amberAccent),
                  IconButton(
                      onPressed: () async {
                        await mdMediaControls.setInfo(title: 'Some title 123', artist: 'some artist 123',
                            imageUrl: 'assets/test.png'
                        );
                      },
                      iconSize: 64.0,
                      icon: Icon(Icons.adb),
                      color: Colors.amberAccent),

                ]);
              },
            ),
            StreamBuilder<Duration>(
              initialData: Duration(),
              stream: mdMediaControls.positionChanged,
              builder: (BuildContext context, AsyncSnapshot<Duration> snapshot) {
                final double max = mdMediaControls.duration.inSeconds.toDouble();
                final double value = snapshot.data.inSeconds.toDouble();

                return Column(
                  children: <Widget>[
                        max > 0.0 ? Center(
                          child: Text('$value/$max')
                        ) : Container(),
                        value >= 0.0 && value <= max ? Slider(
                          onChanged: (double seconds) {
                            mdMediaControls.seek(seconds);
                          },
                          min: 0.0,
                          value: value,
                          max: max
                    ) : Slider(
                          onChanged: null,
                          min: 0.0,
                          value: 0.0,
                          max: max
                      )
                  ],
                );
              }
            )
          ],
          )
        )
      )
    );
  }
}