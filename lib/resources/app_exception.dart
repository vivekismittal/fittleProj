
class AppExceptions implements Exception{
  AppExceptions([this._message, this._prefix]);
  final String? _message;
  final String? _prefix;
  @override
  String toString(){
    return "$_prefix$_message";
  }
}

//If we can't communicate with the network then this will throw ann exception after a certain time
class ClientRequestException extends AppExceptions{
  ClientRequestException({String? message}) : super(message, "");
}
class ServerException extends AppExceptions{
  ServerException({String? message}) : super(message, "Error During Communication");
}
class RequestTimeOutException extends AppExceptions{
  RequestTimeOutException({String? message}) : super(message, "Request TimeOut");
}
//If the BaseUrl is wrong and if the api is not available
class BadRequestException extends AppExceptions{
  BadRequestException({String? message}) : super(message, "");
}

//While doing signup/ login we get a token which validate that user has this app access/ data access
class UnAuthorizedException extends AppExceptions{
  UnAuthorizedException({String? message}) : super(message, "");
}

class InvalidInputException extends AppExceptions{
  InvalidInputException({String? message}) : super(message, "Invalid Input");
}
