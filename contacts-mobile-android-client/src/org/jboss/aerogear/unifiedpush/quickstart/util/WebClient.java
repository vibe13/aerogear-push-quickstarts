package org.jboss.aerogear.unifiedpush.quickstart.util;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.methods.HttpDelete;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.jboss.aerogear.android.http.HttpException;
import org.jboss.aerogear.android.impl.util.UrlUtils;
import org.jboss.aerogear.unifiedpush.quickstart.model.Contact;
import org.jboss.aerogear.unifiedpush.quickstart.model.User;

import java.net.URL;
import java.util.List;
import java.util.Map;

public final class WebClient {

    private final String url;
    private final static DefaultHttpClient httpClient;

    static {
        httpClient = new DefaultHttpClient();
    }

    public WebClient(String url) {
        this.url = url;
    }

    public boolean register(User user) {
        try {
            HttpPost post = new HttpPost(url);
            post.setEntity(new StringEntity(new Gson().toJson(user)));

            post.setHeader("Accept", "application/json");
            post.setHeader("Content-type", "application/json");

            httpClient.execute(post);

            return true;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public User authenticate(String username, String password) {

        try {

            CredentialsProvider credProvider = new BasicCredentialsProvider();
            credProvider.setCredentials(new AuthScope(AuthScope.ANY_HOST, AuthScope.ANY_PORT),
                    new UsernamePasswordCredentials(username, password));

            httpClient.setCredentialsProvider(credProvider);

            HttpGet get = new HttpGet(url);

            get.setHeader("Accept", "application/json");
            get.setHeader("Content-type", "application/json");

            HttpResponse response = httpClient.execute(get);

            if (isStatusCodeOk(response)) {
                String responseData = EntityUtils.toString(response.getEntity());

                Gson gson = new GsonBuilder().create();

                Map<String, Object> rootNode = gson.fromJson(responseData, Map.class);
                String innerJson = gson.toJson(rootNode.get("account"));
                return gson.fromJson(innerJson, User.class);
            } else {
                return null;
            }

        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    public void logout() {
        try {
            HttpPost post = new HttpPost(url);

            post.setHeader("Accept", "application/json");
            post.setHeader("Content-type", "application/json");

            httpClient.execute(post);
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    public List<Contact> contacts() {

        try {
            HttpGet get = new HttpGet(url);

            get.setHeader("Accept", "application/json");
            get.setHeader("Content-type", "application/json");

            HttpResponse response = httpClient.execute(get);
            String responseData = EntityUtils.toString(response.getEntity());

            return new Gson().fromJson(responseData, new TypeToken<List<Contact>>() {
            }.getType());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    public Boolean saveContact(Contact contact) {
        if (contact.getId() != null) {
            return updateContact(contact);
        } else {
            return newContact(contact);
        }
    }

    private Boolean newContact(Contact contact) {
        try {
            HttpPost post = new HttpPost(url);
            post.setEntity(new StringEntity(new Gson().toJson(contact)));

            post.setHeader("Accept", "application/json");
            post.setHeader("Content-type", "application/json");

            HttpResponse response = httpClient.execute(post);

            if (isStatusCodeOk(response)) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private Boolean updateContact(Contact contact) {
        try {
            String updateURL = this.url + "/" + String.valueOf(contact.getId());

            HttpPut put = new HttpPut(updateURL);
            put.setEntity(new StringEntity(new Gson().toJson(contact)));

            put.setHeader("Accept", "application/json");
            put.setHeader("Content-type", "application/json");

            HttpResponse response = httpClient.execute(put);

            if (isStatusCodeOk(response)) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    public boolean delete(Contact contact) {
        try {
            String deleteURL = this.url + "/" + String.valueOf(contact.getId());

            HttpDelete delete = new HttpDelete(deleteURL);

            delete.setHeader("Accept", "application/json");
            delete.setHeader("Content-type", "application/json");

            HttpResponse response = httpClient.execute(delete);

            if (isStatusCodeOk(response)) {
                return true;
            } else {
                return false;
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private boolean isStatusCodeOk(HttpResponse response) {
        return ((response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) || (response.getStatusLine().getStatusCode() == HttpStatus.SC_NO_CONTENT));
    }

}
