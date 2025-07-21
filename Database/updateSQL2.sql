-- Tạo cơ sở dữ liệu
CREATE DATABASE SwimmingPoolManagement1;
GO

USE SwimmingPoolManagement1;
GO

-- 1. Tạo bảng Roles
CREATE TABLE Roles (
    RoleID INT PRIMARY KEY IDENTITY(1,1),
    RoleName NVARCHAR(100)
);

-- 2. Tạo bảng SwimmingPools
CREATE TABLE SwimmingPools (
    PoolID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100),
    Location NVARCHAR(200),
    Phone NVARCHAR(20),
    Fanpage NVARCHAR(100),
    Description NVARCHAR(255),
    Status BIT,
    Image NVARCHAR(255)
);

-- 3. Tạo bảng Users
CREATE TABLE Users (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    RoleID INT FOREIGN KEY REFERENCES Roles(RoleID),
    FullName NVARCHAR(100),
    Email NVARCHAR(100),
    Password NVARCHAR(100),
    Phone NVARCHAR(20),
    Address NVARCHAR(200),
    Image NVARCHAR(255)
);

-- 4. Tạo bảng Product
CREATE TABLE Product (
    ProductID INT PRIMARY KEY IDENTITY(1,1),
    ProductName NVARCHAR(100),
    Description NVARCHAR(255),
    Price DECIMAL(10,2),
    Quantity INT,
    Image NVARCHAR(255)
);

-- 5. Tạo bảng Package
CREATE TABLE Package (
    PackageID INT PRIMARY KEY IDENTITY(1,1),
    PackageName NVARCHAR(50) NOT NULL,
    DurationInDays INT NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    Description NVARCHAR(255) NULL,
    IsActive BIT DEFAULT 1,
    CreatedAt DATETIME DEFAULT GETDATE()
);

-- 6. Tạo bảng Blogs
CREATE TABLE Blogs (
    BlogID INT PRIMARY KEY IDENTITY(1,1),
    AuthorID INT FOREIGN KEY REFERENCES Users(UserID),
    Title NVARCHAR(255),
    Content NVARCHAR(MAX),
    CreatedAt DATETIME
);

-- 7. Tạo bảng Events
CREATE TABLE Events (
    EventID INT PRIMARY KEY IDENTITY(1,1),
    PoolID INT FOREIGN KEY REFERENCES SwimmingPools(PoolID),
    CreatedBy INT FOREIGN KEY REFERENCES Users(UserID),
    EventDate DATE,
    Title NVARCHAR(255),
    Description NVARCHAR(255),
    Image NVARCHAR(255)
);

-- 8. Tạo bảng UserSchedules
CREATE TABLE UserSchedules (
    ScheduleID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    StartTime DATETIME,
    EndTime DATETIME,
    Task NVARCHAR(255)
);

-- 9. Tạo bảng SwimHistory
CREATE TABLE SwimHistory (
    HistoryID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    PoolID INT FOREIGN KEY REFERENCES SwimmingPools(PoolID),
    SwimDate DATE
);

-- 10. Tạo bảng Order
CREATE TABLE [Order] (
    OrderID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    Amount INT,
    Status NVARCHAR(50),
    PaymentDate DATETIME
);

-- 11. Tạo bảng TrainerBookings
CREATE TABLE TrainerBookings (
    BookingID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    PoolID INT FOREIGN KEY REFERENCES SwimmingPools(PoolID),
    TrainerID INT FOREIGN KEY REFERENCES Users(UserID),
    BookingDate DATE,
    UserName NVARCHAR(100),
    Note NVARCHAR(255),
);

-- 12. Tạo bảng UserReviews
CREATE TABLE UserReviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    PoolID INT FOREIGN KEY REFERENCES SwimmingPools(PoolID),
    Rating INT,
    Comment NVARCHAR(255),
    CreatedAt DATETIME
);

-- 13. Tạo bảng Employee
CREATE TABLE Employee (
    UserID INT PRIMARY KEY FOREIGN KEY REFERENCES Users(UserID),
    Description NVARCHAR(255),
    StartDate DATE,
    EndDate DATE,
    Attendance INT,
    Salary DECIMAL(10,2)
);

