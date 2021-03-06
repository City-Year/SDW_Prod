USE [SDW_Prod]
GO
/****** Object:  View [dbo].[vw_SCH_SPMBEH_SessionSkills]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO







CREATE VIEW [dbo].[vw_SCH_SPMBEH_SessionSkills] as

SELECT * FROM
(SELECT *, CONCAT(ABREV, ': ', APPEND) AS SESSION_SKILL_FORUSE
FROM
(SELECT *, 
CASE 
	WHEN ABBREV_SESSIONSKILL LIKE 'DECISION%' THEN 'DM'
	WHEN ABBREV_SESSIONSKILL LIKE 'GOAL%' THEN 'GB' 
	WHEN ABBREV_SESSIONSKILL LIKE 'OPTIMI%' THEN 'OT'
	WHEN ABBREV_SESSIONSKILL LIKE 'PERSONAL%' THEN 'PR' 
	WHEN ABBREV_SESSIONSKILL LIKE 'RELAT%' THEN 'RS' 
	WHEN ABBREV_SESSIONSKILL LIKE 'SELF-AW%' THEN 'SA'
	WHEN ABBREV_SESSIONSKILL LIKE 'SELF-MA%' THEN 'SM' 
	WHEN ABBREV_SESSIONSKILL LIKE 'SOCIAL-AW%' THEN 'SO' END AS ABREV
FROM
(select distinct a.Source_Session_Key Session_ID, g.Behavior_IA Student_IA_Beh, 
e.IndicatorArea Section_IA, e.Program_Description, e.SessionSkill Session_Skill, 
g.CY_StudentID CY_Student_ID, d.SchoolName Student_School_Name, 
d.CYCh_SF_ID cych_Accnt_SF_ID, g.StudentSF_ID Student_SF_ID, 
c.CorpsMember_Name Intervention_Corps_Member, c.CorpsMember_ID Intervention_Corps_Member_ID, 
d.Business_Unit Business_Unit, 
SUBSTRING(e.SessionSkill, 1, CASE WHEN CHARINDEX(',', e.SessionSkill) > 0 THEN charindex(',', e.SessionSkill) - 1 
ELSE len(e.SessionSkill) END) AS PRIMARYSKILL, SUBSTRING(e.SessionSkill, 1, CASE WHEN CHARINDEX(':', e.SessionSkill) > 0 THEN CHARINDEX(':', e.SessionSkill) - 1 ELSE LEN(e.SessionSkill) END) AS ABBREV_SESSIONSKILL, 
SUBSTRING(SUBSTRING(e.SessionSkill, 1, CASE WHEN CHARINDEX(',', e.SessionSkill) > 0 THEN charindex(',', e.SessionSkill) 
- 1 ELSE len(e.SessionSkill) END), CHARINDEX(':', e.SessionSkill) + 2, LEN(e.SessionSkill)) AS APPEND
from SDW_Prod.dbo.FactAll (nolock) a
inner join SDW_Prod.dbo.DimFactType (nolock) b on a.FactTypeID = b.FactTypeID
inner join SDW_Prod.dbo.DimCorpsMember (nolock) c on a.CorpsMemberID = c.CorpsMemberID
inner join SDW_Prod.dbo.DimSchool (nolock) d on a.SchoolID = d.SchoolID
inner join SDW_Prod.dbo.DimIndicatorArea (nolock) e on a.IndicatorAreaID = e.IndicatorAreaID
inner join SDW_Prod.dbo.DimDate (nolock) f on a.DateID = f.DateID
inner join SDW_Prod.dbo.DimStudent (nolock) g on a.StudentID = g.StudentID
inner join SDW_Prod.dbo.DimAssignment (nolock) h on a.AssignmentID = h.AssignmentID
inner join SDW_Prod.dbo.DimGrade (nolock) i on a.GradeID = i.GradeID
where 
(f.Date >= GETDATE() - 42) AND
d.Business_Unit is not null AND
(g.Behavior_IA = 1) AND
e.IndicatorArea like '%Beh%' AND
(e.SessionSkill NOT IN ('Other', 'Homework Assistance', 'Enrichment Activity', 'Other Attendance skill not listed'))
) A) B) C where SESSION_SKILL_FORUSE not like ':%'









GO
