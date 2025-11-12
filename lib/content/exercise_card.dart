import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';
import 'package:video_player/video_player.dart';

class ExerciseCard extends StatefulWidget {
  final ExerciseModel exercise;
  final int index;

  const ExerciseCard({super.key, required this.exercise, required this.index});

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  ChewieController? _chewie;
  VideoPlayerController? _video;

  ChewieController? _maleChewie;
  VideoPlayerController? _maleVideo;

  bool showVideo = false;
  bool showMaleVideo = false;

  @override
  void dispose() {
    _video?.dispose();
    _chewie?.dispose();
    _maleVideo?.dispose();
    _maleChewie?.dispose();
    super.dispose();
  }

  Future<void> playVideo(String url, bool male) async {
    final player = VideoPlayerController.networkUrl(Uri.parse(url));
    await player.initialize();

    setState(() {
      if (male) {
        _maleVideo = player;
        _maleChewie = ChewieController(videoPlayerController: player);
        showMaleVideo = true;
      } else {
        _video = player;
        _chewie = ChewieController(videoPlayerController: player);
        showVideo = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final e = widget.exercise;

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.withOpacity(0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (e.restDuration != null)
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow.withAlpha(85),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text("Rest duration: ${e.restDuration} seconds"),
            ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "Exercise ${widget.index}: ${e.title}",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              _difficulty(e.difficultyLevel),
            ],
          ),

          const SizedBox(height: 4),
          Text("Model id: ${e.modelId}", style: const TextStyle(fontSize: 12)),

          const SizedBox(height: 12),

          // Main video
          showVideo
              ? AspectRatio(
                  aspectRatio: _video!.value.aspectRatio,
                  child: Chewie(controller: _chewie!),
                )
              : _thumbnail(e.thumbnailURL, () => playVideo(e.videoURL, false)),

          const SizedBox(height: 12),

          // Male video
          showMaleVideo
              ? AspectRatio(
                  aspectRatio: _maleVideo!.value.aspectRatio,
                  child: Chewie(controller: _maleChewie!),
                )
              : _thumbnail(
                  e.maleThumbnailURL,
                  () => playVideo(e.maleVideoURL, true),
                ),

          const SizedBox(height: 12),

          if ((e.workoutReps ?? e.averageReps) != null)
            Text(
              "Reps: ${e.workoutReps ?? e.averageReps}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

          if ((e.workoutCountdown ?? e.averageCountdown) != null)
            Text(
              "Countdown: ${e.workoutCountdown ?? e.averageCountdown}",
              style: const TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),

          const SizedBox(height: 8),

          Text(
            "Body Parts: ${e.bodyParts.join(", ")}",
            style: const TextStyle(fontSize: 12),
          ),

          const SizedBox(height: 8),
          Text(e.description),

          const SizedBox(height: 8),
          Text("Steps:", style: const TextStyle(fontWeight: FontWeight.bold)),
          ...e.steps.map(
            (s) => Text("• $s", style: const TextStyle(fontSize: 12)),
          ),

          if (e.tips.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text("Tips:", style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(e.tips, style: const TextStyle(fontSize: 12)),
          ],

          if (e.commonMistakes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              "Common Mistakes:",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(e.commonMistakes, style: const TextStyle(fontSize: 12)),
          ],
        ],
      ),
    );
  }

  Widget _thumbnail(String url, VoidCallback onTap) {
    return Center(
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: url,
            height: 360,
            width: MediaQuery.of(context).size.width * 0.75,
            fit: BoxFit.cover,
            placeholder: (_, __) => const SizedBox(
              height: 160,
              child: Center(child: CircularProgressIndicator()),
            ),
            errorWidget: (_, __, ___) => const Icon(Icons.image, size: 60),
          ),
        ),
      ),
    );
  }

  Widget _difficulty(String level) {
    final color = switch (level.toLowerCase()) {
      "easy" => Colors.green,
      "medium" => Colors.orange,
      "hard" => Colors.red,
      _ => Colors.grey,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(level, style: const TextStyle(color: Colors.white)),
    );
  }
}
