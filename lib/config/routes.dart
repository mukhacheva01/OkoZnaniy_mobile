import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:oko_znaniy_mobile/providers/auth_provider.dart';
import 'package:oko_znaniy_mobile/screens/auth/login_screen.dart';
import 'package:oko_znaniy_mobile/screens/auth/register_screen.dart';
import 'package:oko_znaniy_mobile/screens/home/home_screen.dart';
import 'package:oko_znaniy_mobile/screens/home/landing_screen.dart';
import 'package:oko_znaniy_mobile/screens/orders/create_order_screen.dart';
import 'package:oko_znaniy_mobile/screens/orders/order_detail_screen.dart';
import 'package:oko_znaniy_mobile/screens/orders/orders_feed_screen.dart';
import 'package:oko_znaniy_mobile/screens/orders/my_works_screen.dart';
import 'package:oko_znaniy_mobile/screens/shop/shop_screen.dart';
import 'package:oko_znaniy_mobile/screens/shop/shop_work_detail_screen.dart';
import 'package:oko_znaniy_mobile/screens/shop/purchased_works_screen.dart';
import 'package:oko_znaniy_mobile/screens/chat/chat_list_screen.dart';
import 'package:oko_znaniy_mobile/screens/chat/chat_screen.dart';
import 'package:oko_znaniy_mobile/screens/support/support_center_screen.dart';
import 'package:oko_znaniy_mobile/screens/support/support_chat_screen.dart';
import 'package:oko_znaniy_mobile/screens/profile/profile_screen.dart';
import 'package:oko_znaniy_mobile/screens/profile/edit_profile_screen.dart';
import 'package:oko_znaniy_mobile/screens/expert/expert_dashboard_screen.dart';
import 'package:oko_znaniy_mobile/screens/expert/become_expert_screen.dart';
import 'package:oko_znaniy_mobile/screens/expert/expert_application_screen.dart';
import 'package:oko_znaniy_mobile/screens/partner/partner_dashboard_screen.dart';
import 'package:oko_znaniy_mobile/screens/partner/become_partner_screen.dart';
import 'package:oko_znaniy_mobile/screens/knowledge/knowledge_portal_screen.dart';
import 'package:oko_znaniy_mobile/screens/knowledge/question_detail_screen.dart';
import 'package:oko_znaniy_mobile/screens/notifications/notifications_screen.dart';
import 'package:oko_znaniy_mobile/screens/arbitration/complaint_form_screen.dart';
import 'package:oko_znaniy_mobile/screens/arbitration/complaint_detail_screen.dart';
import 'package:oko_znaniy_mobile/widgets/main_scaffold.dart';

class AppRoutes {
  static const String landing = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String createOrder = '/create-order';
  static const String orderDetail = '/orders/:orderId';
  static const String ordersFeed = '/orders-feed';
  static const String myWorks = '/works';
  static const String shop = '/shop';
  static const String shopWorkDetail = '/shop/works/:workId';
  static const String purchasedWorks = '/shop/purchased';
  static const String chatList = '/chats';
  static const String chat = '/chats/:chatId';
  static const String supportCenter = '/support';
  static const String supportChat = '/support-chat/:chatId';
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String expertDashboard = '/expert';
  static const String becomeExpert = '/become-expert';
  static const String expertApplication = '/expert-application';
  static const String partnerDashboard = '/partner';
  static const String becomePartner = '/become-partner';
  static const String knowledgePortal = '/knowledge';
  static const String questionDetail = '/knowledge/:id';
  static const String notifications = '/notifications';
  static const String complaintForm = '/orders/:orderId/complaint';
  static const String complaintDetail = '/arbitration/complaint/:complaintId';

