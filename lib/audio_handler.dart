import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

class SimpleAudioHandler extends BaseAudioHandler {
  final _player = AudioPlayer();

  SimpleAudioHandler() {
    _player.playbackEventStream.listen((event) {
      playbackState.add(
        playbackState.value.copyWith(
          playing: _player.playing,
          processingState: {
            ProcessingState.idle: AudioProcessingState.idle,
            ProcessingState.loading: AudioProcessingState.loading,
            ProcessingState.buffering: AudioProcessingState.buffering,
            ProcessingState.ready: AudioProcessingState.ready,
            ProcessingState.completed: AudioProcessingState.completed,
          }[_player.processingState]!,
        ),
      );
    });
  }

  Future<void> playFile(String path) async {
    await _player.setFilePath(path);
    mediaItem.add(
      MediaItem(
        id: path,
        title: path.split('/').last,
      ),
    );
    await _player.play();
  }

  @override
  Future<void> play() => _player.play();

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> stop() async {
    await _player.stop();
    await super.stop();
  }
}
