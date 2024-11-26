-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 26, 2024 at 02:14 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `interests`
--

-- --------------------------------------------------------

--
-- Table structure for table `friendships`
--

CREATE TABLE `friendships` (
  `id` int(11) NOT NULL,
  `user1` varchar(50) NOT NULL,
  `user2` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `friendships`
--

INSERT INTO `friendships` (`id`, `user1`, `user2`) VALUES
(5, 'anya', 'lloyd'),
(10, 'crinkles', 'lloyd'),
(12, 'elle', 'kal'),
(11, 'kal', 'elle'),
(2, 'kal', 'lloyd'),
(14, 'kal', 'mallows'),
(3, 'kal', 'oreo'),
(6, 'lloyd', 'anya'),
(9, 'lloyd', 'crinkles'),
(1, 'lloyd', 'kal'),
(16, 'lloyd', 'mallows'),
(8, 'lloyd', 'oreo'),
(13, 'mallows', 'kal'),
(15, 'mallows', 'lloyd'),
(4, 'oreo', 'kal'),
(7, 'oreo', 'lloyd');

-- --------------------------------------------------------

--
-- Table structure for table `friend_requests`
--

CREATE TABLE `friend_requests` (
  `id` int(11) NOT NULL,
  `from_user` varchar(50) NOT NULL,
  `to_user` varchar(50) NOT NULL,
  `status` enum('pending','accepted','rejected') DEFAULT 'pending'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `friend_requests`
--

INSERT INTO `friend_requests` (`id`, `from_user`, `to_user`, `status`) VALUES
(1, 'kal', 'lloyd', 'accepted'),
(2, 'kal', 'mallows', 'accepted'),
(3, 'kal', 'moonie', 'pending'),
(4, 'kal', 'oreo', 'pending'),
(5, 'oreo', 'kal', 'accepted'),
(6, 'crinkles', 'kal', 'pending'),
(7, 'lloyd', 'mallows', 'accepted'),
(8, 'lloyd', 'oreo', 'accepted'),
(9, 'lloyd', 'anya', 'accepted'),
(10, 'crinkles', 'lloyd', 'accepted'),
(11, 'kal', 'elle', 'pending'),
(12, 'elle', 'kal', 'accepted');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `age` int(11) NOT NULL,
  `location` varchar(100) DEFAULT NULL,
  `gender` enum('Male','Female','Other') DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `social_media_link` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `username`, `age`, `location`, `gender`, `password`, `social_media_link`) VALUES
(1, 'lloyd', 20, 'taguig', '', 'lloyd', 'https/missyou'),
(2, 'kal', 19, 'taguig', '', 'kal', 'https//kar'),
(3, 'mallows', 2, 'cat land', '', 'mallows', 'https//mallows.com'),
(4, 'anya', 2, 'taguig', '', 'anya', 'https//wagniyoakopababainsabubong'),
(5, 'moonie', 3, 'cat land', '', 'moonie', 'https//swswswswsw.com'),
(6, 'oreo', 2, 'taguig', '', 'oreo', 'https//bangs.com'),
(7, 'pol', 18, 'zamboanga', '', 'pol', 'https//AAAAAHHHHH.com'),
(8, 'pablo', 2, 'sa bahay ng kapitbahay', '', 'pablo', 'https//IhateBellyrubs.com'),
(9, 'elle', 7, 'house ni imon', '', 'elle', 'none'),
(10, 'crinkles', 2, 'taguig', '', 'crinkles', 'https//givemecatfood.com'),
(11, 'annie', 19, 'taguig', '', 'annie', '');

-- --------------------------------------------------------

--
-- Table structure for table `user_interests`
--

CREATE TABLE `user_interests` (
  `id` int(11) NOT NULL,
  `username` varchar(255) NOT NULL,
  `interest` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_interests`
--

INSERT INTO `user_interests` (`id`, `username`, `interest`) VALUES
(2, 'pablo', 'Music'),
(3, 'pablo', 'Movies'),
(4, 'pablo', 'Gaming'),
(5, 'pablo', 'Art'),
(6, 'pablo', 'Science'),
(7, 'elle', 'Music'),
(8, 'elle', 'Movies'),
(9, 'elle', 'Books'),
(10, 'elle', 'Art'),
(11, 'elle', 'Education'),
(12, 'mallows', 'Sports'),
(13, 'mallows', 'Music'),
(14, 'mallows', 'Movies'),
(15, 'mallows', 'Technology'),
(16, 'mallows', 'Travel'),
(17, 'kal', 'Sports'),
(18, 'kal', 'Music'),
(19, 'kal', 'Movies'),
(20, 'kal', 'Technology'),
(21, 'kal', 'Travel'),
(22, 'lloyd', 'Music'),
(23, 'lloyd', 'Movies'),
(24, 'lloyd', 'Gaming'),
(25, 'lloyd', 'Science'),
(26, 'lloyd', 'Photography'),
(27, 'oreo', 'Sports'),
(28, 'oreo', 'Music'),
(29, 'oreo', 'Movies'),
(30, 'oreo', 'Technology'),
(31, 'oreo', 'Travel'),
(32, 'crinkles', 'Sports'),
(33, 'crinkles', 'Music'),
(34, 'crinkles', 'Movies'),
(35, 'crinkles', 'Technology'),
(36, 'crinkles', 'Travel'),
(37, 'anya', 'Sports'),
(38, 'anya', 'Music'),
(39, 'anya', 'Movies'),
(40, 'anya', 'Books'),
(41, 'anya', 'Gaming'),
(42, 'annie', 'Sports'),
(43, 'annie', 'Music'),
(44, 'annie', 'Movies'),
(45, 'annie', 'Technology'),
(46, 'annie', 'Travel');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `friendships`
--
ALTER TABLE `friendships`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `user1` (`user1`,`user2`),
  ADD KEY `user2` (`user2`);

--
-- Indexes for table `friend_requests`
--
ALTER TABLE `friend_requests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `from_user` (`from_user`),
  ADD KEY `to_user` (`to_user`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username` (`username`);

--
-- Indexes for table `user_interests`
--
ALTER TABLE `user_interests`
  ADD PRIMARY KEY (`id`),
  ADD KEY `username` (`username`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `friendships`
--
ALTER TABLE `friendships`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `friend_requests`
--
ALTER TABLE `friend_requests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `user_interests`
--
ALTER TABLE `user_interests`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=47;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `friendships`
--
ALTER TABLE `friendships`
  ADD CONSTRAINT `friendships_ibfk_1` FOREIGN KEY (`user1`) REFERENCES `users` (`username`) ON DELETE CASCADE,
  ADD CONSTRAINT `friendships_ibfk_2` FOREIGN KEY (`user2`) REFERENCES `users` (`username`) ON DELETE CASCADE;

--
-- Constraints for table `friend_requests`
--
ALTER TABLE `friend_requests`
  ADD CONSTRAINT `friend_requests_ibfk_1` FOREIGN KEY (`from_user`) REFERENCES `users` (`username`) ON DELETE CASCADE,
  ADD CONSTRAINT `friend_requests_ibfk_2` FOREIGN KEY (`to_user`) REFERENCES `users` (`username`) ON DELETE CASCADE;

--
-- Constraints for table `user_interests`
--
ALTER TABLE `user_interests`
  ADD CONSTRAINT `user_interests_ibfk_1` FOREIGN KEY (`username`) REFERENCES `users` (`username`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
