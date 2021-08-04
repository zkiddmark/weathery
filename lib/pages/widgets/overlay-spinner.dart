import 'dart:async';

import 'package:flutter/material.dart';

class OverlaySpinner {
  Stream<bool> showSpinnerStream;
  late OverlayEntry _overlayEntry;
  late OverlayState _overlayState;
  late StreamSubscription _subscription;

  OverlaySpinner({required this.showSpinnerStream});

  _setupSpinnerWidget(BuildContext context) {
    _overlayState = Overlay.of(context)!;
    // showSpinnerStream = _weatherService.fetchingData.stream;
    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        child: SizedBox.expand(
          child: Container(
            color: Colors.black12,
            child: Center(
              child: SizedBox(
                width: 100,
                height: 100,
                child: CircularProgressIndicator(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  factory OverlaySpinner.create(
      Stream<bool> showSpinnerStream, BuildContext context) {
    var spinner = OverlaySpinner(showSpinnerStream: showSpinnerStream);
    spinner._setupSpinnerWidget(context);
    return spinner;
  }

  void showSpinner() {
    _overlayState.insert(_overlayEntry);
  }

  void removeSpinner() {
    _overlayEntry.remove();
  }

  void setupSubscription(Function setState) {
    _subscription = showSpinnerStream.listen((event) {
      if (event == true) {
        setState(() {
          showSpinner();
        });
      } else {
        setState(() {
          removeSpinner();
        });
      }
    });
  }

  void disposeSpinner() {
    _subscription.cancel();
  }
}
