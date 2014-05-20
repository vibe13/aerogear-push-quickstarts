package org.jboss.aerogear.unifiedpush.quickstart.activities;

import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import org.jboss.aerogear.unifiedpush.quickstart.Constants;
import org.jboss.aerogear.unifiedpush.quickstart.QuickstartApplication;
import org.jboss.aerogear.unifiedpush.quickstart.R;
import org.jboss.aerogear.unifiedpush.quickstart.model.Contact;
import org.jboss.aerogear.unifiedpush.quickstart.model.Message;
import org.jboss.aerogear.unifiedpush.quickstart.util.WebClient;

import static android.widget.Toast.LENGTH_SHORT;

public class MessageActivity extends Activity {

    private EditText message;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.message);

        final QuickstartApplication application = (QuickstartApplication) getApplication();
        final Contact contact = (Contact) getIntent().getSerializableExtra(Constants.USER);

        message = (EditText) findViewById(R.id.message);
        Button send = (Button) findViewById(R.id.send);
        send.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Message pushMessage = new Message();
                pushMessage.setAuthor(application.getLoggedUser().getFirstName());
                pushMessage.setReceiver(contact.getEmail());
                pushMessage.setMessage(message.getText().toString());

                sendMessage(pushMessage);
            }
        });

    }

    private void cleanForm() {
        message.setText("");
    }

    private void sendMessage(final Message message) {
        new AsyncTask<Void, Void, Boolean>() {
            @Override
            protected Boolean doInBackground(Void... voids) {
                return new WebClient(Constants.URL_MESSAGE).sendMessage(message);
            }

            @Override
            protected void onPostExecute(Boolean sent) {
                if(sent) {
                    Toast.makeText(getApplicationContext(), getString(R.string.message_sent), LENGTH_SHORT).show();
                    cleanForm();
                } else {
                    Toast.makeText(getApplicationContext(), getString(R.string.an_error_occurred), LENGTH_SHORT).show();
                }

            }
        }.execute();
    }
}
