CREATE DEFINER=`root`@`localhost` PROCEDURE `getDishDetail2`(IN itemId INT)
BEGIN
    SELECT mi.*, d.tblMenuItem2_id AS dishId, d.size AS dishSize, 
           d.unit AS dishUnit, d.category AS dishCategory, 
           c.tblMenuItem2_id AS comboId, c.portion AS comboPortion, 
           c.startDate AS comboStartDate, c.endDate AS comboEndDate 
    FROM tblMenuItem2 mi 
    LEFT JOIN tblDish2 d ON d.tblMenuItem2_id = mi.id 
    LEFT JOIN tblCombo2 c ON c.tblMenuItem2_id = mi.id 
    WHERE mi.id = itemId AND mi.status = 'Còn phục vụ';
END

