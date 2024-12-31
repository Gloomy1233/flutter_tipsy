import 'package:flutter/material.dart';

/// Maps a string key to a Material `IconData`.
IconData getIconDataMusic(String iconName) {
  switch (iconName) {
    case 'music_note':
      return Icons.music_note;
    case 'queue_music':
      return Icons.queue_music;
    case 'library_music':
      return Icons.library_music;
    case 'audiotrack':
      return Icons.audiotrack;
    case 'music_video':
      return Icons.music_video;
    case 'music_off':
      return Icons.music_off;
    case 'album':
      return Icons.album;
    case 'volume_up':
      return Icons.volume_up;
    case 'speaker':
      return Icons.speaker;
    // Add more cases as needed...
    default:
      return Icons.music_note; // Fallback icon
  }
}
