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

  RiderModel(
      {this.riderId,
      this.fullName,
      this.emiratesId,
      this.emiratesIdLocation,
      this.liscenceNumber,
      this.channelName,
      this.imageUrl,
      this.documenstUrlsList}) {
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
    documenstUrlsList = json['documenstUrlsList'].cast<String>();
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
    data['documenstUrlsList'] = documenstUrlsList;
    return data;
  }

  static List<RiderModel> ridersList = [
    RiderModel(
        fullName: "Muhammad Qasim",
        emiratesId: '12345',
        emiratesIdLocation: 'Gujrat',
        liscenceNumber: '87655342',
        channelName: 'Emirateds',
        imageUrl:
            'https://images.pexels.com/photos/15818869/pexels-photo-15818869/free-photo-of-person-riding-extremely-packed-bike.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        documenstUrlsList: [
          {'asd': "asd"}
        ]),
    RiderModel(
        fullName: "Hassan Raza",
        emiratesId: '12345',
        emiratesIdLocation: 'Gujrat',
        liscenceNumber: '87655342',
        channelName: 'Emirates',
        imageUrl:
            'https://images.pexels.com/photos/21050507/pexels-photo-21050507/free-photo-of-a-woman-with-an-umbrella-and-a-black-bag.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
        documenstUrlsList: [
          {'asd': "asd"}
        ]),
  ];
}
