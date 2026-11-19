CREATE DEFINER=`root`@`localhost` PROCEDURE `getCardByCode2`(IN cardCode VARCHAR(50))
BEGIN
    SELECT c.*, customer.id AS customerId, customer.name, customer.phone
    FROM tblMembershipCard2 c 
    JOIN tblCustomer2 customer ON customer.id = c.tblCustomer2_id
    WHERE c.code = cardCode AND c.status = 'Hoạt động';
END