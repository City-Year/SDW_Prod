USE [SDW_Prod]
GO
/****** Object:  View [dbo].[vw_ST_SPMBEH_IntSessions]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_ST_SPMBEH_IntSessions]
AS
SELECT     a.Session_Dosage, b.Date AS session_date, a.Source_Session_Key AS session_id, c.StudentName AS student_name, c.Behavior_IA AS student_ia_beh, 
                      d.IndicatorArea AS section_IA, d.Program_Description, d.SessionSkill AS session_skills, c.CY_StudentID AS cy_student_id, f.CYCh_SF_ID AS cych_accnt_sf_id, 
                      f.SchoolName AS student_school_name, c.StudentSF_ID AS student_sf_id, g.CorpsMember_Name AS intervention_corps_member, 
                      g.CorpsMember_ID AS intervention_corps_member_id, f.Business_Unit
FROM         dbo.FactAll AS a INNER JOIN
                      dbo.DimDate AS b ON a.DateID = b.DateID INNER JOIN
                      dbo.DimStudent AS c ON a.StudentID = c.StudentID INNER JOIN
                      dbo.DimIndicatorArea AS d ON a.IndicatorAreaID = d.IndicatorAreaID INNER JOIN
                      dbo.DimAssessment AS e ON a.AssessmentID = e.AssessmentID INNER JOIN
                      dbo.DimSchool AS f ON a.SchoolID = f.SchoolID INNER JOIN
                      dbo.DimCorpsMember AS g ON a.CorpsMemberID = g.CorpsMemberID
WHERE     (d.IndicatorArea LIKE 'beh%') AND (c.Behavior_IA = 1) AND (b.Date >= GETDATE() - 42)

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
               Top = 114
               Left = 38
               Bottom = 222
               Right = 213
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 114
               Left = 251
               Bottom = 222
               Right = 436
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "d"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 217
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "e"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 438
               Right = 342
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "f"
            Begin Extent = 
               Top = 222
               Left = 255
               Bottom = 330
               Right = 427
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "g"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 531
               Right = 217
            End
            DisplayFlags = 280
            TopColumn = 0
         End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_ST_SPMBEH_IntSessions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1380
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_ST_SPMBEH_IntSessions'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_ST_SPMBEH_IntSessions'
GO
