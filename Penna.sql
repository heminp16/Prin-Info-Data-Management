CREATE TABLE `penna` (
  `ID` int DEFAULT NULL,
  `Timestamp` text,
  `state` text,
  `locality` text,
  `precinct` varchar(50) DEFAULT NULL,
  `geo` text,
  `totalvotes` int DEFAULT NULL,
  `Biden` int DEFAULT NULL,
  `Trump` int DEFAULT NULL,
  `filestamp` text,
  `Winner` text,
  KEY `precinct` (`precinct`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci