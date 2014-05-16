package org.jboss.aerogear.unifiedpush.quickstart.adapter;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;
import org.jboss.aerogear.unifiedpush.quickstart.R;
import org.jboss.aerogear.unifiedpush.quickstart.model.Contact;

import java.util.List;

public class ContactAdapeter extends BaseAdapter {

    private final Context context;
    private final List<Contact> contactList;

    public ContactAdapeter(Context context, List<Contact> contactList) {
        this.context = context;
        this.contactList = contactList;
    }

    @Override
    public int getCount() {
        return contactList.size();
    }

    @Override
    public Contact getItem(int position) {
        return contactList.get(position);
    }

    @Override
    public long getItemId(int position) {
        return getItem(position).getId();
    }

    @Override
    public View getView(int position, View convertView, ViewGroup parent) {
        Contact contact = getItem(position);

        View view = LayoutInflater.from(context).inflate(R.layout.contact_item, null);

        TextView name = (TextView) view.findViewById(R.id.name);
        name.setText(contact.getFirstName() + " " + contact.getLastName());

        TextView email = (TextView) view.findViewById(R.id.email);
        email.setText(contact.getEmail());

        return view;
    }
}
