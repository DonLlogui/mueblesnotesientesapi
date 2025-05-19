const express = require('express');
const cors = require('cors');
const rutacliente = require('./vista/ClienteRutas');
//const rutaadmin = require('./vista/AdminRutas');
const app = express();
const PORT = process.env.PORT || 3333;

// Middleware
app.use(cors({
    origin: '*', // Cambiar ['http://tu.com', 'http://yo.com'],
    methods: ['GET', 'POST', 'PUT', 'DELETE'], // Métodos permitidos
    allowedHeaders: ['Content-Type', 'Authorization'], // Encabezados permitidos
    credentials: true // Habilita el envío de credenciales si es necesario
  }));

  // Middleware para parseo de solicitudes
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
//app.use(express.static(path.join(__dirname, 'public')));

// Rutas 
app.use('/', rutacliente);
//app.use('/', rutaadmin);

// Iniciar el servidor
app.listen(PORT, () => {
    console.log(`Servidor corriendo en http://localhost:${PORT}`);
  });