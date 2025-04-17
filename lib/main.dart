
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/constants/index.dart';
import 'package:hair_salon/firebase_options.dart';
import 'package:hair_salon/localization/app_translations.dart';
import 'package:hair_salon/localization/translation_service.dart';
import 'package:hair_salon/repository/index.dart';
import 'package:hair_salon/repository/manage_staff_api/manage_staff_repo_impl%20.dart';
import 'package:hair_salon/routes/app_routes.dart';
import 'package:hair_salon/view/user_splash.dart';
import 'package:hair_salon/view_model/controller/edit_staff_controller.dart';
import 'package:hair_salon/view_model/index.dart';
import 'package:timezone/data/latest.dart' as tz;

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

  tz.initializeTimeZones();


  // Check if user is authenticated
  final isAuthenticated = await FirebaseAuthRepository().isUserAuthenticated();

  // Get saved locale
  final savedLocale = await TranslationService().getSavedLocale();

  runApp(
      SalonWithAdmin(
    isAuthenticated: isAuthenticated,
    locale: savedLocale,
  ));
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
      title: 'Salon at your Doorstep',
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
      home: UserSplashScreen(),
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

