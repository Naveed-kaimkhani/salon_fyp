import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/constants/index.dart';
import 'package:hair_salon/firebase_options.dart';
import 'package:hair_salon/localization/app_translations.dart';
import 'package:hair_salon/localization/translation_service.dart';
import 'package:hair_salon/repository/index.dart';
import 'package:hair_salon/repository/manage_staff_api/manage_staff_repo_impl%20.dart';
import 'package:hair_salon/routes/app_routes.dart';

import 'package:hair_salon/view/splash_screen.dart';
import 'package:hair_salon/view/user_signin_screen.dart';
import 'package:hair_salon/view/user_splash.dart';
import 'package:hair_salon/view_model/controller/edit_staff_controller.dart';
import 'package:hair_salon/view_model/index.dart';
import 'package:timezone/data/latest.dart' as tz;

// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  servicesLocator();
  Get.put<AuthRepository>(FirebaseAuthRepository());
  // Get.put<HomeController>(HomeController());

  Get.put(TreatmentCardController());
  Get.put(
      FirebaseAppointmentRepository()); // Add this line to register the repository
  Get.put(DateSelectionController());
  Get.put(TimeSelectionController());
  Get.put(TreatmentCardController());
  Get.put(StaffController(staffServices: Get.find<StaffServicesRepository>()));

  Get.put(
      EditStaffController(staffServices: Get.find<StaffServicesRepository>()));
  Get.put(
      AppointmentProvider(appointmentRepo: Get.find<IAppointmentRepository>()));
  Get.put(ManageServiceProvider(serviceRepo: Get.find<ManageServiceRepo>()));
  Get.put(BlockedDatesProvider(
      blockedDatesRepository: Get.find<BlockedDatesRepository>()));
  Get.put(RecurringAppointmentController());

  await initializeNotifications();

  NotificationService notificationService = NotificationService();
  notificationService.requestPermissions();
  notificationService.listenToFirestoreNotifications();
  notificationService.saveDeviceToken();

  // Initialize time zones for scheduled notifications
  tz.initializeTimeZones();

  // Set up Firebase Messaging background handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  final RemoteMessage? initialMessage =
      await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    handleInitialMessage(initialMessage);
  }

  // Check if user is authenticated
  final isAuthenticated = await FirebaseAuthRepository().isUserAuthenticated();

  // Get saved locale
  final savedLocale = await TranslationService().getSavedLocale();

  // runApp(DevicePreview(
  //   enabled: !kReleaseMode && !kDebugMode,
  //   builder: (context) => SalonWithAdmin(
  //     isAuthenticated: isAuthenticated,
  //     locale: savedLocale,
  //   ),
  // ));
  runApp(SalonWithAdmin(
      isAuthenticated: isAuthenticated,
      locale: savedLocale,
    ),);
}

class SalonWithAdmin extends StatelessWidget {
  final bool isAuthenticated;
  final Locale locale;

  const SalonWithAdmin(
      {Key? key, required this.isAuthenticated, required this.locale})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shlomi Stav',
      defaultTransition: Transition.cupertino,
      theme: ThemeData(
        fontFamily: "Inter",
        scaffoldBackgroundColor: AppColors.white,
        appBarTheme: const AppBarTheme(
          color: AppColors.white,
          centerTitle: true,
        ),
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.white),
        useMaterial3: true,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.grey,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.black,
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: RouteName.userSplashScreen,
      getPages: AppRoutes.getAppRoutes(),
      locale: locale,
      translations: AppTranslations(),
      home: AccountVerificationScreen(),
    );
  }
}

void servicesLocator() {
  // Register AuthRepository with FirebaseAuthRepository
  Get.lazyPut<AuthRepository>(() => FirebaseAuthRepository());

  // Register StaffServicesRepository with StaffServicesRepositoryImpl
  Get.lazyPut<StaffServicesRepository>(() => StaffServicesRepositoryImpl());

  // Register IAppointmentRepository with FirebaseAppointmentRepository
  Get.lazyPut<IAppointmentRepository>(() => FirebaseAppointmentRepository());

  // Register ManageServiceRepo with ManageServiceRepoImpl
  Get.lazyPut<ManageServiceRepo>(() => ManageServiceRepoImpl());

  // Register BlockedDatesRepository with FirbaseBlockedDatesRepository
  Get.lazyPut<BlockedDatesRepository>(() => FirbaseBlockedDatesRepository());
}

// Initialize Flutter Local Notifications
Future<void> initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // await flutterLocalNotificationsPlugin.initialize(
  //   initializationSettings,
  //   onDidReceiveNotificationResponse: (NotificationResponse response) {
  //     if (response.payload == RouteName.appointmentScreen) {
  //       Get.toNamed(RouteName.appointmentScreen);
  //     }
  //   },
  // );
}

void handleInitialMessage(RemoteMessage message) {
  // Handle the notification when the app is launched from a terminated state
  if (message.notification != null) {
    print("Notification Title: ${message.notification?.title}");
    print("Notification Body: ${message.notification?.body}");
  }

  if (message.data.containsKey('route')) {
    // Navigate to the specific route
    final String route = message.data['route'];
    Get.toNamed(route);
  }
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase
      .initializeApp(); // Always initialize Firebase in the background handler
  if (message.notification != null) {
    print("Background Notification: ${message.notification?.title}");
    print("Background Notification Body: ${message.notification?.body}");
  }

  if (message.data.containsKey('route')) {
    final String route = message.data['route'];
    Get.toNamed(route); // Example of navigating in the background
  }
}
