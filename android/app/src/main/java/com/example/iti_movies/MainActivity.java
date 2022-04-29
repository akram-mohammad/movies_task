package com.example.iti_movies;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;

import androidx.annotation.NonNull;
import io.flutter.embedding.android.FlutterActivity;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import io.flutter.*;
import io.flutter.embedding.engine.FlutterEngine;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;
import java.util.*;
import java.util.logging.StreamHandler;

public class MainActivity extends FlutterActivity {
    private static final String CHANNEL = "com.example.iti_movies/channel";
    private String startString = null;
    private static final String EVENTS = "com.example.iti_movies/events";
    private BroadcastReceiver linksReceiver = null;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // ATTENTION: This was auto-generated to handle app links.
        Intent appLinkIntent = getIntent();
        String appLinkAction = appLinkIntent.getAction();
        Uri appLinkData = appLinkIntent.getData();
        if(appLinkData != null) {
            startString = appLinkData.toString();
        }
    }

    @Override
    public void configureFlutterEngine(@NonNull FlutterEngine flutterEngine) {
        super.configureFlutterEngine(flutterEngine);
        new MethodChannel(flutterEngine.getDartExecutor().getBinaryMessenger(), CHANNEL)
                .setMethodCallHandler(
                        (call, result) -> {
                            if (call.method.equals("initialLink")) {
                                if (startString != null) {
                                    result.success(startString);
                                }
                            }
                        }
                );

        new EventChannel(flutterEngine.getDartExecutor(), EVENTS).setStreamHandler(
                new EventChannel.StreamHandler() {
                    @Override
                    public void onListen(Object args, EventChannel.EventSink events) {
                        linksReceiver = createChangeReceiver(events);
                    }

                    @Override
                    public void onCancel(Object arguments) {
                        linksReceiver = null;
                    }
                }
        );
    }

    @Override
    public void onNewIntent(@NonNull Intent intent ) {
        super.onNewIntent(intent);
        if (intent.getAction().equals(Intent.ACTION_VIEW)) {
            linksReceiver.onReceive(this.getApplicationContext(), intent);
        }
    }

    BroadcastReceiver createChangeReceiver(EventChannel.EventSink events ){
        return new BroadcastReceiver() {
            @Override
            public void onReceive(Context context,Intent intent) { // NOTE: assuming intent.getAction() is Intent.ACTION_VIEW
                String dataString = intent.getDataString();
                events.error("UNAVAILABLE", "Link unavailable", null);
                events.success(dataString);
            }
        };
    }
}