-- 14. Tạo bảng WarehouseManagers
CREATE TABLE WarehouseManagers (
    ID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    ProductID INT FOREIGN KEY REFERENCES Product(ProductID),
    AssignedAt DATETIME,
    AssigneeAt NVARCHAR(100)
);

-- 15. Tạo bảng Notifications
CREATE TABLE Notifications (
    NotificationID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    Title NVARCHAR(255),
    Message NVARCHAR(255),
    IsRead BIT,
    CreatedAt DATETIME
);

-- 16. Tạo bảng UserPackages
CREATE TABLE UserPackages (
    UserPackageID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    PackageID INT FOREIGN KEY REFERENCES Package(PackageID),
    PurchaseDate DATETIME DEFAULT GETDATE(),
    StartDate DATE NOT NULL,
    EndDate DATE NOT NULL,
    IsActive BIT DEFAULT 1,
    PaymentStatus NVARCHAR(50) DEFAULT N'Pending'
);

-- 17. Tạo bảng TrainerReviews
CREATE TABLE TrainerReviews (
    ReviewID INT PRIMARY KEY IDENTITY(1,1),
    UserID INT FOREIGN KEY REFERENCES Users(UserID),
    TrainerID INT FOREIGN KEY REFERENCES Users(UserID),
    Rating INT,
    Comment NVARCHAR(255),
    CreatedAt DATETIME,
);

-- Chèn dữ liệu vào bảng Roles
INSERT INTO Roles (RoleName) VALUES 
('admin'),
('user'),
('employee'),
('trainer');

-- Chèn dữ liệu vào bảng SwimmingPools
INSERT INTO SwimmingPools (Name, Location, Phone, Fanpage, Description, Status, Image) VALUES 
('Sunset Pool', '123 Main St, Hanoi', '0123456789', 'facebook.com/sunsetpool', 'Olympic-sized pool with modern facilities', 1, 'sunset.jpg'),
('Blue Wave Pool', '456 Tran Phu, Ho Chi Minh City', '0234567890', 'facebook.com/bluewavepool', 'Family-friendly pool with slides', 1, 'bluewave.jpg'),
('Starlight Pool', '789 Nguyen Trai, Da Nang', '0345678901', 'facebook.com/starlightpool', 'Indoor pool with heating system', 0, 'starlight.jpg'),
('Moonlight Pool', '101 Le Van Sy, Ho Chi Minh City', '0456789012', 'facebook.com/moonlightpool', 'Outdoor pool with night lighting', 1, 'moonlight.jpg'),
('Crystal Lake Pool', '222 Ba Dinh, Hanoi', '0567890123', 'facebook.com/crystallakepool', 'Large pool for competitive swimming', 1, 'crystallake.jpg'),
('Ocean Breeze Pool', '333 Hai Phong, Da Nang', '0678901234', 'facebook.com/oceanbreezepool', 'Pool with ocean view', 0, 'oceanbreeze.jpg'),
('Golden Sun Pool', '555 Hoang Hoa Tham, Hanoi', '0789012345', 'facebook.com/goldensunpool', 'Luxury pool with spa facilities', 1, 'goldensun.jpg'),
('Aqua Park Pool', '666 Nguyen Van Cu, Ho Chi Minh City', '0890123456', 'facebook.com/aquaparkpool', 'Pool with water park features', 1, 'aquapark.jpg'),
('Silver Wave Pool', '777 Ly Thuong Kiet, Da Nang', '0901234567', 'facebook.com/silverwavepool', 'Training pool for athletes', 1, 'silverwave.jpg'),
('Emerald Pool', '888 Le Lai, Ho Chi Minh City', '0912345678', 'facebook.com/emeraldpool', 'Eco-friendly pool with solar heating', 1, 'emerald.jpg'),
('Skyline Pool', '999 Hoang Dieu, Hanoi', '0923456789', 'facebook.com/skylinepool', 'Rooftop pool with city views', 1, 'skyline.jpg'),
('Coral Reef Pool', '111 Ba Huyen Thanh Quan, Da Nang', '0934567890', 'facebook.com/coralreefpool', 'Themed pool for relaxation', 0, 'coralreef.jpg'),
('Pearl Pool', '222 Nguyen Thi Minh Khai, Ho Chi Minh City', '0945678901', 'facebook.com/pearlpool', 'Luxury indoor pool with jacuzzi', 1, 'pearl.jpg'),
('Riverfront Pool', '333 Hang Bong, Hanoi', '0956789012', 'facebook.com/riverfrontpool', 'Outdoor pool with scenic views', 1, 'riverfront.jpg'),
('Tropical Oasis Pool', '444 Tran Hung Dao, Da Nang', '0967890123', 'facebook.com/tropicaloasispool', 'Tropical-themed pool for families', 0, 'tropicaloasis.jpg');

