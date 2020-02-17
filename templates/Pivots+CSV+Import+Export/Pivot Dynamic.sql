
USE [salt]
GO

/*
/****** Object:  Table [dbo].[test]    Script Date: 22/11/2015 12:25:53 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[test](
	[folder] [nvarchar](50) NULL,
	[k] [nvarchar](50) NULL,
	[value] [nvarchar](50) NULL
) ON [PRIMARY]

GO
INSERT [dbo].[test] ([folder], [k], [value]) VALUES (N'root', N'size', N'100')
GO
INSERT [dbo].[test] ([folder], [k], [value]) VALUES (N'root', N'type', N'movie')
GO
INSERT [dbo].[test] ([folder], [k], [value]) VALUES (N'root', N'who', N'graham')
GO
INSERT [dbo].[test] ([folder], [k], [value]) VALUES (N'root', N'size', N'200')
GO
INSERT [dbo].[test] ([folder], [k], [value]) VALUES (N'root', N'who', N'me')
GO
INSERT [dbo].[test] ([folder], [k], [value]) VALUES (N'home', N'size', N'100')
GO
INSERT [dbo].[test] ([folder], [k], [value]) VALUES (N'home', N'modifieddate', N'1/1/2010')
GO
INSERT [dbo].[test] ([folder], [k], [value]) VALUES (N'appdata', N'modifieddate', N'1/1/2015')
GO
INSERT [dbo].[test] ([folder], [k], [value]) VALUES (N'home', N'accesstime', N'12:15')
GO
INSERT [dbo].[test] ([folder], [k], [value]) VALUES (N'onedrive', N'accesstime', N'12:45')
GO

*/

DECLARE @cols AS NVARCHAR(MAX),
    @query  AS NVARCHAR(MAX);

SET @cols =  STUFF((SELECT distinct ',' + QUOTENAME(k) 
            FROM [test]
            FOR XML PATH(''), TYPE
            ).value('.', 'NVARCHAR(MAX)') 
        ,1,1,'')

--select @cols

set @query =
' select ' +
	' folder, ' + @cols +
' from ' +
	' (select * from test) as source' +
	' PIVOT' +
	' (' +
		' max(value)' + --the name of the column that contains the values you want for the colummn of interest
		' for k in (' +  @cols + ')' + --k is the field which contains the column data names which become the row header
	' ) as pivottable'

--select @query

execute(@query)