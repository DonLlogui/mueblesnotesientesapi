 const dbService = require('./bd/Conexion');
const crypto = require('crypto');

class LoginClienteModelo {
  static async buscarCorreo(email) {
    const query = 'SELECT idUsuario, nombres, correo, rol, contrasena, estado FROM usuarios WHERE correo = ?';
    try {
      const result = await dbService.query(query, [email]);
      return result.length ? result[0] : null;
    } catch (err) {
      throw new Error(`Error al buscar el usuario: ${err.message}`);
    }
  }//cerrar buscarcorreo

  static generarLlaveSegura() {
    return crypto.randomBytes(32).toString('hex');
  }

  static async guardarToken({ idUsuario, nombres, rol, correo, llave }) {
    const query = 'INSERT INTO token (idToken, usuario, rol, correo, llave) VALUES (?, ?, ?, ?, ?)';
    try {
      await dbService.query(query, [idUsuario, nombres, rol, correo,llave]);
    } catch (err) {
      throw new Error(`Error al guardar el token: ${err.message}`);
    }
  }//cerrar guardar token
  static async incrementarIntentoFallido(correo) {
  const query = `
    UPDATE usuarios 
    SET intentosFallidos = intentosFallidos + 1 
    WHERE correo = ?
  `;
  await dbService.query(query, [correo]);

  // Obtener intentos actualizados
  const result = await dbService.query('SELECT intentosFallidos FROM usuarios WHERE correo = ?', [correo]);
  const intentos = result[0]?.intentosFallidos || 0;

  // Si llegó a 3, bloquear usuario
  if (intentos >= 3) {
    await dbService.query('UPDATE usuarios SET estado = "Bloqueado" WHERE correo = ?', [correo]);
  }
}

static async resetearIntentosFallidos(correo) {
  const query = 'UPDATE usuarios SET intentosFallidos = 0 WHERE correo = ?';
  await dbService.query(query, [correo]);
}

static async intentos(correo) {
  const result = await dbService.query('SELECT intentosFallidos FROM usuarios WHERE correo = ?', [correo]);
  return result[0]?.intentosFallidos || 0;
}
}

module.exports = LoginClienteModelo;
