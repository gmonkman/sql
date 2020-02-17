/* Just do a replace on <TABLE>. Assumes date col is called date_modified */
CREATE TRIGGER trg_<TABLE>_date_modified
ON dbo.<table>
AFTER UPDATE
AS
    UPDATE dbo.<TABLE>
    SET date_modified = GETDATE()
    WHERE <TABLE>ID IN (SELECT DISTINCT <TABLE>ID FROM Inserted)