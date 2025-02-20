import 'package:get/get.dart';
import 'package:hair_salon/constants/constants.dart';
import 'package:hair_salon/repository/auth_api/auth_api.dart';
import 'package:hair_salon/view/admin/admin.dart';
import 'package:hair_salon/view/admin/admin_splash_screen.dart';
import 'package:hair_salon/view/admin/image_management_screen.dart';
import 'package:hair_salon/view/edit_appointment_screen.dart';
import 'package:hair_salon/view/salon_registration/salon_registration_screen.dart';
import 'package:hair_salon/view/user_signin_screen.dart';
import 'package:hair_salon/view/user_splash.dart';
import 'package:hair_salon/view/view.dart';

import '../view/salon_registration/bussiness_details.dart';

class AppRoutes {
  static getAppRoutes() => [
        GetPage(
            name: RouteName.splashScreen,
            page: () => const SplashScreen(),
            transition: Transition.cupertino),

        GetPage(
          name: RouteName.appointmentScreen,
          page: () => AppointmentScreen(),
        ),
        GetPage(
          name: RouteName.manageServicesScreen,
          page: () => ManageServicesScreen(),
        ),
        GetPage(
          name: RouteName.userHomeScreen,
          page: () => BottomNavigationBarComponent(),
        ),
        GetPage(
          name: RouteName.userSplashScreen,
          page: () => UserSplashScreen(),
        ),
         GetPage

         (
          name: RouteName.bussinessDetails,
          page: () => BussinessDetails()
          ,
        ),
         GetPage
         (
          name: RouteName.userSignInScreen,
          page: () => UserSignInScreen()
          ,
        ),
         GetPage(
          name: RouteName.salonRegistrationScreen,
          page: () => SalonRegistrationScreen()
          ,
        ),
        GetPage(
          name: RouteName.userSignUpScreen,
          page: () => const UserSignUpScreen(),
        ),
        GetPage(
          name: RouteName.userLoginScreen,
          page: () => UserLogInScreen(),
        ),
        // GetPage(
        //   name: RouteName.roleSelectionScreen,
        //   page: () => RoleSelectionScreen(),
        // ),
        GetPage(
          name: RouteName.notificationScreen,
          page: () => const NotificationsScreen(),
        ),
        GetPage(
          name: RouteName.bookAppointmentScreen,
          page: () => BookingAppointmentScreen(),
        ),
        GetPage(
          name: RouteName.selectTreatmentScreen,
          page: () => SelectTreatmentScreen(),
        ),
        GetPage(
          name: RouteName.bookingConfirmedScreen,
          page: () => const BookingConfirmedScreen(),
        ),
        GetPage(
          name: RouteName.editProfileScreen,
          page: () => const EditProfileScreen(),
        ),
        GetPage(
          name: '/edit_appointment',
          page: () => EditAppointmentScreen(),
        ),
        GetPage(
            name: RouteName.userNavBar,
            page: () => BottomNavigationBarComponent(),
            transition: Transition.cupertino),
        GetPage(
            name: RouteName.adminBottomNavBar,
            page: () => AdminBottomNavBar(),
            transition: Transition.cupertino),

        //  GetPage(
        //   name: RouteName.assignSecvicesScreen,
        //   page: () => const EditProfileScreen(),
        // ),

//admin Routs
        GetPage(
          name: RouteName.adminLoginScreen,
          page: () => AdminLogInScreen(
            authRepository: Get.find<AuthRepository>(),
          ),
        ),
        GetPage(
            name: RouteName.adminSplashScreen,
            page: () => const AdminSplashScreen(),
            transition: Transition.cupertino),
        // GetPage(
        //   name: RouteName.allAppointmentsScreen,
        //   page: () => AllAppointmentsScreen(),
        // ),
        GetPage(
          name: RouteName.bottomNavBar,
          page: () => AdminBottomNavBar(),
        ),
        // GetPage(
        //   name: RouteName.appointmentDetailsScreen,
        //   page: () => const AppointmentDetailsScreen(),
        // ),
        GetPage(
          name: RouteName.staffManagementScreen,
          page: () => const StaffManagementScreen(),
        ),

        GetPage(
          name: RouteName.addStaffMemberScreen,
          page: () => AddStaffMemberScreen(),
        ),
        GetPage(
          name: RouteName.assignSecvicesScreen,
          page: () => AssignServicesScreen(
            staffName: Get.parameters['staffName']!, // Retrieve the argument
          ),
        ),

        // GetPage(
        //   name: RouteName.staffProfileScreen,
        //   page: () => const StaffProfileScreen(),
        // ),
        GetPage(
          name: RouteName.addServicesScreen,
          page: () => AddServiceScreen(),
        ),
        GetPage(
          name: RouteName.pushNotificationScreen,
          page: () => AdminPushNotificationScreen(),
        ),
        GetPage(
          name: RouteName.imageManagementScreen,
          page: () => ImageManagementScreen(),
        ),
        GetPage(
          name: RouteName.blockDatesScreen,
          page: () => BlockDatesScreen(),
        ),
        GetPage(
          name: RouteName.workHoursScreen,
          page: () => WorkHoursScreen(),
        ),
      ];
}
