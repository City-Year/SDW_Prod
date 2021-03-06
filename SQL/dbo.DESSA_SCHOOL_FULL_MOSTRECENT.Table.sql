USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[DESSA_SCHOOL_FULL_MOSTRECENT]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DESSA_SCHOOL_FULL_MOSTRECENT](
	[cych_Accnt_SF_ID] [varchar](250) NULL,
	[Student_School_Name] [varchar](255) NOT NULL,
	[COMP_PLUS4] [int] NULL,
	[COMP_PLUS1TO3] [int] NULL,
	[COMP_NOCHANGE] [int] NULL,
	[COMP_MINUS1TO3] [int] NULL,
	[COMP_MINUS4] [int] NULL,
	[DM_PLUS4] [int] NULL,
	[DM_PLUS1TO3] [int] NULL,
	[DM_NOCHANGE] [int] NULL,
	[DM_MINUS1TO3] [int] NULL,
	[DM_MINUS4] [int] NULL,
	[GDB_PLUS4] [int] NULL,
	[GDB_PLUS1TO3] [int] NULL,
	[GDB_NOCHANGE] [int] NULL,
	[GDB_MINUS1TO3] [int] NULL,
	[GDB_MINUS4] [int] NULL,
	[OT_PLUS4] [int] NULL,
	[OT_PLUS1TO3] [int] NULL,
	[OT_NOCHANGE] [int] NULL,
	[OT_MINUS1TO3] [int] NULL,
	[OT_MINUS4] [int] NULL,
	[PR_PLUS4] [int] NULL,
	[PR_PLUS1TO3] [int] NULL,
	[PR_NOCHANGE] [int] NULL,
	[PR_MINUS1TO3] [int] NULL,
	[PR_MINUS4] [int] NULL,
	[RS_PLUS4] [int] NULL,
	[RS_PLUS1TO3] [int] NULL,
	[RS_NOCHANGE] [int] NULL,
	[RS_MINUS1TO3] [int] NULL,
	[RS_MINUS4] [int] NULL,
	[SA_PLUS4] [int] NULL,
	[SA_PLUS1TO3] [int] NULL,
	[SA_NOCHANGE] [int] NULL,
	[SA_MINUS1TO3] [int] NULL,
	[SA_MINUS4] [int] NULL,
	[SM_PLUS4] [int] NULL,
	[SM_PLUS1TO3] [int] NULL,
	[SM_NOCHANGE] [int] NULL,
	[SM_MINUS1TO3] [int] NULL,
	[SM_MINUS4] [int] NULL,
	[SoA_PLUS4] [int] NULL,
	[SoA_PLUS1TO3] [int] NULL,
	[SoA_NOCHANGE] [int] NULL,
	[SoA_MINUS1TO3] [int] NULL,
	[SoA_MINUS4] [int] NULL
) ON [PRIMARY]

GO
