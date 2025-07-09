const dbService = require('./bd/Conexion');
const bcrypt = require('bcrypt');

class ClienteModelo {
  // Instancia única de la clase
  static instancia;

  // Constructor privado
  constructor() {
    if (ClienteModelo.instancia) {
      return ClienteModelo.instancia;
    }
    ClienteModelo.instancia = this;
  }

  /**
   * Crear un nuevo cliente en la base de datos
   * @param {string} doc - Documento de identidad
   * @param {string} name - Nombre completo
   * @param {string} tel - Teléfono
   * @param {string} email - Correo electrónico
   * @param {string} contras - Contraseña en texto plano
   */
  async crearCliente(doc, name, tel, email, contras) {
    const query = `
      INSERT INTO usuarios 
      (documento, nombres, telefono, correo, contrasena, fechaCreacion) 
      VALUES (?, ?, ?, ?, ?, ?)`;

    try {
      const saltRounds = 10;
      const hashedPassword = await bcrypt.hash(contras, saltRounds);
      const fechaCreacion = new Date();

      return await dbService.query(query, [doc, name, tel, email, hashedPassword, fechaCreacion]);
    } catch (err) {
      throw new Error(`Error al crear su nueva cuenta: ${err.message}`);
    }
  }

  // Método para obtener la instancia única
  static getInstancia() {
    if (!ClienteModelo.instancia) {
      ClienteModelo.instancia = new ClienteModelo();
    }
    return ClienteModelo.instancia;
  }
}

module.exports = ClienteModelo;
