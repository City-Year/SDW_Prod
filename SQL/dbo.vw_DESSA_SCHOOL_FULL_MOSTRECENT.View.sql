USE [SDW_Prod]
GO
/****** Object:  View [dbo].[vw_DESSA_SCHOOL_FULL_MOSTRECENT]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_DESSA_SCHOOL_FULL_MOSTRECENT]
AS
SELECT     dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.cych_Accnt_SF_ID, dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.Student_School_Name, 
                      dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.COMP_PLUS4, dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.COMP_PLUS1TO3, 
                      dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.COMP_NOCHANGE, dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.COMP_MINUS1TO3, 
                      dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.COMP_MINUS4, dbo.vw_DESSA_SCHOOL_DM_MOSTRECENT.DM_PLUS4, 
                      dbo.vw_DESSA_SCHOOL_DM_MOSTRECENT.DM_PLUS1TO3, dbo.vw_DESSA_SCHOOL_DM_MOSTRECENT.DM_NOCHANGE, 
                      dbo.vw_DESSA_SCHOOL_DM_MOSTRECENT.DM_MINUS1TO3, dbo.vw_DESSA_SCHOOL_DM_MOSTRECENT.DM_MINUS4, 
                      dbo.vw_DESSA_SCHOOL_GDB_MOSTRECENT.GDB_PLUS4, dbo.vw_DESSA_SCHOOL_GDB_MOSTRECENT.GDB_PLUS1TO3, 
                      dbo.vw_DESSA_SCHOOL_GDB_MOSTRECENT.GDB_NOCHANGE, dbo.vw_DESSA_SCHOOL_GDB_MOSTRECENT.GDB_MINUS1TO3, 
                      dbo.vw_DESSA_SCHOOL_GDB_MOSTRECENT.GDB_MINUS4, dbo.vw_DESSA_SCHOOL_OT_MOSTRECENT.OT_PLUS4, 
                      dbo.vw_DESSA_SCHOOL_OT_MOSTRECENT.OT_PLUS1TO3, dbo.vw_DESSA_SCHOOL_OT_MOSTRECENT.OT_NOCHANGE, 
                      dbo.vw_DESSA_SCHOOL_OT_MOSTRECENT.OT_MINUS1TO3, dbo.vw_DESSA_SCHOOL_OT_MOSTRECENT.OT_MINUS4, 
                      dbo.vw_DESSA_SCHOOL_PR_MOSTRECENT.PR_PLUS4, dbo.vw_DESSA_SCHOOL_PR_MOSTRECENT.PR_PLUS1TO3, 
                      dbo.vw_DESSA_SCHOOL_PR_MOSTRECENT.PR_NOCHANGE, dbo.vw_DESSA_SCHOOL_PR_MOSTRECENT.PR_MINUS1TO3, 
                      dbo.vw_DESSA_SCHOOL_PR_MOSTRECENT.PR_MINUS4, dbo.vw_DESSA_SCHOOL_RS_MOSTRECENT.RS_PLUS4, 
                      dbo.vw_DESSA_SCHOOL_RS_MOSTRECENT.RS_PLUS1TO3, dbo.vw_DESSA_SCHOOL_RS_MOSTRECENT.RS_NOCHANGE, 
                      dbo.vw_DESSA_SCHOOL_RS_MOSTRECENT.RS_MINUS1TO3, dbo.vw_DESSA_SCHOOL_RS_MOSTRECENT.RS_MINUS4, 
                      dbo.vw_DESSA_SCHOOL_SA_MOSTRECENT.SA_PLUS4, dbo.vw_DESSA_SCHOOL_SA_MOSTRECENT.SA_PLUS1TO3, 
                      dbo.vw_DESSA_SCHOOL_SA_MOSTRECENT.SA_NOCHANGE, dbo.vw_DESSA_SCHOOL_SA_MOSTRECENT.SA_MINUS1TO3, 
                      dbo.vw_DESSA_SCHOOL_SA_MOSTRECENT.SA_MINUS4, dbo.vw_DESSA_SCHOOL_SM_MOSTRECENT.SM_PLUS4, 
                      dbo.vw_DESSA_SCHOOL_SM_MOSTRECENT.SM_PLUS1TO3, dbo.vw_DESSA_SCHOOL_SM_MOSTRECENT.SM_NOCHANGE, 
                      dbo.vw_DESSA_SCHOOL_SM_MOSTRECENT.SM_MINUS1TO3, dbo.vw_DESSA_SCHOOL_SM_MOSTRECENT.SM_MINUS4, 
                      dbo.vw_DESSA_SCHOOL_SoA_MOSTRECENT.SoA_PLUS4, dbo.vw_DESSA_SCHOOL_SoA_MOSTRECENT.SoA_PLUS1TO3, 
                      dbo.vw_DESSA_SCHOOL_SoA_MOSTRECENT.SoA_NOCHANGE, dbo.vw_DESSA_SCHOOL_SoA_MOSTRECENT.SoA_MINUS1TO3, 
                      dbo.vw_DESSA_SCHOOL_SoA_MOSTRECENT.SoA_MINUS4
FROM         dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT INNER JOIN
                      dbo.vw_DESSA_SCHOOL_OT_MOSTRECENT ON 
                      dbo.vw_DESSA_SCHOOL_OT_MOSTRECENT.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_OT_MOSTRECENT.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.Student_School_Name INNER JOIN
                      dbo.vw_DESSA_SCHOOL_DM_MOSTRECENT ON 
                      dbo.vw_DESSA_SCHOOL_DM_MOSTRECENT.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_DM_MOSTRECENT.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.Student_School_Name INNER JOIN
                      dbo.vw_DESSA_SCHOOL_GDB_MOSTRECENT ON 
                      dbo.vw_DESSA_SCHOOL_GDB_MOSTRECENT.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_GDB_MOSTRECENT.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.Student_School_Name INNER JOIN
                      dbo.vw_DESSA_SCHOOL_PR_MOSTRECENT ON 
                      dbo.vw_DESSA_SCHOOL_PR_MOSTRECENT.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_PR_MOSTRECENT.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.Student_School_Name INNER JOIN
                      dbo.vw_DESSA_SCHOOL_RS_MOSTRECENT ON 
                      dbo.vw_DESSA_SCHOOL_RS_MOSTRECENT.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_RS_MOSTRECENT.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.Student_School_Name INNER JOIN
                      dbo.vw_DESSA_SCHOOL_SA_MOSTRECENT ON 
                      dbo.vw_DESSA_SCHOOL_SA_MOSTRECENT.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_SA_MOSTRECENT.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.Student_School_Name INNER JOIN
                      dbo.vw_DESSA_SCHOOL_SM_MOSTRECENT ON 
                      dbo.vw_DESSA_SCHOOL_SM_MOSTRECENT.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_SM_MOSTRECENT.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.Student_School_Name INNER JOIN
                      dbo.vw_DESSA_SCHOOL_SoA_MOSTRECENT ON 
                      dbo.vw_DESSA_SCHOOL_SoA_MOSTRECENT.cych_Accnt_SF_ID = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.cych_Accnt_SF_ID AND 
                      dbo.vw_DESSA_SCHOOL_SoA_MOSTRECENT.Student_School_Name = dbo.vw_DESSA_SCHOOL_COMP_MOSTRECENT.Student_School_Name

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
         Begin Table = "vw_DESSA_SCHOOL_COMP_MOSTRECENT"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_OT_MOSTRECENT"
            Begin Extent = 
               Top = 6
               Left = 268
               Bottom = 114
               Right = 460
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_DM_MOSTRECENT"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 222
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_GDB_MOSTRECENT"
            Begin Extent = 
               Top = 114
               Left = 268
               Bottom = 222
               Right = 460
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_PR_MOSTRECENT"
            Begin Extent = 
               Top = 222
               Left = 38
               Bottom = 330
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_RS_MOSTRECENT"
            Begin Extent = 
               Top = 222
               Left = 268
               Bottom = 330
               Right = 460
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_SA_MOSTRECENT"
            Begin Extent = 
 ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_DESSA_SCHOOL_FULL_MOSTRECENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'              Top = 330
               Left = 38
               Bottom = 438
               Right = 230
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_SM_MOSTRECENT"
            Begin Extent = 
               Top = 330
               Left = 268
               Bottom = 438
               Right = 460
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "vw_DESSA_SCHOOL_SoA_MOSTRECENT"
            Begin Extent = 
               Top = 438
               Left = 38
               Bottom = 546
               Right = 230
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_DESSA_SCHOOL_FULL_MOSTRECENT'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_DESSA_SCHOOL_FULL_MOSTRECENT'
GO
