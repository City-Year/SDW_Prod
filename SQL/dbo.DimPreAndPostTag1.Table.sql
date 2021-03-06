USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[DimPreAndPostTag1]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimPreAndPostTag1](
	[StudentID] [int] NULL,
	[IndicatorArea] [varchar](50) NULL,
	[GradeType] [varchar](50) NULL,
	[EnrollmentDate] [date] NULL,
	[PriorYearMostRecent] [date] NULL,
	[PYMRValue] [varchar](50) NULL,
	[PriorYearMostRecent_QTR] [varchar](50) NULL,
	[CurrentYearFirst] [varchar](50) NULL,
	[CYFirstValue] [varchar](50) NULL,
	[CurrentYearFirst_QTR] [varchar](50) NULL,
	[CurrentYearLast] [date] NULL,
	[CYLValue] [varchar](50) NULL,
	[CurrentYearLast_QTR] [varchar](50) NULL,
	[ClosestDateToEnrollment] [date] NULL,
	[ClosestDateToEnrollmentValue] [varchar](50) NULL,
	[ClosestDateToEnrollment_QTR] [varchar](50) NULL,
	[ClosestDateToExitDate] [date] NULL,
	[ClosestDateToExitDateValue] [varchar](50) NULL,
	[ClosestDateToExitDate_QTR] [varchar](50) NULL,
	[MostRecentDate] [date] NULL,
	[MostRecentValue] [varchar](50) NULL,
	[MostRecentDate_QTR] [varchar](50) NULL,
	[Last_Update_Date] [datetime] NULL
) ON [PRIMARY]

GO
