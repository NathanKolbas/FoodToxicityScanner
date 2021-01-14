library api;

import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:food_toxicity_scanner/models/ingredient.dart' as Model;
import 'package:food_toxicity_scanner/models/ingredient_log.dart';
import 'package:food_toxicity_scanner/models/user.dart' as Model;
import 'package:http/http.dart' as http;

part 'ingredient.dart';
part 'auth.dart';
part 'user.dart';

// Make sure to set the URL of the api
// const String _url = '';

// Examples
const String _url = 'https://food-toxicity-scanner.herokuapp.com/api/v1/';
// const String _url = 'http://192.168.1.30:3000/api/v1/';
// const String _url = 'http://192.168.201.2:3000/api/v1/';

// Taken from the HttpStatus class as that package is not available outside of web and is discouraged
const int continue_ = 100;
const int switchingProtocols = 101;
const int processing = 102;
const int ok = 200;
const int created = 201;
const int accepted = 202;
const int nonAuthoritativeInformation = 203;
const int noContent = 204;
const int resetContent = 205;
const int partialContent = 206;
const int multiStatus = 207;
const int alreadyReported = 208;
const int imUsed = 226;
const int multipleChoices = 300;
const int movedPermanently = 301;
const int found = 302;
const int movedTemporarily = 302; // Common alias for found.
const int seeOther = 303;
const int notModified = 304;
const int useProxy = 305;
const int temporaryRedirect = 307;
const int permanentRedirect = 308;
const int badRequest = 400;
const int unauthorized = 401;
const int paymentRequired = 402;
const int forbidden = 403;
const int notFound = 404;
const int methodNotAllowed = 405;
const int notAcceptable = 406;
const int proxyAuthenticationRequired = 407;
const int requestTimeout = 408;
const int conflict = 409;
const int gone = 410;
const int lengthRequired = 411;
const int preconditionFailed = 412;
const int requestEntityTooLarge = 413;
const int requestUriTooLong = 414;
const int unsupportedMediaType = 415;
const int requestedRangeNotSatisfiable = 416;
const int expectationFailed = 417;
const int misdirectedRequest = 421;
const int unprocessableEntity = 422;
const int locked = 423;
const int failedDependency = 424;
const int upgradeRequired = 426;
const int preconditionRequired = 428;
const int tooManyRequests = 429;
const int requestHeaderFieldsTooLarge = 431;
const int connectionClosedWithoutResponse = 444;
const int unavailableForLegalReasons = 451;
const int clientClosedRequest = 499;
const int internalServerError = 500;
const int notImplemented = 501;
const int badGateway = 502;
const int serviceUnavailable = 503;
const int gatewayTimeout = 504;
const int httpVersionNotSupported = 505;
const int variantAlsoNegotiates = 506;
const int insufficientStorage = 507;
const int loopDetected = 508;
const int notExtended = 510;
const int networkAuthenticationRequired = 511;
// Client generated status code.
const int networkConnectTimeoutError = 599;

class ApiException implements Exception {
  final cause;
  ApiException(this.cause);
}