-- Chèn dữ liệu vào bảng Users
INSERT INTO Users (RoleID, FullName, Email, Password, Phone, Address, Image) VALUES 
(1, N'Nguyễn Văn An', 'an.nguyen@example.com', 'pass123', '0901234567', '12 Hoan Kiem, Hanoi', 'an_profile.jpg'),
(2, N'Trần Thị Bình', 'binh.tran@example.com', 'pass456', '0912345678', '15 District 1, HCMC', 'binh_profile.jpg'),
(3, N'Phạm Minh Cường', 'cuong.pham@example.com', 'pass789', '0923456789', '20 Hai Ba Trung, Hanoi', 'cuong_profile.jpg'),
(4, N'Lê Thị Duyên', 'duyen.le@example.com', 'pass101', '0934567890', '30 Nguyen Hue, HCMC', 'duyen_profile.jpg'),
(2, N'Hoàng Văn Em', 'em.hoang@example.com', 'pass202', '0945678901', '45 Le Loi, Da Nang', 'em_profile.jpg'),
(2, N'Vũ Thị Hương', 'huong.vu@example.com', 'pass303', '0956789012', '50 Ba Dinh, Hanoi', 'huong_profile.jpg'),
(2, N'Đỗ Văn Khang', 'khang.do@example.com', 'pass404', '0967890123', '60 District 3, HCMC', 'khang_profile.jpg'),
(3, N'Bùi Minh Long', 'long.bui@example.com', 'pass505', '0978901234', '70 Ngo Quyen, Da Nang', 'long_profile.jpg'),
(4, N'Ngô Thị Mai', 'mai.ngo@example.com', 'pass606', '0989012345', '80 Tran Hung Dao, Hanoi', 'mai_profile.jpg'),
(2, N'Phan Văn Đức', 'duc.phan@example.com', 'pass707', '0990123456', '90 Dong Da, Hanoi', 'duc_profile.jpg'),
(2, N'Nguyễn Thị Hằng', 'hang.nguyen@example.com', 'pass808', '0991234567', '100 District 7, HCMC', 'hang_profile.jpg'),
(3, N'Trương Minh Khoa', 'khoa.truong@example.com', 'pass909', '0992345678', '110 Quang Trung, Da Nang', 'khoa_profile.jpg'),
(4, N'Võ Thị Lan', 'lan.vo@example.com', 'pass1010', '0993456789', '120 Nguyen Trai, Hanoi', 'lan_profile.jpg'),
(2, N'Đinh Văn Nam', 'nam.dinh@example.com', 'pass1111', '0994567890', '130 Ly Thai To, Hanoi', 'nam_profile.jpg'),
(2, N'Phùng Thị Oanh', 'oanh.phung@example.com', 'pass1212', '0995678901', '140 District 5, HCMC', 'oanh_profile.jpg'),
(3, N'Lương Minh Phong', 'phong.luong@example.com', 'pass1313', '0996789012', '150 Tran Phu, Da Nang', 'phong_profile.jpg'),
(4, N'Hà Thị Quyên', 'quyen.ha@example.com', 'pass1414', '0997890123', '160 Nguyen Van Troi, Hanoi', 'quyen_profile.jpg'),
(2, N'Nguyễn Văn Bảo', 'bao.nguyen@example.com', 'pass1515', '0998901234', '170 Le Duan, Hanoi', 'bao_profile.jpg'),
(3, N'Trần Thị Cẩm', 'cam.tran@example.com', 'pass1616', '0999012345', '180 District 2, HCMC', 'cam_profile.jpg'),
(4, N'Phạm Văn Đạt', 'dat.pham@example.com', 'pass1717', '0999123456', '190 Hai Ba Trung, Da Nang', 'dat_profile.jpg'),
(2, N'Lê Thị Hồng', 'hong.le@example.com', 'pass1818', '0999234567', '200 Nguyen Hue, Hanoi', 'hong_profile.jpg');

