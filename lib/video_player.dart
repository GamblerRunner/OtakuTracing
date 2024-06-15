import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Firebase_Manager.dart';

class PlayerAnime extends StatelessWidget {
  final int totalEpisodes;
  final int currentEpisode;
  final String AnimeName;

  const PlayerAnime({Key? key, required this.totalEpisodes, required this.currentEpisode, required this.AnimeName}) : super(key: key);

  static const customSwatch = MaterialColor(
    0xFFFF5252,
    <int, Color>{
      50: Color(0xFFFFEBEE),
      100: Color(0xFFFFCDD2),
      200: Color(0xFFEF9A9A),
      300: Color(0xFFE57373),
      400: Color(0xFFEF5350),
      500: Color(0xFFFF5252),
      600: Color(0xFFE53935),
      700: Color(0xFFD32F2F),
      800: Color(0xFFC62828),
      900: Color(0xFFB71C1C),
    },
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: customSwatch,
      ),
      debugShowCheckedModeBanner: false,
      home: MyHomePage(totalEpisodes: totalEpisodes, currentEpisode: currentEpisode, AnimeName: AnimeName),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final int totalEpisodes;
  final int currentEpisode;
  final String AnimeName;

  const MyHomePage({Key? key, required this.totalEpisodes, required this.currentEpisode, required this.AnimeName}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FirebaseManager fm = FirebaseManager();
  FirebaseFirestore db = FirebaseFirestore.instance;
  late YoutubePlayerController _controller;
  bool isMuted = true;
  double volume = 100.0;
  Duration watchedDuration = Duration.zero;
  Duration videoDuration = Duration.zero;
  int videoStart = 0;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  Future<void> _initializeController() async {
    // Get the start time in seconds from your data source asynchronously
    int getFMSeconds = await fm.getEpiodeSecond(widget.AnimeName, widget.currentEpisode);

    // Initialize _controller with startAt set to getFMSeconds
    _controller = YoutubePlayerController(
      initialVideoId: 'OhNwckCLzis', // Replace with your video ID
      flags: YoutubePlayerFlags(
        autoPlay: false,
        mute: true,
        isLive: false,
        startAt: getFMSeconds,
      ),
    );

    _controller.addListener(_videoListener);
    await _loadWatchedDuration();
    _controller.seekTo(watchedDuration);

    // Get the video duration and update the state
    _controller.addListener(() {
      setState(() {
        videoDuration = _controller.metadata.duration;
      });
    });
  }

  void _videoListener() {
    if (_controller.value.isPlaying) {
      _saveWatchedDuration(_controller.value.position);
    }
  }

  Future<void> _loadWatchedDuration() async {
    final prefs = await SharedPreferences.getInstance();
    final seconds = prefs.getInt('watched_duration_${widget.currentEpisode}') ?? 0;
    setState(() {
      watchedDuration = Duration(seconds: seconds);
    });
  }

  Future<void> _saveWatchedDuration(Duration duration) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('watched_duration_${widget.currentEpisode}', duration.inSeconds);
    print('Duración vista guardada: ${duration.inSeconds} segundos del total de ${videoDuration.inSeconds }'); // Añadir esta línea
    if(duration.inSeconds == videoDuration.inSeconds -5){
      fm.saveEndDuration(widget.AnimeName ,widget.currentEpisode, true);
    }
    if(duration.inSeconds % 5 ==0){
      fm.saveDuration(widget.AnimeName , widget.currentEpisode, duration.inSeconds);
    }
  }

  void _toggleMute() {
    setState(() {
      if (isMuted) {
        _controller.unMute();
      } else {
        _controller.mute();
      }
      isMuted = !isMuted;
    });
  }

  void _setVolume(double newVolume) {
    setState(() {
      volume = newVolume;
      _controller.setVolume(newVolume.toInt());
    });
  }

  void _navigateToEpisode(int episode) {
    if (episode > 0 && episode <= widget.totalEpisodes) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => PlayerAnime(
            totalEpisodes: widget.totalEpisodes,
            currentEpisode: episode,
            AnimeName: "pinga",
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return YoutubePlayerBuilder(
      player: YoutubePlayer(
        controller: _controller,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.amber,
        progressColors: const ProgressBarColors(
          playedColor: Colors.amber,
          handleColor: Colors.amberAccent,
        ),
        bottomActions: [
          CurrentPosition(),
          ProgressBar(isExpanded: true),
          RemainingDuration(),
          IconButton(
            icon: Icon(
              isMuted ? Icons.volume_off : Icons.volume_up,
              color: Colors.white,
            ),
            onPressed: _toggleMute,
          ),
          Container(
            height: 100,
            child: RotatedBox(
              quarterTurns: 1,
              child: Slider(
                value: volume,
                min: 0,
                max: 100,
                onChanged: _setVolume,
                activeColor: Colors.amber,
                inactiveColor: Colors.grey,
              ),
            ),
          ),
          PopupMenuButton<double>(
            initialValue: _controller.value.playbackRate,
            tooltip: 'Velocidad de reproducción',
            onSelected: (value) {
              _controller.setPlaybackRate(value);
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 0.25,
                child: Text('0.25x'),
              ),
              PopupMenuItem(
                value: 0.5,
                child: Text('0.5x'),
              ),
              PopupMenuItem(
                value: 0.75,
                child: Text('0.75x'),
              ),
              PopupMenuItem(
                value: 1.0,
                child: Text('1.0x'),
              ),
              PopupMenuItem(
                value: 1.25,
                child: Text('1.25x'),
              ),
              PopupMenuItem(
                value: 1.5,
                child: Text('1.5x'),
              ),
              PopupMenuItem(
                value: 1.75,
                child: Text('1.75x'),
              ),
              PopupMenuItem(
                value: 2.0,
                child: Text('2.0x'),
              ),
            ],
            child: Icon(
              Icons.speed,
              color: Colors.white,
            ),
          ),
          FullScreenButton(
            controller: _controller,
            color: Colors.white,
          ),
        ],
      ),
      builder: (context, player) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context); // Cambia la navegación a la página anterior
              },
            ),
            title: Text(
              'EPISODIO ${widget.currentEpisode}',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 24,
              ),
            ),
            backgroundColor: Colors.black,
            centerTitle: true,
          ),
          body: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  'assets/img/fondoPantalla.jpg', // Cambia a tu imagen de fondo
                  fit: BoxFit.cover,
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0), // Padding para separación de los bordes
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.transparent,
                            width: 0,
                          ),
                        ),
                        child: player,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: widget.currentEpisode > 1
                                ? () => _navigateToEpisode(widget.currentEpisode - 1)
                                : null,
                            child: Text('Anterior'),
                          ),
                          ElevatedButton(
                            onPressed: widget.currentEpisode < widget.totalEpisodes
                                ? () => _navigateToEpisode(widget.currentEpisode + 1)
                                : null,
                            child: Text('Siguiente'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _saveWatchedDuration(_controller.value.position);
    _controller.dispose();
    super.dispose();
  }
}