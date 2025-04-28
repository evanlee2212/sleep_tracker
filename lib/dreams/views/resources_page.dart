import 'package:flutter/material.dart';
import 'package:sleep_app/dreams/views/sounds.dart';
import 'package:sleep_app/components/menu_button.dart';
import 'package:sleep_app/dreams/contracts/resources_contract.dart';
import 'package:sleep_app/dreams/presenter/resources_presenter.dart';
import 'package:sleep_app/dreams/views/video_page.dart';
import 'package:sleep_app/dreams/views/assessment_page.dart';

class ResourcesPage extends StatefulWidget {
  const ResourcesPage({super.key});

  @override
  State<ResourcesPage> createState() => _ResourcesPageState();
}

class _ResourcesPageState extends State<ResourcesPage>
    implements ResourcesContractView {
  late final ResourcesPresenter _presenter;

  @override
  void initState() {
    super.initState();
    _presenter = ResourcesPresenter(this);
  }

  @override
  void navigateToSounds() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SleepSoundApp()),
    );
  }

  @override
  void navigateToVideos() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const VideoPage()),
    );
  }

  void navigateToAssessment() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AssessmentPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Resources'),
        backgroundColor: Colors.deepPurpleAccent,
        toolbarHeight: 100,
      ),
      body: SafeArea(
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MenuButton(
                text: 'Sounds',
                onPressed: () => _presenter.onSoundsPressed(),
              ),
              const SizedBox(height: 10),
              MenuButton(
                text: 'Videos',
                onPressed: () => _presenter.onVideosPressed(),
              ),
              const SizedBox(height: 10),
              MenuButton(
                text: 'Assessment',
                onPressed: navigateToAssessment,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
