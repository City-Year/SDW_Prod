USE [SDW_Prod]
GO
/****** Object:  View [dbo].[vw_CM_SPMBEH_DESSATable]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE VIEW [dbo].[vw_CM_SPMBEH_DESSATable]
AS
select 
g.StudentSF_ID Student__c, f.Date Date_Administered__c, j.AssessmentName Assessment_Name,
g.StudentName Student_Name, j.Decision_Making_Description Decision_Making_Description__c,
j.Goal_directed_Behavior_Description Goal_directed_Behavior_Description__c,
j.Optimistic_Thinking_Description Optimistic_Thinking_Description__c,
j.Personal_Responsibility_Description Personal_Responsibility_Description__c,
j.Relationship_Skills_Description Relationship_Skills_Description__c,
j.SEL_Composite_Description SEL_Composite_Description__c,
j.Self_Awareness_Description Self_Awareness_Description__c,
j.Self_Management_Description Self_Management_Description__c,
j.Social_Awareness_Description Social_Awareness_Description__c,
ROW_NUMBER() OVER (PARTITION BY g.StudentSF_ID ORDER BY f.Date DESC, j.AssessmentName ASC) AS MOSTRECENT,
c.CorpsMember_ID Intervention_Corps_Member_ID, 
c.CorpsMember_Name Intervention_Corps_Member, 
d.CYCh_SF_ID cych_Accnt_SF_ID
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_CM_SPMBEH_DESSATable'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_CM_SPMBEH_DESSATable'
GO
