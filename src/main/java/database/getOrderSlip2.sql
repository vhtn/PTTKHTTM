CREATE DEFINER=`root`@`localhost` PROCEDURE `getOrderSlip2`(IN tableId INT)
BEGIN
    SELECT o.*, t.id AS tableId, t.number AS tableNumber, 
           t.capacity AS tableCapacity, t.status AS tableStatus, t.location AS tableLocation 
    FROM tblOrderSlip2 o 
    JOIN tblTable2 t ON t.id = o.tblTable2_id 
    WHERE o.tblTable2_id = tableId AND o.status = 'Đang sử dụng';
END

