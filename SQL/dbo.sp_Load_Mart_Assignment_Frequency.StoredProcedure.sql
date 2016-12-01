USE [SDW_Prod]
GO
/****** Object:  StoredProcedure [dbo].[sp_Load_Mart_Assignment_Frequency]    Script Date: 12/1/2016 8:51:13 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Load_Mart_Assignment_Frequency]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	update SDW_Prod.dbo.DimAssignment set Frequency = 'N/A' where AssignmentName = 'N/A'

END


GO
