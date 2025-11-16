import 'package:local_auth/local_auth.dart';

class AuthService {
  static final _auth = LocalAuthentication();

  static Future<bool> authenticate() async {
    final canCheck =
        await _auth.canCheckBiometrics || await _auth.isDeviceSupported();
    if (!canCheck) return false;

    return await _auth.authenticate(
      localizedReason: 'Autentique-se para abrir o Ticker',
      biometricOnly: true,
      persistAcrossBackgrounding: true,
    );
  }
}
