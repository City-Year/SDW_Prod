USE [SDW_Prod]
GO
/****** Object:  View [dbo].[vw_DESSA_SCHOOL_FULL]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_DESSA_SCHOOL_FULL]
AS
SELECT     dbo.vw_DESSA_SCHOOL_COMP.cych_Accnt_SF_ID, dbo.vw_DESSA_SCHOOL_COMP.Student_School_Name, 
                      dbo.vw_DESSA_SCHOOL_COMP.Assessment_Administration_Number, 
                      CASE WHEN DBO.VW_DESSA_SCHOOL_COMP.ASSESSMENT_ADMINISTRATION_NUMBER = 1 THEN '1st Administration' WHEN DBO.VW_DESSA_SCHOOL_COMP.ASSESSMENT_ADMINISTRATION_NUMBER
                       = 2 THEN '2nd Administration' WHEN DBO.VW_DESSA_SCHOOL_COMP.ASSESSMENT_ADMINISTRATION_NUMBER = 3 THEN '3rd Administration' WHEN DBO.VW_DESSA_SCHOOL_COMP.ASSESSMENT_ADMINISTRATION_NUMBER
                       = 4 THEN '4th Administration' WHEN DBO.VW_DESSA_SCHOOL_COMP.ASSESSMENT_ADMINISTRATION_NUMBER = 5 THEN '5th Administration' WHEN DBO.VW_DESSA_SCHOOL_COMP.ASSESSMENT_ADMINISTRATION_NUMBER
                       = 6 THEN '6th Administration' WHEN DBO.VW_DESSA_SCHOOL_COMP.ASSESSMENT_ADMINISTRATION_NUMBER = 7 THEN '7th Administration' WHEN DBO.VW_DESSA_SCHOOL_COMP.ASSESSMENT_ADMINISTRATION_NUMBER
                       = 8 THEN '8th Administration' WHEN DBO.VW_DESSA_SCHOOL_COMP.ASSESSMENT_ADMINISTRATION_NUMBER = 9 THEN '9th Administration' WHEN DBO.VW_DESSA_SCHOOL_COMP.ASSESSMENT_ADMINISTRATION_NUMBER
                       = 10 THEN '10th Administration' WHEN DBO.VW_DESSA_SCHOOL_COMP.ASSESSMENT_ADMINISTRATION_NUMBER = 11 THEN '11th Administration' WHEN DBO.VW_DESSA_SCHOOL_COMP.ASSESSMENT_ADMINISTRATION_NUMBER
                       = 12 THEN '12th Administration' END AS ASSESSMENT_ADMINISTRATION_TEXT, dbo.vw_DESSA_SCHOOL_COMP.COMP_N, 
                      dbo.vw_DESSA_SCHOOL_COMP.COMP_T, dbo.vw_DESSA_SCHOOL_COMP.COMP_S, dbo.vw_DESSA_SCHOOL_DM.DM_N, dbo.vw_DESSA_SCHOOL_DM.DM_T, 
                      dbo.vw_DESSA_SCHOOL_DM.DM_S, dbo.vw_DESSA_SCHOOL_GDB.GDB_N, dbo.vw_DESSA_SCHOOL_GDB.GDB_T, dbo.vw_DESSA_SCHOOL_GDB.GDB_S, 
                      dbo.vw_DESSA_SCHOOL_OT.OT_N, dbo.vw_DESSA_SCHOOL_OT.OT_T, dbo.vw_DESSA_SCHOOL_OT.OT_S, dbo.vw_DESSA_SCHOOL_PR.PR_N, 
                      dbo.vw_DESSA_SCHOOL_PR.PR_T, dbo.vw_DESSA_SCHOOL_PR.PR_S, dbo.vw_DESSA_SCHOOL_RS.RS_N, dbo.vw_DESSA_SCHOOL_RS.RS_T, 
                      dbo.vw_DESSA_SCHOOL_RS.RS_S, dbo.vw_DESSA_SCHOOL_SA.SA_N, dbo.vw_DESSA_SCHOOL_SA.SA_T, dbo.vw_DESSA_SCHOOL_SA.SA_S, 
                      dbo.vw_DESSA_SCHOOL_SM.SM_N, dbo.vw_DESSA_SCHOOL_SM.SM_T, dbo.vw_DESSA_SCHOOL_SM.SM_S, dbo.vw_DESSA_SCHOOL_SoA.SoA_N, 
                      dbo.vw_DESSA_SCHOOL_SoA.SoA_T, dbo.vw_DESSA_SCHOOL_SoA.SoA_S
FROM         dbo.vw_DESSA_SCHOOL_COMP INNER JOIN
                      dbo.vw_DESSA_SCHOOL_OT ON dbo.vw_DESSA_SCHOOL_OT.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_OT.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP.Student_School_Name AND 
                      dbo.vw_DESSA_SCHOOL_OT.Assessment_Administration_Number = dbo.vw_DESSA_SCHOOL_COMP.Assessment_Administration_Number INNER JOIN
                      dbo.vw_DESSA_SCHOOL_DM ON dbo.vw_DESSA_SCHOOL_DM.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_DM.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP.Student_School_Name AND 
                      dbo.vw_DESSA_SCHOOL_DM.Assessment_Administration_Number = dbo.vw_DESSA_SCHOOL_COMP.Assessment_Administration_Number INNER JOIN
                      dbo.vw_DESSA_SCHOOL_GDB ON dbo.vw_DESSA_SCHOOL_GDB.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_GDB.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP.Student_School_Name AND 
                      dbo.vw_DESSA_SCHOOL_GDB.Assessment_Administration_Number = dbo.vw_DESSA_SCHOOL_COMP.Assessment_Administration_Number INNER JOIN
                      dbo.vw_DESSA_SCHOOL_PR ON dbo.vw_DESSA_SCHOOL_PR.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_PR.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP.Student_School_Name AND 
                      dbo.vw_DESSA_SCHOOL_PR.Assessment_Administration_Number = dbo.vw_DESSA_SCHOOL_COMP.Assessment_Administration_Number INNER JOIN
                      dbo.vw_DESSA_SCHOOL_RS ON dbo.vw_DESSA_SCHOOL_RS.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_RS.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP.Student_School_Name AND 
                      dbo.vw_DESSA_SCHOOL_RS.Assessment_Administration_Number = dbo.vw_DESSA_SCHOOL_COMP.Assessment_Administration_Number INNER JOIN
                      dbo.vw_DESSA_SCHOOL_SA ON dbo.vw_DESSA_SCHOOL_SA.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_SA.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP.Student_School_Name AND 
                      dbo.vw_DESSA_SCHOOL_SA.Assessment_Administration_Number = dbo.vw_DESSA_SCHOOL_COMP.Assessment_Administration_Number INNER JOIN
                      dbo.vw_DESSA_SCHOOL_SM ON dbo.vw_DESSA_SCHOOL_SM.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_SM.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP.Student_School_Name AND 
                      dbo.vw_DESSA_SCHOOL_SM.Assessment_Administration_Number = dbo.vw_DESSA_SCHOOL_COMP.Assessment_Administration_Number INNER JOIN
                      dbo.vw_DESSA_SCHOOL_SoA ON dbo.vw_DESSA_SCHOOL_SoA.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_SoA.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP.Student_School_Name AND 
                      dbo.vw_DESSA_SCHOOL_SoA.Assessment_Administration_Number = dbo.vw_DESSA_SCHOOL_COMP.Assessment_Administration_Number

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
         Begin Table = "vw_DESSA_SCHOOL_COMP"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_OT"
            Begin Extent = 
               Top = 6
               Left = 330
               Bottom = 114
               Right = 584
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_DM"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_GDB"
            Begin Extent = 
               Top = 114
               Left = 330
               Bottom = 222
               Right = 584
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_PR"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_RS"
            Begin Extent = 
               Top = 222
               Left = 330
               Bottom = 330
               Right = 584
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_SA"
            Begin Extent = 
               Top = 330
               Left = 38
               Bottom = 43' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_DESSA_SCHOOL_FULL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'8
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_SM"
            Begin Extent = 
               Top = 330
               Left = 330
               Bottom = 438
               Right = 584
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_SoA"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 546
               Right = 292
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_DESSA_SCHOOL_FULL'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_DESSA_SCHOOL_FULL'
GO
