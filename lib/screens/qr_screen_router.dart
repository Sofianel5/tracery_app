import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/screens/qr_code_screen_venue.dart';
import 'package:tracery_app/screens/qrcode_screen.dart';

class QrScreenRouter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context);
    return userRepo.user.isVenueAdmin ? QRScreenVenue(userRepo: userRepo,) : QRScreen(userRepo: userRepo,);
  }
}