class TeCNetworkLayerConstants {
  static const int success = 200; // success with data
  static const int noContent = 201; // success with no data (no content)
  static const int badRequest = 400; // failure, API rejected request
  static const int unAuthorised = 401; // failure, user is not authorised
  static const int forbidden = 403; //  failure, API rejected request
  static const int internalServerError = 500; // failure, crash in server side
  static const int notFound = 404; // failure, not found
  static const int unknown = 9999; //unknown
  static const int responseNotValid = 8888; //response not valid
  static const int defaultInCaseOfNull = 5555; //default in case of null
  static const int noInternetConnection = 4444; //no internet connection
  static const int dioNetworkLayerException =
      3333; //dio network layer exception
  static const int badCertificate = 1233; //bad certificate | No match
  static const int connectionTimeout = 1244; //connection timeout
  static const int requestCancelled = 1245; //request Cancelled
  static const int receiveTimeout = 1246;
  static const int sendTimeout = 1247;
  static const int connectionError = 1248;
}

class TeCDMPNetworkConstants {
  /// private constructor
  TeCDMPNetworkConstants._();

  /// the one and only instance of this singleton
  static final instance = TeCDMPNetworkConstants._();

  String baseUrl = "";
  int appNetworkLayerTimeoutInSeconds = 60;
  String baseUrlForCDPEvents = "";
  String fallBackBaseUrlForCDPEvents = "";
  Map<String, String> requestHeaders = {};
  Map<String, String> cdpEventsRequestHeaders = {};

  ///Add or Assign any list of strings for the SSL keys in this list
  List<String> appSSLConfigs = [];

  ///To validate through the SSL the below should be true | Default is false
  ///It is bypassing the SSL by default
  bool validateThroughSSL = false;

  ///Network Endpoint for the CDP Events
  String networkRequestEndpointForCDPEvents = "";

  ///Network Fallback Endpoint for the CDP Events
  String networkFallbackRequestEndpointForCDPEvents = "";

  ///Verify App Version
  String verifyAppVersionEndPoint = "";

  ///App Content
  String appContentEndPoint = "";

  ///App Translations
  String appTranslationsEndPoint = "";

  ///App Theme
  String appThemeEndPoint = "";

  ///Verify Login OTP
  String verifyLoginOTPEndPoint = "";

  ///Generate Login OTP
  String generateLoginOTPEndPoint = "";

  ///Perform Login
  String performLoginEndPoint = "";

  ///Get Dashboard
  String getDashboardEndPoint = "";

  ///App Resume
  String appResumeEndPoint = "";

  ///FAQs
  String faqsEndPoint = "";

  ///App Menus
  String appMenusEndPoint = "";

  ///App Logout
  String appLogoutEndPoint = "";

  ///Dashboard Widgets
  String dashboardWidgetsEndPoint = "";

  ///Dashboard Widgets details
  String dashboardWidgetsDetailsEndPoint = "";

  ///Update Profile
  String updateProfileEndPoint = "";

  ///Get offers
  String getOffersEndPoint = "";

  ///Subscribe offers
  String subscribeOfferEndPoint = "";

  ///Unsubscribe offers
  String unSubscribeOfferEndPoint = "";

  ///Get Complaints
  String getComplaintsEndPoint = "";

  ///Get Complaint details
  String getComplaintDetailsEndPoint = "";

  ///Get Complaint Categories
  String getComplaintCategoriesEndPoint = "";

  ///Register New Complaint
  String registerComplaintEndPoint = "";

  ///Add Comment On Complain
  String addCommentOnComplainEndPoint = "";

  ///Get Store Locator
  String getStoreLocatorEndPoint = "";

  ///Remove Number
  String removeNumberEndPoint = "";

  ///Loyalty Points Dashboard
  String loyaltyPointsDashboard = "";

  ///Loyalty Points Redeem
  String loyaltyPointsRedeem = "";

  ///Share Feedback
  String shareFeedBackEndPoint = "";

  ///Get Customize Bundle
  String getCustomizeBundleEndPoint = "";

  ///Customize Bundle Subscribe Offer
  String customizeBundleSubscribeOfferEndPoint = "";

  ///MySubscriptions Api
  String mySubscriptionsApiEndPoint = "";

  ///Get Reward Configuration
  String getRewardConfigurationApiEndPoint = "";

  ///Get Rewards
  String getRewardApiEndPoint = "";

  ///Claim Reward
  String claimRewardEndPoint = "";

  ///Loyalty Dashboard
  String loyaltyPointsDashboardEndPoint = "";

  ///Loyalty Points History
  String loyaltyPointsHistoryEndPoint = "";

  ///Loyalty Offer Redeem
  String loyaltyOfferRedeemEndPoint = "";

  ///BOK top up generate OTP
  String topUpGenerateOTPEndPoint = "";

  ///BOK top up verify OTP
  String topUpVerifyOTPEndPoint = "";

  ///BOK get invoice
  String topUpGetInvoiceEndPoint = "";

  ///Gift Offer
  String giftOfferEndPoint = "";

  ///Get Filters
  String getFiltersApiEndPoint = "";

  ///Get Customise bundle subscribe offer
  String getCustomiseBundleSubscribeOffersApiEndPoint = "";

  ///Subscribe Digital Service
  String subscribeDigitalServiceApiEndPoint = "";

  ///Unsubscribe Digital Service
  String unsubscribeDigitalServiceApiEndPoint = "";

  ///Subscribe SPAY Digital Service
  String subscribeSPAYDigitalServiceApiEndPoint = "";

  ///Unsubscribe SPAY Digital Service
  String unsubscribeSPAYDigitalServiceApiEndPoint = "";

  ///RBT Set My Tune
  String rbtSetMyTune = "";

  ///RBT Get Dashboard
  String getRbtDashboard = "";

  ///RBT My Tune
  String rbtMyTunes = "";

  ///RBT Get Offers
  String rbtGetOffers = "";

  ///RBT Subscribe
  String rbtSubscribe = "";

  ///RBT Unsubscribe
  String rbtUnsubscribe = "";

  ///Get Specific Content
  String getSpecificContent = "";

  ///Get Vas Subscription
  String getVasSubscriptionApiEndPoint = "";

  ///Transaction History
  String transactionHistoryApiEndPoint = "";

  ///TopUp Bill Payment
  String topUpBillPaymentEndPoint = "";

  ///Forgot Password Generate OTP
  String forgotPasswordGenerateOTPEndPoint = "";

  ///Forgot Password Verify OTP
  String forgotPasswordVerifyOTPEndPoint = "";

  ///Reset Password
  String resetPasswordApiEndpoint = "";

  ///Get Commission Summary
  String getCommissionSummaryApiEndPoint = "";
}
