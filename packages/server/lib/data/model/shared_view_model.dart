typedef SharedViewModelUser = ({
  String id,
  String title,
  String description,
  String imagePath,
});

typedef SharedViewModelBeacon = ({
  String id,
  String title,
  String description,
  String place,
  String time,
  SharedViewModelUser author,
  String imagePath,
});

typedef SharedViewModelComment = ({
  String id,
  String content,
  SharedViewModelBeacon beacon,
  SharedViewModelUser commentor,
  String imagePath,
});
