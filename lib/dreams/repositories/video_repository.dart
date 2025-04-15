import '../models/video_resource.dart';

class VideoRepository {
  List<VideoResource> fetchVideos() {
    return [
      //Sleep Hygiene
      VideoResource(
        title: 'Sleep Hygiene Tips',
        category: 'Sleep Hygiene',
        videoUrl: 'https://www.youtube.com/watch?v=k7_Fi0G5GsM',
      ),
      VideoResource(
        title: 'Understanding Sleep Cycles',
        category: 'Sleep Hygiene',
        videoUrl: 'https://www.youtube.com/watch?v=t0kACis_dJE&t=3s',
      ),
      VideoResource(
        title: 'Why Sleep Is Important',
        category: 'Sleep Hygiene',
        videoUrl: 'https://www.youtube.com/watch?v=fk-_SwHhLLc&t=21s',
      ),

      //Research on Sleep
      VideoResource(
        title: 'Why Do We Sleep? – SciShow',
        category: 'Research on Sleep',
        videoUrl: 'https://www.youtube.com/watch?v=LWULB9Aoopc',
      ),
      VideoResource(
        title: 'Sleep is your superpower | Matt Walker | TED',
        category: 'Research on Sleep',
        videoUrl: 'https://www.youtube.com/watch?v=5MuIMqhT8DM',
      ),
      VideoResource(
        title: 'How to Fall Asleep Fast (10 Tips) – AsapSCIENCE',
        category: 'Research on Sleep',
        videoUrl: 'https://www.youtube.com/watch?v=gbQFSMayJxk',
      ),

      //Relaxation Techniques
      VideoResource(
        title: 'Guided Meditation for Sleep',
        category: 'Meditation & Yoga',
        videoUrl: 'https://www.youtube.com/watch?v=v7SN-d4qXx0&t=3s',
      ),
      VideoResource(
        title: 'Bedtime Yoga',
        category: 'Meditation & Yoga',
        videoUrl: 'https://www.youtube.com/watch?v=SrkTBWfZc3Q',
      ),
      VideoResource(
        title: '"4-7-8 Breathing Exercise to Relax & Fall Asleep" – Michael Sealey',
        category: 'Meditation & Yoga',
        videoUrl: 'https://www.youtube.com/watch?v=_ZLqXqG6tRA',
      ),
      VideoResource(
        title: 'Evening Wind Down Routine',
        category: 'Meditation & Yoga',
        videoUrl: 'https://www.youtube.com/watch?v=dLxyqBjvkRg',



      ),
    ];
  }
}
