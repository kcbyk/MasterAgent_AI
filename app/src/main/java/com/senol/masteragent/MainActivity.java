package com.senol.masteragent;
import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.media.projection.MediaProjectionManager;
import android.os.Bundle;
import android.widget.Toast;

public class MainActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        Toast.makeText(this, "AI PLUS: Ekran Yansıtma İzni İsteniyor...", Toast.LENGTH_LONG).show();
        
        // Ekranı Panale Aktarmak İçin Senden İzin İsteyen Otonom Kod
        MediaProjectionManager mpm = (MediaProjectionManager) getSystemService(Context.MEDIA_PROJECTION_SERVICE);
        if (mpm != null) {
            startActivityForResult(mpm.createScreenCaptureIntent(), 1000);
        }
    }
}
