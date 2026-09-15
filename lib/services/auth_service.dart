import 'package:gelir_gider_app/models/app_user.dart';
import 'package:gelir_gider_app/services/api_service.dart';
import 'package:gelir_gider_app/services/storage_service.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService extends GetxService {
  late final StorageService _storageService;
  late final ApiService _apiService;
  late final GoogleSignIn _googleSignIn;

  final Rx<AppUser?> currentUser = Rx<AppUser?>(null);

  // =========================================================
  // INIT
  // =========================================================

  Future<AuthService> init() async {
    _storageService = Get.find<StorageService>();
    _apiService = Get.find<ApiService>();

    _googleSignIn = GoogleSignIn.instance;

    await _googleSignIn.initialize(
      serverClientId: ApiConstants.serverClientId,
    );

    return this;
  }

  // =========================================================
  // GOOGLE LOGIN
  // =========================================================

  Future<AppUser?> signInWithGoogle() async {
    try {
      await _googleSignIn.initialize(
        serverClientId: ApiConstants.serverClientId,
      );

      await _googleSignIn.signOut();

      // v7 API'si doğrudan authenticate() kullanır
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.authenticate();

      if (googleUser == null) {
        print("Google girişi kullanıcı tarafından iptal edildi.");
        return null;
      }

      final GoogleSignInAuthentication googleAuthentication =
          await googleUser.authentication;

      print("ALINAN ID TOKEN: ${googleAuthentication.idToken}");

      if (googleAuthentication.idToken == null) {
        print("HATA: idToken üretilemedi!");
        return null;
      }

      final response = await _apiService.post(
        ApiConstants.login,
        data: {
          'idToken': googleAuthentication.idToken,
        },
      );

      if (response.statusCode == 200) {
        await _storageService.setValue(
          StorageKeys.userToken,
          response.data['token'],
        );

        print("JWT TOKEN: ${response.data['token']}");

        final user = AppUser.fromJson(
          response.data['user'],
        );

        currentUser.value = user;

        return user;
      } else {
        print("Backend giriş başarısız, Status: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Google giriş hatası: $e");
      currentUser.value = null;
      return null;
    }
  }

  // =========================================================
  // PROFİL GÜNCELLE
  // =========================================================

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
  }) async {
    try {
      final response = await _apiService.put(
        ApiConstants.profile,
        data: {
          'first_name': firstName,
          'last_name': lastName,
        },
      );

      print("UPDATE PROFILE STATUS: ${response.statusCode}");
      print("UPDATE PROFILE RESPONSE: ${response.data}");

      if (response.statusCode == 200) {
        currentUser.value = AppUser.fromJson(
          response.data,
        );
        return true;
      }

      return false;
    } catch (e) {
      print("Update profile error: $e");
      return false;
    }
  }

  // =========================================================
  // PROFİL GETİR
  // =========================================================

  Future<AppUser?> getProfile() async {
    try {
      final response = await _apiService.get(
        ApiConstants.profile,
      );

      print("GET PROFILE STATUS: ${response.statusCode}");
      print("GET PROFILE RESPONSE: ${response.data}");

      if (response.statusCode == 200) {
        final user = AppUser.fromJson(
          response.data,
        );
        currentUser.value = user;
        return user;
      }

      return null;
    } catch (e) {
      print("Get profile error: $e");
      return null;
    }
  }

  // =========================================================
  // AUTHENTICATED MI?
  // =========================================================

  Future<bool> isAuthenticated() async {
    try {
      final token = _storageService.getValue<String>(
        StorageKeys.userToken,
      );

      if (token == null) {
        currentUser.value = null;
        return false;
      }

      final response = await getProfile();

      if (response != null) {
        currentUser.value = response;
        return true;
      }

      return false;
    } catch (e) {
      print("Authentication kontrol hatası: $e");
      await _storageService.remove(
        StorageKeys.userToken,
      );
      currentUser.value = null;
      return false;
    }
  }

  // =========================================================
  // ÇIKIŞ YAP
  // =========================================================

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();

      await _storageService.remove(
        StorageKeys.userToken,
      );

      currentUser.value = null;
    } catch (e) {
      print("Çıkış yapılırken hata çıktı: $e");
    }
  }
}