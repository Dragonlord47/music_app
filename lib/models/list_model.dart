import 'dart:typed_data';

class TrackModel {
  final String trackName;
  final String album;
  final String trackLocation;
  final Uint8List imageBytes;
  TrackModel({this.trackName = '', this.album = '',this.imageBytes = null, this.trackLocation});
}
