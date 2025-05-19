const express = require('express');
const CRutas = require('../controlador/ClienteControlador');
const LRutas = require('../controlador/LoginClienteControlador');
const router = express.Router();

router.post('/usuarios', CRutas.crearCliente);
router.post('/login', LRutas.validarCredencial);
module.exports = router; 