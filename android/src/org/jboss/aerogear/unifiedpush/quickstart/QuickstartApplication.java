package org.jboss.aerogear.unifiedpush.quickstart;

import android.app.Application;
import org.jboss.aerogear.unifiedpush.quickstart.model.User;

public class QuickstartApplication extends Application {

    private User loggedUser;

    public User getLoggedUser() {
        return loggedUser;
    }

    public void setLoggedUser(User loggedUser) {
        this.loggedUser = loggedUser;
    }

}
