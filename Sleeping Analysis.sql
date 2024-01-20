# Data Cleanning

# Browse Raw Data
SELECT	*
FROM	sleep_data;

# Drop the useless columns 
ALTER TABLE sleep_data 
DROP COLUMN ISO8601,
DROP COLUMN SpO2Avg,
DROP COLUMN SpO2Min,
DROP COLUMN SpO2Max,
DROP COLUMN tags,
DROP COLUMN notes;

# drop the records that their sessions = 2
DELETE FROM sleep_data
WHERE sessions = 2;

# Check the data type
DESCRIBE sleep_data;

#We found that out that all fields are VARCHAR, so we need to convert some fields to other types
# Extract weekday data from fromDate

ALTER TABLE sleep_data ADD COLUMN Weekday VARCHAR(10);

UPDATE sleep_data
SET Weekday = SUBSTRING_INDEX(fromDate, ',', 1);

# Extract Year data from fromDate
ALTER TABLE sleep_data ADD COLUMN Year int;

UPDATE sleep_data
SET Year = SUBSTRING_INDEX(fromDate, ' ', -1);

# Extract Month data from fromDate
ALTER TABLE sleep_data ADD COLUMN Month VARCHAR(3);

UPDATE sleep_data
SET Month = SUBSTRING_INDEX(SUBSTRING_INDEX(fromDate, ' ', 2), ' ', -1);

# Convert fromDate, toDate to DATE
ALTER TABLE sleep_data ADD COLUMN newDate DATE;

UPDATE sleep_data
SET newDate = STR_TO_DATE(SUBSTRING_INDEX(fromDate, ' ', -3), '%b %d, %Y');

# Convert some columns to datetime, date and time type
ALTER TABLE sleep_data
MODIFY bedtime DATETIME,
MODIFY waketime DATETIME,
MODIFY inbed TIME,
MODIFY awake TIME,
MODIFY fellAsleepIn TIME,
MODIFY asleep TIME,
MODIFY asleepAvg7 TIME,
MODIFY quality TIME,
MODIFY qualityAvg7 TIME,
MODIFY deep TIME,
MODIFY deepAvg7 TIME;

# Convert some columns to DOUBLE type
ALTER TABLE sleep_data
MODIFY sessions DOUBLE,
MODIFY efficiency DOUBLE,
MODIFY efficiencyAvg7 DOUBLE,
MODIFY sleepBPM DOUBLE,
MODIFY sleepBPMAvg7 DOUBLE,
MODIFY dayBPM DOUBLE,
MODIFY dayBPMAvg7 DOUBLE,
MODIFY wakingBPM DOUBLE,
MODIFY wakingBPMAvg7 DOUBLE,
MODIFY hrv DOUBLE,
MODIFY hrvAvg7 DOUBLE,
MODIFY sleepHRV DOUBLE,
MODIFY sleepHRVAvg7 DOUBLE,
MODIFY respAvg DOUBLE,
MODIFY respMin DOUBLE,
MODIFY respMax DOUBLE;

# Add a new field that we can see quality/asleep, which is very important to evaluate sleep quality 
ALTER TABLE sleep_data
ADD quality_efficiency DOUBLE,
ADD qualityAvg7_efficiency DOUBLE; 

UPDATE sleep_data
SET quality_efficiency = quality/asleep*100,
		qualityAvg7_efficiency = qualityAvg7/asleepAvg7*100;

# Add two new fields extract the time from Bedtime and Waketime
ALTER TABLE sleep_data
ADD COLUMN BedtimeTime TIME,
ADD COLUMN WaketimeTime TIME;

UPDATE sleep_data
SET 
    BedtimeTime = TIME(bedtime),
    WaketimeTime = TIME(waketime);

#Add new columns to convert these TIME type fields to other type

ALTER TABLE sleep_data
ADD COLUMN inbed_minutes INT,
ADD COLUMN awake_minutes INT,
ADD COLUMN fellAsleepIn_minutes INT,
ADD COLUMN asleep_minutes INT,
ADD COLUMN asleepAvg7_minutes INT,
ADD COLUMN quality_minutes INT,
ADD COLUMN qualityAvg7_minutes INT,
ADD COLUMN deep_minutes INT,
ADD COLUMN deepAvg7_minutes INT,
ADD COLUMN BedtimeTime_minutes INT,
ADD COLUMN WaketimeTime_minutes INT;

