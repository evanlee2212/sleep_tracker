import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';
import '../../components/theme.dart';

// void main() => runApp(const SleepSoundApp());

class SleepSoundPage extends StatelessWidget {
  const SleepSoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SoundTabs(),
    );
  }
}


class SoundTabs extends StatefulWidget {
  const SoundTabs({super.key});

  @override
  _SoundTabsState createState() => _SoundTabsState();
}

class _SoundTabsState extends State<SoundTabs> {
  int _selectedIndex = 0;
  List<String> favorites = [];

  final List<String> _titles = ['All Sounds', 'Favorites', 'Custom'];

  @override
  void initState() {
    super.initState();
    _loadFavorites();

    // 🔹 Status bar dark icons for white AppBar
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
    );
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  void _updateFavorites(List<String> favs) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favs);
    setState(() => favorites = favs);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          _titles[_selectedIndex],
          style: const TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context), // ⬅️ This will now go back to ResourcesPage
        ),
      ),

      body: BackgroundWrapper(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            SoundPlayerPage(onFavoritesChanged: _updateFavorites),
            FavoritesPage(favorites: favorites, onFavoritesChanged: _updateFavorites),
            const CustomSoundPage(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.library_music), label: 'All Sounds'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Favorites'),
          BottomNavigationBarItem(icon: Icon(Icons.upload_file), label: 'Custom'),
        ],
      ),
    );
  }
}


class EqualizerPainter extends CustomPainter {
  final List<double> bars;

  EqualizerPainter(this.bars);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blueAccent.withOpacity(0.2)
      ..strokeWidth = 3;

