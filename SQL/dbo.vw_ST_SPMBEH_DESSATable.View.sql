USE [SDW_Prod]
GO
/****** Object:  View [dbo].[vw_ST_SPMBEH_DESSATable]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ST_SPMBEH_DESSATable]
AS
SELECT     a.*
FROM         (SELECT     g.StudentSF_ID Student__c, f.Date Date_Administered__c, j.AssessmentName Assessment_Name, g.StudentName Student_Name, 
                                              j.Social_Awareness_Description social_awareness_Description__c, j.Self_Management_Description self_management_description__c, 
                                              j.Self_Awareness_Description self_awareness_description__c, j.SEL_Composite_Description SEL_composite_description__c, 
                                              j.Relationship_Skills_Description relationship_skills_description__c, j.Personal_Responsibility_Description personal_responsibility_description__c, 
                                              j.Optimistic_Thinking_Description optimistic_thinking_description__c, j.Goal_directed_Behavior_Description goal_directed_behavior_description__c, 
                                              j.Decision_Making_Description decision_making_description__c, ROW_NUMBER() OVER (PARTITION BY g.StudentSF_ID
                       ORDER BY f.Date DESC, j.AssessmentName ASC) AS MOSTRECENT, studentname, schoolname, CYch_SF_ID AS cych_accnt_sf_id, business_unit
FROM         SDW_Prod.dbo.FactAll(nolock) a INNER JOIN
                      SDW_Prod.dbo.DimFactType(nolock) b ON a.FactTypeID = b.FactTypeID INNER JOIN
                      SDW_Prod.dbo.DimCorpsMember(nolock) c ON a.CorpsMemberID = c.CorpsMemberID INNER JOIN
                      SDW_Prod.dbo.DimSchool(nolock) d ON a.SchoolID = d .SchoolID INNER JOIN
                      SDW_Prod.dbo.DimIndicatorArea(nolock) e ON a.IndicatorAreaID = e.IndicatorAreaID INNER JOIN
                      SDW_Prod.dbo.DimDate(nolock) f ON a.DateID = f.DateID INNER JOIN
                      SDW_Prod.dbo.DimStudent(nolock) g ON a.StudentID = g.StudentID INNER JOIN
                      SDW_Prod.dbo.DimAssignment(nolock) h ON a.AssignmentID = h.AssignmentID INNER JOIN
                      SDW_Prod.dbo.DimGrade(nolock) i ON a.GradeID = i.GradeID INNER JOIN
                      SDW_Prod.dbo.DimAssessment(nolock) j ON a.AssessmentID = j.AssessmentID
WHERE     j.AssessmentName = 'DESSA' AND g.Behavior_IA = '1') a
WHERE     MOSTRECENT = 1

GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_ST_SPMBEH_DESSATable'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_ST_SPMBEH_DESSATable'
GO
