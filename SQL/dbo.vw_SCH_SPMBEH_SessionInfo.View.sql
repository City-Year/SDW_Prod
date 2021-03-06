USE [SDW_Prod]
GO
/****** Object:  View [dbo].[vw_SCH_SPMBEH_SessionInfo]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO










CREATE  VIEW [dbo].[vw_SCH_SPMBEH_SessionInfo] as

SELECT     b.Program_Description, b.cych_accnt_sf_id, b.Intervention_Corps_Member, b.Intervention_Corps_Member_ID, b.TOTALSTUDENTS, b.TOTALSESSIONS6WK, 
                      b.TOTALSTUDENTS6WK, E.AVGSessionDosage6wks, E.STUDENTSPERSESSION6wks, 
                      CASE WHEN E.program_description = 'SEL CHECK IN CHECK OUT' THEN (TOTALSTUDENTS * 12) 
                      WHEN E.PROGRAM_DESCRIPTION LIKE '50 ACTS%' THEN (TOTALSTUDENTS * 6) END AS EXPECTED_SESSIONS
FROM         (SELECT     Program_Description, cych_accnt_sf_id, Intervention_Corps_Member, Intervention_Corps_Member_ID, COUNT(DISTINCT Student_SF_ID) 
                                              AS TOTALSTUDENTS, COUNT(DISTINCT (CASE WHEN SESSION_DATE >= (GETDATE() - 42) THEN SESSION_ID END)) AS TOTALSESSIONS6WK, 
                                              COUNT(DISTINCT (CASE WHEN SESSION_DATE >= (GETDATE() - 42) THEN STUDENT_SF_ID END)) AS TOTALSTUDENTS6WK
                       FROM          (SELECT DISTINCT 
                                                                      d.Program_Description, f.CYCh_SF_ID AS cych_accnt_sf_id, a.Source_Session_Key AS session_id, b.Date AS SESSION_DATE, 
                                                                      c.StudentSF_ID AS Student_SF_ID, g.CorpsMember_Name AS Intervention_Corps_Member, 
                                                                      g.CorpsMember_ID AS Intervention_Corps_Member_ID
                                               FROM          dbo.FactAll AS a INNER JOIN
                                                                      dbo.DimDate AS b ON a.DateID = b.DateID INNER JOIN
                                                                      dbo.DimStudent AS c ON a.StudentID = c.StudentID INNER JOIN
                                                                      dbo.DimIndicatorArea AS d ON a.IndicatorAreaID = d.IndicatorAreaID INNER JOIN
                                                                      dbo.DimAssessment AS e ON a.AssessmentID = e.AssessmentID INNER JOIN
                                                                      dbo.DimSchool AS f ON a.SchoolID = f.SchoolID INNER JOIN
                                                                      dbo.DimCorpsMember AS g ON a.CorpsMemberID = g.CorpsMemberID
                                               WHERE      (d.IndicatorArea LIKE 'BEH%') AND (c.Behavior_IA = 1) AND (g.CorpsMemberID IS NOT NULL)) AS a
                       GROUP BY Intervention_Corps_Member_ID, Program_Description, cych_accnt_sf_id, Intervention_Corps_Member) AS b INNER JOIN
                          (SELECT     Program_Description, cych_accnt_sf_id, intervention_corps_member_id, intervention_corps_member, AVG(SESSION_DOSSAGE) 
                                                   AS AVGSessionDosage6wks, AVG(STUDENTSPERSESSION) AS STUDENTSPERSESSION6wks
                            FROM          (SELECT     Program_Description, cych_accnt_sf_id, session_id, COUNT(STUDENTSPERSESSION) AS STUDENTSPERSESSION, 
                                                                           intervention_corps_member, intervention_corps_member_id, MAX(SESSION_DOSSAGE) AS SESSION_DOSSAGE
                                                    FROM          (SELECT     d.Program_Description, f.CYCh_SF_ID AS cych_accnt_sf_id, a.Source_Session_Key AS session_id, 
                                                                                                   c.StudentSF_ID AS STUDENTSPERSESSION, g.CorpsMember_Name AS intervention_corps_member, 
                                                                                                   g.CorpsMember_ID AS intervention_corps_member_id, a.Session_Dosage AS SESSION_DOSSAGE
                                                                            FROM          dbo.FactAll AS a INNER JOIN
                                                                                                   dbo.DimDate AS b ON a.DateID = b.DateID INNER JOIN
                                                                                                   dbo.DimStudent AS c ON a.StudentID = c.StudentID INNER JOIN
                                                                                                   dbo.DimIndicatorArea AS d ON a.IndicatorAreaID = d.IndicatorAreaID INNER JOIN
                                                                                                   dbo.DimAssessment AS e ON a.AssessmentID = e.AssessmentID INNER JOIN
                                                                                                   dbo.DimSchool AS f ON a.SchoolID = f.SchoolID INNER JOIN
                                                                                                   dbo.DimCorpsMember AS g ON a.CorpsMemberID = g.CorpsMemberID
                                                                            WHERE      (d.IndicatorArea LIKE 'BEH%') AND (c.Behavior_IA = 1) AND (g.CorpsMember_ID IS NOT NULL) AND (b.Date >= GETDATE() - 42)) 
                                                                           AS C
                                                    GROUP BY intervention_corps_member_id, cych_accnt_sf_id, intervention_corps_member, session_id, Program_Description) AS D
                            GROUP BY intervention_corps_member_id, cych_accnt_sf_id, intervention_corps_member, Program_Description) AS E ON 
                      b.Intervention_Corps_Member_ID = E.intervention_corps_member_id AND b.cych_accnt_sf_id = E.cych_accnt_sf_id AND 
                      b.Program_Description = E.Program_Description




GO
