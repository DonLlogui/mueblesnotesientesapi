const express = require('express');
const CRutas = require('../controlador/usuarios/ClienteControlador');
const LRutas = require('../controlador/usuarios/LoginClienteControlador');
const router = express.Router();

router.post('/usuarios', CRutas.crearCliente);
router.post('/login', LRutas.validarCredencial);
module.exports = router; 