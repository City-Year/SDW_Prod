USE [SDW_Prod]
GO
/****** Object:  View [dbo].[vw_DESSA_Composite]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vw_DESSA_Composite]
AS
SELECT     
A.*, C.MAX_ASSESSMENT_ADMINISTRATION_NUMBER, 
CASE WHEN C.MAX_ASSESSMENT_ADMINISTRATION_NUMBER = ASSESSMENT_ADMINISTRATION_NUMBER THEN 1 ELSE NULL 
END AS MOST_RECENT_ADMIN
FROM         
(select g.StudentName Student_Name, d.SchoolName Student_School_Name, f.Date Date_Administered__c, 
ROW_NUMBER() OVER (PARTITION BY studentSF_ID ORDER BY f.Date ASC) AS Assessment_Administration_Number, 
j.SEL_Composite_Description SEL_Composite_Description__c, j.SEL_Composite_T_Score SEL_Composite_T_Score__c, 
j.AssessmentName Assessment_Name,
LAG(cast(j.SEL_Composite_T_Score as decimal(18,3)), 1, NULL) OVER (PARTITION BY g.StudentSF_ID ORDER BY f.Date ASC) AS SEL_Composite_T_Score__MostRecent, cast(j.SEL_Composite_T_Score as decimal(18,3)) - LAG(cast(j.SEL_Composite_T_Score as decimal(18,3)), 1, NULL) 
OVER (PARTITION BY g.StudentSF_ID ORDER BY f.Date ASC) AS SEL_Composite_T_Score_Diff, CASE WHEN cast(j.SEL_Composite_T_Score as decimal(18,3)) - LAG(cast(j.SEL_Composite_T_Score as decimal(18,3)), 1, NULL) OVER (PARTITION BY g.StudentSF_ID
ORDER BY f.Date ASC) >= 4 THEN 1 WHEN cast(j.SEL_Composite_T_Score as decimal(18,3)) - LAG(cast(j.SEL_Composite_T_Score as decimal(18,3)), 1, NULL) OVER (PARTITION BY g.StudentSF_ID
ORDER BY f.Date ASC) >= 1 AND cast(j.SEL_Composite_T_Score as decimal(18,3)) - LAG(cast(j.SEL_Composite_T_Score as decimal(18,3)), 1, NULL) OVER (PARTITION BY g.StudentSF_ID
ORDER BY f.Date ASC) <= 3 THEN 2 WHEN cast(j.SEL_Composite_T_Score as decimal(18,3)) - LAG(cast(j.SEL_Composite_T_Score as decimal(18,3)), 1, NULL) OVER (PARTITION BY g.StudentSF_ID
ORDER BY f.Date ASC) = 0 THEN 3 WHEN cast(j.SEL_Composite_T_Score as decimal(18,3)) - LAG(cast(j.SEL_Composite_T_Score as decimal(18,3)), 1, NULL) OVER (PARTITION BY g.StudentSF_ID
ORDER BY f.Date ASC) <= - 1 AND cast(j.SEL_Composite_T_Score as decimal(18,3)) - LAG(cast(j.SEL_Composite_T_Score as decimal(18,3)), 1, NULL) OVER (PARTITION BY g.StudentSF_ID
ORDER BY f.Date ASC) >= - 3 THEN 4 WHEN cast(j.SEL_Composite_T_Score as decimal(18,3)) - LAG(cast(j.SEL_Composite_T_Score as decimal(18,3)), 1, NULL) OVER (PARTITION BY g.StudentSF_ID
ORDER BY f.Date ASC) <= - 4 THEN 5 ELSE NULL END AS Score_Diff_Category,
g.StudentSF_ID STUDENT_SF_ID, d.cych_SF_ID cych_Accnt_SF_ID
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
where j.AssessmentName ='DESSA') A JOIN
(SELECT     
MAX(Assessment_Administration_Number) AS MAX_ASSESSMENT_ADMINISTRATION_NUMBER, 
STUDENT_SF_ID
FROM          
(select
g.StudentSF_ID STUDENT_SF_ID, d.cych_SF_ID cych_Accnt_SF_ID,
ROW_NUMBER() OVER (PARTITION BY g.StudentSF_ID ORDER BY f.Date ASC) AS Assessment_Administration_Number
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
where j.AssessmentName ='DESSA') B
 GROUP BY STUDENT_SF_ID) C 
ON A.STUDENT_SF_ID = C.STUDENT_SF_ID


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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_DESSA_Composite'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vw_DESSA_Composite'
GO
