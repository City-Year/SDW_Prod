USE [SDW_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_Mart_Assessment_Indicator_Area]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO





-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE  PROCEDURE [dbo].[sp_Load_Mart_Assessment_Indicator_Area]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Behavior' where AssessmentName = '50 Acts of Greatness - Behavior'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Behavior' where AssessmentName = '50 Acts of Leadership - Behavior'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'Achieve 3000 - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'AIMSweb - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'AIMSweb - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'Amplify - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'ANet - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'ANet - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Attendance' where AssessmentName = 'Attendance Check In Check Out - Attendance'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'BPS Predictive - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'BPS Predictive - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Behavior' where AssessmentName = 'DESSA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Behavior' where AssessmentName = 'DESSA-mini'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'DIBELS - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'District Benchmark Assessments - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'District Benchmark Assessments - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'DRA - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'EADMS - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'EADMS - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'EasyCBM - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'EasyCBM - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'Explore - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'Explore - Reading - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'Florida State Assessment Algebra 1 - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'Florida State Assessment English Language Arts - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'Florida State Assessment Mathematics - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'Fountas and Pinnell Benchmark Assessment System - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'iReady - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'iReady - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'IRLA - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'iStation Indicators of Progress - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'Jerry Johns BRI - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'Lexia - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'NWEA - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'NWEA - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'Scantron - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'Scantron - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Behavior' where AssessmentName = 'SEL Check In Check Out - Behavior'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'SMI: Scholastic Math Inventory - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'SRI: Scholastic Reading Inventory - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Math' where AssessmentName = 'STAR Math - Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'STAR Reading - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Attendance' where AssessmentName = 'Time Based Attendance Tracker - Attendance'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'Behavior' where AssessmentName = 'Time Based Behavior Tracker - Behavior'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'TRC - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area = 'ELA' where AssessmentName = 'Wonders (McGraw Hill Readers) and Accelerated Reader - ELA'

	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='Attendance' where AssessmentName =  'Reporting Period Time Based Attendance Tracker - Attendance'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='Attendance' where AssessmentName =  'Cumulative Time Based Attendance Tracker - Attendance'
	
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='Behavior'where AssessmentName =   'Reporting Period Time Based Behavior Tracker - Behavior'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='Behavior'where AssessmentName =   'Cumulative Time Based Behavior Tracker - Behavior'

	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='Attendance' where AssessmentName = 'Reporting Period ADA Tracker - Attendance'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='Attendance' where AssessmentName = 'Cumulative ADA Tracker - Attendance'


	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='ELA' where AssessmentName = 'Florida Assessments for Instruction in Reading - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='MATH' where AssessmentName = 'Compass Learning -  Math'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='ELA' where AssessmentName = 'Degrees of Reading Power - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='ELA' where AssessmentName = 'Smarter Balanced Assessment Consortium - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='MATH' where AssessmentName = 'Smarter Balanced Assessment Consortium - MATH'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='ELA' where AssessmentName = 'ACT Aspire - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='MATH' where AssessmentName = 'ACT Aspire - MATH'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='MATH' where AssessmentName = 'Agile Minds - MATH'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='ELA' where AssessmentName = 'ANet - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='MATH' where AssessmentName = 'ANet - MATH'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='ELA' where AssessmentName = 'DC District Unit Test - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='MATH' where AssessmentName = 'DC District Unit Test - MATH'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='MATH' where AssessmentName = 'Manchester School District Computation Assessment - MATH'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='ELA' where AssessmentName = 'Teachers College Reading Assessment - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='ELA' where AssessmentName = 'Wonders (McGraw Hill Readers)and Accelerated Reader - ELA'
	
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='ELA' where AssessmentName = 'Orlando Common Numeric Assessment - ELA'
	update SDW_Prod.dbo.DimAssessment set Indicator_Area ='MATH' where AssessmentName = 'Orlando Common Numeric Assessment - MATH'

	
	
END








GO
