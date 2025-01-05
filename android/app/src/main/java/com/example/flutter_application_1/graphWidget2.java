package com.example.flutter_application_1;

import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.widget.RemoteViews;
import android.content.SharedPreferences;

/**
 * Implementation of App Widget functionality.
 */
public class graphWidget2 extends AppWidgetProvider {

    static void updateAppWidget(Context context, AppWidgetManager appWidgetManager,
                                int appWidgetId) {
        SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        String excellenceData = prefs.getString("flutter.excellence", null);//R.string.appwidget_text
        String meritData = prefs.getString("flutter.merit", null);
        String achievedData = prefs.getString("flutter.achieved", null);
        String notAchievedData = prefs.getString("flutter.not_achieved", null);
        // Construct the RemoteViews object
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.graph_widget2);
        views.setTextViewText(R.id.excellence_count, excellenceData);
        views.setTextViewText(R.id.merit_count, meritData);
        views.setTextViewText(R.id.achieved_count, achievedData);
        views.setTextViewText(R.id.not_achieved_count, notAchievedData);

        // Instruct the widget manager to update the widget
        appWidgetManager.updateAppWidget(appWidgetId, views);
    }

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        super.onUpdate(context, appWidgetManager, appWidgetIds);

        SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        String data = prefs.getString("flutter.KEY", "Default Value");

        // There may be multiple widgets active, so update all of them
        for (int appWidgetId : appWidgetIds) {

            updateAppWidget(context, appWidgetManager, appWidgetId);
        }
    }

    @Override
    public void onEnabled(Context context) {
        // Enter relevant functionality for when the first widget is created
        SharedPreferences prefs = context.getSharedPreferences("FlutterSharedPreferences", Context.MODE_PRIVATE);
        String excellenceData = prefs.getString("flutter.excellence", null);//R.string.appwidget_text
        String meritData = prefs.getString("flutter.merit", null);
        String achievedData = prefs.getString("flutter.achieved", null);
        String notAchievedData = prefs.getString("flutter.not_achieved", null);
        // Construct the RemoteViews object
        RemoteViews views = new RemoteViews(context.getPackageName(), R.layout.graph_widget2);
        views.setTextViewText(R.id.excellence_count, excellenceData);
        views.setTextViewText(R.id.merit_count, meritData);
        views.setTextViewText(R.id.achieved_count, achievedData);
        views.setTextViewText(R.id.not_achieved_count, notAchievedData);
    }

    @Override
    public void onDisabled(Context context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}