UPDATE sleep_data
SET inbed_minutes = EXTRACT(HOUR FROM inbed)*60 + EXTRACT(MINUTE FROM inbed),
    awake_minutes = EXTRACT(HOUR FROM awake)*60 + EXTRACT(MINUTE FROM awake),
    fellAsleepIn_minutes = EXTRACT(HOUR FROM fellAsleepIn)*60 + EXTRACT(MINUTE FROM fellAsleepIn),
    asleep_minutes = EXTRACT(HOUR FROM asleep)*60 + EXTRACT(MINUTE FROM asleep),
    asleepAvg7_minutes = EXTRACT(HOUR FROM asleepAvg7)*60 + EXTRACT(MINUTE FROM asleepAvg7),
    quality_minutes = EXTRACT(HOUR FROM quality)*60 + EXTRACT(MINUTE FROM quality),
    qualityAvg7_minutes = EXTRACT(HOUR FROM qualityAvg7)*60 + EXTRACT(MINUTE FROM qualityAvg7),
    deep_minutes = EXTRACT(HOUR FROM deep)*60 + EXTRACT(MINUTE FROM deep),
    deepAvg7_minutes = EXTRACT(HOUR FROM deepAvg7)*60 + EXTRACT(MINUTE FROM deepAvg7),
    BedtimeTime_minutes = EXTRACT(HOUR FROM BedtimeTime)*60 + EXTRACT(MINUTE FROM BedtimeTime),
    WaketimeTime_minutes = EXTRACT(HOUR FROM WaketimeTime)*60 + EXTRACT(MINUTE FROM WaketimeTime);

# Queries

# Overall sleep trends 
SELECT 
		SEC_TO_TIME(AVG(TIME_TO_SEC(BedtimeTime))) AS AvgBedtime,
		SEC_TO_TIME(AVG(TIME_TO_SEC(WaketimeTime))) AS AvgWaketime,
		SEC_TO_TIME(AVG(TIME_TO_SEC(inbed))) AS AvgInbed,
		SEC_TO_TIME(AVG(TIME_TO_SEC(awake))) AS AvgAwake,
		SEC_TO_TIME(AVG(TIME_TO_SEC(fellAsleepin))) AS AvgFellAsleepin,
		SEC_TO_TIME(AVG(TIME_TO_SEC(asleep))) AS AvgAsleep,
		AVG(efficiency) AS AvgEfficiency,
    AVG(quality_efficiency) AS AvgQuality,
		SEC_TO_TIME(AVG(TIME_TO_SEC(deep))) AS AvgDeep,
		AVG(sleepBPM) AS AvgSleepBPM,
		AVG(dayBPM) AS AvgDayBPM,
		AVG(wakingBPM) AS AvgWakingBPM,
		AVG(hrv) AS AvgHrv,
		AVG(sleepHRV) AS AvgSleepHRV,
		AVG(respAvg) AS AvgResp
FROM 
    sleep_data
		
# Sleep Analysis by weekday 
SELECT 
    Weekday,
		SEC_TO_TIME(AVG(TIME_TO_SEC(BedtimeTime))) AS AvgBedtime,
		SEC_TO_TIME(AVG(TIME_TO_SEC(WaketimeTime))) AS AvgWaketime,
		SEC_TO_TIME(AVG(TIME_TO_SEC(inbed))) AS AvgInbed,
		SEC_TO_TIME(AVG(TIME_TO_SEC(awake))) AS AvgAwake,
		SEC_TO_TIME(AVG(TIME_TO_SEC(fellAsleepin))) AS AvgFellAsleepin,
		SEC_TO_TIME(AVG(TIME_TO_SEC(asleep))) AS AvgAsleep,
		AVG(efficiency) AS AvgEfficiency,
    AVG(quality_efficiency) AS AvgQuality,
		SEC_TO_TIME(AVG(TIME_TO_SEC(deep))) AS AvgDeep,
		AVG(sleepBPM) AS AvgSleepBPM,
		AVG(dayBPM) AS AvgDayBPM,
		AVG(wakingBPM) AS AvgWakingBPM,
		AVG(hrv) AS AvgHrv,
		AVG(sleepHRV) AS AvgSleepHRV,
		AVG(respAvg) AS AvgResp
FROM 
    sleep_data
GROUP BY 
    Weekday
