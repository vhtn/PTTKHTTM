CREATE DEFINER=`root`@`localhost` PROCEDURE `checkLogin`(IN usr VARCHAR(50), IN pwd VARCHAR(255))
BEGIN
SELECT * FROM tblStaff2
WHERE username = usr AND password = pwd;
END