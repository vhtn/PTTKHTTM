CREATE DEFINER=`root`@`localhost` PROCEDURE `searchTableByNumber2`(IN tableNumber VARCHAR(50))
BEGIN
    SELECT t.id, t.number, t.capacity, 'Đang sử dụng' AS status, t.location 
    FROM tblTable2 t 
    WHERE t.number LIKE CONCAT('%', tableNumber, '%') 
      AND EXISTS (SELECT 1 FROM tblOrderSlip2 o 
                  WHERE o.tblTable2_id = t.id AND o.status = 'Đang sử dụng');
END