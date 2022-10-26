class DeviceCode{
  final String user_code;
  final String device_code;
  final String verification_uri;
  final int expires_in;
  final int interval;
  final String message;

  const DeviceCode({
    required this.user_code,
    required this.device_code,
    required this.verification_uri,
    required this.expires_in,
    required this.interval,
    required this.message
  });

  factory DeviceCode.fromJson(Map<String, dynamic> json){
    return DeviceCode(
        user_code: json['user_code'], 
        device_code: json['device_code'], 
        verification_uri: json['verification_uri'], 
        expires_in: json['expires_in'], 
        interval: json['interval'], 
        message: json['message']
      );
  }
}