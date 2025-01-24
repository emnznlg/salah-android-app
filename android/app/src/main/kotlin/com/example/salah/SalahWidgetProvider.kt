package com.example.salah

import android.app.AlarmManager
import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import java.text.SimpleDateFormat
import java.util.*

class SalahWidgetProvider : AppWidgetProvider() {
    private val ALARM_ID = 1234
    private val TIME_FORMAT = "HH:mm"
    private val UPDATE_INTERVAL = 60000L  // 1 dakika

    override fun onUpdate(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        updateWidget(context, appWidgetManager, appWidgetIds)
        scheduleNextUpdate(context)
    }

    private fun updateWidget(context: Context, appWidgetManager: AppWidgetManager, appWidgetIds: IntArray) {
        appWidgetIds.forEach { widgetId ->
            val views = RemoteViews(context.packageName, R.layout.salah_widget).apply {
                val widgetData = HomeWidgetPlugin.getData(context)
                
                // Namaz vakitlerini güncelle
                setTextViewText(R.id.imsak_time, widgetData.getString("imsak", "00:00"))
                setTextViewText(R.id.gunes_time, widgetData.getString("gunes", "00:00"))
                setTextViewText(R.id.ogle_time, widgetData.getString("ogle", "00:00"))
                setTextViewText(R.id.ikindi_time, widgetData.getString("ikindi", "00:00"))
                setTextViewText(R.id.aksam_time, widgetData.getString("aksam", "00:00"))
                setTextViewText(R.id.yatsi_time, widgetData.getString("yatsi", "00:00"))

                // Kalan süreyi hesapla ve güncelle
                val remainingTime = calculateRemainingTime(context)
                setTextViewText(R.id.next_prayer_text, "Sonraki Vakte: $remainingTime")
            }
            appWidgetManager.updateAppWidget(widgetId, views)
        }
    }

    private fun calculateRemainingTime(context: Context): String {
        val widgetData = HomeWidgetPlugin.getData(context)
        val currentTime = Calendar.getInstance()
        val formatter = SimpleDateFormat(TIME_FORMAT, Locale.getDefault())
        
        val prayerTimes = listOf(
            Pair("imsak", widgetData.getString("imsak", "00:00")),
            Pair("gunes", widgetData.getString("gunes", "00:00")),
            Pair("ogle", widgetData.getString("ogle", "00:00")),
            Pair("ikindi", widgetData.getString("ikindi", "00:00")),
            Pair("aksam", widgetData.getString("aksam", "00:00")),
            Pair("yatsi", widgetData.getString("yatsi", "00:00"))
        )

        var nextPrayerTime: Calendar? = null
        
        for (prayer in prayerTimes) {
            val time = formatter.parse(prayer.second)
            if (time != null) {
                val prayerCal = Calendar.getInstance().apply {
                    set(Calendar.HOUR_OF_DAY, time.hours)
                    set(Calendar.MINUTE, time.minutes)
                    set(Calendar.SECOND, 0)
                }
                
                if (currentTime.before(prayerCal)) {
                    nextPrayerTime = prayerCal
                    break
                }
            }
        }

        if (nextPrayerTime == null) {
            val tomorrowImsak = formatter.parse(prayerTimes[0].second)
            if (tomorrowImsak != null) {
                nextPrayerTime = Calendar.getInstance().apply {
                    add(Calendar.DAY_OF_MONTH, 1)
                    set(Calendar.HOUR_OF_DAY, tomorrowImsak.hours)
                    set(Calendar.MINUTE, tomorrowImsak.minutes)
                    set(Calendar.SECOND, 0)
                }
            }
        }

        if (nextPrayerTime != null) {
            val diff = nextPrayerTime.timeInMillis - currentTime.timeInMillis
            val hours = diff / (60 * 60 * 1000)
            val minutes = (diff / (60 * 1000)) % 60

            return when {
                hours > 0 -> "${hours}s ${minutes}dk"
                else -> "${minutes}dk"
            }
        }

        return "--:--"
    }

    private fun scheduleNextUpdate(context: Context) {
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, SalahWidgetProvider::class.java).apply {
            action = AppWidgetManager.ACTION_APPWIDGET_UPDATE
        }

        val pendingIntent = PendingIntent.getBroadcast(
            context,
            ALARM_ID,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        // Mevcut alarmı iptal et
        alarmManager.cancel(pendingIntent)

        // Yeni alarmı planla
        val nextUpdateTime = System.currentTimeMillis() + UPDATE_INTERVAL

        try {
            if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.S) {
                if (alarmManager.canScheduleExactAlarms()) {
                    alarmManager.setExactAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        nextUpdateTime,
                        pendingIntent
                    )
                } else {
                    alarmManager.setAndAllowWhileIdle(
                        AlarmManager.RTC_WAKEUP,
                        nextUpdateTime,
                        pendingIntent
                    )
                }
            } else {
                alarmManager.setExactAndAllowWhileIdle(
                    AlarmManager.RTC_WAKEUP,
                    nextUpdateTime,
                    pendingIntent
                )
            }
        } catch (e: Exception) {
            alarmManager.setAndAllowWhileIdle(
                AlarmManager.RTC_WAKEUP,
                nextUpdateTime,
                pendingIntent
            )
        }
    }

    override fun onEnabled(context: Context) {
        super.onEnabled(context)
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val appWidgetIds = appWidgetManager.getAppWidgetIds(
            android.content.ComponentName(context, SalahWidgetProvider::class.java)
        )
        updateWidget(context, appWidgetManager, appWidgetIds)
        scheduleNextUpdate(context)
    }

    override fun onDisabled(context: Context) {
        super.onDisabled(context)
        val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager
        val intent = Intent(context, SalahWidgetProvider::class.java)
        val pendingIntent = PendingIntent.getBroadcast(
            context,
            ALARM_ID,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        alarmManager.cancel(pendingIntent)
    }

    override fun onReceive(context: Context, intent: Intent) {
        super.onReceive(context, intent)
        when (intent.action) {
            AppWidgetManager.ACTION_APPWIDGET_UPDATE,
            Intent.ACTION_BOOT_COMPLETED,
            Intent.ACTION_TIME_CHANGED,
            Intent.ACTION_TIMEZONE_CHANGED,
            Intent.ACTION_TIME_TICK,
            "android.intent.action.SCREEN_ON" -> {
                val appWidgetManager = AppWidgetManager.getInstance(context)
                val appWidgetIds = appWidgetManager.getAppWidgetIds(
                    android.content.ComponentName(context, SalahWidgetProvider::class.java)
                )
                updateWidget(context, appWidgetManager, appWidgetIds)
                scheduleNextUpdate(context)
            }
        }
    }
} 