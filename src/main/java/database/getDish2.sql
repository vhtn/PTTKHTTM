CREATE DEFINER=`root`@`localhost` PROCEDURE `getDish2`(IN keyword VARCHAR(255))
BEGIN
    SELECT * FROM tblMenuItem2 
    WHERE status = 'Còn phục vụ' AND name LIKE CONCAT('%', keyword, '%');
END
