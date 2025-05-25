const express = require('express');
const ARutas = require('../controlador/admin/AdminControlador');
const LARutas = require('../controlador/admin/LoginAdminControlador');
const router = express.Router();

router.post('/admon', ARutas.validarDatos(5)); //admin
router.post('/cliente', ARutas.validarDatos(3)); //cliente
router.post('/vendedor', ARutas.validarDatos(8)); //vendedor
router.post('/carpintero', ARutas.validarDatos(10));//carpintero
router.post('/login', LARutas.validarCredencial);
module.exports = router; 