-- Chèn dữ liệu vào bảng Product
INSERT INTO Product (ProductName, Description, Price, Quantity, Image) VALUES 
('Swim Goggles', 'Anti-fog swim goggles', 15.50, 100, 'goggles.jpg'),
('Swim Cap', 'Silicone swim cap', 8.00, 200, 'cap.jpg'),
('Swim Fins', 'Training swim fins', 25.00, 50, 'fins.jpg'),
('Swim Towel', 'Quick-dry microfiber towel', 12.00, 150, 'towel.jpg'),
('Swim Bag', 'Waterproof swim bag', 20.00, 80, 'bag.jpg'),
('Kickboard', 'Foam kickboard for training', 18.50, 60, 'kickboard.jpg'),
('Swim Earplugs', 'Waterproof silicone earplugs', 6.50, 200, 'earplugs.jpg'),
('Swim Snorkel', 'Center-mount swim snorkel', 22.00, 70, 'snorkel.jpg'),
('Pool Noodle', 'Foam pool noodle for flotation', 5.00, 300, 'noodle.jpg'),
('Swim Vest', 'Inflatable swim vest for safety', 30.00, 90, 'vest.jpg'),
('Waterproof Phone Case', 'Protective case for swimming', 10.00, 120, 'phonecase.jpg'),
('Swim Paddles', 'Hand paddles for stroke training', 15.00, 80, 'paddles.jpg'),
('Swim Buoy', 'Inflatable buoy for open water swimming', 18.00, 100, 'buoy.jpg'),
('Swim Gloves', 'Webbed gloves for resistance training', 12.50, 150, 'gloves.jpg'),
('Pool Float', 'Inflatable pool float for relaxation', 20.00, 80, 'float.jpg');

-- Chèn dữ liệu vào bảng Package
INSERT INTO Package (PackageName, DurationInDays, Price, Description, IsActive) VALUES
(N'Weekly Pass', 7, 150000.00, N'Valid for 7 days from the activation date', 1),
(N'Unlimited Monthly Swim', 30, 500000.00, N'Valid for 30 days from the activation date, unlimited swim sessions', 1),
(N'Gold Annual Pass', 365, 4000000.00, N'Valid for 365 days, includes special benefits', 1),
(N'Basic 3-Month Pass', 90, 1200000.00, N'3-month package for regular swimmers', 1),
(N'Single Day Pass', 1, 30000.00, N'Entry ticket valid for one day (weekdays only)', 0);

-- Chèn dữ liệu vào bảng Blogs
INSERT INTO Blogs (AuthorID, Title, Content, CreatedAt) VALUES 
(1, 'Top 5 Swimming Tips', 'Learn the best techniques for freestyle swimming...', '2025-05-20 10:00:00'),
(4, 'Why Swimming is Great for Health', 'Swimming improves cardiovascular health...', '2025-05-21 14:30:00'),
(2, 'Choosing the Right Swim Gear', 'Guide to selecting swim goggles and caps...', '2025-05-22 09:15:00'),
(2, 'Swimming for Beginners', 'Tips for new swimmers to build confidence...', '2025-05-23 11:00:00'),
(9, 'Advanced Swim Drills', 'Improve your speed with these drills...', '2025-05-24 08:30:00'),
(1, 'Pool Safety Guidelines', 'Essential safety tips for all swimmers...', '2025-05-24 10:00:00'),
(2, 'Benefits of Early Morning Swimming', 'Start your day with a refreshing swim...', '2025-05-24 12:00:00'),
(13, 'Swim Stroke Techniques', 'Master the butterfly stroke with these tips...', '2025-05-24 14:00:00'),
(1, 'Maintaining Pool Hygiene', 'Best practices for clean pools...', '2025-05-24 16:00:00'),
(2, 'Swimming and Mental Health', 'How swimming reduces stress and anxiety...', '2025-05-25 09:00:00'),
(16, 'Pool Maintenance Tips', 'Keep your pool clean and safe...', '2025-05-25 11:00:00'),
(17, 'Freestyle Stroke Guide', 'Master freestyle with these techniques...', '2025-05-25 13:00:00');

