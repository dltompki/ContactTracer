import 'package:location/location.dart';

class LocationPermission {
  final Location location = Location();

  PermissionStatus _permissionGranted;

  /// Updates [_permsissionGranted].
  Future<void> _checkPermissions() async {
    PermissionStatus permissionGrantedResult = await location.hasPermission();
    _permissionGranted = permissionGrantedResult;
  }

  /// Attempts to get the user to enable location use for the app.
  Future<void> _requestPermission() async {
    if (_permissionGranted != PermissionStatus.granted) {
      final PermissionStatus permissionRequestedResult =
          await location.requestPermission();
      _permissionGranted = permissionRequestedResult;
      if (permissionRequestedResult != PermissionStatus.granted) {
        return;
      }
    }
  }

  /// Checks if [_permissionStatus] is granted. If not, tries to get it.
  ///
  /// Returns true if permission is granted.
  /// Return false if permission is denied or denied forever.
  Future<bool> requestStatus() async {
    await _checkPermissions();
    switch (_permissionGranted) {
      case PermissionStatus.granted:
        return true;
        break;
      case PermissionStatus.deniedForever:
        return false;
        break;
      default:
        return _getPermission();
    }
  }

  /// Requests permission and returns true if successful.
  /// Returns false if permission is denied after asking the user.
  bool _getPermission() {
    _checkPermissions();
    if (_permissionGranted == PermissionStatus.granted) {
      return true;
    } else {
      _requestPermission();
      if (_permissionGranted == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
