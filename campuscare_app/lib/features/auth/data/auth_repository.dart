import 'auth_api_service.dart';
import 'auth_token_storage.dart';
import 'login_request.dart';
import 'login_response.dart';

class AuthRepository {
  AuthRepository({
    required AuthApiService apiService,
    required AuthTokenStorage tokenStorage,
  }) : _apiService = apiService,
       _tokenStorage = tokenStorage;

  final AuthApiService _apiService;
  final AuthTokenStorage _tokenStorage;

  Future<LoginResponse> login({
    required String username,
    required String password,
  }) async {
    final response = await _apiService.login(
      LoginRequest(username: username, password: password),
    );

    await _tokenStorage.saveAccessToken(response.accessToken);

    return response;
  }

  Future<void> logout() async {
    await _tokenStorage.clearAccessToken();
  }

  bool hasAccessToken() {
    return _tokenStorage.readAccessToken() != null;
  }
}
