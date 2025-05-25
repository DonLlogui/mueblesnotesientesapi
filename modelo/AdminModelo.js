//------------------este es admin mdelo ------------------------
const dbService = require('./bd/Conexion');
const bcrypt = require('bcrypt');

class AdminModelo {
  static async crearUsuario(doc, name, tel, email, contras, rol) {
    const query = 'INSERT INTO usuarios (documento, nombres, telefono, correo, contrasena, rol, fechaCreacion) VALUES (?, ?, ?, ?, ?, ?, ?)';

    try {
      const saltRounds = 10;
      const contraHasheada = await bcrypt.hash(contras, saltRounds);
      const fecha = new Date();

      return await dbService.query(query, [doc, name, tel, email, contraHasheada, rol, fecha]);
    } catch (err) {
      throw new Error(`Error al crear la cuenta de tipo ${rol}: ${err.message}`);
    }
  }

  static async crearAdmin(doc, name, tel, email, contras) {
    return this.crearUsuario(doc, name, tel, email, contras, 'Admin');
  }

  static async crearCliente(doc, name, tel, email, contras) {
    return this.crearUsuario(doc, name, tel, email, contras, 'Cliente');
  }

  static async crearCarpintero(doc, name, tel, email, contras) {
    return this.crearUsuario(doc, name, tel, email, contras, 'Carpintero');
  }

  static async crearVendedor(doc, name, tel, email, contras) {
    return this.crearUsuario(doc, name, tel, email, contras, 'Vendedor');
  }
}

module.exports = AdminModelo;