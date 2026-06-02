class MomoResponse {
  final String payUrl;
  final String? deeplink;
  final String? qrCodeUrl;
  final String orderId;
  final String requestId;
  final int resultCode;
  final String message;

  MomoResponse({
    required this.payUrl,
    this.deeplink,
    this.qrCodeUrl,
    required this.orderId,
    required this.requestId,
    required this.resultCode,
    required this.message,
  });

  factory MomoResponse.fromJson(Map<String, dynamic> json) {
    return MomoResponse(
      payUrl: json['payUrl'],
      deeplink: json['deeplink'],
      qrCodeUrl: json['qrCodeUrl'],
      orderId: json['orderId'],
      requestId: json['requestId'],
      resultCode: json['resultCode'],
      message: json['message'],
    );
  }
}
