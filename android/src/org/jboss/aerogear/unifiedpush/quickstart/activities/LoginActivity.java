package org.jboss.aerogear.unifiedpush.quickstart.activities;

import android.app.Activity;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;
import org.jboss.aerogear.android.Callback;
import org.jboss.aerogear.android.unifiedpush.PushConfig;
import org.jboss.aerogear.android.unifiedpush.PushRegistrar;
import org.jboss.aerogear.android.unifiedpush.Registrations;
import org.jboss.aerogear.unifiedpush.quickstart.Constants;
import org.jboss.aerogear.unifiedpush.quickstart.R;
import org.jboss.aerogear.unifiedpush.quickstart.model.User;
import org.jboss.aerogear.unifiedpush.quickstart.util.WebClient;

import java.net.URI;
import java.net.URISyntaxException;

import static org.jboss.aerogear.unifiedpush.quickstart.Constants.*;

public class LoginActivity extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.login);

        final TextView username = (TextView) findViewById(R.id.username);
        final TextView password = (TextView) findViewById(R.id.password);

        final Button login = (Button) findViewById(R.id.login);
        login.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                login(username.getText().toString(), password.getText().toString());
            }
        });

        TextView register = (TextView) findViewById(R.id.register);
        register.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Intent intent = new Intent(LoginActivity.this, RegisterActivity.class);
                startActivity(intent);
            }
        });
    }

    private void login(final String username, final String password) {
        new AsyncTask<Void, Void, User>() {
            @Override
            protected User doInBackground(Void... voids) {
                return new WebClient(Constants.URL_LOGIN).authenticate(username, password);
            }

            @Override
            protected void onPostExecute(User loggedUser) {
                if (loggedUser != null) {
                    registerLoogedUserInUnifiedPushServer(loggedUser);
                } else {
                    Toast.makeText(getApplicationContext(),
                            getString(R.string.an_error_occurred), Toast.LENGTH_SHORT).show();
                }
            }
        }.execute();
    }

    private void registerLoogedUserInUnifiedPushServer(User user) {
        try {

            PushConfig config = new PushConfig(new URI(UNIFIED_PUSH_URL), GCM_SENDER_ID);
            config.setVariantID(VARIANT_ID);
            config.setSecret(SECRET);
            config.setAlias(user.getUserName());

            Registrations registrations = new Registrations();
            PushRegistrar registrar = registrations.push("register", config);
            registrar.register(getApplicationContext(), new Callback<Void>() {
                @Override
                public void onSuccess(Void data) {
                    Intent intent = new Intent(getApplicationContext(), ContactsActivity.class);
                    startActivity(intent);
                    finish();
                }

                @Override
                public void onFailure(Exception e) {
                    Toast.makeText(getApplicationContext(), e.getMessage(), Toast.LENGTH_LONG).show();
                }
            });

        } catch (URISyntaxException e) {
            throw new RuntimeException(e);
        }
    }

}
