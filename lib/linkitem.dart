class LinkItem {
  String name;
  String urlLink;
  int upVotes;
  int downVotes;

  LinkItem({
    required this.name,
    required this.urlLink,
    this.upVotes = 0,
    this.downVotes = 0,
  });

  void incrementUpVotes() {
    upVotes++;
  }

  void incrementDownVotes() {
    downVotes++;
  }

  void decrementUpVotes() {
    upVotes--;
  }

  void decrementDownVotes() {
    downVotes--;
  }

  int get totalVotes => upVotes - downVotes;

  Map<String, dynamic> toJSONEncodable() {
    return {
      'name': name,
      'urlLink': urlLink,
      'upVotes': upVotes,
      'downVotes': downVotes,
    };
  }
}