ORDER BY
    CASE 
        WHEN Weekday = 'Monday' THEN 1
        WHEN Weekday = 'Tuesday' THEN 2
        WHEN Weekday = 'Wednesday' THEN 3
        WHEN Weekday = 'Thursday' THEN 4
        WHEN Weekday = 'Friday' THEN 5
        WHEN Weekday = 'Saturday' THEN 6
        WHEN Weekday = 'Sunday' THEN 7
    END;
		
# Based on By Weekday Analysis, we can find out that:
#1. Friday night and Sunday night have the latest average bedtimes
#2. Friday night (i.e. Saturday morning) has the latest average wake-up time
#3. The average total time in bed on Sunday night was the shortest
#4. The average time awake in bed on Sunday night was the shortest
#5. The average time taken to fall asleep was the longest on Friday night, followed by Sunday night
#6. Wednesday night had the shortest average sleep duration
#7. Thursday night and Friday night had the longest average sleep duration
#8. Average sleep efficiency (hours slept/total hours in bed) was highest on Sunday night
#9. Average sleep quality (quality sleep/length of sleep) was highest on Sunday nights and lowest on Friday nights
#10. Average deep sleep on Tuesday nights was the longest and on Friday nights was the shortest
#11. Average sleep heart rate is highest on Sunday nights
#12. Heart rate variability was lowest on Friday night, followed by Sunday night
#13. Average respiration was highest on Friday night

# Common sense Takeways
#1. Sleeping habits on weekends are different from those on weekdays: I tend to go to bed late on Friday nights, and it takes me the longest to fall asleep on Friday nights and wake up late on Saturday mornings, which is consistent with the general weekend rest pattern.
#2. Thursday and Friday nights are the longest sleepers: This is probably because the weekend is coming up and people start to relax and have more time to sleep.
#3. Wednesday nights are the shortest: this may be the peak of a stressful week at work, resulting in less sleep.
#4. Tuesday's deep sleep is the longest, suggesting that people are more tired after the first two days of work and sleep more soundly.
#5. Sunday night had the highest sleep heart rate along with a very low sleep variant heart rate, both trends are bad indicators that I am relatively anxious.

#Interesting Takeways
#1. I go to bed late on Sunday nights, take the longest time to fall asleep, and get the least amount of sleep, which doesn't quite fit the pattern of going to bed early on Sunday nights to prepare for work the following Monday, and suggests that I'm still not accustomed to going to bed early on Sunday nights after a weekend of rest.
#2. my average waking time on Sunday night is the shortest, and the percentage of quality sleep is the highest, which means that I am very efficient after going to bed late, and I sleep very soundly and deeply.
#3. my sleep quality on Friday night was poor, my deep sleep time was the shortest, my sleep variant heart rate was the lowest and my respiratory rate was the highest on Friday night, indicating that I was anxious and did not conform to the common sense of sleeping more soundly after a work week.

