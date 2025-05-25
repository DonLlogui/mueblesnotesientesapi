const express = require('express');
const CRutas = require('../controlador/admin/AdminControlador');
//const LRutas = require('../controlador/usuarios/LoginClienteControlador');
const router = express.Router();

router.post('/admon', CRutas.validarDatos(5)); //admin
router.post('/cliente', CRutas.validarDatos(3)); //cliente
router.post('/vendedor', CRutas.validarDatos(8)); //vendedor
router.post('/carpintero', CRutas.validarDatos(10));//carpintero
//router.post('/login', LRutas.validarCredencial);
module.exports = router; 