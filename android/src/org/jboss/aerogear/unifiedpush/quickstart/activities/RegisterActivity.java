package org.jboss.aerogear.unifiedpush.quickstart.activities;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;
import org.jboss.aerogear.unifiedpush.quickstart.R;

public class RegisterActivity extends Activity {

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.register);

        Button register = (Button) findViewById(R.id.save);
        register.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Toast.makeText(getApplicationContext(), getString(R.string.register_successful), Toast.LENGTH_SHORT).show();
                finish();
            }
        });

    }

}
