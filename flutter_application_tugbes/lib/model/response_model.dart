class DataResponse {
  final String? insertedId;
  final String message;
  final int status;

  DataResponse({
    this.insertedId,
    required this.message,
    required this.status,
  });

  factory DataResponse.fromJson(Map<String, dynamic> json) => DataResponse(
        insertedId: json["data"] != null ? json["data"]["_id"] : null,
        message: json["message"],
        status: json["status"],
      );
}
