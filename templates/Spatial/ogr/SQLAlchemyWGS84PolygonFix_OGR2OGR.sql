
/*
FOR WGS84 POLYGONS - THIS IS BECAUSE OF THE SPATIAL INDEX CREATION

This SQL creates a new table which just holds a geometry/geography feature.
This is a workaround for the current lack of support for MSSQL geometry/geography features in SQLAlchemy

sqlcodeagen can then be run, excludeing the tables wth geom/geog field types



Replace <CHILD> with the name of the new table which holds the geometry/geography features
Replace <PARENT> with the name of the table which has the the geometry/geography features
*/


USE [gazetteer]
GO

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


CREATE TABLE [dbo].[<CHILD>](
	[ogr_fid] [int] NOT NULL,
	[geog] [geography] NOT NULL,
 CONSTRAINT [PK_<CHILD>] PRIMARY KEY CLUSTERED 
(
	[ogr_fid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO

ALTER TABLE [dbo].[<CHILD>]  WITH CHECK ADD CONSTRAINT [FK_<PARENT>_<CHILD>] FOREIGN KEY([ogr_fid])
REFERENCES [dbo].[<CHILD>] ([ogr_fid])
GO

insert into <CHILD> select <PARENT>.ogr_fid, <PARENT>.geog from <PARENT>
go

drop index ogr_dbo_<CHILD>_sidx on <PARENT>
go

alter table <PARENT> drop column geog
go


CREATE SPATIAL INDEX [SPATIAL_<CHILD>] ON [dbo].[<CHILD>]
(
	[geog]
) USING  GEOGRAPHY_AUTO_GRID 
WITH (
CELLS_PER_OBJECT = 16, PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]


update geometry_columns set f_table_name='<CHILD>' where f_table_name='<PARENT>'