# The maximum and minimum values of the various sleep data and indicators and their corresponding DATES
WITH RankedValues AS (
    SELECT
        newDate,
        BedtimeTime,
        WaketimeTime,
        inbed,
        awake,
        fellAsleepIn,
        asleep,
        efficiency,
        quality_efficiency,
        deep,
        sleepBPM,
        dayBPM,
        wakingBPM,
        hrv,
        sleepHRV,
        respAvg,
        ROW_NUMBER() OVER (ORDER BY BedtimeTime DESC) AS RankBedtimeTimeMax,
        ROW_NUMBER() OVER (ORDER BY BedtimeTime) AS RankBedtimeTimeMin,
        ROW_NUMBER() OVER (ORDER BY WaketimeTime DESC) AS RankWaketimeTimeMax,
        ROW_NUMBER() OVER (ORDER BY WaketimeTime) AS RankWaketimeTimeMin,
        ROW_NUMBER() OVER (ORDER BY inbed DESC) AS RankInbedMax,
        ROW_NUMBER() OVER (ORDER BY inbed) AS RankInbedMin,
        ROW_NUMBER() OVER (ORDER BY awake DESC) AS RankAwakeMax,
        ROW_NUMBER() OVER (ORDER BY awake) AS RankAwakeMin,
        ROW_NUMBER() OVER (ORDER BY fellAsleepIn DESC) AS RankFellAsleepInMax,
        ROW_NUMBER() OVER (ORDER BY fellAsleepIn) AS RankFellAsleepInMin,
        ROW_NUMBER() OVER (ORDER BY asleep DESC) AS RankAsleepMax,
        ROW_NUMBER() OVER (ORDER BY asleep) AS RankAsleepMin,
        ROW_NUMBER() OVER (ORDER BY efficiency DESC) AS RankEfficiencyMax,
        ROW_NUMBER() OVER (ORDER BY efficiency) AS RankEfficiencyMin,
        ROW_NUMBER() OVER (ORDER BY quality_efficiency DESC) AS RankQualityEfficiencyMax,
        ROW_NUMBER() OVER (ORDER BY quality_efficiency) AS RankQualityEfficiencyMin,
        ROW_NUMBER() OVER (ORDER BY deep DESC) AS RankDeepMax,
        ROW_NUMBER() OVER (ORDER BY deep) AS RankDeepMin,
        ROW_NUMBER() OVER (ORDER BY sleepBPM DESC) AS RankSleepBPMMax,
        ROW_NUMBER() OVER (ORDER BY sleepBPM) AS RankSleepBPMMin,
        ROW_NUMBER() OVER (ORDER BY dayBPM DESC) AS RankDayBPMMax,
        ROW_NUMBER() OVER (ORDER BY dayBPM) AS RankDayBPMMin,
        ROW_NUMBER() OVER (ORDER BY wakingBPM DESC) AS RankWakingBPMMax,
        ROW_NUMBER() OVER (ORDER BY wakingBPM) AS RankWakingBPMMin,
        ROW_NUMBER() OVER (ORDER BY hrv DESC) AS RankHrvMax,
        ROW_NUMBER() OVER (ORDER BY hrv) AS RankHrvMin,
        ROW_NUMBER() OVER (ORDER BY sleepHRV DESC) AS RankSleepHRVMax,
        ROW_NUMBER() OVER (ORDER BY sleepHRV) AS RankSleepHRVMin,
        ROW_NUMBER() OVER (ORDER BY respAvg DESC) AS RankRespAvgMax,
        ROW_NUMBER() OVER (ORDER BY respAvg) AS RankRespAvgMin
    FROM sleep_data
    WHERE 
        BedtimeTime IS NOT NULL AND
        WaketimeTime IS NOT NULL AND
        inbed IS NOT NULL AND
        awake IS NOT NULL AND
        fellAsleepIn IS NOT NULL AND
        asleep IS NOT NULL AND
        efficiency IS NOT NULL AND
        quality_efficiency IS NOT NULL AND
        deep IS NOT NULL AND
        sleepBPM IS NOT NULL AND
        dayBPM IS NOT NULL AND
        wakingBPM IS NOT NULL AND
        hrv IS NOT NULL AND
        sleepHRV IS NOT NULL AND
        respAvg IS NOT NULL
)
SELECT 
    newDate,
    CASE 
        WHEN RankBedtimeTimeMax = 1 THEN 'BedtimeTime Max'
        WHEN RankBedtimeTimeMin = 1 THEN 'BedtimeTime Min'
        WHEN RankWaketimeTimeMax = 1 THEN 'WaketimeTime Max'
        WHEN RankWaketimeTimeMin = 1 THEN 'WaketimeTime Min'
        WHEN RankInbedMax = 1 THEN 'Inbed Max'
        WHEN RankInbedMin = 1 THEN 'Inbed Min'
        WHEN RankAwakeMax = 1 THEN 'Awake Max'
        WHEN RankAwakeMin = 1 THEN 'Awake Min'
        WHEN RankFellAsleepInMax = 1 THEN 'FellAsleepIn Max'
        WHEN RankFellAsleepInMin = 1 THEN 'FellAsleepIn Min'
        WHEN RankAsleepMax = 1 THEN 'Asleep Max'
        WHEN RankAsleepMin = 1 THEN 'Asleep Min'
        WHEN RankEfficiencyMax = 1 THEN 'Efficiency Max'
        WHEN RankEfficiencyMin = 1 THEN 'Efficiency Min'
        WHEN RankQualityEfficiencyMax = 1 THEN 'QualityEfficiency Max'
        WHEN RankQualityEfficiencyMin = 1 THEN 'QualityEfficiency Min'
        WHEN RankDeepMax = 1 THEN 'Deep Max'
        WHEN RankDeepMin = 1 THEN 'Deep Min'
        WHEN RankSleepBPMMax = 1 THEN 'SleepBPM Max'
        WHEN RankSleepBPMMin = 1 THEN 'SleepBPM Min'
        WHEN RankDayBPMMax = 1 THEN 'DayBPM Max'
        WHEN RankDayBPMMin = 1 THEN 'DayBPM Min'
        WHEN RankWakingBPMMax = 1 THEN 'WakingBPM Max'
        WHEN RankWakingBPMMin = 1 THEN 'WakingBPM Min'
        WHEN RankHrvMax = 1 THEN 'Hrv Max'
        WHEN RankHrvMin = 1 THEN 'Hrv Min'
        WHEN RankSleepHRVMax = 1 THEN 'SleepHRV Max'
        WHEN RankSleepHRVMin = 1 THEN 'SleepHRV Min'
        WHEN RankRespAvgMax = 1 THEN 'RespAvg Max'
        WHEN RankRespAvgMin = 1 THEN 'RespAvg Min'
    END AS ValueType,
    CASE 
        WHEN RankBedtimeTimeMax = 1 THEN BedtimeTime
        WHEN RankBedtimeTimeMin = 1 THEN BedtimeTime
        WHEN RankWaketimeTimeMax = 1 THEN WaketimeTime
        WHEN RankWaketimeTimeMin = 1 THEN WaketimeTime
        WHEN RankInbedMax = 1 THEN inbed
        WHEN RankInbedMin = 1 THEN inbed
        WHEN RankAwakeMax = 1 THEN awake
        WHEN RankAwakeMin = 1 THEN awake
        WHEN RankFellAsleepInMax = 1 THEN fellAsleepIn
        WHEN RankFellAsleepInMin = 1 THEN fellAsleepIn
        WHEN RankAsleepMax = 1 THEN asleep
        WHEN RankAsleepMin = 1 THEN asleep
        WHEN RankEfficiencyMax = 1 THEN efficiency
        WHEN RankEfficiencyMin = 1 THEN efficiency
        WHEN RankQualityEfficiencyMax = 1 THEN quality_efficiency
        WHEN RankQualityEfficiencyMin = 1 THEN quality_efficiency
        WHEN RankDeepMax = 1 THEN deep
        WHEN RankDeepMin = 1 THEN deep
        WHEN RankSleepBPMMax = 1 THEN sleepBPM
        WHEN RankSleepBPMMin = 1 THEN sleepBPM
        WHEN RankDayBPMMax = 1 THEN dayBPM
        WHEN RankDayBPMMin = 1 THEN dayBPM
        WHEN RankWakingBPMMax = 1 THEN wakingBPM
        WHEN RankWakingBPMMin = 1 THEN wakingBPM
        WHEN RankHrvMax = 1 THEN hrv
        WHEN RankHrvMin = 1 THEN hrv
        WHEN RankSleepHRVMax = 1 THEN sleepHRV
        WHEN RankSleepHRVMin = 1 THEN sleepHRV
        WHEN RankRespAvgMax = 1 THEN respAvg
        WHEN RankRespAvgMin = 1 THEN respAvg
    END AS Value
FROM RankedValues
WHERE RankBedtimeTimeMax = 1 OR RankBedtimeTimeMin = 1
   OR RankWaketimeTimeMax = 1 OR RankWaketimeTimeMin = 1
   OR RankInbedMax = 1 OR RankInbedMin = 1
   OR RankAwakeMax = 1 OR RankAwakeMin = 1
   OR RankFellAsleepInMax = 1 OR RankFellAsleepInMin = 1
   OR RankAsleepMax = 1 OR RankAsleepMin = 1
   OR RankEfficiencyMax = 1 OR RankEfficiencyMin = 1
   OR RankQualityEfficiencyMax = 1 OR RankQualityEfficiencyMin = 1
   OR RankDeepMax = 1 OR RankDeepMin = 1
   OR RankSleepBPMMax = 1 OR RankSleepBPMMin = 1
   OR RankDayBPMMax = 1 OR RankDayBPMMin = 1
   OR RankWakingBPMMax = 1 OR RankWakingBPMMin = 1
   OR RankHrvMax = 1 OR RankHrvMin = 1
   OR RankSleepHRVMax = 1 OR RankSleepHRVMin = 1
   OR RankRespAvgMax = 1 OR RankRespAvgMin = 1;
