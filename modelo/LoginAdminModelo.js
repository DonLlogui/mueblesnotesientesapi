 const dbService = require('./bd/Conexion');
const crypto = require('crypto');

class LoginAdminModelo {
  //busca por correo el usuario para el login
  static async buscarCorreo(email) {
    const query = 'SELECT idUsuario, nombres, correo, rol, contrasena, estado FROM usuarios WHERE correo = ? AND rol = ?';
    try {
      const result = await dbService.query(query, [email, "Admin"]);
      return result.length ? result[0] : null;
    } catch (err) {
      throw new Error(`Error al buscar el usuario: ${err.message}`);
    }
  }//cerrar buscarcorreo
    //este genera el token para no estar verificando contraseña
  static generarLlaveSegura() {
    return crypto.randomBytes(32).toString('hex');
  }
    //cuando se entra al sistema genera un registro con una llave
    //ya que con esta sera la que mantiene la secion
  static async guardarToken({ idUsuario, nombres, rol, correo, llave }) {
    const query = 'INSERT INTO token (idToken, usuario, rol, correo, llave) VALUES (?, ?, ?, ?, ?)';
    try {
      await dbService.query(query, [idUsuario, nombres, rol, correo,llave]);
    } catch (err) {
      throw new Error(`Error al guardar el token: ${err.message}`);
    }
  }//cerrar guardar token
  //esta hace que aumente el campo cada vez que no pueda entrar
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

  // Si llegó a 3 initentos fallidos, bloquear usuario
  if (intentos >= 3) {
    await dbService.query('UPDATE usuarios SET estado = "Bloqueado" WHERE correo = ?', [correo]);
  }
}

//esta recetea a cero cuando logra entrar
static async resetearIntentosFallidos(correo) {
  const query = 'UPDATE usuarios SET intentosFallidos = 0 WHERE correo = ?';
  await dbService.query(query, [correo]);
}
//esta verifica los intentos para bloquear si pasa o llega a 3
static async intentos(correo) {
  const result = await dbService.query('SELECT intentosFallidos FROM usuarios WHERE correo = ?', [correo]);
  return result[0]?.intentosFallidos || 0;
}
//esta para verificar si ya tiene secion abierta
static async buscartoken(email) {
    const query = 'SELECT idToken, correo, llave  FROM token WHERE correo = ?';
    try {
      const result = await dbService.query(query, [email]);
      return result.length ? result[0] : null;
    } catch (err) {
      throw new Error(`No existe token: ${err.message}`);
    }
  }//cerrar buscarcorreo
  
}

module.exports = LoginAdminModelo;
