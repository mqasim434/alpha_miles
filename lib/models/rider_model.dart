class RiderModel {
  String? riderId;
  String? fullName;
  String? emiratesId;
  String? emiratesIdLocation;
  String? liscenceNumber;
  String? channelName;
  String? imageUrl;
  List<Map<String, String>>? documenstUrlsList;
  static int id = 100;

  RiderModel({
    this.riderId,
    this.fullName,
    this.emiratesId,
    this.emiratesIdLocation,
    this.liscenceNumber,
    this.channelName,
    this.imageUrl,
    this.documenstUrlsList,
  }) {
    id++;
    riderId = "rider-$id";
  }

  RiderModel.fromJson(Map<String, dynamic> json) {
    riderId = json['riderId'];
    fullName = json['fullName'];
    emiratesId = json['emiratesId'];
    emiratesIdLocation = json['emiratesIdLocation'];
    liscenceNumber = json['liscenceNumber'];
    channelName = json['channelName'];
    imageUrl = json['imageUrl'];
    if (json['documenstUrlsList'] != null) {
      documenstUrlsList = List<Map<String, String>>.from(
        json['documenstUrlsList'].map((item) => Map<String, String>.from(item)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['riderId'] = riderId;
    data['fullName'] = fullName;
    data['emiratesId'] = emiratesId;
    data['emiratesIdLocation'] = emiratesIdLocation;
    data['liscenceNumber'] = liscenceNumber;
    data['channelName'] = channelName;
    data['imageUrl'] = imageUrl;
    if (documenstUrlsList != null) {
      data['documenstUrlsList'] = documenstUrlsList!
          .map((item) => Map<String, String>.from(item))
          .toList();
    }
    return data;
  }

  static List<RiderModel> ridersList = [];
}
