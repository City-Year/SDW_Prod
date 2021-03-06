USE [SDW_Prod]
GO
/****** Object:  View [dbo].[vw_AVG_DAILY_ATT]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vw_AVG_DAILY_ATT]
AS
SELECT     g.StudentSF_ID AS Student_SF_ID, d.CYCh_SF_ID AS cych_Accnt_SF_ID, g.StudentSF_ID AS Student__c, 
c.CorpsMember_Name AS Intervention_Corps_Member, 
c.CorpsMember_ID AS Intervention_Corps_Member_ID, j.AssessmentName AS Assessment_Name__c, 
                      j.Average_Daily_Attendance__c, k.Quarter, f.Date AS Date_Administered__c, d.CYSch_SF_ID AS cysch_Accnt_SF_ID
FROM         dbo.FactAll AS a WITH (nolock) INNER JOIN
                      dbo.DimFactType AS b WITH (nolock) ON a.FactTypeID = b.FactTypeID INNER JOIN
                      dbo.DimCorpsMember AS c WITH (nolock) ON a.CorpsMemberID = c.CorpsMemberID INNER JOIN
                      dbo.DimSchool AS d WITH (nolock) ON a.SchoolID = d.SchoolID INNER JOIN
                      dbo.DimIndicatorArea AS e WITH (nolock) ON a.IndicatorAreaID = e.IndicatorAreaID INNER JOIN
                      dbo.DimDate AS f WITH (nolock) ON a.DateID = f.DateID INNER JOIN
                      dbo.DimStudent AS g WITH (nolock) ON a.StudentID = g.StudentID INNER JOIN
                      dbo.DimAssignment AS h WITH (nolock) ON a.AssignmentID = h.AssignmentID INNER JOIN
                      dbo.DimGrade AS i WITH (nolock) ON a.GradeID = i.GradeID INNER JOIN
                      dbo.DimAssessment AS j WITH (nolock) ON a.AssessmentID = j.AssessmentID LEFT OUTER JOIN
                      dbo.DimSchoolSetup AS k WITH (nolock) ON a.SchoolID = k.SchoolID LEFT OUTER JOIN
                      dbo.Section_Indicator_Area_Matrix AS l WITH (nolock) ON l.StudentSF_ID = g.StudentSF_ID
WHERE     (g.Behavior_IA = 1) AND (j.AssessmentName = 'Reporting Period ADA Tracker - ATTENDANCE') AND (j.Average_Daily_Attendance__c <> 'N/A') AND (f.Date BETWEEN 
                      k.Start_Date AND k.End_Date) AND (l.Section_IA LIKE '%BEH%') AND (l.Behavior_IA = 1)


GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[22] 2[21] 3) )"
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
         Begin Table = "a"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "b"
            Begin Extent = 
               Top = 6
               Left = 330
               Bottom = 84
               Right = 481
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 84
               Left = 330
               Bottom = 177
               Right = 509
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 210
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 180
               Left = 248
               Bottom = 288
               Right = 427
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 180
               Left = 465
               Bottom = 288
               Right = 640
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "g"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 223
            End
            DisplayFlags = 280
            TopColumn = 0
         End
  ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_AVG_DAILY_ATT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'       Begin Table = "h"
            Begin Extent = 
               Top = 288
               Left = 261
               Bottom = 396
               Right = 434
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "i"
            Begin Extent = 
               Top = 288
               Left = 472
               Bottom = 381
               Right = 623
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "j"
            Begin Extent = 
               Top = 396
               Left = 38
               Bottom = 504
               Right = 342
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "k"
            Begin Extent = 
               Top = 504
               Left = 38
               Bottom = 612
               Right = 198
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "l"
            Begin Extent = 
               Top = 6
               Left = 519
               Bottom = 114
               Right = 698
            End
            DisplayFlags = 280
            TopColumn = 0
         End
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_AVG_DAILY_ATT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_AVG_DAILY_ATT'
GO
