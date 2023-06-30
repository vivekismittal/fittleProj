class AuthInputDetailModel {
  const AuthInputDetailModel({
    required this.mobile,
    required this.isTncAccepted,
    required this.isWhatsappSubscribed,
  });

  final String mobile;
  final bool isTncAccepted;
  final bool isWhatsappSubscribed;
}
