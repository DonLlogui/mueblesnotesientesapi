const bcrypt = require('bcrypt');
const modelo = require('../modelo/LoginClienteModelo');

class LoginClienteControlador {
    static async validarCredencial(req, res) {
        const { t1: email, t2: contra } = req.body;

        if (!email || !contra) {
            return res.status(400).json({ error: 'Correo y contraseña son obligatorios' });
        }

        try {
            const usuario = await modelo.buscarCorreo(email);

            if (!usuario) {
                return res.status(401).json({ error: 'Usuario no encontrado' });
            }
            //verifica si el usuario esta activo
            if (usuario.estado !== 'Activo') {
                return res.status(403).json({ error: 'Usuario bloqueado. Consulte con el administrador.' });
            }

            const coincide = await bcrypt.compare(contra, usuario.contrasena);

            if (!coincide) {
                await modelo.incrementarIntentoFallido(email);

                // Consultar si ya está bloqueado para enviar el mensaje adecuado
                const actualizado = await modelo.buscarCorreo(email);
                if (actualizado.estado === 'Bloqueado') {
                    return res.status(403).json({ error: 'Cuenta bloqueada por múltiples intentos fallidos.' });
                }
                 const intentos = await modelo.intentos(email);
                return res.status(401).json({ error: 'Contraseña incorrecta',
                    Intentos: intentos + ' De 3 posibles al sobrepasar será bloqueada la cuenta'
                 });
            }

            const llave = modelo.generarLlaveSegura();

            await modelo.guardarToken({
                idUsuario: usuario.idUsuario,
                nombres: usuario.nombres,
                rol: usuario.rol,
                correo: usuario.correo,
                llave
            });

            // Eliminar contraseña del objeto usuario
            const { contrasena, ...usuarioSinContrasena } = usuario;

            res.json({
                mensaje: `Bienvenido ${usuario.rol} ${usuario.nombres}`,
                usuario: usuarioSinContrasena,
                token: llave
            });

        } catch (err) {
            res.status(500).json({ error: `Error interno del servidor: ${err.message}` });
        }
    }
}

module.exports = LoginClienteControlador;
