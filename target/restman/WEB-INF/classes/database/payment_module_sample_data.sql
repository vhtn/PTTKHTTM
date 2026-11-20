USE restman;

-- Tạm thời tắt kiểm tra khóa ngoại
SET FOREIGN_KEY_CHECKS = 0;

-- Xóa chi tiết món ăn thuộc hóa đơn thử nghiệm
DELETE d
FROM tblOrderDetails2 d
JOIN tblOrderSlip2 o
    ON d.tblOrderSlip2_id = o.id
JOIN tblTable2 t
    ON o.tblTable2_id = t.id
WHERE t.number IN (
    'TT-PAY-01',
    'TT-PAY-02',
    'TT-PAY-03',
    'TT-PAY-04',
    'TT-PAY-05',
    'B01', 'B02', 'B03', 'B04', 'B05'
)
AND o.date BETWEEN '2026-11-20 14:00:01'
                AND '2026-11-20 14:00:05';

-- Xóa hóa đơn thử nghiệm
DELETE o
FROM tblOrderSlip2 o
JOIN tblTable2 t
    ON o.tblTable2_id = t.id
WHERE t.number IN (
    'TT-PAY-01',
    'TT-PAY-02',
    'TT-PAY-03',
    'TT-PAY-04',
    'TT-PAY-05',
    'B01', 'B02', 'B03', 'B04', 'B05'
)
AND o.date BETWEEN '2026-11-20 14:00:01'
                AND '2026-11-20 14:00:05';

-- Xóa thẻ thành viên thử nghiệm
DELETE FROM tblMembershipCard2
WHERE code IN (
    'PAY-TEST-DONG',
    'PAY-TEST-BAC',
    'PAY-TEST-VANG',
    'PAY-TEST-CHUA-HANG'
);

-- Xóa khách hàng thử nghiệm
DELETE FROM tblCustomer2
WHERE phone IN (
    '0987654301',
    '0987654302',
    '0987654303',
    '0987654304'
);

-- Xóa bàn thử nghiệm
DELETE FROM tblTable2
WHERE number IN (
    'TT-PAY-01',
    'TT-PAY-02',
    'TT-PAY-03',
    'TT-PAY-04',
    'TT-PAY-05',
    'B01', 'B02', 'B03', 'B04', 'B05'
);

-- Bật lại kiểm tra khóa ngoại
SET FOREIGN_KEY_CHECKS = 1;