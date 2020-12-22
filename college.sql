-- phpMyAdmin SQL Dump
-- version 5.0.3
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 22, 2020 at 01:53 AM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.2.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `college`
--

-- --------------------------------------------------------

--
-- Table structure for table `campus`
--

CREATE TABLE `campus` (
  `name` varchar(8) COLLATE latin1_spanish_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `class`
--

CREATE TABLE `class` (
  `crn` int(11) NOT NULL,
  `course` varchar(8) COLLATE latin1_spanish_ci NOT NULL,
  `period` varchar(16) COLLATE latin1_spanish_ci NOT NULL,
  `teacher` int(10) UNSIGNED NOT NULL,
  `days` enum('MON-THU','TUE-FRI','WED','SAT','WEEKDAYS','OTHER','MON-WED-THU','MON-TUE-FRI','TUE-THU','TUE-WED-THU','MON-WED','TUE-FRI','TUE') COLLATE latin1_spanish_ci DEFAULT NULL,
  `hour` time DEFAULT NULL,
  `length` enum('1.5','3') COLLATE latin1_spanish_ci NOT NULL DEFAULT '1.5',
  `classroom` varchar(32) COLLATE latin1_spanish_ci DEFAULT NULL,
  `abs_limit` int(10) UNSIGNED DEFAULT 4,
  `grade_first` int(10) UNSIGNED DEFAULT NULL,
  `abs_1` int(10) UNSIGNED DEFAULT NULL,
  `grade_second` int(10) UNSIGNED DEFAULT NULL,
  `abs_2` int(10) UNSIGNED DEFAULT NULL,
  `grade_exam` int(10) UNSIGNED DEFAULT NULL,
  `abs_3` int(10) UNSIGNED DEFAULT NULL,
  `grade_final` int(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `course`
--

CREATE TABLE `course` (
  `id` varchar(8) COLLATE latin1_spanish_ci NOT NULL,
  `name` varchar(64) COLLATE latin1_spanish_ci NOT NULL,
  `campus` varchar(8) COLLATE latin1_spanish_ci NOT NULL DEFAULT 'UDEM',
  `credits` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- --------------------------------------------------------

--
-- Table structure for table `period`
--

CREATE TABLE `period` (
  `name` varchar(16) COLLATE latin1_spanish_ci NOT NULL,
  `campus` varchar(8) COLLATE latin1_spanish_ci NOT NULL DEFAULT 'UDEM',
  `start` date NOT NULL,
  `end` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- --------------------------------------------------------

--
-- Stand-in structure for view `semester_current`
-- (See below for the actual view)
--
CREATE TABLE `semester_current` (
`Class` varchar(64)
,`Teacher` varchar(32)
,`abs_1` int(10) unsigned
,`abs_2` int(10) unsigned
,`abs_3` int(10) unsigned
,`grade_first` int(10) unsigned
,`grade_second` int(10) unsigned
,`grade_exam` int(10) unsigned
,`grade_final` int(10)
);

-- --------------------------------------------------------

--
-- Table structure for table `teacher`
--

CREATE TABLE `teacher` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(32) COLLATE latin1_spanish_ci NOT NULL,
  `last_name` varchar(32) COLLATE latin1_spanish_ci NOT NULL,
  `office_day` enum('MON','TUE','WED','THU','FRI') COLLATE latin1_spanish_ci DEFAULT NULL,
  `office_from` time DEFAULT NULL,
  `office_to` time DEFAULT NULL,
  `email` varchar(64) COLLATE latin1_spanish_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1 COLLATE=latin1_spanish_ci;

-- --------------------------------------------------------

--
-- Structure for view `semester_current`
--
DROP TABLE IF EXISTS `semester_current`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `semester_current`  AS SELECT DISTINCT `course`.`name` AS `Class`, `teacher`.`name` AS `Teacher`, `class`.`abs_1` AS `abs_1`, `class`.`abs_2` AS `abs_2`, `class`.`abs_3` AS `abs_3`, `class`.`grade_first` AS `grade_first`, `class`.`grade_second` AS `grade_second`, `class`.`grade_exam` AS `grade_exam`, `class`.`grade_final` AS `grade_final` FROM ((`course` join `teacher`) join `class`) WHERE `class`.`course` = `course`.`id` AND `class`.`teacher` = `teacher`.`id` AND `class`.`period` = (select `period`.`name` from `period` order by `period`.`start` desc limit 1) ORDER BY `course`.`credits` DESC ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `campus`
--
ALTER TABLE `campus`
  ADD PRIMARY KEY (`name`);

--
-- Indexes for table `class`
--
ALTER TABLE `class`
  ADD PRIMARY KEY (`crn`),
  ADD KEY `period` (`period`),
  ADD KEY `course` (`course`),
  ADD KEY `teacher` (`teacher`);

--
-- Indexes for table `course`
--
ALTER TABLE `course`
  ADD PRIMARY KEY (`id`),
  ADD KEY `campus` (`campus`);

--
-- Indexes for table `period`
--
ALTER TABLE `period`
  ADD PRIMARY KEY (`name`),
  ADD KEY `campus` (`campus`);

--
-- Indexes for table `teacher`
--
ALTER TABLE `teacher`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `teacher`
--
ALTER TABLE `teacher`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `class`
--
ALTER TABLE `class`
  ADD CONSTRAINT `class_ibfk_1` FOREIGN KEY (`course`) REFERENCES `course` (`id`),
  ADD CONSTRAINT `class_ibfk_2` FOREIGN KEY (`teacher`) REFERENCES `teacher` (`id`),
  ADD CONSTRAINT `class_ibfk_3` FOREIGN KEY (`period`) REFERENCES `period` (`name`);

--
-- Constraints for table `course`
--
ALTER TABLE `course`
  ADD CONSTRAINT `course_ibfk_1` FOREIGN KEY (`campus`) REFERENCES `campus` (`name`);

--
-- Constraints for table `period`
--
ALTER TABLE `period`
  ADD CONSTRAINT `period_ibfk_1` FOREIGN KEY (`campus`) REFERENCES `campus` (`name`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
