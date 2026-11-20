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
                           birthday DATE NULL,
                           email VARCHAR(100) NOT NULL UNIQUE,
                           phone VARCHAR(10) NOT NULL UNIQUE,
                           address VARCHAR(255) NULL,
                           position VARCHAR(255) NOT NULL,
                           note VARCHAR(255) NULL
);

-- --------------------------------------------------------
-- 2. Thẻ thành viên (MembershipCard2)
-- --------------------------------------------------------
CREATE TABLE tblMembershipCard2 (
                                    id INT AUTO_INCREMENT PRIMARY KEY,
                                    code VARCHAR(50) NOT NULL UNIQUE,
                                    date DATE NOT NULL,
                                    status VARCHAR(30) NOT NULL,
                                    rank_level VARCHAR(100) NOT NULL DEFAULT 'Chưa có',
                                    point INT NOT NULL DEFAULT 0,
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
                           status VARCHAR(30) NOT NULL,
                           location VARCHAR(100) NOT NULL
);

CREATE TABLE tblReservationSlip2 (
                                     id INT AUTO_INCREMENT PRIMARY KEY,
                                     guestCount INT NOT NULL,
                                     bookingDate TIMESTAMP NOT NULL,
                                     status VARCHAR(255) NOT NULL,
                                     tblTable2_id INT NULL,
                                     tblSalesStaff2_id INT NULL,
                                     tblCustomer2_id INT NOT NULL,
                                     FOREIGN KEY (tblTable2_id) REFERENCES tblTable2(id),
                                     FOREIGN KEY (tblSalesStaff2_id) REFERENCES tblStaff2(id),
                                     FOREIGN KEY (tblCustomer2_id) REFERENCES tblCustomer2(id)
);

-- --------------------------------------------------------
-- 4. Thực đơn & Món ăn (MenuItem, Dish, Combo, ComboDetails)
-- --------------------------------------------------------
CREATE TABLE tblMenuItem2 (
                              id INT AUTO_INCREMENT PRIMARY KEY,
                              name VARCHAR(255) NOT NULL,
                              image VARCHAR(255) NULL,
                              description VARCHAR(255) NULL,
                              price DECIMAL(12, 2) NOT NULL,
                              status VARCHAR(30) NOT NULL
);

CREATE TABLE tblDish2 (
                          tblMenuItem2_id INT PRIMARY KEY,
                          size VARCHAR(50) NOT NULL,
                          unit VARCHAR(255) NOT NULL,
                          category VARCHAR(255) NOT NULL,
                          FOREIGN KEY (tblMenuItem2_id) REFERENCES tblMenuItem2(id) ON DELETE CASCADE
);

CREATE TABLE tblCombo2 (
                           tblMenuItem2_id INT PRIMARY KEY,
                           portion VARCHAR(255) NOT NULL,
                           startDate DATE NULL,
                           endDate DATE NULL,
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
                               status VARCHAR(30) NOT NULL,
                               tblTable2_id INT NULL,
                               tblReservationSlip2_id INT NULL UNIQUE,
                               tblSalesStaff2_id INT NULL,
                               FOREIGN KEY (tblTable2_id) REFERENCES tblTable2(id),
                               FOREIGN KEY (tblReservationSlip2_id) REFERENCES tblReservationSlip2(id),
                               FOREIGN KEY (tblSalesStaff2_id) REFERENCES tblStaff2(id)
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
                          discountPercent DECIMAL(5, 2) NOT NULL DEFAULT 0,
                          status VARCHAR(30) NOT NULL,
                          cashGiven DECIMAL(12, 2) NOT NULL,
                          changeAmount DECIMAL(12, 2) NOT NULL,
                          tblOrderSlip2_id INT NOT NULL UNIQUE,
                          tblSalesStaff2_id INT NOT NULL,
                          tblMembershipCard2_id INT NULL,
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