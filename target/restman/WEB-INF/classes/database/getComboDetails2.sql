CREATE DEFINER=`root`@`localhost` PROCEDURE `getComboDetails2`(IN comboId INT)
BEGIN
    SELECT cd.id AS detailId, cd.quantity, 
           cd.price AS detailPrice, cd.amount AS detailAmount, 
           d.size, d.unit, d.category, 
           mi.id AS id, mi.name, mi.image, mi.price, mi.status, mi.description 
    FROM tblComboDetails2 cd 
    JOIN tblDish2 d ON d.tblMenuItem2_id = cd.tblDish2_id 
    JOIN tblMenuItem2 mi ON mi.id = d.tblMenuItem2_id 
    WHERE cd.tblCombo2_id = comboId ORDER BY cd.id;
END