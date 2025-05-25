-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 25-05-2025 a las 13:02:52
-- Versión del servidor: 8.0.30
-- Versión de PHP: 8.1.10

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de datos: `mueblenotesiente`
--

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perfil`
--

CREATE TABLE `perfil` (
  `idPerfil` int NOT NULL,
  `documento` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `nombres` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `telefono` varchar(10) COLLATE utf8mb4_general_ci NOT NULL,
  `correo` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `respuesta1` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `respuesta2` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `respuesta3` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `direccion` varchar(255) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fechaexpedicion` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `perfil`
--

INSERT INTO `perfil` (`idPerfil`, `documento`, `nombres`, `telefono`, `correo`, `respuesta1`, `respuesta2`, `respuesta3`, `direccion`, `fechaexpedicion`) VALUES
(1, '1234567890', 'Pepito Perez Perez', '3001111111', 'pepito@gmail.com', NULL, NULL, NULL, NULL, NULL),
(2, '1234567891', 'Juanito sukenber Gate', '3001111112', 'juanito@gmail.com', NULL, NULL, NULL, NULL, NULL),
(3, '1010101010', 'guillo', '3013333333', 'guillo@gmail.com', NULL, NULL, NULL, NULL, NULL),
(4, '1234567820', 'Bill Gate', '3002222222', 'bill@gmail.com', NULL, NULL, NULL, NULL, NULL),
(6, '1234567830', 'Pajaro Carpintero', '3004444444', 'pajaro@gmail.com', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `token`
--

CREATE TABLE `token` (
  `idToken` int NOT NULL,
  `usuario` varchar(100) COLLATE utf8mb4_general_ci NOT NULL,
  `rol` varchar(20) COLLATE utf8mb4_general_ci NOT NULL,
  `correo` varchar(200) COLLATE utf8mb4_general_ci NOT NULL,
  `llave` varchar(255) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `usuarios`
--

CREATE TABLE `usuarios` (
  `idUsuario` int NOT NULL,
  `documento` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nombres` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `telefono` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `correo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `contrasena` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `rol` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Cliente',
  `estado` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Activo',
  `fechaCreacion` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `intentosFallidos` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`idUsuario`, `documento`, `nombres`, `telefono`, `correo`, `contrasena`, `rol`, `estado`, `fechaCreacion`, `intentosFallidos`) VALUES
(1, '1234567890', 'Pepito Perez Perez', '3001111111', 'pepito@gmail.com', '$2b$10$yrkvpQDGry9kZoS06cZj2ONZxr4vIWV9NeTu/cPIBSo7Bjssf9MdO', 'Cliente', 'Activo', '2025-05-24 19:28:51.803', 0),
(2, '1234567891', 'Juanito sukenber Gate', '3001111112', 'juanito@gmail.com', '$2b$10$Vs90UYRrVZgyShTsYlpxT.VGS2KRsSKnGX/YEr9/X.uIRM3jJmQ.a', 'Cliente', 'Activo', '2025-05-24 19:31:33.325', 0),
(3, '1010101010', 'guillo', '3013333333', 'guillo@gmail.com', '$2b$10$dP4vampemteA6TB2fJGyaOEZ25I7hwyN4qdQREDfwkKsCI3X/1Z7e', 'Admin', 'Activo', '2025-05-24 19:33:41.216', 0),
(4, '1234567820', 'Bill Gate', '3002222222', 'bill@gmail.com', '$2b$10$Pi/9DO3yaQ1LwXJSQJOgF.LKwLQ5i1K401GvaImH9tbOV2/ggewoa', 'Vendedor', 'Activo', '2025-05-24 19:36:30.165', 0),
(6, '1234567830', 'Pajaro Carpintero', '3004444444', 'pajaro@gmail.com', '$2b$10$WEIqV9Ay6rCUQptUUBZ5cuymGpMuJwx8.Lt/FH9MIm6jIKRc.0SRm', 'Carpintero', 'Activo', '2025-05-24 19:41:01.538', 0);

--
-- Disparadores `usuarios`
--
DELIMITER $$
CREATE TRIGGER `crear_perfil_despues_usuario` AFTER INSERT ON `usuarios` FOR EACH ROW BEGIN
  INSERT INTO perfil (
    idPerfil,
    documento,
    nombres,
    telefono,
    correo
  ) VALUES (
    NEW.idUsuario,
    NEW.documento,
    NEW.nombres,
    NEW.telefono,
    NEW.correo
  );
END
$$
DELIMITER ;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `perfil`
--
ALTER TABLE `perfil`
  ADD PRIMARY KEY (`idPerfil`),
  ADD UNIQUE KEY `documento` (`documento`),
  ADD UNIQUE KEY `telefono` (`telefono`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `token`
--
ALTER TABLE `token`
  ADD PRIMARY KEY (`idToken`),
  ADD UNIQUE KEY `usuario` (`usuario`),
  ADD UNIQUE KEY `correo` (`correo`),
  ADD UNIQUE KEY `llave` (`llave`);

--
-- Indices de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  ADD PRIMARY KEY (`idUsuario`),
  ADD UNIQUE KEY `documento` (`documento`),
  ADD UNIQUE KEY `telefono` (`telefono`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idUsuario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
