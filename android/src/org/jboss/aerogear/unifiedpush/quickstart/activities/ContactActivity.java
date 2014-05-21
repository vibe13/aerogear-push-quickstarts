package org.jboss.aerogear.unifiedpush.quickstart.activities;

import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import org.jboss.aerogear.unifiedpush.quickstart.R;
import org.jboss.aerogear.unifiedpush.quickstart.model.Contact;
import org.jboss.aerogear.unifiedpush.quickstart.model.User;

public class ContactActivity extends ActionBarActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.contact);
    }

}
