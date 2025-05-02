import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioMediaWidget extends StatefulWidget {
  final String url;
  final String? title;

  const AudioMediaWidget({super.key, required this.url, this.title});

  @override
  State<AudioMediaWidget> createState() => _AudioMediaWidgetState();
}

class _AudioMediaWidgetState extends State<AudioMediaWidget> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  Duration _duration = const Duration();
  Duration _position = const Duration();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
  }

  void _initAudioPlayer() async {
    // Set up event listeners
    _audioPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
        _isLoading = false;
      });
    });

    _audioPlayer.onPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });

    _audioPlayer.onPlayerComplete.listen((_) {
      setState(() {
        _isPlaying = false;
        _position = const Duration();
      });
    });

    try {
      // Set source
      if (widget.url.startsWith('http') || widget.url.startsWith('https')) {
        await _audioPlayer.setSourceUrl(widget.url);
      } else {
        await _audioPlayer.setSourceDeviceFile(widget.url);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print("Error loading audio: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Audio visualization
          Container(
            height: 120,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                27,
                (index) => Container(
                  width: 4,
                  height: (20 + (index % 9) * 10).toDouble(),
                  decoration: BoxDecoration(
                    color: _isPlaying ? Colors.blue : Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),
          ),

          // Controls and info
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Title if available
                if (widget.title != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      widget.title!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                // Audio progress slider
                Slider(
                  value: _position.inSeconds.toDouble(),
                  min: 0.0,
                  max: _duration.inSeconds.toDouble() + 1.0,
                  onChanged: (value) {
                    final position = Duration(seconds: value.toInt());
                    _audioPlayer.seek(position);
                  },
                ),

                // Time indicators and controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Current position
                    Text(_formatDuration(_position)),

                    // Play/pause button
                    IconButton(
                      icon: Icon(
                        _isLoading
                            ? Icons.hourglass_bottom
                            : (_isPlaying ? Icons.pause : Icons.play_arrow),
                        size: 36,
                      ),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_isPlaying) {
                                await _audioPlayer.pause();
                              } else {
                                await _audioPlayer.resume();
                              }
                              setState(() {
                                _isPlaying = !_isPlaying;
                              });
                            },
                    ),

                    // Total duration
                    Text(_formatDuration(_duration)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
