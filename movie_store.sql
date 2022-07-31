-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Oct 26, 2021 at 10:30 AM
-- Server version: 10.4.21-MariaDB
-- PHP Version: 7.4.25

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `movie_store`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_cart_item` (IN `userId` INT, IN `movieId` INT, IN `movieName` VARCHAR(150), IN `itemPrice` DECIMAL(10,2), IN `itemImg` VARCHAR(150) CHARSET utf8)  MODIFIES SQL DATA
IF
    (
    SELECT
        cart_item_id
    FROM
        cart_items
    WHERE
        user_id = userId AND movie_id = movieId
) THEN
SELECT
    0; ELSE
INSERT INTO cart_items(
    user_id,
    movie_id,
    movie_name,
    item_price,
    item_img
)
VALUES(
    userId,
    movieId,
    movieName,
    itemPrice,
    itemImg
);
SELECT
    ROW_COUNT() AS AffectedRows;
    END IF$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_add_shipping_addr` (IN `userId` INT, IN `addrL1` VARCHAR(50), IN `addrL2` VARCHAR(50), IN `addrZip` VARCHAR(5), IN `addrName` VARCHAR(20))  NO SQL
BEGIN
INSERT INTO shipping_addresses (shipping_addresses.user_id, shipping_addresses.address_line_1, shipping_addresses.address_line_2, shipping_addresses.address_zip_code, shipping_addresses.address_name) VALUES (userId, addrL1, addrL2, addrZip, addrName);
SELECT ROW_COUNT() AS AffectedRows;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_cart_item` (IN `cartItemId` INT)  MODIFIES SQL DATA
BEGIN
DELETE FROM cart_items WHERE cart_items.cart_item_id=cartItemId;
SELECT ROW_COUNT() AS AffectedRows;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_delete_shipping_addr` (IN `addrId` INT)  MODIFIES SQL DATA
BEGIN
DELETE FROM shipping_addresses WHERE shipping_addresses.shipping_address_id=addrId;
SELECT ROW_COUNT() AS AffectedRows;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_edit_shipping_addr` (IN `userId` INT, IN `addrId` INT, IN `addrL1` VARCHAR(50), IN `addrL2` VARCHAR(50), IN `addrZip` VARCHAR(5), IN `addrName` VARCHAR(20))  NO SQL
BEGIN
UPDATE shipping_addresses SET shipping_addresses.address_line_1=addrL1,
shipping_addresses.address_line_2=addrL2, shipping_addresses.address_zip_code=addrZip, shipping_addresses.address_name=addrName WHERE shipping_addresses.shipping_address_id=addrId AND shipping_addresses.user_id=userID;
SELECT ROW_COUNT() AS AffectedRows;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_cart_items` (IN `userId` INT)  READS SQL DATA
SELECT * FROM cart_items_view WHERE cart_items_view.UserId=userId$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_get_shipping_addr` (IN `userId` INT)  NO SQL
SELECT * FROM shipping_addresses_view WHERE shipping_addresses_view.UserId=userId$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cart_items`
--

