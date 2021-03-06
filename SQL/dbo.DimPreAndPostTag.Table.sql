USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[DimPreAndPostTag]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimPreAndPostTag](
	[StudentID] [int] NULL,
	[IndicatorArea] [varchar](50) NULL,
	[GradeType] [varchar](100) NULL,
	[DataType] [varchar](100) NULL,
	[FactType] [varchar](50) NULL,
	[School_EnrollmentDate] [date] NULL,
	[PrYr_MostRecent_Date] [date] NULL,
	[PrYr_MostRecent_Value] [varchar](50) NULL,
	[PrYr_MostRecent_Interval] [varchar](50) NULL,
	[First_MPEarliest_Date] [varchar](50) NULL,
	[First_MPEarliest_Value] [varchar](50) NULL,
	[First_MPEarliest_Interval] [varchar](50) NULL,
	[CYr_Earliest_Date] [varchar](50) NULL,
	[CYr_Earliest_Value] [varchar](50) NULL,
	[CYr_Earliest_Interval] [varchar](50) NULL,
	[MY_Proxy_Date] [varchar](50) NULL,
	[MY_Proxy_Value] [varchar](50) NULL,
	[MY_Proxy_Interval] [varchar](50) NULL,
	[CYr_MostRecent_Date] [date] NULL,
	[CYr_MostRecent_Value] [varchar](50) NULL,
	[CYr_MostRecent_Interval] [varchar](50) NULL,
	[IntStartEnroll_Earliest_Proxy_Date] [date] NULL,
	[IntStartEnroll_Earliest_Proxy_Value] [varchar](50) NULL,
	[IntStartEnroll_Earliest_Proxy_Interval] [varchar](50) NULL,
	[IntEndExit_Latest_Proxy_Date] [date] NULL,
	[IntEndExit_Latest_Proxy_Value] [varchar](50) NULL,
	[IntEndExit_Latest_Proxy_Interval] [varchar](50) NULL,
	[Final_MPLatest_Date] [date] NULL,
	[Final_MPLatest_Value] [varchar](50) NULL,
	[Final_MPLatest_Interval] [varchar](50) NULL,
	[Last_Update_Date] [datetime] NULL,
	[CYSCHOOLHOUSE_ID] [varchar](250) NULL
) ON [INDEX]

GO
