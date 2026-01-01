
String responseOfStatusCode(int? statusCode) {
  if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
    return 'Bad Response Some Thing Went Wrong';
  } else if (statusCode == 404) {
    return 'Your request not found, Please try later!';
  } else if (statusCode == 500) {
    return 'Internal Server error, Please try later';
  } else {
    return 'Opps There was an Error, Please try again $statusCode';
  }
}