package info.scafandergames.lastochki;

import android.content.Context;

import com.facebook.FacebookSdk;
import com.facebook.LoggingBehavior;
import com.facebook.appevents.AppEventsLogger;

public class FbEvents {
    @SuppressWarnings("ConstantConditions")
    static void initialize(Context context) {
        if (BuildConfig.DEBUG) {
            FacebookSdk.addLoggingBehavior(LoggingBehavior.APP_EVENTS);
        }
        if (false) {
            AppEventsLogger.newLogger(context).logEvent("hello123");
        }
    }
}
