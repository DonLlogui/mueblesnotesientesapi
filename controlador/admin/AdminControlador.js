const modelo = require('../../modelo/AdminModelo');

class AdminControlador {
    static validarDatos(cuenta) {
      return async (req, res) => {
        const { t1: doc, t2: name, t3: tel, t4: email, t5: contra } = req.body;

        // Validaciones
        const errorCampos = this.verCampos(doc, name, tel, email, contra);
        if (errorCampos) return res.status(400).json({ error: errorCampos });

        const erorIde = this.verIde(doc);
        if (erorIde) return res.status(400).json({ error: erorIde });

        const errornom = this.vernom(name);
        if (errornom) return res.status(400).json({ error: errornom });

        const errortel = this.verTel(tel);
        if (errortel) return res.status(400).json({ error: errortel });

        const errorem = this.veremail(email);
        if (errorem) return res.status(400).json({ error: errorem });

        const errorkey = this.verkey(contra);
        if (errorkey) return res.status(400).json({ error: errorkey });

        try {
            let result;

            switch (cuenta) {
                case 3:
                    result = await modelo.crearCliente(doc, name, tel, email, contra);
                    break;
                case 5:
                    result = await modelo.crearAdmin(doc, name, tel, email, contra);
                    break;
                case 8:
                    result = await modelo.crearVendedor(doc, name, tel, email, contra);
                    break;
                case 10:
                    result = await modelo.crearCarpintero(doc, name, tel, email, contra);
                    break;
                default:
                    return res.status(401).json({ mensaje: 'Área no permitida para crear cuenta.' });
            }

            res.status(201).json({ mensaje: 'Usuario creado correctamente.', id: result.insertId });
        } catch (err) {
            if (err.message.includes("Duplicate entry")) {
                return res.status(409).json({ error: 'Ya existe un usuario con estos datos. Sugerencia: intenta recuperar la cuenta o inicia sesión.' });
            }
            return res.status(500).json({ error: 'Error inesperado: ' + err.message });
        }
      }
    }
    // Validaciones
    static verCampos(doc, name, tel, email, contra) {
        if (!doc || !name || !tel || !email || !contra) {
            return 'Todos los campos son obligatorios.';
        }
        return null;
    }

    static verIde(doc) {
        return /^\d{8,10}$/.test(doc) ? null : 'La identificación debe tener entre 8 y 10 dígitos numéricos.';
    }

    static vernom(name) {
        const regex = /^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]{3,100}$/;
        return regex.test(name)
            ? null
            : 'Nombres inválidos. Solo letras, entre 3 y 100 caracteres.';
    }

    static verTel(tel) {
        return /^\d{10}$/.test(tel) ? null : 'El teléfono debe tener exactamente 10 dígitos numéricos.';
    }

    static veremail(email) {
        const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return regex.test(email) && email.length <= 200
            ? null
            : 'Correo inválido. Ejemplo válido: ejemplo@email.com';
    }

    static verkey(contra) {
        const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
        return regex.test(contra)
            ? null
            : 'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un símbolo.';
    }
}

module.exports = AdminControlador;