    for (int i = 0; i < bars.length; i++) {
      double x = i * (size.width / bars.length);
      canvas.drawLine(Offset(x, size.height), Offset(x, size.height - bars[i]), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class SoundPlayerPage extends StatefulWidget {
  final Function(List<String>) onFavoritesChanged;
  const SoundPlayerPage({super.key, required this.onFavoritesChanged});

  @override
  _SoundPlayerPageState createState() => _SoundPlayerPageState();
}

class _SoundPlayerPageState extends State<SoundPlayerPage> with TickerProviderStateMixin {
  List<String> allSounds = ['assets/sounds/brown_noise.mp3', 'assets/sounds/crackling_fire.mp3',
    'assets/sounds/whirring_fan.mp3', 'assets/sounds/white_noise.mp3',];
  List<String> favorites = [];
  String? currentSound;
  double volume = 0.5;
  Duration? timerDuration;
  Duration timeLeft = Duration.zero;
  Timer? countdown;
  bool isPlaying = false;
  AudioPlayer player = AudioPlayer();
  TextEditingController searchController = TextEditingController();
  TextEditingController customTimeController = TextEditingController();
  late AnimationController equalizerController;
  List<double> equalizerBars = List.generate(20, (_) => 0);

  @override
  void initState() {
    super.initState();
    loadFavorites();
    equalizerController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    equalizerController.addListener(() {
      if (isPlaying) updateEqualizer();
    });
    equalizerController.repeat();
  }

  void loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  void saveFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favorites', favorites);
    widget.onFavoritesChanged(favorites);
  }

  void updateEqualizer() {
    final random = Random();
    setState(() {
      for (int i = 0; i < equalizerBars.length; i++) {
        equalizerBars[i] = random.nextDouble() * 50 + 10;
      }
    });
  }

  void playSound(String sound) async {
    await player.stop();
    await player.setVolume(volume);
    await player.setReleaseMode(ReleaseMode.loop);
    await player.play(AssetSource(sound.replaceFirst('assets/', '')));
    setState(() {
      currentSound = sound;
      isPlaying = true;
    });
    if (timerDuration != null && timerDuration != Duration.zero) {
      startTimer(timerDuration!);
    }
  }

  void pauseSound() {
    player.pause();
    countdown?.cancel();
    setState(() => isPlaying = false);
  }

  void toggleFavorite(String sound) {
    setState(() {
      if (favorites.contains(sound)) {
        favorites.remove(sound);
      } else {
        favorites.insert(0, sound);
      }
      saveFavorites();
    });
  }

  void startTimer(Duration duration) {
    countdown?.cancel();
    timeLeft = duration;
    countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timeLeft > Duration.zero) {
        setState(() => timeLeft -= const Duration(seconds: 1));
      } else {
        timer.cancel();
        player.stop();
        setState(() => isPlaying = false);
      }
    });
  }

  void resetTimer() {
    countdown?.cancel();
    setState(() => timeLeft = Duration.zero);
  }

  List<String> get filteredSounds {
    String query = searchController.text.toLowerCase();
    List<String> baseList = [...favorites, ...allSounds.where((s) => !favorites.contains(s))];
    return baseList.where((s) => s.toLowerCase().contains(query)).toList();
  }

  @override
  void dispose() {
    player.dispose();
    countdown?.cancel();
    equalizerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CustomPaint(painter: EqualizerPainter(equalizerBars), child: Container()),
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Search sounds...',
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(8),
                children: filteredSounds.map((sound) {
                  final isFav = favorites.contains(sound);
                  final isCurrent = currentSound == sound;
                  return Card(
                    elevation: 3,
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    child: ListTile(
                      title: Text(sound.split('/').last.replaceAll('.mp3', '')),
                      leading: IconButton(
                        icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : null),
                        onPressed: () => toggleFavorite(sound),
                      ),
                      trailing: isCurrent && isPlaying
                          ? IconButton(icon: const Icon(Icons.pause), onPressed: pauseSound)
                          : IconButton(icon: const Icon(Icons.play_arrow), onPressed: () => playSound(sound)),
                    ),
                  );
                }).toList(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  ElevatedButton(
                      onPressed: () => _showTimerDialog(),
                      style: AppTheme.elevatedButtonStyle,
                      child: const Text('Set Timer')),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: resetTimer,
                      style: AppTheme.elevatedButtonStyle,
                      child: const Text('Reset Timer')),
                  const Spacer(),
                  Text('${timeLeft.inMinutes.toString().padLeft(2, '0')}:${(timeLeft.inSeconds % 60).toString().padLeft(2, '0')}'),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      value: timerDuration != null && timerDuration!.inSeconds > 0
                          ? 1.0 - timeLeft.inSeconds / timerDuration!.inSeconds
                          : 0,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showTimerDialog() {
    showDialog(
      context: context,
      builder: (context) {
        int selectedMinutes = 15;
        return AlertDialog(
          title: const Text('Set Timer Duration'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<int>(
                value: selectedMinutes,
                items: [15, 30, 60].map((e) => DropdownMenuItem(value: e, child: Text('$e minutes'))).toList(),
                onChanged: (value) => selectedMinutes = value!,
              ),
              TextField(
                controller: customTimeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Or enter custom time (minutes)'),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
            ElevatedButton(
              style: AppTheme.elevatedButtonStyle,
              child: const Text('Start Timer'),
              onPressed: () {
                int custom = int.tryParse(customTimeController.text) ?? selectedMinutes;
                setState(() {
                  timerDuration = Duration(minutes: custom);
                  timeLeft = timerDuration!;
                });
                if (isPlaying) startTimer(timerDuration!);
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}

class FavoritesPage extends StatelessWidget {
  final List<String> favorites;
  final Function(List<String>) onFavoritesChanged;

  const FavoritesPage({super.key, required this.favorites, required this.onFavoritesChanged});

  @override
  Widget build(BuildContext context) {
    if (favorites.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Text("Nothing here yet! Click the heart next to sounds to show them here.",
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16)),
        ),
      );
    } else {
      return ListView(
        padding: const EdgeInsets.all(12),
        children: favorites.map((sound) => Card(
          child: ListTile(title: Text(sound.split('/').last)),
        )).toList(),
      );
    }
  }
}

class CustomSoundPage extends StatelessWidget {
  const CustomSoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Text('Upload and manage custom sounds',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
