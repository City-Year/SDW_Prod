USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[SR_ST_SPMBEH_IntSessions]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SR_ST_SPMBEH_IntSessions](
	[session_dossage] [decimal](18, 0) NULL,
	[session_date] [datetime] NULL,
	[session_id] [varchar](18) NULL,
	[student_name] [varchar](80) NULL,
	[student_ia_beh] [decimal](1, 0) NULL,
	[section_ia] [varchar](255) NULL,
	[program_description] [varchar](80) NULL,
	[session_skills] [varchar](1300) NULL,
	[cy_student_id] [varchar](100) NULL,
	[cych_accnt_sf_id] [varchar](20) NULL,
	[student_school_name] [varchar](1300) NULL,
	[student_sf_id] [varchar](18) NOT NULL,
	[intervention_corps_member] [varchar](80) NULL,
	[intervention_corps_member_id] [varchar](18) NULL,
	[business_Unit] [varchar](1300) NULL
) ON [PRIMARY]

GO
