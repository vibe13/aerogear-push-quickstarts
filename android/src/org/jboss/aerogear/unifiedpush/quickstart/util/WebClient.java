package org.jboss.aerogear.unifiedpush.quickstart.util;

import org.apache.http.HttpResponse;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;

public final class WebClient {

    private final String url;

    public WebClient(String url) {
        this.url = url;
    }

    public String register(String json) {
        try {
            DefaultHttpClient httpClient = new DefaultHttpClient();

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

}