-- Chèn dữ liệu vào bảng Events
INSERT INTO Events (PoolID, CreatedBy, EventDate, Title, Description, Image) VALUES 
(1, 1, '2025-06-01', 'Summer Swim Fest', 'Annual swimming competition', 'event1.jpg'),
(2, 4, '2025-06-15', 'Kids Swim Day', 'Fun day for kids with games', 'event2.jpg'),
(3, 3, '2025-07-01', 'Night Swim Party', 'Evening swim with music', 'event3.jpg'),
(4, 2, '2025-06-10', 'Moonlight Swim Night', 'Evening swim event with lights', 'event4.jpg'),
(5, 1, '2025-06-20', 'Swim Championship', 'Regional swim competition', 'event5.jpg'),
(6, 9, '2025-07-05', 'Family Pool Day', 'Fun activities for families', 'event6.jpg'),
(7, 2, '2025-06-25', 'Summer Splash', 'Community swim event', 'event7.jpg'),
(8, 1, '2025-07-01', 'Aqua Fun Day', 'Water games for all ages', 'event8.jpg'),
(9, 13, '2025-07-10', 'Athlete Training Camp', 'Intensive swim training', 'event9.jpg'),
(10, 2, '2025-07-15', 'Eco Swim Day', 'Promoting eco-friendly swimming', 'event10.jpg'),
(11, 1, '2025-07-20', 'Rooftop Swim Party', 'Evening event with skyline views', 'event11.jpg'),
(12, 17, '2025-08-01', 'Relaxation Swim', 'Calm swim session with music', 'event12.jpg'),
(13, 1, '2025-08-05', 'Pearl Pool Opening', 'Grand opening of the new luxury pool', 'event13.jpg'),
(14, 2, '2025-08-10', 'River Swim Challenge', 'Competitive swim along the riverfront', 'event14.jpg'),
(15, 19, '2025-08-15', 'Tropical Pool Party', 'Family-friendly tropical-themed event', 'event15.jpg');

-- Chèn dữ liệu vào bảng UserSchedules
INSERT INTO UserSchedules (UserID, StartTime, EndTime, Task) VALUES 
(4, '2025-05-25 08:00:00', '2025-05-25 10:00:00', 'Swim Training Session'),
(3, '2025-05-26 09:00:00', '2025-05-26 11:00:00', 'Lifeguard Duty'),
(1, '2025-05-27 14:00:00', '2025-05-27 16:00:00', 'Admin Meeting'),
(9, '2025-05-28 09:00:00', '2025-05-28 11:00:00', 'Swim Coaching Session'),
(8, '2025-05-29 13:00:00', '2025-05-29 15:00:00', 'Pool Maintenance'),
(2, '2025-05-30 10:00:00', '2025-05-30 12:00:00', 'User Activity Review'),
(13, '2025-05-31 08:00:00', '2025-05-31 10:00:00', 'Swim Coaching'),
(12, '2025-06-01 10:00:00', '2025-06-01 12:00:00', 'Lifeguard Shift'),
(2, '2025-06-02 09:00:00', '2025-06-02 11:00:00', 'User Activity Review'),
(17, '2025-06-03 08:00:00', '2025-06-03 10:00:00', 'Swim Coaching'),
(16, '2025-06-04 09:00:00', '2025-06-04 11:00:00', 'Pool Maintenance'),
(2, '2025-06-05 10:00:00', '2025-06-05 12:00:00', 'User Activity Review'),
(19, '2025-06-06 08:00:00', '2025-06-06 10:00:00', 'Swim Coaching'),
(20, '2025-06-07 09:00:00', '2025-06-07 11:00:00', 'Lifeguard Shift'),
(2, '2025-06-08 10:00:00', '2025-06-08 12:00:00', 'User Activity Review');

