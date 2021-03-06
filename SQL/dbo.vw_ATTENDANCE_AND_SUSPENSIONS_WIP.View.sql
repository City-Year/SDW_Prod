USE [SDW_Prod]
GO
/****** Object:  View [dbo].[vw_ATTENDANCE_AND_SUSPENSIONS_WIP]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_ATTENDANCE_AND_SUSPENSIONS_WIP]
AS
SELECT     Student_SF_ID,cych_Accnt_SF_ID, Student__c, Intervention_Corps_Member, Intervention_Corps_Member_ID, 
                      Assessment_Name__c AS Assessment_Name, Average_Daily_Attendance__c, 
                      '' AS  Number_of_Suspensions__c,'' AS Number_of_Detentions__c,'' AS Number_of_Office_Referrals__c, Quarter, Date_Administered__c, cysch_Accnt_SF_ID, 
                     ''  AS SUSPENSION_IND, 
                    '' AS DETENTION_IND, 
                     '' AS OFFICEREFERRAL_IND
FROM         dbo.vw_AVG_DAILY_ATT 

			UNION ALL
			
			SELECT     Student_SF_ID,cych_Accnt_SF_ID, Student__c, Intervention_Corps_Member, Intervention_Corps_Member_ID, 
                      Assessment_Name__c AS Assessment_Name, '' AS Average_Daily_Attendance__c,  
                      Number_of_Suspensions__c, Number_of_Detentions__c, Number_of_Office_Referrals__c, Quarter, Date_Administered__c, cysch_Accnt_SF_ID, 
                     CASE WHEN Number_of_Suspensions__c IS NOT NULL AND Number_of_Suspensions__c <> '0.0' THEN 1 ELSE 0 END AS SUSPENSION_IND, 
                     CASE WHEN Number_of_Detentions__c IS NOT NULL AND Number_of_Detentions__c <> '0.0' THEN 1 ELSE 0 END AS DETENTION_IND, 
                     CASE WHEN Number_of_Office_Referrals__c IS NOT NULL AND Number_of_Office_Referrals__c <> '0.0' THEN 1 ELSE 0 END AS OFFICEREFERRAL_IND
FROM         dbo.vw_NUM_OF_SUSPENSIONS	
                      	  

GO