  static GoRouter router(AuthProvider authProvider) {
    return GoRouter(
      initialLocation: landing,
      refreshListenable: authProvider,
      redirect: (BuildContext context, GoRouterState state) {
        final isLoggedIn = authProvider.isAuthenticated;
        final isAuthRoute = state.matchedLocation == login ||
            state.matchedLocation == register ||
            state.matchedLocation == landing;

        if (!isLoggedIn && !isAuthRoute) {
          return login;
        }
        if (isLoggedIn && (state.matchedLocation == login ||
            state.matchedLocation == register ||
            state.matchedLocation == landing)) {
          return home;
        }
        return null;
      },
      routes: [
        GoRoute(
          path: landing,
          builder: (context, state) => const LandingScreen(),
        ),
        GoRoute(
          path: login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: register,
          builder: (context, state) => const RegisterScreen(),
        ),
        ShellRoute(
          builder: (context, state, child) => MainScaffold(child: child),
          routes: [
            GoRoute(
              path: home,
              builder: (context, state) => const HomeScreen(),
            ),
            GoRoute(
              path: ordersFeed,
              builder: (context, state) => const OrdersFeedScreen(),
            ),
            GoRoute(
              path: myWorks,
              builder: (context, state) => const MyWorksScreen(),
            ),
            GoRoute(
              path: shop,
              builder: (context, state) => const ShopScreen(),
            ),
            GoRoute(
              path: chatList,
              builder: (context, state) => const ChatListScreen(),
            ),
            GoRoute(
              path: profile,
              builder: (context, state) => const ProfileScreen(),
            ),
          ],
        ),
        GoRoute(
          path: createOrder,
          builder: (context, state) => const CreateOrderScreen(),
        ),
        GoRoute(
          path: orderDetail,
          builder: (context, state) {
            final orderId =
                int.parse(state.pathParameters['orderId']!);
            return OrderDetailScreen(orderId: orderId);
          },
        ),
        GoRoute(
          path: shopWorkDetail,
          builder: (context, state) {
            final workId = int.parse(state.pathParameters['workId']!);
            return ShopWorkDetailScreen(workId: workId);
          },
        ),
        GoRoute(
          path: purchasedWorks,
          builder: (context, state) => const PurchasedWorksScreen(),
        ),
        GoRoute(
          path: chat,
          builder: (context, state) {
            final chatId = int.parse(state.pathParameters['chatId']!);
            return ChatScreen(chatId: chatId);
          },
        ),
        GoRoute(
          path: supportCenter,
          builder: (context, state) => const SupportCenterScreen(),
        ),
        GoRoute(
          path: supportChat,
          builder: (context, state) {
            final chatId = int.parse(state.pathParameters['chatId']!);
            return SupportChatScreen(chatId: chatId);
          },
        ),
        GoRoute(
          path: editProfile,
          builder: (context, state) => const EditProfileScreen(),
        ),
        GoRoute(
          path: expertDashboard,
          builder: (context, state) => const ExpertDashboardScreen(),
        ),
        GoRoute(
          path: becomeExpert,
          builder: (context, state) => const BecomeExpertScreen(),
        ),
        GoRoute(
          path: expertApplication,
          builder: (context, state) => const ExpertApplicationScreen(),
        ),
        GoRoute(
          path: partnerDashboard,
          builder: (context, state) => const PartnerDashboardScreen(),
        ),
        GoRoute(
          path: becomePartner,
          builder: (context, state) => const BecomePartnerScreen(),
        ),
        GoRoute(
          path: knowledgePortal,
          builder: (context, state) => const KnowledgePortalScreen(),
        ),
        GoRoute(
          path: questionDetail,
          builder: (context, state) {
            final id = int.parse(state.pathParameters['id']!);
            return QuestionDetailScreen(questionId: id);
          },
        ),
        GoRoute(
          path: notifications,
          builder: (context, state) => const NotificationsScreen(),
        ),
        GoRoute(
          path: complaintForm,
          builder: (context, state) {
            final orderId =
                int.parse(state.pathParameters['orderId']!);
            return ComplaintFormScreen(orderId: orderId);
          },
        ),
        GoRoute(
          path: complaintDetail,
          builder: (context, state) {
            final complaintId =
                int.parse(state.pathParameters['complaintId']!);
            return ComplaintDetailScreen(complaintId: complaintId);
          },
        ),
      ],
    );
  }
}
