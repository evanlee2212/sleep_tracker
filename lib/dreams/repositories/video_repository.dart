import '../models/video_resource.dart';

class VideoRepository {
  List<VideoResource> fetchVideos() {
    return [
      //sleep hygiene
      VideoResource(
        title: 'Sleep Hygiene Tips',
        category: 'Sleep Education',
        videoUrl: 'https://www.youtube.com/watch?v=k7_Fi0G5GsM',
      ),
      VideoResource(
        title: 'Understanding Sleep Cycles',
        category: 'Sleep Education',
        videoUrl: 'https://www.youtube.com/watch?v=t0kACis_dJE&t=3s',
      ),
      VideoResource(
        title: 'Why Sleep Is Important',
        category: 'Sleep Education',
        videoUrl: 'https://www.youtube.com/watch?v=fk-_SwHhLLc&t=21s',
      ),

      //meditation and yoga
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
        title: 'Evening Wind Down Routine',
        category: 'Meditation & Yoga',
        videoUrl: 'https://www.youtube.com/watch?v=dLxyqBjvkRg',
      ),
    ];
  }
}
