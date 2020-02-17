alter FUNCTION fHelpdeskResourceCSV
(
      @Helpdeskid uniqueidentifier
)
RETURNS nvarchar(4000)
AS
BEGIN
	declare @username nvarchar(4000)

	Select @username = null

	SELECT @username = Coalesce(@username + ', ', '') +
		userprofile.username
	from 
		HELPDESK with (nolock)
		INNER JOIN HELPDESK_RESOURCE with (nolock) ON HELPDESK.HELPDESKID=HELPDESK_RESOURCE.HELPDESKID
		INNER JOIN USERPROFILE with (nolock) ON HELPdesk_RESOURCE.USERID=USERPROFILE.USERID
	where 
		helpdesk.helpdeskid=@Helpdeskid
	 
	RETURN @username
end