USE [SDW_Prod]
GO
/****** Object:  View [dbo].[vw_CM_SPMBEH_DESSAChart]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[vw_CM_SPMBEH_DESSAChart]
AS
select g.StudentSF_ID Student__c, g.StudentName Student_Name, j.AssessmentName Assessment_Name,
f.Date Date_Administered__c, j.SEL_Composite_T_Score SEL_Composite_T_Score__c, 
c.CorpsMember_ID Intervention_Corps_Member_ID, 
c.CorpsMember_Name Intervention_Corps_Member, 
d.CYCh_SF_ID cych_Accnt_SF_ID, DATEADD(month, DATEDIFF(month, 0, f.Date), 0) AS Month_Administered
from SDW_Prod.dbo.FactAll (nolock) a
inner join SDW_Prod.dbo.DimFactType (nolock) b on a.FactTypeID = b.FactTypeID
inner join SDW_Prod.dbo.DimCorpsMember (nolock) c on a.CorpsMemberID = c.CorpsMemberID
inner join SDW_Prod.dbo.DimSchool (nolock) d on a.SchoolID = d.SchoolID
inner join SDW_Prod.dbo.DimIndicatorArea (nolock) e on a.IndicatorAreaID = e.IndicatorAreaID
inner join SDW_Prod.dbo.DimDate (nolock) f on a.DateID = f.DateID
inner join SDW_Prod.dbo.DimStudent (nolock) g on a.StudentID = g.StudentID
inner join SDW_Prod.dbo.DimAssignment (nolock) h on a.AssignmentID = h.AssignmentID
inner join SDW_Prod.dbo.DimGrade (nolock) i on a.GradeID = i.GradeID
inner join SDW_Prod.dbo.DimAssessment (nolock) j on a.AssessmentID = j.AssessmentID
left outer join dbo.Section_Indicator_Area_Matrix AS l WITH (nolock) ON l.StudentSF_ID = g.StudentSF_ID
where (g.Behavior_IA = 1) and j.AssessmentName ='DESSA' and l.Section_IA like '%BEH%'





GO
