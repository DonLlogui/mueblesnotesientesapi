const ClienteModelo = require('../../modelo/ClienteModelo');

class ClienteControlador {
  static instancia;

  constructor() {
    if (ClienteControlador.instancia) {
      return ClienteControlador.instancia;
    }

    this.modelo = ClienteModelo.getInstancia(); // Usamos el Singleton del modelo
    ClienteControlador.instancia = this;
  }

  // Método para crear cliente
  async crearCliente(req, res) {
    const { t1: doc, t2: name, t3: tel, t4: email, t5: contra } = req.body;

    // Validaciones
    const error = this.validarCampos(doc, name, tel, email, contra);
    if (error) {
      return res.status(400).json({ error });
    }

    try {
      const result = await this.modelo.crearCliente(doc, name, tel, email, contra);
      return res.status(201).json({ mensaje: 'Usuario creado', id: result.insertId });
    } catch (err) {
      if (err.message.includes("Duplicate entry")) {
        return res.status(409).json({
          error: 'Ya existe un usuario con estos datos. Sugerencia: intenta recuperar la cuenta o inicia sesión.'
        });
      } else {
        return res.status(500).json({ error: 'Error inesperado: ' + err.message });
      }
    }
  }

  // ✅ Método de validación general
  validarCampos(doc, name, tel, email, contra) {
    return (
      this.verCampos(doc, name, tel, email, contra) ||
      this.verIde(doc) ||
      this.verNom(name) ||
      this.verTel(tel) ||
      this.verEmail(email) ||
      this.verKey(contra)
    );
  }

  verCampos(doc, name, tel, email, contra) {
    if (!doc || !name || !tel || !email || !contra) {
      return 'Todos los campos son obligatorios.';
    }
    return null;
  }

  verIde(doc) {
    if (!/^\d{8,10}$/.test(doc)) {
      return 'La identificación debe tener entre 8 y 10 dígitos numéricos.';
    }
    return null;
  }

  verNom(name) {
    const regex = /^[A-Za-zÁÉÍÓÚáéíóúÑñ\s]{3,100}$/;
    if (!regex.test(name)) {
      return 'Nombres y apellidos inválidos. Deben tener entre 3 y 100 caracteres y solo letras.';
    }
    return null;
  }

  verTel(tel) {
    if (!/^\d{10}$/.test(tel)) {
      return 'El teléfono debe tener exactamente 10 dígitos numéricos.';
    }
    return null;
  }

  verEmail(email) {
    const regex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!regex.test(email) || email.length > 200) {
      return 'Correo inválido. Ejemplo válido: ejemplo@email.com';
    }
    return null;
  }

  verKey(contra) {
    const regex = /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[\W_]).{8,}$/;
    if (!regex.test(contra)) {
      return 'La contraseña debe tener al menos 8 caracteres, una mayúscula, una minúscula, un número y un símbolo especial.';
    }
    return null;
  }

  // Método Singleton
  static getInstancia() {
    if (!ClienteControlador.instancia) {
      ClienteControlador.instancia = new ClienteControlador();
    }
    return ClienteControlador.instancia;
  }
}

module.exports = ClienteControlador;
