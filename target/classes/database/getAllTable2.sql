CREATE DEFINER=`root`@`localhost` PROCEDURE `getAllTable2`()
BEGIN
    SELECT t.id, t.number, t.capacity, 'Đang sử dụng' AS status, t.location 
    FROM tblTable2 t 
    WHERE EXISTS (SELECT 1 FROM tblOrderSlip2 o 
                  WHERE o.tblTable2_id = t.id AND o.status = 'Đang sử dụng');
END
