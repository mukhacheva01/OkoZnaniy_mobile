class ApiConfig {
  static const String baseUrl = 'https://okoznaniy.ru';
  static const String apiUrl = '$baseUrl/api';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 15);
}

class ApiEndpoints {
  // Auth
  static const String login = '/users/token/';
  static const String register = '/users/';
  static const String me = '/users/me/';
  static const String refreshToken = '/users/token/refresh/';
  static const String verifyEmailCode = '/users/verify_email_code/';
  static const String resendVerificationCode = '/users/resend_verification_code/';
  static const String requestPasswordReset = '/users/request_password_reset/';
  static const String resetPasswordWithCode = '/users/reset_password_with_code/';
  static const String telegramAuth = '/users/telegram_auth/';
  static String telegramAuthStatus(String authId) =>
      '/users/telegram_auth_status/$authId/';

  // Users
  static const String recentUsers = '/users/recent_users/';
  static const String publicStats = '/public/stats/';
  static const String supportUser = '/users/support_user/';
  static const String updateProfile = '/users/update_me/';
  static const String submitExpertApplication =
      '/users/submit_expert_application/';
  static const String improvementSuggestions =
      '/users/improvement_suggestions/';

  // Orders
  static const String ordersList = '/orders/orders/';
  static const String ordersAvailable = '/orders/orders/available/';
  static const String clientOrders = '/users/client_orders/';
  static String orderDetail(int id) => '/orders/orders/$id/';
  static String orderTake(int id) => '/orders/orders/$id/take/';
  static String orderComplete(int id) => '/orders/orders/$id/complete/';
  static String orderSubmit(int id) => '/orders/orders/$id/submit/';
  static String orderApprove(int id) => '/orders/orders/$id/approve/';
  static String orderRevision(int id) => '/orders/orders/$id/revision/';
  static String orderReject(int id) => '/orders/orders/$id/reject/';
  static String orderExtendDeadline(int id) =>
      '/orders/orders/$id/extend_deadline/';
  static String orderUploadFile(int id) => '/orders/orders/$id/files/';
  static String orderBids(int id) => '/orders/orders/$id/bids/';
  static String orderAcceptBid(int id) => '/orders/orders/$id/accept_bid/';
  static String orderComments(int id) => '/orders/orders/$id/comments/';
  static String orderDownloadFile(int id, int fileId) =>
      '/orders/orders/$id/files/$fileId/download/';
  static String orderCreateReview(int id) =>
      '/orders/orders/$id/create_review/';

  // Shop
  static const String shopWorks = '/shop/works/';
  static String shopWorkDetail(int id) => '/shop/works/$id/';
  static String shopWorkPurchase(int id) => '/shop/works/$id/purchase/';
  static const String shopPurchased = '/shop/purchased/';

  // Chat
  static const String chatRooms = '/chat/rooms/';
  static String chatMessages(int roomId) => '/chat/rooms/$roomId/messages/';

  // Support
  static const String supportTickets = '/support/tickets/';
  static String supportTicketDetail(int id) => '/support/tickets/$id/';

  // Knowledge
  static const String knowledgeQuestions = '/knowledge/questions/';
  static String knowledgeQuestionDetail(int id) =>
      '/knowledge/questions/$id/';

  // Notifications
  static const String notifications = '/notifications/';
  static String notificationMarkRead(int id) => '/notifications/$id/read/';

  // Arbitration
  static const String complaints = '/arbitration/complaints/';
  static String complaintDetail(int id) => '/arbitration/complaints/$id/';

  // Partners
  static const String partnerStats = '/partners/stats/';
  static const String partnerReferrals = '/partners/referrals/';
  static const String partnerDashboard = '/users/partner_dashboard/';
  static const String generateReferralLink = '/users/generate_referral_link/';
  static const String partnersList = '/users/partners_list/';

  // Chat (HTTP)
  static const String chatChats = '/chat/chats/';
  static String chatSendMessage(int id) => '/chat/chats/$id/send_message/';
  static String chatViolations(int id) => '/chat/violations/$id/';
  static const String chatSupport = '/chat/support/';

  // Catalog
  static const String catalogSubjects = '/catalog/subjects/';
  static const String catalogTopics = '/catalog/topics/';
  static const String catalogWorkTypes = '/catalog/work-types/';
  static const String catalogComplexity = '/catalog/complexity-levels/';
  static const String catalogCategories = '/catalog/categories/';
  static const String catalogSkills = '/catalog/skills/';
  static const String catalogDiscounts = '/catalog/discounts/';

  // Orders (additional actions)
  static String orderFreeze(int id) => '/orders/orders/$id/freeze/';
  static String orderUnfreeze(int id) => '/orders/orders/$id/unfreeze/';
  static String orderCancel(int id) => '/orders/orders/$id/cancel/';
  static String orderReactivate(int id) => '/orders/orders/$id/reactivate/';
  static String orderDeclineBid(int id, int bidId) => '/orders/orders/$id/bids/$bidId/decline/';
  static String orderAssignExpert(int id) => '/orders/orders/$id/assign_expert/';
  static String orderDeleteFile(int id, int fileId) => '/orders/orders/$id/files/$fileId/';

  // Disputes
  static const String disputes = '/orders/disputes/';

  // Shop (purchases)
  static const String shopPurchases = '/shop/purchases/';

  // Experts
  static const String expertsMatching = '/experts/matching/';
  static const String expertSpecializations = '/experts/specializations/';
  static const String expertDocuments = '/experts/documents/';
  static const String expertReviews = '/experts/reviews/';
  static const String expertRatings = '/experts/ratings/';
  static const String expertStatistics = '/experts/statistics/';
  static const String expertDashboard = '/experts/dashboard/';
  static const String expertApplications = '/experts/applications/';

  // OAuth
  static const String googleCallback = '/users/google/callback/';
  static const String vkCallback = '/users/vk/callback/';

  // WebSocket
  static String wsNotifications(String token) => 'wss://okoznaniy.ru/ws/notifications/?token=$token';
  static String wsChat(int chatId, String token) => 'wss://okoznaniy.ru/ws/chat/$chatId/?token=$token';
}
