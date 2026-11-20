ALTER TABLE tblMembershipCard2
    MODIFY rank_level ENUM('Chưa có', 'Vàng', 'Bạc', 'Đồng') NOT NULL DEFAULT 'Chưa có';

UPDATE tblMembershipCard2
SET rank_level = CASE
    WHEN COALESCE(point, 0) >= 1000 THEN 'Vàng'
    WHEN COALESCE(point, 0) >= 500 THEN 'Bạc'
    WHEN COALESCE(point, 0) >= 100 THEN 'Đồng'
    ELSE 'Chưa có'
END;
