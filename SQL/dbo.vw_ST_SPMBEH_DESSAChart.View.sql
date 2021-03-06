USE [SDW_Prod]
GO
/****** Object:  View [dbo].[vw_ST_SPMBEH_DESSAChart]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




CREATE  VIEW [dbo].[vw_ST_SPMBEH_DESSAChart]
AS
SELECT     
g.StudentSF_ID AS Student__c, f.Date AS Date_Administered__c, 
j.AssessmentName AS Assessment_Name, 
j.Decision_Making_T_Score Decision_Making_T_Score__c,
j.Goal_directed_Behavior_T_Score Goal_directed_Behavior_T_Score__c,
j.Optimistic_Thinking_T_Score Optimistic_Thinking_T_Score__c,
j.Personal_Responsibility_T_Score Personal_Responsibility_T_Score__c,
j.Relationship_Skills_T_Score Relationship_Skills_T_Score__c,
j.SEL_Composite_T_Score SEL_Composite_T_Score__c,
j.Self_Awareness_T_Score Self_Awareness_T_Score__c, 
j.Self_Management_T_Score Self_Management_T_Score__c, 
j.Social_Awareness_T_Score Social_Awareness_T_Score__c, 
DATEADD(month, DATEDIFF(month, 0, f.Date), 0) AS Month_Administered,
studentname, 
schoolname, 
CYCh_SF_ID  AS cych_accnt_sf_id,  
business_unit


FROM dbo.FactAll AS a WITH (nolock) 
INNER JOIN dbo.DimFactType AS b WITH (nolock) ON a.FactTypeID = b.FactTypeID 
INNER JOIN dbo.DimCorpsMember AS c WITH (nolock) ON a.CorpsMemberID = c.CorpsMemberID 
INNER JOIN dbo.DimSchool AS d WITH (nolock) ON a.SchoolID = d.SchoolID 
INNER JOIN dbo.DimIndicatorArea AS e WITH (nolock) ON a.IndicatorAreaID = e.IndicatorAreaID 
INNER JOIN dbo.DimDate AS f WITH (nolock) ON a.DateID = f.DateID 
INNER JOIN dbo.DimStudent AS g WITH (nolock) ON a.StudentID = g.StudentID 
INNER JOIN dbo.DimAssignment AS h WITH (nolock) ON a.AssignmentID = h.AssignmentID 
INNER JOIN dbo.DimGrade AS i WITH (nolock) ON a.GradeID = i.GradeID 
INNER JOIN dbo.DimAssessment AS j WITH (nolock) ON a.AssessmentID = j.AssessmentID
WHERE     (g.Behavior_IA = 1) AND (j.AssessmentName = 'DESSA')






GO
