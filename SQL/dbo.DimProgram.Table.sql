USE [SDW_Prod]
GO
/****** Object:  Table [dbo].[DimProgram]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimProgram](
	[ProgramID] [int] IDENTITY(1,1) NOT NULL,
	[Program] [varchar](250) NULL
) ON [PRIMARY]

GO
