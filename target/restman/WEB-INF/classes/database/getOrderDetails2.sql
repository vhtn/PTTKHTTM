CREATE DEFINER=`root`@`localhost` PROCEDURE `getOrderDetails2`(IN orderSlipId INT)
BEGIN
    SELECT od.id, od.quantity, od.price, od.amount, 
           m.id AS m_id, m.name, m.image, m.price AS m_price, 
           m.status AS m_status, m.description 
    FROM tblOrderDetails2 od 
    JOIN tblMenuItem2 m ON od.tblMenuItem2_id = m.id 
    WHERE od.tblOrderSlip2_id = orderSlipId;
END