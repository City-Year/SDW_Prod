USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[DimDate]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimDate](
	[DateID] [int] IDENTITY(1,1) NOT NULL,
	[Date] [datetime] NOT NULL,
	[Day] [char](10) NULL,
	[DayOfWeek] [smallint] NULL,
	[DayOfMonth] [smallint] NULL,
	[DayOfYear] [smallint] NULL,
	[PreviousDay] [datetime] NULL,
	[NextDay] [datetime] NULL,
	[WeekOfYear] [smallint] NULL,
	[Month] [char](10) NULL,
	[MonthOfYear] [smallint] NULL,
	[QuarterOfYear] [smallint] NULL,
	[Year] [int] NULL,
	[YearMonth] [varchar](250) NULL,
	[YearMonth_Number] [int] NULL,
	[Week] [varchar](250) NULL,
PRIMARY KEY CLUSTERED 
(
	[DateID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
