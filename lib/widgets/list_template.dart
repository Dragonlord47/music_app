import 'dart:typed_data';

import 'package:audiotagger/models/tag.dart';
import 'package:flutter/material.dart';
import 'package:musicPlayer/ui/track_page.dart';
import '../models/list_model.dart';
import 'package:audiotagger/audiotagger.dart';

class ListTemplate extends StatefulWidget {
  final TrackModel trackModel;
  ListTemplate(this.trackModel);

  @override
  _ListTemplateState createState() => _ListTemplateState();
}

class _ListTemplateState extends State<ListTemplate> {
  final tagger = new Audiotagger();

  String trackName;

  String albumName;

  Uint8List trackImageBytes;

  Future<Uint8List> getTrackImage() async {
    return await tagger.readArtwork(path: widget.trackModel.trackLocation);
  }

  void getMetaData() async {
    print(widget.trackModel.trackLocation);
    final Tag tag =
        await tagger.readTags(path: widget.trackModel.trackLocation);
    print(tag);

    setState(() {
      trackName =
          tag.title == null || tag.title.trim().isEmpty ? 'UNKNOWN TRACK' : tag.title;
      albumName =
          tag.album == null || tag.album.trim().isEmpty ? 'UNKNOWN ALBUM' : tag.album;
    });
    trackImageBytes = await getTrackImage();
  }

  @override
  void initState() {
    super.initState();
    trackName = '';
    albumName = '';
    getMetaData();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        var track = new TrackModel(
            trackName: trackName,
            album: albumName,
            imageBytes: trackImageBytes,
            trackLocation: widget.trackModel.trackLocation);
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => TrackPage(track)));
      },
      child: Container(
          color: Colors.transparent,
          child: ListTile(
            contentPadding: EdgeInsets.all(0),
            title: Text(trackName, style: TextStyle(color: Colors.grey[400])),
            subtitle: Text(albumName,
                style: TextStyle(fontSize: 12, color: Colors.grey[400])),
            trailing: Container(
              child: RaisedButton(
                  elevation: 3,
                  color: Colors.black12,
                  onPressed: () {},
                  shape: CircleBorder(
                      side: BorderSide(
                    color: Colors.grey[700],
                  )),
                  child: Icon(Icons.play_arrow,
                      color: Colors.grey[400], size: 15)),
            ),
          )),
    );
  }
}
