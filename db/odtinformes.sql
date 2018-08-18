CREATE TABLE `odtinformes` (
  `codigoInforme` int(11) NOT NULL,
  `numeroInforme` varchar(255) DEFAULT NULL,
  `nombreInforme` varchar(50) DEFAULT NULL,
  `desdeInforme` date DEFAULT NULL,
  `hastaInforme` date DEFAULT NULL,
  `fechaCreacion` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `mnCreacion` varchar(10) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Índices para tablas volcadas
--

--
-- Indices de la tabla `odtinformes`
--
ALTER TABLE `odtinformes`
  ADD PRIMARY KEY (`codigoInforme`);

--
-- AUTO_INCREMENT de las tablas volcadas
--

--
-- AUTO_INCREMENT de la tabla `odtinformes`
--
ALTER TABLE `odtinformes`
  MODIFY `codigoInforme` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;