class Urls {
  static const bool Debug = false;
  static String getBaseURL() => Debug ? "http://127.0.0.1:8000/" : "https://api.tracery.us/";
  static String LOGIN_URL = getBaseURL() + "api/auth/token/login/";
  static String USER_URL = getBaseURL() + "api/auth/users/me/";
  //static String MEDIA_BASE_URL = getBaseURL().substring(0, getBaseURL().length - 1);
  static String SIGNUP_URL = getBaseURL() + "api/auth/users/";
  static String PASSWORD_RESET_URL = getBaseURL() + "passwordreset/";
  static String TOGGLE_LOCK_STATE = getBaseURL() + "api/toggle-lockstate/";
  static String CHECK_FOR_VENUE_SCAN = getBaseURL() + "api/check-for-venue-scan/";
  static String USER_CONFIRM_ENTRY = getBaseURL() + "api/person-confirm-entry/";
  static String GET_PV_HANDSHAKES = getBaseURL() + "api/person-get-handshakes-with-venue/";
  static String SCAN_VENUE = getBaseURL() + "api/person-scan-venue/";
  static String ANON_SIGNUP = getBaseURL() + "api/open-account/";
  static String GET_VENUES = getBaseURL() + "api/get-venues/";
  static String GET_ANON_USER = getBaseURL() + "api/get-privateaccount-info/";
  static String SCAN_PERSON = getBaseURL() + "api/venue-scan-person/";
  static String VENUE_CONFIRM_ENTRY = getBaseURL() + "api/venue-confirm-entry/";
  static String GET_VENUE = getBaseURL() + "api/get-my-venue/";
  static String CHECK_FOR_PERSON_SCAN = getBaseURL() + "api/check-for-person-scan/";
  static String GET_PV_HANDSHAKES_AS_VENUE = getBaseURL() + "api/venue-get-handshakes-with-people/";
}