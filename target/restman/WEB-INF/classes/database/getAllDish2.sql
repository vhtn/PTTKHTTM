CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllDish2`()
BEGIN
    SELECT * FROM tblMenuItem2 WHERE status = 'Còn phục vụ';
END
