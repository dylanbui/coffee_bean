import 'package:coffee_bean/data/model/response/hub/hot_topic.dart';

class TopicSelectionMockData {

  static List<HotTopic> get mockTopics => List.generate(13, (index) => HotTopic(
    id: index + 1,
    topicName: 'Chủ đề thịnh hành ${index + 1}',
    topicIcon: 'https://i.pravatar.cc/100?u=${index + 1}',
  ));
}
