package org.jboss.aerogear.unifiedpush.quickstart.activities;

import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.ActionBarActivity;
import android.support.v7.view.ActionMode;
import android.util.SparseBooleanArray;
import android.view.Menu;
import android.view.MenuInflater;
import android.view.MenuItem;
import android.view.View;
import android.widget.AbsListView;
import android.widget.AdapterView;
import android.widget.ListView;
import android.widget.Toast;
import org.jboss.aerogear.android.unifiedpush.MessageHandler;
import org.jboss.aerogear.android.unifiedpush.Registrations;
import org.jboss.aerogear.unifiedpush.quickstart.Constants;
import org.jboss.aerogear.unifiedpush.quickstart.R;
import org.jboss.aerogear.unifiedpush.quickstart.adapter.ContactAdapeter;
import org.jboss.aerogear.unifiedpush.quickstart.handler.NotificationBarMessageHandler;
import org.jboss.aerogear.unifiedpush.quickstart.model.Contact;
import org.jboss.aerogear.unifiedpush.quickstart.util.WebClient;

import java.util.List;

public class ContactsActivity extends ActionBarActivity implements MessageHandler {

    private List<Contact> contacts;

    private ListView listView;
    private ActionMode mActionMode;
    private ActionMode.Callback mActionModeCallback = new ActionMode.Callback() {

        @Override
        public boolean onCreateActionMode(ActionMode mode, Menu menu) {
            MenuInflater inflater = mode.getMenuInflater();
            inflater.inflate(R.menu.context_menu, menu);
            return true;
        }

        @Override
        public boolean onPrepareActionMode(ActionMode mode, Menu menu) {
            mode.setTitle(getString(R.string.select_contacts_remove));
            return false;
        }

        @Override
        public boolean onActionItemClicked(ActionMode mode, MenuItem item) {
            switch (item.getItemId()) {
                case R.id.delete:
                    final SparseBooleanArray checked = listView.getCheckedItemPositions();
                    for (int i = 0; i < checked.size(); i++) {
                        final int index = checked.keyAt(i);
                        if ((checked.get(index)) && deleteFromServer(contacts.get(index))) {
                            contacts.remove(index);
                        }
                    }
                    mode.finish();
                    updateContactList();
                    return true;
                default:
                    return false;
            }
        }

    @Override
        public void onDestroyActionMode(ActionMode mode) {
            updateContactList();
            mActionMode = null;
        }

    };

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.contacts);

        listView = (ListView) findViewById(R.id.contact_list);
        listView.setChoiceMode(ListView.CHOICE_MODE_MULTIPLE);
        listView.setItemsCanFocus(false);
        listView.setOnItemClickListener(new AdapterView.OnItemClickListener() {
            @Override
            public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                if(mActionMode != null) {
                    check(view);
                    mActionMode.invalidate();
                }
            }
        });
        listView.setOnItemLongClickListener(new AdapterView.OnItemLongClickListener() {
            @Override
            public boolean onItemLongClick(AdapterView<?> adapterView, View view, int position, long id) {
                if (mActionMode != null) {
                    return false;
                }
                mActionMode = ContactsActivity.this.startSupportActionMode(mActionModeCallback);
                return true;
            }
        });
    }

    @Override
    protected void onStart() {
        super.onStart();
        retrieveContacts();
    }

    @Override
    protected void onResume() {
        super.onResume();
        Registrations.registerMainThreadHandler(this);
        Registrations.unregisterBackgroundThreadHandler(NotificationBarMessageHandler.instance);
    }

    @Override
    protected void onPause() {
        super.onPause();
        Registrations.unregisterMainThreadHandler(this);
        Registrations.registerBackgroundThreadHandler(NotificationBarMessageHandler.instance);
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        getMenuInflater().inflate(R.menu.menu_contacts, menu);
        return super.onCreateOptionsMenu(menu);
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        if (item.getItemId() == R.id.new_contact) {
            Intent intent = new Intent(this, ContactActivity.class);
            startActivity(intent);
        } else if (item.getItemId() == R.id.logout) {
            new AsyncTask<Void, Void, Void>() {
                @Override
                protected Void doInBackground(Void... voids) {
                    new WebClient(Constants.URL_LOGOUT).logout();
                    return null;
                }

                @Override
                protected void onPostExecute(Void aVoid) {
                    Intent intent = new Intent(getApplicationContext(), LoginActivity.class);
                    startActivity(intent);
                    finish();
                }
            }.execute();
        }
        return super.onOptionsItemSelected(item);
    }

    @Override
    public void onMessage(Context context, Bundle message) {
        Toast.makeText(getApplicationContext(), message.getString("alert"), Toast.LENGTH_SHORT).show();
        retrieveContacts();
    }

    @Override
    public void onDeleteMessage(Context context, Bundle message) {
    }

    @Override
    public void onError() {
    }

    private void retrieveContacts() {
        new AsyncTask<Void, Void, List<Contact>>() {
            @Override
            protected List<Contact> doInBackground(Void... voids) {
                return new WebClient(Constants.URL_CONTACTS).contacts();
            }

            @Override
            protected void onPostExecute(List<Contact> contactList) {
                ContactsActivity.this.contacts = contactList;
                updateContactList();
            }
        }.execute();
    }

    private void updateContactList() {
        listView.setAdapter(new ContactAdapeter(getApplicationContext(), this.contacts));
    }

    private boolean deleteFromServer(Contact contact) {
        return true;
    }

    private void check(View view) {
        boolean checked = !((view.getTag() != null) && (boolean) view.getTag());
        view.setTag(checked);

        if(checked) {
            view.setBackgroundColor(getResources().getColor(R.color.lisview_select_background_color));
        } else {
            view.setBackgroundColor(getResources().getColor(R.color.lisview_default_background_color));
        }
    }

}