CREATE TABLE `cart_items` (
  `cart_item_id` int(11) NOT NULL,
  `movie_id` int(11) NOT NULL,
  `movie_name` varchar(150) NOT NULL,
  `user_id` int(11) NOT NULL,
  `item_price` decimal(10,2) NOT NULL,
  `item_img` varchar(150) DEFAULT NULL,
  `item_add_timestamp` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `cart_items`
--

INSERT INTO `cart_items` (`cart_item_id`, `movie_id`, `movie_name`, `user_id`, `item_price`, `item_img`, `item_add_timestamp`) VALUES
(41, 580489, 'Venom: Habrá Matanza', 1, '6667.20', 'https://image.tmdb.org/t/p/w500/2jVVDtDaeMxmcvrz2SNyhMcYtWc.jpg', '2021-10-26 03:01:04'),
(42, 588921, 'Ainbo: La Guerrera Del Amazonas', 1, '599.08', 'https://image.tmdb.org/t/p/w500/fM1HPebotc4TQh4wnMx5mRufC3g.jpg', '2021-10-26 03:01:06'),
(43, 675445, 'La patrulla canina: la película', 1, '756.67', 'https://image.tmdb.org/t/p/w500/fOYt5TfJKHHz0hFY37kSXKvEdf7.jpg', '2021-10-26 03:01:09'),
(44, 379686, 'Space Jam: Nuevas Leyendas', 1, '721.03', 'https://image.tmdb.org/t/p/w500/i6E8fx8lAEI0PGGCUlaA2Ap1gWi.jpg', '2021-10-26 03:03:27'),
(45, 438631, 'Dune', 1, '8870.67', 'https://image.tmdb.org/t/p/w500/1uLeHkWV4IXrHZcrodX4N6Rsa8X.jpg', '2021-10-26 03:04:07'),
(46, 550988, 'Free Guy', 1, '3073.45', 'https://image.tmdb.org/t/p/w500/suaooqn1Mnv60V19MoGxneMupJs.jpg', '2021-10-26 03:15:18'),
(47, 610253, 'Halloween Kills', 1, '3298.71', 'https://image.tmdb.org/t/p/w500/j1Jf5OCpjCDBCp4K7Nnh8JlvNUJ.jpg', '2021-10-26 03:17:03'),
(49, 568620, 'Snake Eyes: El origen', 1, '1755.47', 'https://image.tmdb.org/t/p/w500/dxe2P2lSyr3I2rS14lQHOwQd7G8.jpg', '2021-10-26 03:18:27'),
(50, 874948, 'Rencor', 1, '1302.95', 'https://image.tmdb.org/t/p/w500/jv3LQmsVKkQqVF94cvwHqF05eZz.jpg', '2021-10-26 03:18:31'),
(51, 589754, 'El último guerrero. Las raíces del mal', 1, '1184.70', 'https://image.tmdb.org/t/p/w500/fXjYpt5VfShntmwieXtUli8r1My.jpg', '2021-10-26 03:18:34');

-- --------------------------------------------------------

--
-- Table structure for table `shipping_addresses`
--

CREATE TABLE `shipping_addresses` (
  `shipping_address_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `address_line_1` varchar(50) NOT NULL,
  `address_line_2` varchar(50) NOT NULL,
  `address_zip_code` varchar(5) NOT NULL,
  `address_name` varchar(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `shipping_addresses`
--

INSERT INTO `shipping_addresses` (`shipping_address_id`, `user_id`, `address_line_1`, `address_line_2`, `address_zip_code`, `address_name`) VALUES
(1, 1, 'Calle principal #222-A', 'Col. El Moral, León, Gto.', '37000', 'Casa 1');
-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL,
  `first_name` varchar(30) NOT NULL,
  `last_name` varchar(20) NOT NULL,
  `email_user` varchar(50) NOT NULL,
  `password_user` varchar(50) NOT NULL,
  `register_timestamp` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`user_id`, `first_name`, `last_name`, `email_user`, `password_user`, `register_timestamp`) VALUES
(1, 'Saúl', 'Ramírez', 'sdfsdfklsdfksdmfmsdmfksdkfksf', '', '2021-10-24 15:24:08');
-- --------------------------------------------------------

--
-- Structure for view `cart_items_view`
--
DROP TABLE IF EXISTS `cart_items_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `cart_items_view`  AS SELECT `cart_items`.`cart_item_id` AS `CartItemId`, `cart_items`.`movie_id` AS `MovieId`, `cart_items`.`movie_name` AS `MovieName`, `cart_items`.`user_id` AS `UserId`, `cart_items`.`item_price` AS `ItemPrice`, `cart_items`.`item_img` AS `ItemImg`, `cart_items`.`item_add_timestamp` AS `ItemAddTimeStamp` FROM `cart_items` ;

-- --------------------------------------------------------

--
-- Structure for view `shipping_addresses_view`
--
DROP TABLE IF EXISTS `shipping_addresses_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `shipping_addresses_view`  AS SELECT `shipping_addresses`.`shipping_address_id` AS `ShippingAddressId`, `shipping_addresses`.`user_id` AS `UserId`, `shipping_addresses`.`address_line_1` AS `AddressLine1`, `shipping_addresses`.`address_line_2` AS `AddressLine2`, `shipping_addresses`.`address_zip_code` AS `AddressZipCode`, `shipping_addresses`.`address_name` AS `AddressName` FROM `shipping_addresses` ;

-- --------------------------------------------------------

--
-- Structure for view `users_view`
--
DROP TABLE IF EXISTS `users_view`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `users_view`  AS SELECT `users`.`user_id` AS `UserId`, `users`.`first_name` AS `FirstName`, `users`.`last_name` AS `LastName`, `users`.`register_timestamp` AS `RegisterTimestamp` FROM `users` ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD PRIMARY KEY (`cart_item_id`),
  ADD KEY `FK_Users_CartItem` (`user_id`);

--
-- Indexes for table `shipping_addresses`
--
ALTER TABLE `shipping_addresses`
  ADD PRIMARY KEY (`shipping_address_id`),
  ADD KEY `FK_users_ShippAdd` (`user_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cart_items`
--
ALTER TABLE `cart_items`
  MODIFY `cart_item_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `shipping_addresses`
--
ALTER TABLE `shipping_addresses`
  MODIFY `shipping_address_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `cart_items`
--
ALTER TABLE `cart_items`
  ADD CONSTRAINT `FK_Users_CartItem` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Constraints for table `shipping_addresses`
--
ALTER TABLE `shipping_addresses`
  ADD CONSTRAINT `FK_users_ShippAdd` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
