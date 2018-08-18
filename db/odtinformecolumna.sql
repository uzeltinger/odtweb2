CREATE TABLE `odtinformecolumna` (
  `idInfoCol` int(11) NOT NULL,
  `idInforme` int(11) NOT NULL,
  `idColumna` varchar(255) DEFAULT NULL,
  `nombreColumna` varchar(255) DEFAULT NULL,
  `colMostrar` tinyint(1) NOT NULL,
  `colNombre` varchar(255) NOT NULL,
  `colFiltrar` tinyint(1) NOT NULL,
  `colFiltro` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `odtinformecolumna`
--
ALTER TABLE `odtinformecolumna`
  ADD PRIMARY KEY (`idInfoCol`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `odtinformecolumna`
--
ALTER TABLE `odtinformecolumna`
  MODIFY `idInfoCol` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;