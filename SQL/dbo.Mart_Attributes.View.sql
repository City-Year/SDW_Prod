USE [SDW_Prod]
GO
/****** Object:  View [dbo].[Mart_Attributes]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[Mart_Attributes]
AS
SELECT     dbo.DimAssignment.AssignmentName, dbo.DimAssignment.AssignmentSubject, dbo.DimAssignment.AssignmentType, dbo.DimAssignment.SectionName, 
                      dbo.DimAssignment.ProgramDescription, dbo.DimAssessment.AssessmentName, dbo.DimCorpsMember.CorpsMember_Name, dbo.DimDate.Date, 
                      dbo.DimGrade.SchoolYear, dbo.DimGrade.MarkingPeriod, dbo.DimIndicatorArea.IndicatorArea, dbo.DimIndicatorArea.SessionSkill, dbo.DimSchool.SchoolName, 
                      dbo.DimSchool.Business_Unit, dbo.DimSchool.Region, dbo.DimSchool.District, dbo.DimSchool.Team, dbo.DimSchool.TeamDescription, 
                      dbo.DimSchool.Number_Of_Teams, dbo.DimSchool.CYSch_SF_ID, dbo.DimSchool.CYCh_SF_ID, dbo.DimSchool.CYCh_Account_#, dbo.DimSchool.Diplomas_Now, 
                      dbo.DimStudent.CY_StudentID, dbo.DimStudent.StudentDistrictID, dbo.DimStudent.StudentSF_ID, dbo.DimStudent.StudentName, dbo.DimStudent.StudentFirst_Name, 
                      dbo.DimStudent.StudentLast_Name, dbo.DimStudent.DateOfBirth, dbo.DimStudent.Gender, dbo.DimStudent.StudentName_Display, dbo.DimStudent.Enrollment_Date, 
                      dbo.DimStudent.Enrollment_End_Date, dbo.DimStudent.Attendance_IA, dbo.DimStudent.Behavior_IA, dbo.DimStudent.ELA_IA, dbo.DimStudent.Math_IA, 
                      dbo.DimStudent.Grade, dbo.DimFactType.FactType, dbo.FactAll.Assignment_Entered_Grade, dbo.FactAll.Assignment_Grade_Number, 
                      dbo.FactAll.Assignment_Weighted_Grade_Value, dbo.FactAll.Session_Dosage, dbo.DimAssessment.Days_Enrolled, dbo.DimAssessment.Local_Benchmark, 
                      dbo.DimAssessment.Lexile_Score, dbo.DimAssessment.Number_of_Detentions, dbo.DimAssessment.Number_of_Excused_Absences, 
                      dbo.DimAssessment.Number_of_In_School_Suspensions, dbo.DimAssessment.Number_of_Office_Referrals, 
                      dbo.DimAssessment.Number_of_Out_of_School_Suspensions, dbo.DimAssessment.Number_of_Suspensions, dbo.DimAssessment.Number_of_Tardies, 
                      dbo.DimAssessment.Number_of_Unexcused_Absences, dbo.DimAssessment.ADA
FROM         dbo.FactAll INNER JOIN
                      dbo.DimAssignment ON dbo.FactAll.AssignmentID = dbo.DimAssignment.AssignmentID INNER JOIN
                      dbo.DimAssessment ON dbo.FactAll.AssessmentID = dbo.DimAssessment.AssessmentID INNER JOIN
                      dbo.DimCorpsMember ON dbo.FactAll.CorpsMemberID = dbo.DimCorpsMember.CorpsMemberID INNER JOIN
                      dbo.DimDate ON dbo.FactAll.DateID = dbo.DimDate.DateID INNER JOIN
                      dbo.DimGrade ON dbo.FactAll.GradeID = dbo.DimGrade.GradeID INNER JOIN
                      dbo.DimIndicatorArea ON dbo.FactAll.IndicatorAreaID = dbo.DimIndicatorArea.IndicatorAreaID INNER JOIN
                      dbo.DimSchool ON dbo.FactAll.SchoolID = dbo.DimSchool.SchoolID INNER JOIN
                      dbo.DimStudent ON dbo.FactAll.StudentID = dbo.DimStudent.StudentID INNER JOIN
                      dbo.DimFactType ON dbo.FactAll.FactTypeID = dbo.DimFactType.FactTypeID


GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[25] 4[45] 2[11] 3) )"
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
         Top = -192
         Left = 0
      End
      Begin Tables = 
         Begin Table = "FactAll"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 114
               Right = 292
            End
            DisplayFlags = 280
            TopColumn = 11
         End
         Begin Table = "DimAssignment"
            Begin Extent = 
               Top = 6
               Left = 330
               Bottom = 114
               Right = 501
            End
            DisplayFlags = 280
            TopColumn = 2
         End
         Begin Table = "DimAssessment"
            Begin Extent = 
               Top = 114
               Left = 38
               Bottom = 270
               Right = 313
            End
            DisplayFlags = 280
            TopColumn = 32
         End
         Begin Table = "DimCorpsMember"
            Begin Extent = 
               Top = 6
               Left = 539
               Bottom = 84
               Right = 718
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DimDate"
            Begin Extent = 
               Top = 84
               Left = 539
               Bottom = 192
               Right = 714
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DimGrade"
            Begin Extent = 
               Top = 114
               Left = 351
               Bottom = 207
               Right = 502
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DimIndicatorArea"
            Begin Extent = 
               Top = 6
               Left = 756
               Bottom = 99
               Right = 913
            End
   ' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Mart_Attributes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane2', @value=N'         DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "DimSchool"
            Begin Extent = 
               Top = 102
               Left = 752
               Bottom = 247
               Right = 924
            End
            DisplayFlags = 280
            TopColumn = 6
         End
         Begin Table = "DimStudent"
            Begin Extent = 
               Top = 192
               Left = 540
               Bottom = 350
               Right = 725
            End
            DisplayFlags = 280
            TopColumn = 10
         End
         Begin Table = "DimFactType"
            Begin Extent = 
               Top = 174
               Left = 338
               Bottom = 252
               Right = 489
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
      Begin ColumnWidths = 23
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Mart_Attributes'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=2 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Mart_Attributes'
GO