-- Chèn dữ liệu vào bảng SwimHistory
INSERT INTO SwimHistory (UserID, PoolID, SwimDate) VALUES 
(2, 1, '2025-05-20'),
(5, 2, '2025-05-21'),
(4, 3, '2025-05-22'),
(7, 4, '2025-05-23'),
(8, 5, '2025-05-24'),
(9, 6, '2025-05-24'),
(11, 7, '2025-05-24'),
(12, 8, '2025-05-24'),
(13, 9, '2025-05-24'),
(15, 10, '2025-05-25'),
(16, 11, '2025-05-25'),
(17, 12, '2025-05-25'),
(18, 13, '2025-05-26'),
(20, 14, '2025-05-26'),
(19, 15, '2025-05-26');

-- Chèn dữ liệu vào bảng Order
INSERT INTO [Order] (UserID, ProductID, Amount, Status, PaymentDate) VALUES 
(2, 1, 2, 'Completed', '2025-05-20 12:00:00'),
(5, 2, 3, 'Pending', '2025-05-21 15:30:00'),
(4, 3, 1, 'Completed', '2025-05-22 10:45:00'),
(7, 4, 1, 'Completed', '2025-05-23 14:00:00'),
(8, 5, 2, 'Pending', '2025-05-24 09:30:00'),
(9, 6, 3, 'Completed', '2025-05-24 11:15:00'),
(11, 7, 2, 'Completed', '2025-05-24 13:00:00'),
(12, 8, 1, 'Pending', '2025-05-24 15:00:00'),
(13, 9, 4, 'Completed', '2025-05-24 17:00:00'),
(15, 10, 1, 'Completed', '2025-05-25 10:00:00'),
(16, 11, 2, 'Pending', '2025-05-25 12:00:00'),
(17, 12, 3, 'Completed', '2025-05-25 14:00:00'),
(18, 13, 1, 'Completed', '2025-05-26 10:00:00'),
(20, 14, 2, 'Pending', '2025-05-26 12:00:00'),
(19, 15, 1, 'Completed', '2025-05-26 14:00:00');

-- Chèn dữ liệu vào bảng TrainerBookings
INSERT INTO TrainerBookings (UserID, PoolID, TrainerID, BookingDate, UserName, Note) VALUES 
(5, 1, 4, '2025-05-25', N'Hoàng Văn Em', N'Beginner swim lesson'),
(6, 2, 4, '2025-05-26', N'Vũ Thị Hương', N'Advanced freestyle training'),
(7, 3, 4, '2025-05-27', N'Đỗ Văn Khang', N'Group lesson'),
(10, 1, 9, '2025-05-28', N'Phan Văn Đức', N'Private swim lesson'),
(11, 2, 9, '2025-05-29', N'Nguyễn Thị Hằng', N'Group training session'),
(14, 3, 9, '2025-05-30', N'Đinh Văn Nam', N'Beginner coaching'),
(18, 2, 13, '2025-05-31', N'Nguyễn Văn Bảo', N'Intermediate swim lesson'),
(18, 1, 13, '2025-06-01', N'Nguyễn Văn Bảo', N'Group freestyle training'),
(11, 1, 13, '2025-06-02', N'Nguyễn Thị Hằng', N'Private lesson'),
(5, 2, 17, '2025-06-03', N'Lê Thị Hồng', N'Beginner swim lesson'),
(6, 3, 17, '2025-06-04', N'Lê Thị Hồng', N'Advanced stroke training');

