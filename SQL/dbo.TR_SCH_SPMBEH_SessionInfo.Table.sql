USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[TR_SCH_SPMBEH_SessionInfo]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TR_SCH_SPMBEH_SessionInfo](
	[program_description] [varchar](80) NULL,
	[cych_accnt_sf_id] [varchar](20) NULL,
	[INTERVENTION_CORPS_MEMBER] [varchar](80) NULL,
	[INTERVENTION_CORPS_MEMBER_ID] [varchar](18) NULL,
	[TOTALSTUDENTS] [int] NULL,
	[TOTALSESSIONS6WK] [int] NULL,
	[TOTALSTUDENTS6WK] [int] NULL,
	[AVGSessionDosage6wks] [decimal](38, 6) NULL,
	[STUDENTSPERSESSION6wks] [int] NULL,
	[EXPECTED_SESSIONS] [int] NULL
) ON [PRIMARY]

GO
