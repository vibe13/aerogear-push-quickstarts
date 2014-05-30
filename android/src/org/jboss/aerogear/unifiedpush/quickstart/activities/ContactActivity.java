package org.jboss.aerogear.unifiedpush.quickstart.activities;

import android.app.DatePickerDialog;
import android.app.Dialog;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.DialogFragment;
import android.support.v7.app.ActionBarActivity;
import android.view.MenuItem;
import android.view.View;
import android.widget.*;
import org.jboss.aerogear.unifiedpush.quickstart.Constants;
import org.jboss.aerogear.unifiedpush.quickstart.R;
import org.jboss.aerogear.unifiedpush.quickstart.model.Contact;
import org.jboss.aerogear.unifiedpush.quickstart.util.WebClient;

import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import static android.widget.Toast.LENGTH_SHORT;

public class ContactActivity extends ActionBarActivity {

    private EditText firstName;
    private EditText lastName;
    private EditText phone;
    private EditText email;
    private EditText birthDate;

    private final Calendar dateSelected = Calendar.getInstance();
    private final SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.contact);

        getSupportActionBar().setDisplayHomeAsUpEnabled(true);

        firstName = (EditText) findViewById(R.id.first_name);
        lastName = (EditText) findViewById(R.id.last_name);
        phone = (EditText) findViewById(R.id.phone);
        email = (EditText) findViewById(R.id.email);
        birthDate = (EditText) findViewById(R.id.birth_date);

        ImageView calendar = (ImageView) findViewById(R.id.calendar);
        calendar.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                DialogFragment newFragment = new DatePickerFragment();
                newFragment.show(getSupportFragmentManager(), "datePicker");
            }
        });


        Button save = (Button) findViewById(R.id.save);
        save.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Contact contact = retriveContactFromForm();
                addContact(contact);
            }
        });

    }

    public boolean onOptionsItemSelected(MenuItem item) {
        finish();
        return super.onOptionsItemSelected(item);
    }

    private Contact retriveContactFromForm() {
        Contact contact = new Contact();
        contact.setFirstName(firstName.getText().toString());
        contact.setLastName(lastName.getText().toString());
        contact.setPhoneNumber(phone.getText().toString());
        contact.setEmail(email.getText().toString());
        contact.setBirthDate(dateFormat.format(dateSelected.getTime()));
        return contact;
    }

    private void addContact(final Contact contact) {
        new AsyncTask<Void, Void, Boolean>() {
            @Override
            protected Boolean doInBackground(Void... voids) {
                return new WebClient(Constants.URL_CONTACTS).newContact(contact);
            }

            @Override
            protected void onPostExecute(Boolean registered) {
                if (registered) {
                    Toast.makeText(getApplicationContext(), getString(R.string.contact_added), LENGTH_SHORT).show();
                    finish();
                } else {
                    Toast.makeText(getApplicationContext(), getString(R.string.an_error_occurred), LENGTH_SHORT).show();
                }
            }
        }.execute();
    }

    public class DatePickerFragment extends DialogFragment implements DatePickerDialog.OnDateSetListener {

        @Override
        public Dialog onCreateDialog(Bundle savedInstanceState) {
            int year = dateSelected.get(Calendar.YEAR);
            int month = dateSelected.get(Calendar.MONTH);
            int day = dateSelected.get(Calendar.DAY_OF_MONTH);

            return new DatePickerDialog(getActivity(), this, year, month, day);
        }

        public void onDateSet(DatePicker view, int year, int month, int day) {
            dateSelected.set(Calendar.DAY_OF_MONTH, day);
            dateSelected.set(Calendar.MONTH, month);
            dateSelected.set(Calendar.YEAR, year);
            birthDate.setText(dateFormat.format(dateSelected.getTime()));
        }
    }

}