-- Chèn dữ liệu vào bảng UserReviews
INSERT INTO UserReviews (UserID, PoolID, Rating, Comment, CreatedAt) VALUES 
(2, 1, 5, 'Great facilities and clean pool!', '2025-05-20 16:00:00'),
(5, 2, 4, 'Fun for kids, but crowded.', '2025-05-21 17:30:00'),
(4, 3, 3, 'Needs better heating.', '2025-05-22 11:00:00'),
(7, 4, 4, 'Beautiful lighting at night!', '2025-05-23 17:00:00'),
(8, 5, 5, 'Perfect for competitions.', '2025-05-24 12:00:00'),
(9, 6, 3, 'Needs better maintenance.', '2025-05-24 13:30:00'),
(11, 7, 5, 'Amazing spa facilities!', '2025-05-24 14:00:00'),
(12, 8, 4, 'Fun water park, but busy.', '2025-05-24 16:00:00'),
(13, 9, 4, 'Great for training sessions.', '2025-05-24 18:00:00'),
(15, 10, 5, 'Eco-friendly and clean!', '2025-05-25 15:00:00'),
(16, 11, 4, 'Amazing views, but small pool.', '2025-05-25 16:00:00'),
(17, 12, 3, 'Relaxing, but under maintenance.', '2025-05-25 17:00:00'),
(18, 13, 5, 'Luxurious and relaxing pool!', '2025-05-26 15:00:00'),
(20, 14, 4, 'Great views, but chilly water.', '2025-05-26 16:00:00'),
(19, 15, 3, 'Fun theme, but needs repairs.', '2025-05-26 17:00:00');

-- Chèn dữ liệu vào bảng Employee
INSERT INTO Employee (UserID, Description, StartDate, EndDate, Attendance, Salary) VALUES 
(3, 'Lifeguard and maintenance staff', '2025-01-01', NULL, 20, 1000.00),
(4, 'Swim trainer', '2025-02-01', NULL, 22, 1200.00),
(8, 'Pool maintenance staff', '2025-03-01', NULL, 18, 900.00),
(9, 'Swim instructor', '2025-04-01', NULL, 20, 1100.00),
(12, 'Lifeguard', '2025-05-01', NULL, 15, 950.00),
(13, 'Swim coach', '2025-05-15', NULL, 18, 1150.00),
(16, 'Maintenance staff', '2025-06-01', NULL, 10, 850.00),
(17, 'Swim coach', '2025-06-01', NULL, 12, 1100.00),
(20, 'Lifeguard', '2025-06-01', NULL, 8, 900.00),
(19, 'Swim coach', '2025-06-01', NULL, 10, 1100.00);

-- Chèn dữ liệu vào bảng WarehouseManagers
INSERT INTO WarehouseManagers (UserID, ProductID, AssignedAt, AssigneeAt) VALUES 
(1, 1, '2025-05-20 08:00:00', 'Main Warehouse'),
(3, 2, '2025-05-21 09:00:00', 'Branch Warehouse'),
(1, 3, '2025-05-22 10:00:00', 'Main Warehouse'),
(2, 4, '2025-05-23 09:00:00', 'Main Warehouse'),
(8, 5, '2025-05-24 10:00:00', 'Branch Warehouse'),
(2, 6, '2025-05-24 11:00:00', 'Main Warehouse'),
(2, 7, '2025-05-24 12:00:00', 'Main Warehouse'),
(12, 8, '2025-05-24 14:00:00', 'Branch Warehouse'),
(2, 9, '2025-05-24 16:00:00', 'Main Warehouse'),
(2, 10, '2025-05-25 08:00:00', 'Main Warehouse'),
(16, 11, '2025-05-25 10:00:00', 'Branch Warehouse'),
(2, 12, '2025-05-25 12:00:00', 'Main Warehouse'),
(2, 13, '2025-05-26 08:00:00', 'Main Warehouse'),
(20, 14, '2025-05-26 10:00:00', 'Branch Warehouse'),
(2, 15, '2025-05-26 12:00:00', 'Main Warehouse');

