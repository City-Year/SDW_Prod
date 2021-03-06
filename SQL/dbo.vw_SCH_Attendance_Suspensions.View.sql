USE [SDW_Prod]
GO
/****** Object:  View [dbo].[vw_SCH_Attendance_Suspensions]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[vw_SCH_Attendance_Suspensions] as

SELECT
	CYCH_ACCNT_SF_ID,
	QUARTER,
	AVG(convert(decimal(4,3),Average_Daily_Attendance__c)) AS AVG_AVERAGE_DAILY_ATTENDANCE,
	 (SUM(CASE WHEN SUSPENSION_IND=1 THEN 1 END)*1.0)/NULLIF(SUM(CASE WHEN Number_of_Suspensions__c IS NOT NULL THEN 1 END), 0) AS PERC_SUSPENSION,
	  (SUM(CASE WHEN DETENTION_IND=1 THEN 1 END)*1.0)/NULLIF(SUM(CASE WHEN Number_of_Detentions__c IS NOT NULL THEN 1 END), 0) AS PERC_DETENTION,
	  (SUM(CASE WHEN OFFICEREFERRAL_IND=1 THEN 1 END)*1.0)/NULLIF(SUM(CASE WHEN Number_of_Office_Referrals__c IS NOT NULL THEN 1 END), 0) AS PERC_OFFICEREFERRAL
FROM
(SELECT DISTINCT 
	   [student_sf_id]
      ,[cych_Accnt_SF_ID]
      ,[Student__c]
      ,[Assessment_Name_ATT]
      ,[Average_Daily_Attendance__c]
      ,[Assessment_Name_SUS]
      ,[Quarter]
      ,[Date_Administered__c]
      ,[cysch_accnt_sf_id]
	  ,[SUSPENSION_IND]
      ,[DETENTION_IND]
      ,[OFFICEREFERRAL_IND],
	  Number_of_Office_Referrals__c,
	  Number_of_Detentions__c,
	  Number_of_Suspensions__c
  FROM [SDW_Prod].[dbo].[vw_ATTENDANCE_AND_SUSPENSIONS]) a
  GROUP BY CYCH_ACCNT_SF_ID, QUARTER




GO
