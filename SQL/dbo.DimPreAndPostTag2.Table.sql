USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[DimPreAndPostTag2]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimPreAndPostTag2](
	[StudentID] [int] NULL,
	[IndicatorArea] [varchar](50) NULL,
	[GradeType] [varchar](100) NULL,
	[FactType] [varchar](50) NULL,
	[National_BenchMark] [varchar](50) NULL,
	[local_BenchMark] [varchar](50) NULL,
	[EnrollmentDate] [date] NULL,
	[PriorYearMostRecent] [date] NULL,
	[PYMRValue] [varchar](50) NULL,
	[PriorYearMostRecent_QTR] [varchar](50) NULL,
	[CurrentYearEarliest] [varchar](50) NULL,
	[CYFirstValue] [varchar](50) NULL,
	[CurrentYearFirst_QTR] [varchar](50) NULL,
	[Mid_Year_Proxy] [varchar](50) NULL,
	[CurrentYearMostRecent] [date] NULL,
	[CYLValue] [varchar](50) NULL,
	[CurrentYearLast_QTR] [varchar](50) NULL,
	[CurrentYearClosestToEnrollment] [date] NULL,
	[ClosestDateToEnrollmentValue] [varchar](50) NULL,
	[ClosestDateToEnrollment_QTR] [varchar](50) NULL,
	[CurrentYearClosestToExit] [date] NULL,
	[ClosestDateToExitDateValue] [varchar](50) NULL,
	[ClosestDateToExitDate_QTR] [varchar](50) NULL,
	[Last_Update_Date] [datetime] NULL,
	[CYSCHOOLHOUSE_ID] [varchar](250) NULL
) ON [PRIMARY]

GO
