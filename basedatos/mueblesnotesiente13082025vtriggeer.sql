-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Servidor: localhost:3306
-- Tiempo de generación: 13-08-2025 a las 17:13:14
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
-- Estructura de tabla para la tabla `detalles`
--

CREATE TABLE `detalles` (
  `IdDetalle` int NOT NULL,
  `idFactura` int NOT NULL,
  `idRegProducto` int NOT NULL,
  `cantidad` int NOT NULL,
  `precioUnitario` double(10,2) NOT NULL,
  `subtotal` double(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Disparadores `detalles`
--
DELIMITER $$
CREATE TRIGGER `guardar_detalle` BEFORE INSERT ON `detalles` FOR EACH ROW BEGIN
  DECLARE current_stock INT;
  DECLARE current_estado VARCHAR(30);

  -- 1. Obtener el stock actual del producto
  SELECT stock INTO current_stock
  FROM regprductos
  WHERE idRegProducto = NEW.idRegProducto;

  -- 2. Validar si hay suficiente stock
  IF current_stock < NEW.cantidad THEN
    SIGNAL SQLSTATE '45000'
    SET MESSAGE_TEXT = 'Stock insuficiente para registrar el detalle.';
  END IF;

  -- 3. Calcular el subtotal
  SET NEW.subtotal = NEW.cantidad * NEW.precioUnitario;

  -- 4. Descontar del stock
  UPDATE regprductos
  SET stock = stock - NEW.cantidad
  WHERE idRegProducto = NEW.idRegProducto;

  -- 5. Cambiar estado si el stock llega a cero
  UPDATE regprductos
  SET estado = 'No disponible'
  WHERE idRegProducto = NEW.idRegProducto AND stock - NEW.cantidad <= 0;

END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `factura`
--

CREATE TABLE `factura` (
  `idFactura` int NOT NULL,
  `idUsuario` int NOT NULL,
  `fecha` varchar(30) COLLATE utf8mb4_general_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perfil`
--

CREATE TABLE `perfil` (
  `idPerfil` int NOT NULL,
  `documento` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nombres` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `telefono` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `correo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `respuesta1` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `respuesta2` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `respuesta3` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `direccion` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `fechaexpedicion` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `perfil`
--

INSERT INTO `perfil` (`idPerfil`, `documento`, `nombres`, `telefono`, `correo`, `respuesta1`, `respuesta2`, `respuesta3`, `direccion`, `fechaexpedicion`) VALUES
(1, '1234567890', 'Pepito Perez Perez', '3001111111', 'pepito@gmail.com', NULL, NULL, NULL, NULL, NULL),
(2, '1234567891', 'Juanito sukenber Gate', '3001111112', 'juanito@gmail.com', NULL, NULL, NULL, NULL, NULL),
(3, '1010101010', 'guillo', '3013333333', 'guillo@gmail.com', NULL, NULL, NULL, NULL, NULL),
(4, '1234567820', 'Bill Gate', '3002222222', 'bill@gmail.com', NULL, NULL, NULL, NULL, NULL),
(6, '1234567830', 'Pajaro Carpintero', '3004444444', 'pajaro@gmail.com', NULL, NULL, NULL, NULL, NULL),
(7, '6666666666', 'ficha setenta', '3333333333', 'ficha@gmail.com', NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `producto`
--

CREATE TABLE `producto` (
  `idProducto` int NOT NULL,
  `producto` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `descripcion` varchar(255) COLLATE utf8mb4_general_ci NOT NULL,
  `estado` varchar(30) COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Disponible'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `producto`
--

INSERT INTO `producto` (`idProducto`, `producto`, `descripcion`, `estado`) VALUES
(1, 'silla clic clac', 'silla clic clac color gris patas en acero inoxidable quirurgico ', 'Disponible'),
(2, 'silla poltrona', 'silla poltrona patas en madera pintadas acabado  negro mate', 'Disponible');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `regprductos`
--

CREATE TABLE `regprductos` (
  `idRegProducto` int NOT NULL,
  `idProducto` int NOT NULL,
  `cantidad` int NOT NULL,
  `stock` int NOT NULL,
  `precioCompra` double(10,2) NOT NULL,
  `precioVentaMenor` double(10,2) NOT NULL,
  `precioVentaMayor` double(10,2) NOT NULL,
  `fechaRegistro` varchar(50) COLLATE utf8mb4_general_ci NOT NULL,
  `lote` varchar(30) COLLATE utf8mb4_general_ci NOT NULL,
  `garantia` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `estado` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'Disponible'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `regprductos`
--

INSERT INTO `regprductos` (`idRegProducto`, `idProducto`, `cantidad`, `stock`, `precioCompra`, `precioVentaMenor`, `precioVentaMayor`, `fechaRegistro`, `lote`, `garantia`, `estado`) VALUES
(1, 1, 15, 15, 400000.00, 600000.00, 560000.00, '6-08-2025', 'sm06-08-2025', '1', 'Disponible'),
(2, 2, 10, 10, 400000.00, 600000.00, 560000.00, '6-08-2025', 'pt06-08-2025', '1', 'Disponible');

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `token`
--

CREATE TABLE `token` (
  `idToken` int NOT NULL,
  `usuario` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `rol` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `correo` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `llave` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL
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
  `fechaCreacion` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `intentosFallidos` int NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Volcado de datos para la tabla `usuarios`
--

INSERT INTO `usuarios` (`idUsuario`, `documento`, `nombres`, `telefono`, `correo`, `contrasena`, `rol`, `estado`, `fechaCreacion`, `intentosFallidos`) VALUES
(1, '1234567890', 'Pepito Perez Perez', '3001111111', 'pepito@gmail.com', '$2b$10$yrkvpQDGry9kZoS06cZj2ONZxr4vIWV9NeTu/cPIBSo7Bjssf9MdO', 'Cliente', 'Activo', '2025-05-24 19:28:51.803', 2),
(2, '1234567891', 'Juanito sukenber Gate', '3001111112', 'juanito@gmail.com', '$2b$10$Vs90UYRrVZgyShTsYlpxT.VGS2KRsSKnGX/YEr9/X.uIRM3jJmQ.a', 'Cliente', 'Activo', '2025-05-24 19:31:33.325', 0),
(3, '1010101010', 'guillo', '3013333333', 'guillo@gmail.com', '$2b$10$dP4vampemteA6TB2fJGyaOEZ25I7hwyN4qdQREDfwkKsCI3X/1Z7e', 'Admin', 'Activo', '2025-05-24 19:33:41.216', 0),
(4, '1234567820', 'Bill Gate', '3002222222', 'bill@gmail.com', '$2b$10$Pi/9DO3yaQ1LwXJSQJOgF.LKwLQ5i1K401GvaImH9tbOV2/ggewoa', 'Vendedor', 'Activo', '2025-05-24 19:36:30.165', 0),
(6, '1234567830', 'Pajaro Carpintero', '3004444444', 'pajaro@gmail.com', '$2b$10$WEIqV9Ay6rCUQptUUBZ5cuymGpMuJwx8.Lt/FH9MIm6jIKRc.0SRm', 'Carpintero', 'Activo', '2025-05-24 19:41:01.538', 0),
(7, '6666666666', 'ficha setenta', '3333333333', 'ficha@gmail.com', '$2b$10$Tr..Tt7sECNgLajtCpWhUe2E/rfBU9WmyiCupGaFmZLV6snEVhZxO', 'Cliente', 'Activo', '2025-05-30 11:35:29.840', 0);

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
-- Indices de la tabla `detalles`
--
ALTER TABLE `detalles`
  ADD PRIMARY KEY (`IdDetalle`),
  ADD KEY `idRegProducto` (`idRegProducto`),
  ADD KEY `idFactura` (`idFactura`);

--
-- Indices de la tabla `factura`
--
ALTER TABLE `factura`
  ADD PRIMARY KEY (`idFactura`),
  ADD KEY `idUsuario` (`idUsuario`);

--
-- Indices de la tabla `perfil`
--
ALTER TABLE `perfil`
  ADD PRIMARY KEY (`idPerfil`),
  ADD UNIQUE KEY `documento` (`documento`),
  ADD UNIQUE KEY `telefono` (`telefono`),
  ADD UNIQUE KEY `correo` (`correo`);

--
-- Indices de la tabla `producto`
--
ALTER TABLE `producto`
  ADD PRIMARY KEY (`idProducto`),
  ADD UNIQUE KEY `producto` (`producto`);

--
-- Indices de la tabla `regprductos`
--
ALTER TABLE `regprductos`
  ADD PRIMARY KEY (`idRegProducto`),
  ADD KEY `idProducto` (`idProducto`);

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
-- AUTO_INCREMENT de la tabla `detalles`
--
ALTER TABLE `detalles`
  MODIFY `IdDetalle` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `factura`
--
ALTER TABLE `factura`
  MODIFY `idFactura` int NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT de la tabla `producto`
--
ALTER TABLE `producto`
  MODIFY `idProducto` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `regprductos`
--
ALTER TABLE `regprductos`
  MODIFY `idRegProducto` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT de la tabla `usuarios`
--
ALTER TABLE `usuarios`
  MODIFY `idUsuario` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- Restricciones para tablas volcadas
--

--
-- Filtros para la tabla `detalles`
--
ALTER TABLE `detalles`
  ADD CONSTRAINT `detalles_ibfk_1` FOREIGN KEY (`idFactura`) REFERENCES `factura` (`idFactura`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `detalles_ibfk_2` FOREIGN KEY (`idRegProducto`) REFERENCES `regprductos` (`idRegProducto`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `factura`
--
ALTER TABLE `factura`
  ADD CONSTRAINT `factura_ibfk_1` FOREIGN KEY (`idUsuario`) REFERENCES `usuarios` (`idUsuario`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Filtros para la tabla `regprductos`
--
ALTER TABLE `regprductos`
  ADD CONSTRAINT `regprductos_ibfk_1` FOREIGN KEY (`idProducto`) REFERENCES `producto` (`idProducto`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