-- Chèn dữ liệu vào bảng Notifications
INSERT INTO Notifications (UserID, Title, Message, IsRead, CreatedAt) VALUES 
(2, 'Order Confirmation', 'Your order for swim goggles has been confirmed.', 1, '2025-05-20 12:30:00'),
(5, 'Event Reminder', 'Join us for Kids Swim Day on June 15!', 0, '2025-05-21 08:00:00'),
(4, 'Schedule Update', 'Your training session is scheduled for May 25.', 1, '2025-05-22 09:00:00'),
(7, 'Order Confirmation', 'Your order for a swim towel has been confirmed.', 1, '2025-05-23 14:30:00'),
(8, 'Event Reminder', 'Join us for the Swim Championship on June 20!', 0, '2025-05-24 08:00:00'),
(9, 'Schedule Update', 'Your coaching session is scheduled for May 28.', 1, '2025-05-24 09:30:00'),
(11, 'Order Confirmation', 'Your order for earplugs has been confirmed.', 1, '2025-05-24 13:30:00'),
(12, 'Event Reminder', 'Join us for Aqua Fun Day on July 1!', 0, '2025-05-24 15:30:00'),
(13, 'Schedule Update', 'Your coaching session is scheduled for May 31.', 1, '2025-05-24 17:30:00'),
(15, 'Order Confirmation', 'Your order for a swim vest has been confirmed.', 1, '2025-05-25 10:30:00'),
(16, 'Event Reminder', 'Join us for Rooftop Swim Party on July 20!', 0, '2025-05-25 11:00:00'),
(17, 'Schedule Update', 'Your coaching session is scheduled for June 3.', 1, '2025-05-25 13:30:00'),
(18, 'Order Confirmation', 'Your order for a swim buoy has been confirmed.', 1, '2025-05-26 10:30:00'),
(20, 'Event Reminder', 'Join us for Tropical Pool Party on August 15!', 0, '2025-05-26 11:00:00'),
(19, 'Schedule Update', 'Your coaching session is scheduled for June 6.', 1, '2025-05-26 13:30:00');

-- Chèn dữ liệu vào bảng UserPackages
INSERT INTO UserPackages (UserID, PackageID, StartDate, EndDate, IsActive, PaymentStatus) VALUES
(2, 2, '2025-05-25', DATEADD(day, 30, '2025-05-25'), 1, N'Completed'),
(5, 1, '2025-05-20', DATEADD(day, 7, '2025-05-20'), 0, N'Completed'),
(7, 3, '2025-01-01', DATEADD(day, 365, '2025-01-01'), 1, N'Completed'),
(10, 4, '2025-05-15', DATEADD(day, 90, '2025-05-15'), 1, N'Completed'),
(11, 1, '2025-05-25', DATEADD(day, 7, '2025-05-25'), 1, N'Pending'),
(14, 2, '2025-05-10', DATEADD(day, 30, '2025-05-10'), 1, N'Completed'),
(18, 3, '2025-03-01', DATEADD(day, 365, '2025-03-01'), 1, N'Completed'),
(21, 1, '2025-05-24', DATEADD(day, 7, '2025-05-24'), 1, N'Completed');

-- Chèn dữ liệu vào bảng TrainerReviews
INSERT INTO TrainerReviews (UserID, TrainerID, Rating, Comment, CreatedAt) VALUES
(5, 4, 5, N'Excellent', '2025-05-25'),
(6, 4, 4, N'Very enthusiastic', '2025-05-26'),
(7, 4, 5, N'Clear instructions', '2025-05-27'),
(10, 9, 3, N'Average', '2025-05-28'),
(11, 9, 4, N'Effective training', '2025-05-29'),
(14, 9, 5, N'Enthusiastic and professional', '2025-05-30'),
(18, 13, 4, N'Good, curriculum needs improvement', '2025-05-31'),
(11, 13, 5, N'Very good', '2025-06-01'),
(5, 17, 5, N'Outstanding', '2025-06-02'),
(6, 17, 4, N'Stable and friendly', '2025-06-03'),
(7, 13, 5, N'Professional and supportive', '2025-06-04'),
(10, 4, 4, N'Motivating and well-prepared', '2025-06-05'),
(14, 17, 5, N'Great experience with the trainer', '2025-06-06'),
(18, 9, 3, N'Needs to improve communication', '2025-06-07'),
(6, 13, 5, N'Excellent guidance and encouragement', '2025-06-08'),
(5, 9, 4, N'Solid sessions, good pacing', '2025-06-09'),
(11, 4, 5, N'Always energetic and inspiring', '2025-06-10'),
(14, 13, 4, N'Helpful with customized plans', '2025-06-11'),
(10, 17, 5, N'Makes workouts fun and effective', '2025-06-12'),
(7, 9, 3, N'Decent trainer, can be more engaging', '2025-06-13');

