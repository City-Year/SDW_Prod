USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[AssessmentDescription]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AssessmentDescription](
	[id_num] [int] IDENTITY(1,1) NOT NULL,
	[assessmentname] [varchar](250) NULL,
	[datatype] [varchar](250) NULL
) ON [INDEX]

GO
