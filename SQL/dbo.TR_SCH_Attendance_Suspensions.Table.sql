USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[TR_SCH_Attendance_Suspensions]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TR_SCH_Attendance_Suspensions](
	[CYCH_ACCNT_SF_ID] [varchar](20) NULL,
	[QUARTER] [varchar](250) NULL,
	[AVG_AVERAGE_DAILY_ATTENDANCE] [decimal](38, 6) NULL,
	[PERC_SUSPENSION] [numeric](24, 12) NULL,
	[PERC_DETENTION] [numeric](24, 12) NULL,
	[PERC_OFFICEREFERRAL] [numeric](24, 12) NULL
) ON [PRIMARY]

GO
