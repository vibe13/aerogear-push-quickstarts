package org.jboss.aerogear.unifiedpush.quickstart.activities;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import org.jboss.aerogear.unifiedpush.quickstart.Constants;
import org.jboss.aerogear.unifiedpush.quickstart.R;
import org.jboss.aerogear.unifiedpush.quickstart.model.User;
import org.jboss.aerogear.unifiedpush.quickstart.util.WebClient;

public class RegisterActivity extends Activity {

    private EditText firstName;
    private EditText lastName;
    private EditText userName;
    private EditText password;

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.register);

        firstName = (EditText) findViewById(R.id.first_name);
        lastName = (EditText) findViewById(R.id.last_name);
        userName = (EditText) findViewById(R.id.username);
        password = (EditText) findViewById(R.id.password);

        final Button register = (Button) findViewById(R.id.save);
        register.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                User user = retriveUserFromForm();
                register(user);
                finish();
            }
        });
    }

    private User retriveUserFromForm() {
        User user = new User();
        user.setFirstName(firstName.getText().toString());
        user.setLastName(lastName.getText().toString());
        user.setUserName(userName.getText().toString());
        user.setPassword(password.getText().toString());
        return user;
    }

    private void register(final User user) {
        new AsyncTask<Void, Void, Void>() {
            @Override
            protected Void doInBackground(Void... voids) {
                new WebClient(Constants.URL_REGISTER).register(user.toJSON());
                return null;
            }

            @Override
            protected void onPostExecute(Void aVoid) {
                Toast.makeText(getApplicationContext(), getString(R.string.register_successful), Toast.LENGTH_SHORT);
            }
        }.execute();
    }

}
