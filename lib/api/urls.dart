class Urls {
  static const bool Debug = true;
  static String getBaseURL() => Debug ? "http://127.0.0.1:8000/" : "https://tracery.us/";
  static String LOGIN_URL = getBaseURL() + "api/auth/token/login/";
  static String USER_URL = getBaseURL() + "api/auth/users/me/";
  static String MEDIA_BASE_URL = getBaseURL().substring(0, getBaseURL().length - 1);
  static String SIGNUP_URL = getBaseURL() + "api/auth/users/";
  static String PASSWORD_RESET_URL = getBaseURL() + "passwordreset/";
  static String TOGGLE_LOCK_STATE = getBaseURL() + "api/toggle-lockstate/";
  static String CHECK_FOR_VENUE_SCAN = getBaseURL() + "api/check-for-venue-scan/";
}