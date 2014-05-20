package org.jboss.aerogear.unifiedpush.quickstart.util;

import android.util.Log;
import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.reflect.TypeToken;
import org.apache.http.HttpResponse;
import org.apache.http.auth.AuthScope;
import org.apache.http.auth.UsernamePasswordCredentials;
import org.apache.http.client.CookieStore;
import org.apache.http.client.CredentialsProvider;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.BasicCookieStore;
import org.apache.http.impl.client.BasicCredentialsProvider;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.jboss.aerogear.unifiedpush.quickstart.model.Contact;
import org.jboss.aerogear.unifiedpush.quickstart.model.Message;
import org.jboss.aerogear.unifiedpush.quickstart.model.User;

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

    public String register(String json) {
        try {
            HttpPost post = new HttpPost(url);
            post.setEntity(new StringEntity(json));

            post.setHeader("Accept", "application/json");
            post.setHeader("Content-type", "application/json");

            HttpResponse response = httpClient.execute(post);
            String responseData = EntityUtils.toString(response.getEntity());

            return responseData;
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
            String responseData = EntityUtils.toString(response.getEntity());

            Gson gson = new GsonBuilder().create();

            Map<String,Object> rootNode = gson.fromJson(responseData, Map.class);
            String innerJson = gson.toJson(rootNode.get("account"));
            User user = gson.fromJson(innerJson, User.class);

            return user;
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

            return new Gson().fromJson(responseData, new TypeToken<List<Contact>>(){}.getType());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    public boolean sendMessage(Message message) {
        try {
            HttpPost post = new HttpPost(url);
            post.setEntity(new StringEntity(new Gson().toJson(message)));

            post.setHeader("Accept", "application/json");
            post.setHeader("Content-type", "application/json");

            httpClient.execute(post);

            return true;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

}
