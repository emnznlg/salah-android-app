package com.example.salah

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class SalahWidgetProvider : AppWidgetProvider() {
    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.salah_widget)

            // Namaz vakitlerini güncelle
            views.setTextViewText(R.id.imsak_time, widgetData.getString("imsak", "00:00"))
            views.setTextViewText(R.id.gunes_time, widgetData.getString("gunes", "00:00"))
            views.setTextViewText(R.id.ogle_time, widgetData.getString("ogle", "00:00"))
            views.setTextViewText(R.id.ikindi_time, widgetData.getString("ikindi", "00:00"))
            views.setTextViewText(R.id.aksam_time, widgetData.getString("aksam", "00:00"))
            views.setTextViewText(R.id.yatsi_time, widgetData.getString("yatsi", "00:00"))

            // Sonraki vakte kalan süreyi güncelle
            views.setTextViewText(R.id.next_prayer_text, widgetData.getString("next_prayer", "Sonraki Vakte: --:--"))

            // Widget'a tıklama işlevi ekle
            val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
            val pendingIntent = PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE)
            views.setOnClickPendingIntent(R.id.widget_layout, pendingIntent)

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
} 