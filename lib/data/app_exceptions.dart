// ignore_for_file: prefer_typing_uninitialized_variables

class AppExceptions implements Exception {
  final message;
  final prefix;

  AppExceptions([this.message, this.prefix]);

  @override
  String toString() {
    return "$prefix$message";
  }
}

class FetchDataException extends AppExceptions {
  FetchDataException([String? message])
      : super(message, "Error During Communication: ");
}

class BadRequestException extends AppExceptions {
  BadRequestException([message]) : super(message, "Invalid Request: ");
}

class UnauthorisedException extends AppExceptions {
  UnauthorisedException([message]) : super(message, "Unauthorised: ");
}

class InvalidInputException extends AppExceptions {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class NoInternetException extends AppExceptions {
  NoInternetException([String? message]) : super(message, "No Internet: ");
}

class NoServiceFoundException extends AppExceptions {
  NoServiceFoundException([String? message]) : super(message, "No Service Found: ");
}

class InvalidFormatException extends AppExceptions {
  InvalidFormatException([String? message]) : super(message, "Invalid Format: ");
}

class UnknownException extends AppExceptions {
  UnknownException([String? message]) : super(message, "Unknown Exception: ");
}

class NoDataException extends AppExceptions {
  NoDataException([String? message]) : super(message, "No Data: ");
}

class NoMoreDataException extends AppExceptions {
  NoMoreDataException([String? message]) : super(message, "No More Data: ");
}

class NoDataFoundException extends AppExceptions {
  NoDataFoundException([String? message]) : super(message, "No Data Found: ");
}

class RequestTimeoutException extends AppExceptions {
  RequestTimeoutException([String? message]) : super(message, "Request Timeout: ");
}

