# My-Sleeping-Analysis
# Overview
I've been recording my sleep for three years now through my wearable device logs and the Autosleep application, and based on that data, this is a SQL project to analyze my sleeping pattern based my past three years' sleeping data. 
# Pipline
* Uploaded raw data 'sleep_data' into my MySQL database
* Further data clean up and type conversion in MySQL
* Run queries to explore data and generate insights
# Conclusions

| AvgBedtime | AvgWaketime | AvgInbed | AvgAwake | AvgFellAsleepin | AvgAsleep | AvgEfficiency | AvgQuality | AvgDeep | AvgSleepBPM | AvgDayBPM | AvgWakingBPM | AvgHrv | AvgSleepHRV | AvgResp |
|------------|-------------|----------|----------|-----------------|-----------|---------------|------------|---------|-------------|-----------|--------------|--------|-------------|---------|
| 11:29:01   | 19:31:03    | 08:04:24 | 00:48:19 | 00:25:29        | 07:16:05  | 90.26         | 83.71      | 02:52:18| 49.81       | 72.60     | 49.20        | 111.26 | 71.62       | 16.79   |

| newDate | ValueType | Value |
|---------|-----------|-------|
| 2022-02-17 | RespAvg Min | 15.4 |
| 2023-12-13 | BedtimeTime Min | 00:35:38 |
| 2022-05-05 | Hrv Min | 50 |
| 2022-08-11 | Asleep Max | 10:35:00 |
| 2023-01-18 | WakingBPM Min | 41 |
| 2022-10-13 | DayBPM Max | 107.2 |
| 2022-01-13 | Inbed Min | 04:37:36 |
| 2021-11-05 | FellAsleepIn Max | 02:15:57 |
| 2022-10-31 | BedtimeTime Max | 13:54:14 |
| 2022-03-23 | QualityEfficiency Min | 65.4622641 |
| 2024-01-08 | WaketimeTime Min | 07:55:00 |
| 2022-10-11 | Deep Max | 05:02:17 |
| 2022-10-19 | WaketimeTime Max | 23:52:00 |
| 2022-04-23 | Inbed Max | 11:32:40 |
| 2021-09-29 | Awake Min | 00:00:00 |
| 2022-07-07 | SleepHRV Max | 140 |
| 2023-11-22 | SleepHRV Min | 22 |
| 2022-05-10 | Efficiency Min | 58.4 |
| 2022-05-25 | SleepBPM Min | 44.1 |
| 2021-09-26 | Hrv Max | 321 |
| 2022-10-20 | QualityEfficiency Max | 97.5674418 |
| 2021-12-17 | Deep Min | 00:00:00 |

Common sense Takeways:
1. Sleeping habits on weekends are different from those on weekdays: I tend to go to bed late on Friday nights, and it takes me the longest to fall asleep on Friday nights and wake up late on Saturday mornings, which is consistent with the general weekend rest pattern.
2. Thursday and Friday nights are the longest sleepers: This is probably because the weekend is coming up and people start to relax and have more time to sleep.
3. Wednesday nights are the shortest: this may be the peak of a stressful week at work, resulting in less sleep.
4. Tuesday's deep sleep is the longest, suggesting that people are more tired after the first two days of work and sleep more soundly.
5. Sunday night had the highest sleep heart rate along with a very low sleep variant heart rate, both trends are bad indicators that I am relatively anxious.

Interesting Takeways:
1. I go to bed late on Sunday nights, take the longest time to fall asleep, and get the least amount of sleep, which doesn't quite fit the pattern of going to bed early on Sunday nights to prepare for work the following Monday, and suggests that I'm still not accustomed to going to bed early on Sunday nights after a weekend of rest.
2. my average waking time on Sunday night is the shortest, and the percentage of quality sleep is the highest, which means that I am very efficient after going to bed late, and I sleep very soundly and deeply.
3. my sleep quality on Friday night was poor, my deep sleep time was the shortest, my sleep variant heart rate was the lowest and my respiratory rate was the highest on Friday night, indicating that I was anxious and did not conform to the common sense of sleeping more soundly after a work week.
# Data Science Techniques Used
Local MySQL database creation, ALTER TABLE, CTE's, CASE Statement, Subqueries, Converting Data Types, Window Functions, Aggregate Functions
# Tools Used
SQL
