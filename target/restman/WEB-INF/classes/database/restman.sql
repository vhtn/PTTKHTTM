DROP DATABASE IF EXISTS restman;
CREATE DATABASE IF NOT EXISTS restman DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE restman;

-- --------------------------------------------------------
-- 1. Quản lý khách hàng và nhân viên
-- --------------------------------------------------------
CREATE TABLE tblCustomer2 (
                              id INT AUTO_INCREMENT PRIMARY KEY,
                              name VARCHAR(255) NOT NULL,
                              phone VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE tblStaff2 (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           name VARCHAR(255) NOT NULL,
                           username VARCHAR(50) NOT NULL UNIQUE,
                           password VARCHAR(255) NOT NULL,
                           birthday DATE,
                           address VARCHAR(255),
                           email VARCHAR(100) NOT NULL UNIQUE,
                           phone VARCHAR(10) NOT NULL UNIQUE,
                           position ENUM('SalesStaff', 'Manager', 'WarehouseStaff') NOT NULL,
                           note VARCHAR(255)
);

-- --------------------------------------------------------
-- 2. Thẻ thành viên (MembershipCard2)
-- --------------------------------------------------------
CREATE TABLE tblMembershipCard2 (
                                    id INT AUTO_INCREMENT PRIMARY KEY,
                                    code VARCHAR(50) NOT NULL UNIQUE,
                                    date DATE NOT NULL,
                                    status ENUM('Hoạt động', 'Khoá') NOT NULL,
                                    rank_level ENUM('Vàng', 'Bạc', 'Đồng') NOT NULL,
                                    point INT DEFAULT 0,
                                    tblCustomer2_id INT NOT NULL UNIQUE,
                                    tblSalesStaff2_id INT NOT NULL,
                                    FOREIGN KEY (tblCustomer2_id) REFERENCES tblCustomer2(id),
                                    FOREIGN KEY (tblSalesStaff2_id) REFERENCES tblStaff2(id)
);

-- --------------------------------------------------------
-- 3. Bàn ăn & Đặt bàn (Table2, ReservationSlip2)
-- --------------------------------------------------------
CREATE TABLE tblTable2 (
                           id INT AUTO_INCREMENT PRIMARY KEY,
                           number VARCHAR(10) NOT NULL,
                           capacity INT NOT NULL,
                           status ENUM('Trống', 'Đang sử dụng', 'Đã đặt') NOT NULL,
                           location VARCHAR(100) NOT NULL
);

CREATE TABLE tblReservationSlip2 (
                                     id INT AUTO_INCREMENT PRIMARY KEY,
                                     guestCount INT NOT NULL,
                                     bookingDate TIMESTAMP NOT NULL,
                                     status ENUM('Đã xác nhận', 'Chờ xác nhận', 'Đã huỷ') NOT NULL,
                                     tblCustomer2_id INT NOT NULL,
                                     tblTable2_id INT NOT NULL,
                                     tblSalesStaff2_id INT NOT NULL,
                                     FOREIGN KEY (tblCustomer2_id) REFERENCES tblCustomer2(id),
                                     FOREIGN KEY (tblTable2_id) REFERENCES tblTable2(id),
                                     FOREIGN KEY (tblSalesStaff2_id) REFERENCES tblStaff2(id)
);

-- --------------------------------------------------------
-- 4. Thực đơn & Món ăn (MenuItem, Dish, Combo, ComboDetails)
-- --------------------------------------------------------
CREATE TABLE tblMenuItem2 (
                              id INT AUTO_INCREMENT PRIMARY KEY,
                              name VARCHAR(255) NOT NULL,
                              image VARCHAR(255),
                              price DECIMAL(12, 2) NOT NULL,
                              status ENUM('Tạm hết', 'Ngừng phục vụ', 'Còn phục vụ') NOT NULL,
                              description VARCHAR(255)
);

CREATE TABLE tblDish2 (
                          tblMenuItem2_id INT PRIMARY KEY,
                          size VARCHAR(50) NOT NULL ,
                          unit VARCHAR(255) NOT NULL ,
                          category ENUM('Khai vị', 'Món chính', 'Tráng miệng', 'Đồ uống') NOT NULL ,
                          FOREIGN KEY (tblMenuItem2_id) REFERENCES tblMenuItem2(id) ON DELETE CASCADE
);

CREATE TABLE tblCombo2 (
                           tblMenuItem2_id INT PRIMARY KEY,
                           portion VARCHAR(255) NOT NULL,
                           startDate DATE,
                           endDate DATE,
                           FOREIGN KEY (tblMenuItem2_id) REFERENCES tblMenuItem2(id) ON DELETE CASCADE
);

CREATE TABLE tblComboDetails2 (
                                  id INT AUTO_INCREMENT PRIMARY KEY,
                                  quantity INT NOT NULL,
                                  price DECIMAL(12, 2) NOT NULL,
                                  amount DECIMAL(12, 2) NOT NULL,
                                  tblCombo2_id INT NOT NULL,
                                  tblDish2_id INT NOT NULL,
                                  FOREIGN KEY (tblCombo2_id) REFERENCES tblCombo2(tblMenuItem2_id) ON DELETE CASCADE,
                                  FOREIGN KEY (tblDish2_id) REFERENCES tblDish2(tblMenuItem2_id)
);

-- --------------------------------------------------------
-- 5. Gọi món, Hóa đơn (OrderSlip, OrderDetails, Bill)
-- --------------------------------------------------------
CREATE TABLE tblOrderSlip2 (
                               id INT AUTO_INCREMENT PRIMARY KEY,
                               date TIMESTAMP NOT NULL,
                               guestCount INT NOT NULL,
                               status ENUM('Đặt trước', 'Đang sử dụng', 'Đã thanh toán') NOT NULL,
                               tblTable2_id INT NOT NULL,
                               tblSalesStaff2_id INT NOT NULL,
                               tblReservationSlip2_id INT UNIQUE,
                               FOREIGN KEY (tblTable2_id) REFERENCES tblTable2(id),
                               FOREIGN KEY (tblSalesStaff2_id) REFERENCES tblStaff2(id),
                               FOREIGN KEY (tblReservationSlip2_id) REFERENCES tblReservationSlip2(id)
);

CREATE TABLE tblOrderDetails2 (
                                  id INT AUTO_INCREMENT PRIMARY KEY,
                                  quantity INT NOT NULL,
                                  price DECIMAL(12, 2) NOT NULL,
                                  amount DECIMAL(12, 2) NOT NULL,
                                  tblOrderSlip2_id INT NOT NULL,
                                  tblMenuItem2_id INT NOT NULL,
                                  FOREIGN KEY (tblOrderSlip2_id) REFERENCES tblOrderSlip2(id) ON DELETE CASCADE,
                                  FOREIGN KEY (tblMenuItem2_id) REFERENCES tblMenuItem2(id)
);

CREATE TABLE tblBill2 (
                          id INT AUTO_INCREMENT PRIMARY KEY,
                          date TIMESTAMP NOT NULL,
                          totalAmount DECIMAL(12, 2) NOT NULL,
                          discountPercent DECIMAL(5, 2) DEFAULT 0,
                          status ENUM('Chưa thanh toán', 'Đã thanh toán') NOT NULL,
                          cashGiven DECIMAL(12, 2) NOT NULL,
                          changeAmount DECIMAL(12, 2) NOT NULL,
                          tblOrderSlip2_id INT NOT NULL UNIQUE,
                          tblSalesStaff2_id INT NOT NULL,
                          tblMembershipCard2_id INT,
                          FOREIGN KEY (tblOrderSlip2_id) REFERENCES tblOrderSlip2(id),
                          FOREIGN KEY (tblSalesStaff2_id) REFERENCES tblStaff2(id),
                          FOREIGN KEY (tblMembershipCard2_id) REFERENCES tblMembershipCard2(id)
);

-- --------------------------------------------------------
-- 6. Kho & Nhập hàng (Supplier, Ingredient, ImportReceipt)
-- --------------------------------------------------------
CREATE TABLE tblSupplier2 (
                              id INT AUTO_INCREMENT PRIMARY KEY,
                              name VARCHAR(255) NOT NULL,
                              phone VARCHAR(10) NOT NULL UNIQUE,
                              address VARCHAR(255) NOT NULL,
                              representative VARCHAR(100) NOT NULL
);

CREATE TABLE tblIngredient2 (
                                id INT AUTO_INCREMENT PRIMARY KEY,
                                name VARCHAR(255) NOT NULL,
                                unit VARCHAR(255) NOT NULL,
                                type VARCHAR(255) NOT NULL
);

CREATE TABLE tblImportReceipt2 (
                                   id INT AUTO_INCREMENT PRIMARY KEY,
                                   date TIMESTAMP NOT NULL,
                                   totalAmount DECIMAL(12, 2) NOT NULL,
                                   tblSupplier2_id INT NOT NULL,
                                   tblWarehouseStaff2_id INT NOT NULL,
                                   FOREIGN KEY (tblSupplier2_id) REFERENCES tblSupplier2(id),
                                   FOREIGN KEY (tblWarehouseStaff2_id) REFERENCES tblStaff2(id)
);

CREATE TABLE tblImportReceiptDetails2 (
                                          id INT AUTO_INCREMENT PRIMARY KEY,
                                          quantity INT NOT NULL,
                                          price DECIMAL(12, 2) NOT NULL,
                                          amount DECIMAL(12, 2) NOT NULL,
                                          tblImportReceipt2_id INT NOT NULL,
                                          tblIngredient2_id INT NOT NULL,
                                          FOREIGN KEY (tblImportReceipt2_id) REFERENCES tblImportReceipt2(id) ON DELETE CASCADE,
                                          FOREIGN KEY (tblIngredient2_id) REFERENCES tblIngredient2(id)
);

-- ========================================================
-- NẠP DỮ LIỆU MẪU
-- ========================================================

-- 1. Nhân viên
INSERT INTO tblStaff2 (name, username, password, birthday, address, email, phone, position, note) VALUES
                                                                                                      ('Nguyễn Văn An', 'sales01', '123456', '1998-05-12', '12 Trần Phú, Hà Đông, Hà Nội', 'an.nv@restman.vn', '0901234561', 'SalesStaff', 'Nhân viên thu ngân ca sáng'),
                                                                                                      ('Trần Thị Bích', 'manager01', '123456', '1995-08-20', '45 Nguyễn Trãi, Thanh Xuân, Hà Nội', 'bich.tt@restman.vn', '0901234562', 'Manager', 'Quản lý nhà hàng'),
                                                                                                      ('Lê Hoàng Cường', 'warehouse01', '123456', '1997-11-03', '88 Cầu Giấy, Cầu Giấy, Hà Nội', 'cuong.lh@restman.vn', '0901234563', 'WarehouseStaff', 'Nhân viên quản lý kho');

-- 2. Khách hàng
INSERT INTO tblCustomer2 (name, phone) VALUES
                                           ('Phạm Minh Đức', '0912345001'),
                                           ('Vũ Thu Hà', '0912345002'),
                                           ('Đỗ Quang Huy', '0912345003'),
                                           ('Ngô Lan Hương', '0912345004'),
                                           ('Bùi Tuấn Kiệt', '0912345005');

-- 3. Thẻ thành viên (ID 1-4)
INSERT INTO tblMembershipCard2 (code, date, status, rank_level, point, tblCustomer2_id, tblSalesStaff2_id) VALUES
                                                                                                               ('CARD001', '2026-01-15', 'Hoạt động', 'Vàng', 1500, 1, 1),
                                                                                                               ('CARD002', '2026-03-10', 'Hoạt động', 'Bạc', 720, 2, 1),
                                                                                                               ('CARD003', '2026-05-22', 'Hoạt động', 'Đồng', 250, 3, 1),
                                                                                                               ('CARD004', '2026-06-01', 'Khoá', 'Đồng', 50, 4, 1);

-- 4. Bàn ăn (ID 1-8)
INSERT INTO tblTable2 (number, capacity, status, location) VALUES
                                                               ('Bàn 01', 4, 'Đang sử dụng', 'Tầng 1 - Khu A'),
                                                               ('Bàn 02', 4, 'Đang sử dụng', 'Tầng 1 - Khu A'),
                                                               ('Bàn 03', 6, 'Đang sử dụng', 'Tầng 1 - Khu B'),
                                                               ('Bàn 04', 2, 'Trống', 'Tầng 1 - Cửa sổ'),
                                                               ('Bàn 05', 4, 'Trống', 'Tầng 2 - Khu A'),
                                                               ('Bàn 06', 8, 'Đã đặt', 'Tầng 2 - Phòng VIP 1'),
                                                               ('Bàn 07', 6, 'Trống', 'Tầng 2 - Khu B'),
                                                               ('Bàn 08', 10, 'Trống', 'Tầng 2 - Phòng VIP 2');

-- 5. Phiếu đặt bàn (ID 1-4)
INSERT INTO tblReservationSlip2 (guestCount, bookingDate, status, tblCustomer2_id, tblTable2_id, tblSalesStaff2_id) VALUES
                                                                                                                        (3, '2026-11-12 18:30:00', 'Đã xác nhận', 1, 1, 1),
                                                                                                                        (8, '2026-11-12 20:30:00', 'Đã xác nhận', 2, 6, 1),
                                                                                                                        (4, '2026-11-13 19:00:00', 'Chờ xác nhận', 3, 5, 1),
                                                                                                                        (2, '2026-11-10 18:00:00', 'Đã huỷ', 4, 4, 1);

-- 6. Thực đơn: MenuItem (ID 1-8 là Dish, ID 9-10 là Combo)
INSERT INTO tblMenuItem2 (name, image, price, status, description) VALUES
                                                                       ('Bò bít tết sốt tiêu đen', 'beefsteak.jpg', 185000, 'Còn phục vụ', 'Thăn nội bò Úc nướng kèm khoai tây chiên và sốt tiêu đen'),
                                                                       ('Cá hồi áp chảo sốt chanh leo', 'salmon.jpg', 210000, 'Còn phục vụ', 'Phi lê cá hồi Na Uy áp chảo ăn kèm măng tây'),
                                                                       ('Gà nướng mật ong nguyên con', 'chicken.jpg', 260000, 'Còn phục vụ', 'Gà ta thả vườn tẩm mật ong rừng nướng lu'),
                                                                       ('Salad Caesar ức gà', 'salad.jpg', 85000, 'Còn phục vụ', 'Xà lách Romaine, ức gà nướng, phô mai Parmesan'),
                                                                       ('Súp bí đỏ kem tươi', 'soup.jpg', 55000, 'Còn phục vụ', 'Súp bí đỏ nấu cùng kem tươi và bánh mì bơ tỏi'),
                                                                       ('Mì Ý sốt bò bằm Bolognese', 'spaghetti.jpg', 110000, 'Còn phục vụ', 'Mì Ý truyền thống với thịt bò bằm và sốt cà chua'),
                                                                       ('Nước ép dưa hấu tươi', 'watermelon.jpg', 35000, 'Còn phục vụ', 'Nước ép dưa hấu nguyên chất không đường'),
                                                                       ('Trà đào cam sả', 'peachtea.jpg', 40000, 'Còn phục vụ', 'Trà đen ủ lạnh kết hợp đào ngâm và sả tươi'),
                                                                       ('Combo Hẹn Hò Lãng Mạn', 'combo_couple.jpg', 420000, 'Còn phục vụ', 'Set ăn dành cho 2 người gồm 2 phần bít tết và 2 ly trà đào'),
                                                                       ('Combo Tiệc Gia Đình', 'combo_family.jpg', 790000, 'Còn phục vụ', 'Set ăn 4 người gồm gà nướng, mì Ý, salad và nước ép');

INSERT INTO tblDish2 (tblMenuItem2_id, size, unit, category) VALUES
                                                                 (1, '250g', 'Đĩa', 'Món chính'),
                                                                 (2, '200g', 'Đĩa', 'Món chính'),
                                                                 (3, '1.2kg', 'Con', 'Món chính'),
                                                                 (4, 'Vừa', 'Đĩa', 'Khai vị'),
                                                                 (5, 'Nhỏ', 'Bát', 'Khai vị'),
                                                                 (6, 'Vừa', 'Đĩa', 'Món chính'),
                                                                 (7, '350ml', 'Ly', 'Đồ uống'),
                                                                 (8, '400ml', 'Ly', 'Đồ uống');

INSERT INTO tblCombo2 (tblMenuItem2_id, portion, startDate, endDate) VALUES
                                                                         (9, '2 người', '2026-01-01', '2026-12-31'),
                                                                         (10, '4 người', '2026-01-01', '2026-12-31');

INSERT INTO tblComboDetails2 (quantity, price, amount, tblCombo2_id, tblDish2_id) VALUES
                                                                                      (2, 185000, 370000, 9, 1),
                                                                                      (2, 40000, 80000, 9, 8),
                                                                                      (1, 260000, 260000, 10, 3),
                                                                                      (2, 110000, 220000, 10, 6),
                                                                                      (2, 85000, 170000, 10, 4),
                                                                                      (4, 35000, 140000, 10, 7);

-- 7. Phiếu gọi món & Chi tiết gọi món (ID 1-3 đang ăn, ID 4-5 đã thanh toán)
INSERT INTO tblOrderSlip2 (date, guestCount, status, tblTable2_id, tblSalesStaff2_id, tblReservationSlip2_id) VALUES
                                                                                                                  ('2026-11-12 18:30:00', 3, 'Đang sử dụng', 1, 1, 1),
                                                                                                                  ('2026-11-12 19:00:00', 4, 'Đang sử dụng', 2, 1, NULL),
                                                                                                                  ('2026-11-12 19:15:00', 5, 'Đang sử dụng', 3, 1, NULL),
                                                                                                                  ('2026-11-11 12:15:00', 2, 'Đã thanh toán', 4, 1, NULL),
                                                                                                                  ('2026-11-11 20:00:00', 4, 'Đã thanh toán', 5, 1, NULL);

INSERT INTO tblOrderDetails2 (quantity, price, amount, tblOrderSlip2_id, tblMenuItem2_id) VALUES
                                                                                              (2, 185000, 370000, 1, 1),
                                                                                              (1, 85000, 85000, 1, 4),
                                                                                              (3, 40000, 120000, 1, 8),
                                                                                              (1, 420000, 420000, 2, 9),
                                                                                              (2, 55000, 110000, 2, 5),
                                                                                              (1, 790000, 790000, 3, 10),
                                                                                              (1, 210000, 210000, 3, 2),
                                                                                              (2, 210000, 420000, 4, 2),
                                                                                              (2, 55000, 110000, 5, 5),
                                                                                              (2, 185000, 370000, 5, 1);

-- 8. Hóa đơn đã thanh toán (ID 1-2)
INSERT INTO tblBill2 (date, totalAmount, discountPercent, status, cashGiven, changeAmount, tblOrderSlip2_id, tblSalesStaff2_id, tblMembershipCard2_id) VALUES
                                                                                                                                                           ('2026-11-11 13:30:00', 420000, 10, 'Đã thanh toán', 400000, 22000, 4, 1, 1),
                                                                                                                                                           ('2026-11-11 21:20:00', 480000, 0, 'Đã thanh toán', 500000, 20000, 5, 1, NULL);

-- 9. Kho & Phiếu nhập hàng (ID 1-3 Nhà cung cấp, ID 1-5 Nguyên liệu, ID 1-2 Phiếu nhập)
INSERT INTO tblSupplier2 (name, phone, address, representative) VALUES
                                                                    ('Công ty Thực phẩm Sạch Hà Nội', '0243888999', 'KCN Quang Minh, Mê Linh, Hà Nội', 'Trần Quốc Bảo'),
                                                                    ('Hải sản Tươi sống Biển Đông', '0243777666', '120 Hoàng Quốc Việt, Cầu Giấy, Hà Nội', 'Nguyễn Thị Mai'),
                                                                    ('Nông sản Đà Lạt VietGAP', '0243555444', 'Chợ đầu mối Minh Khai, Bắc Từ Liêm, Hà Nội', 'Lê Minh Tuấn');

INSERT INTO tblIngredient2 (name, unit, type) VALUES
                                                  ('Thăn nội bò Úc', 'kg', 'Thịt tươi'),
                                                  ('Phi lê cá hồi Na Uy', 'kg', 'Hải sản'),
                                                  ('Gà ta nguyên con', 'kg', 'Gia cầm'),
                                                  ('Xà lách Romaine', 'kg', 'Rau củ'),
                                                  ('Đào ngâm đóng hộp', 'hộp', 'Nguyên liệu pha chế');

INSERT INTO tblImportReceipt2 (date, totalAmount, tblSupplier2_id, tblWarehouseStaff2_id) VALUES
                                                                                              ('2026-11-10 08:00:00', 5600000, 1, 3),
                                                                                              ('2026-11-11 08:30:00', 4500000, 2, 3);

INSERT INTO tblImportReceiptDetails2 (quantity, price, amount, tblImportReceipt2_id, tblIngredient2_id) VALUES
                                                                                                            (10, 420000, 4200000, 1, 1),
                                                                                                            (10, 140000, 1400000, 1, 3),
                                                                                                            (8, 480000, 3840000, 2, 2),
                                                                                                            (12, 55000, 660000, 2, 5);