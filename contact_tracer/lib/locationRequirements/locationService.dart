import 'package:flutter/material.dart';
import 'package:location/location.dart';

class LocationService {
  final Location location = Location();

  bool _serviceEnabled = false;

  /// Updates _serviceEnabled with current state.
  Future<void> _checkService() async {
    final bool serviceEnabledResult = await location.serviceEnabled();
      _serviceEnabled = serviceEnabledResult;
  }

  /// Asks the user to enable the service.
  Future<void> _requestService() async {
    if (_serviceEnabled == null || !_serviceEnabled) {
      final bool serviceRequestedResult = await location.requestService();
        _serviceEnabled = serviceRequestedResult;
      if (!serviceRequestedResult) {
        return;
      }
    }
  }

  /// Checks if _serviceEnabled is enabled. If not, tries to get it.
  /// 
  /// Returns true if service is enabled.
  /// Return false if permission is denied or denied forever.
  bool _getStatus() {
    if (_serviceEnabled) {
      return true;
    } else {
      _getService();
    }
  }

  /// Requests service and returns true if successful.
  bool _getService() {
    _checkService();
    if (_serviceEnabled) {
      return true;
    } else {
      _requestService();
      if (_serviceEnabled) {
        return true;
      } else {
        return false;
      }
    }
  }

  bool get status => _getStatus();
}
