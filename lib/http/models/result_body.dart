class ResultBody<T> {
  final int statusCode;
  final String? message;
  final dynamic? data;

  ResultBody({
    required this.statusCode,
    this.message,
    this.data,
  });

  factory ResultBody.fromJson(Map<String, dynamic> json, int statusCode) {
    return ResultBody(
      statusCode: statusCode,
      message: json['message'] as String,
      data: json['data'] as dynamic,
    );
  }
}
