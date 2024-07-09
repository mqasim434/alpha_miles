class RiderModel {
  String? riderId;
  String? fullName;
  String? emiratesId;
  String? emiratesIdExpiryDate;
  String? location;
  String? liscenceNumber;
  String? liscenceNumberExpiryDate;
  String? channelName;
  String? salaryPassword;
  String? imageUrl;
  List<Map<String, dynamic>>? documenstUrlsList;

  RiderModel({
    this.riderId,
    this.fullName,
    this.emiratesId,
    this.emiratesIdExpiryDate,
    this.location,
    this.liscenceNumber,
    this.liscenceNumberExpiryDate,
    this.channelName,
    this.salaryPassword,
    this.imageUrl,
    this.documenstUrlsList,
  });

  RiderModel.fromJson(Map<String, dynamic> json) {
    riderId = json['riderId'];
    fullName = json['fullName'];
    emiratesId = json['emiratesId'];
    emiratesIdExpiryDate = json['emiratesIdExpiryDate'];
    location = json['location'];
    liscenceNumber = json['liscenceNumber'];
    liscenceNumberExpiryDate = json['liscenceNumberExpiryDate'];
    channelName = json['channelName'];
    salaryPassword = json['salaryPassword'];
    imageUrl = json['imageUrl'];
    if (json['documenstUrlsList'] != null) {
      documenstUrlsList = List<Map<String, dynamic>>.from(
        json['documenstUrlsList']
            .map((item) => Map<String, dynamic>.from(item)),
      );
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['riderId'] = riderId;
    data['fullName'] = fullName;
    data['emiratesId'] = emiratesId;
    data['emiratesIdExpiryDate'] = emiratesIdExpiryDate;
    data['location'] = location;
    data['liscenceNumber'] = liscenceNumber;
    data['liscenceNumberExpiryDate'] = liscenceNumberExpiryDate;
    data['channelName'] = channelName;
    data['imageUrl'] = imageUrl;
    data['salaryPassword'] = salaryPassword;
    if (documenstUrlsList != null) {
      data['documenstUrlsList'] = documenstUrlsList!
          .map((item) => Map<String, dynamic>.from(item))
          .toList();
    }
    return data;
  }

  static List<RiderModel> ridersList = [];
}
