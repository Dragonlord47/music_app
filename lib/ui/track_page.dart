import 'package:flutter/material.dart';
import '../models/list_model.dart';
import 'package:audioplayers/audioplayers.dart';

class TrackPage extends StatefulWidget {
  final TrackModel trackModel;

  TrackPage(this.trackModel);
  @override
  _TrackPageState createState() => _TrackPageState();
}

void updateSlider(double value) {}

class _TrackPageState extends State<TrackPage> {
  AudioPlayer audioPlayer = new AudioPlayer();
  double sliderValue = 0;
  double maxSliderValue = 0;
  IconData playerIcon = Icons.play_arrow;
  bool isStarting = true;
  bool playerButtonState = false;
  bool hasClickedPlayButton = false;
  String currentDuration = '';
  String songDuration = '';
  int currentPosition;

  @override
  void initState() {
    super.initState();
    audioPlayer.onAudioPositionChanged.listen((event) async {
      currentPosition = event.inMilliseconds;
      setState(() {
        currentDuration = getTrackDuration(currentPosition);
        sliderValue = currentPosition / 1000;
      });

      var trackDuration = await audioPlayer.getDuration();
      if (isStarting) {
        maxSliderValue = trackDuration / 1000;
        isStarting = false;
      }

      setState(() {
        songDuration = getTrackDuration(trackDuration - currentPosition);
      });
    });
  }

  String getTrackDuration(int songDuration) {
    int songInSeconds = (songDuration / 1000).toInt();
    int songInMinutes = (songInSeconds / 60).toInt();
    int seconds = songInSeconds - (songInMinutes * 60);
    String str_minutes = songInMinutes.toString();
    String str_seconds = seconds.toString();

    if (str_minutes.length == 1) {
      str_minutes = '0$str_minutes';
    }
    if (str_seconds.length == 1) {
      str_seconds = '0$str_seconds';
    }

    return '$str_minutes:$str_seconds';
  }

  void play(String trackLocation) async {
    if (!hasClickedPlayButton) {
      await audioPlayer.play(trackLocation, isLocal: true);
      hasClickedPlayButton = true;
    }
  }

  void pause() {
    if (hasClickedPlayButton) {
      audioPlayer.pause();
      hasClickedPlayButton = false;
    }
  }

  void fastForward() {
    if (hasClickedPlayButton) {
      audioPlayer.getDuration().then((trackDuration) {
        if (5000 + currentPosition < trackDuration) {
          audioPlayer.seek(Duration(milliseconds: 5000 + currentPosition));
        }
      });
    }
  }

  void rewind() {
    if (hasClickedPlayButton) {
      audioPlayer.getDuration().then((trackDuration) {
        if (currentPosition - 5000 > 0) {
          audioPlayer.seek(Duration(milliseconds: currentPosition - 5000));
        }
      });
    }
  }

  Future getAudioFileLength() async {
    await audioPlayer.setUrl(widget.trackModel.trackLocation, isLocal: true);
  }

  @override
  Widget build(BuildContext context) {
    var circleBorder = CircleBorder();
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (hasClickedPlayButton) {
            audioPlayer.stop();
          }
          return true;
        },
        child: Scaffold(
          backgroundColor: Colors.grey[900],
          body: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          if (hasClickedPlayButton) {
                            audioPlayer.stop();
                          }
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back,
                            color: Colors.grey[400], size: 12),
                        color: Colors.black12,
                        shape: CircleBorder(
                            side: BorderSide(
                          color: Colors.grey[400],
                        )),
                      ),
                      Text('PLAYING NOW',
                          style: TextStyle(color: Colors.grey[400])),
                      RaisedButton(
                          onPressed: () {},
                          color: Colors.black12,
                          shape: CircleBorder(
                              side: BorderSide(
                            color: Colors.grey[400],
                          )),
                          child: Icon(Icons.menu,
                              color: Colors.grey[400], size: 12)),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(150),
                      border: Border.all(
                        color: Colors.black,
                        width: 7,
                      ),
                    ),
                    margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(150),
                      child: widget.trackModel.imageBytes == null
                          ? Image.asset(
                              'assets/images/albumCover.png',
                              width: 300,
                              height: 300,
                            )
                          : Image.memory(widget.trackModel.imageBytes,
                              width: 300, height: 300),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 50, 10, 0),
                    child: Text(
                      widget.trackModel.trackName,
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: Text(widget.trackModel.album,
                          style: TextStyle(
                              fontSize: 15, color: Colors.grey[600]))),
                  Container(
                      margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(currentDuration,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[600])),
                          Text(songDuration,
                              style: TextStyle(
                                  fontSize: 15, color: Colors.grey[600])),
                        ],
                      )),
                  Container(
                      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: Slider(
                          activeColor: Colors.amberAccent,
                          inactiveColor: Colors.black,
                          value: sliderValue,
                          max: maxSliderValue,
                          
                          onChanged: (value) {
                            setState(() {
                              sliderValue = value;
                              audioPlayer.seek(Duration(
                                  milliseconds: (value * 1000).toInt()));
                            });
                          })),
                  Container(
                    margin: EdgeInsets.fromLTRB(10, 20, 10, 0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RaisedButton(
                              padding: EdgeInsets.all(20),
                              color: Colors.black12,
                              shape: CircleBorder(
                                side: BorderSide(
                                  color: Colors.grey[400],
                                ),
                              ),
                              child:
                                  Icon(Icons.fast_rewind, color: Colors.white),
                              onPressed: () {
                                rewind();
                              }),
                          RaisedButton(
                              padding: EdgeInsets.all(20),
                              color: Colors.orange[700],
                              shape: CircleBorder(
                                side: BorderSide(color: Colors.grey[400]),
                              ),
                              child: Icon(playerIcon, color: Colors.white),
                              onPressed: () {
                                if (playerButtonState) {
                                  setState(() {
                                    pause();
                                    playerButtonState = false;
                                    playerIcon = Icons.play_arrow;
                                  });
                                } else {
                                  setState(() {
                                    play(widget.trackModel.trackLocation);
                                    playerButtonState = true;
                                    playerIcon = Icons.pause;
                                  });
                                }
                              }),
                          RaisedButton(
                              padding: EdgeInsets.all(20),
                              color: Colors.black12,
                              shape: CircleBorder(
                                side: BorderSide(color: Colors.grey[400]),
                              ),
                              child:
                                  Icon(Icons.fast_forward, color: Colors.white),
                              onPressed: () {
                                fastForward();
                              }),
                        ]),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
