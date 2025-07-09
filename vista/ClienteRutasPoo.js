const express = require('express');
const ClienteControlador = require('../controlador/usuarios/ClienteControlador');
const LoginClienteControlador = require('../controlador/usuarios/LoginClienteControlador');

class UsuarioRutas {
  static instancia;

  constructor() {
    if (UsuarioRutas.instancia) {
      return UsuarioRutas.instancia;
    }

    this.router = express.Router();
    this.clienteControlador = ClienteControlador.getInstancia();
    this.loginControlador = LoginClienteControlador.getInstancia();

    this.configurarRutas();

    UsuarioRutas.instancia = this;
  }

  configurarRutas() {
    this.router.post('/usuarios', (req, res) => this.clienteControlador.crearCliente(req, res));
    this.router.post('/login', (req, res) => this.loginControlador.validarCredencial(req, res));
  }

  getRouter() {
    return this.router;
  }

  static getInstancia() {
    if (!UsuarioRutas.instancia) {
      UsuarioRutas.instancia = new UsuarioRutas();
    }
    return UsuarioRutas.instancia;
  }
}

module.exports = UsuarioRutas;
