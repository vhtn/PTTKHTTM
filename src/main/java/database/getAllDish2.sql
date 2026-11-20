CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllDish2`()
BEGIN
    SELECT * FROM tblMenuItem2 WHERE status IN ('Còn phục vụ', 'Tạm hết');
END
