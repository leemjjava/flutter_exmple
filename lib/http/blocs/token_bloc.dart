import '../http_repository.dart';
import 'package:rxdart/rxdart.dart';
import '../models/token.dart';
import '../models/auth_token.dart';
import '../../utile/token_decoder.dart';

class TokenBloc {
  final _httpService = HttpRepository();
  final _tokenFetcher = PublishSubject<Token>();
  final _authTokenFetcher = PublishSubject<AuthToken>();
  final _localTokenFetcher = PublishSubject<String>();

  Stream<Token> get token => _tokenFetcher.stream;
  Stream<AuthToken> get authToken => _authTokenFetcher.stream;
  Stream<String> get localToken => _localTokenFetcher.stream;

  fetchToken() async {
    try {
      Token token = await _httpService.getToken();
      _tokenFetcher.sink.add(token);
    } catch (e) {
      _tokenFetcher.sink.addError(e);
    }
  }

  fetchAuthToken(String id, String password) async {
    try {
      AuthToken authToken = await _httpService.getAuthToken(id, password);
      _authTokenFetcher.sink.add(authToken);
    } catch (e) {
      _authTokenFetcher.sink.addError(e);
    }
  }

  fetchReAuthToken() async {
    try {
      AuthToken authToken = await _httpService.getReToken();
      _authTokenFetcher.sink.add(authToken);
    } catch (e) {
      _authTokenFetcher.sink.addError(e);
    }
  }

  fetchLocalToken() async {
    try {
      String? localToken = await getLocalToken();
      if (localToken == null) return;
      _localTokenFetcher.sink.add(localToken);
    } catch (e) {
      _localTokenFetcher.sink.addError(e);
    }
  }

  dispose() {
    _tokenFetcher.close();
    _authTokenFetcher.close();
    _localTokenFetcher.close();
  }
}
