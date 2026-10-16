-- Red Social Pascualina
-- DDL físico para MySQL 8.0+
-- Charset recomendado: utf8mb4
-- Nota: mensaje_chat.id_mensaje usa CHAR(36); generar UUID con UUID() al insertar.
CREATE DATABASE IF NOT EXISTS red_social_pascualina
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE red_social_pascualina;

CREATE TABLE rol (
  id_rol INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  descripcion VARCHAR(255) NULL,
  estado VARCHAR(20) NOT NULL,
  CONSTRAINT pk_rol PRIMARY KEY (id_rol),
  CONSTRAINT uk_rol_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE tipo_usuario (
  id_tipo_usuario INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  descripcion VARCHAR(255) NULL,
  estado VARCHAR(20) NOT NULL,
  CONSTRAINT pk_tipo_usuario PRIMARY KEY (id_tipo_usuario),
  CONSTRAINT uk_tipo_usuario_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE tipo_servicio (
  id_tipo_servicio INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(100) NOT NULL,
  descripcion VARCHAR(255) NULL,
  estado VARCHAR(20) NOT NULL,
  CONSTRAINT pk_tipo_servicio PRIMARY KEY (id_tipo_servicio),
  CONSTRAINT uk_tipo_servicio_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE tipo_producto (
  id_tipo_producto INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(30) NOT NULL,
  descripcion VARCHAR(100) NULL,
  estado VARCHAR(20) NOT NULL,
  CONSTRAINT pk_tipo_producto PRIMARY KEY (id_tipo_producto),
  CONSTRAINT uk_tipo_producto_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE tipo_evento (
  id_tipo_evento INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(20) NOT NULL,
  descripcion VARCHAR(100) NULL,
  estado VARCHAR(20) NOT NULL,
  CONSTRAINT pk_tipo_evento PRIMARY KEY (id_tipo_evento),
  CONSTRAINT uk_tipo_evento_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE tipo_reaccion (
  id_tipo_reaccion INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  descripcion VARCHAR(255) NULL,
  CONSTRAINT pk_tipo_reaccion PRIMARY KEY (id_tipo_reaccion),
  CONSTRAINT uk_tipo_reaccion_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE tipo_notificacion (
  id_tipo_notificacion INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  descripcion VARCHAR(100) NULL,
  CONSTRAINT pk_tipo_notificacion PRIMARY KEY (id_tipo_notificacion),
  CONSTRAINT uk_tipo_notificacion_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE tipo_denuncia (
  id_tipo_denuncia INT NOT NULL AUTO_INCREMENT,
  nombre VARCHAR(50) NOT NULL,
  descripcion VARCHAR(255) NULL,
  CONSTRAINT pk_tipo_denuncia PRIMARY KEY (id_tipo_denuncia),
  CONSTRAINT uk_tipo_denuncia_nombre UNIQUE (nombre)
) ENGINE=InnoDB;

CREATE TABLE usuario (
  id_usuario INT NOT NULL AUTO_INCREMENT,
  id_rol INT NOT NULL,
  id_tipo_usuario INT NOT NULL,
  nombres VARCHAR(100) NOT NULL,
  apellidos VARCHAR(100) NOT NULL,
  correo VARCHAR(150) NOT NULL,
  contraseña VARCHAR(255) NOT NULL,
  telefono VARCHAR(20) NOT NULL,
  fecha_registro DATETIME NOT NULL,
  estado VARCHAR(20) NOT NULL,
  CONSTRAINT pk_usuario PRIMARY KEY (id_usuario),
  CONSTRAINT uk_usuario_correo UNIQUE (correo),
  CONSTRAINT fk_usuario_rol FOREIGN KEY (id_rol) REFERENCES rol(id_rol),
  CONSTRAINT fk_usuario_tipo FOREIGN KEY (id_tipo_usuario) REFERENCES tipo_usuario(id_tipo_usuario)
) ENGINE=InnoDB;

CREATE TABLE perfil (
  id_perfil INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  informacion VARCHAR(7000) NULL,
  fecha_actualizacion DATETIME NOT NULL,
  CONSTRAINT pk_perfil PRIMARY KEY (id_perfil),
  CONSTRAINT uk_perfil_usuario UNIQUE (id_usuario),
  CONSTRAINT fk_perfil_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE publicacion (
  id_publicacion INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  contenido VARCHAR(7000) NOT NULL,
  tipo_contenido VARCHAR(30) NOT NULL,
  fecha_publicacion DATETIME NOT NULL,
  CONSTRAINT pk_publicacion PRIMARY KEY (id_publicacion),
  CONSTRAINT fk_publicacion_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE comentario (
  id_comentario INT NOT NULL AUTO_INCREMENT,
  id_publicacion INT NOT NULL,
  id_usuario INT NOT NULL,
  contenido VARCHAR(7000) NOT NULL,
  fecha_comentario DATETIME NOT NULL,
  CONSTRAINT pk_comentario PRIMARY KEY (id_comentario),
  CONSTRAINT fk_comentario_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion),
  CONSTRAINT fk_comentario_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE grupo (
  id_grupo INT NOT NULL AUTO_INCREMENT,
  id_usuario_creador INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  descripcion VARCHAR(500) NULL,
  categoria VARCHAR(100) NULL,
  privacidad VARCHAR(20) NOT NULL,
  fecha_creacion DATETIME NOT NULL,
  estado VARCHAR(20) NOT NULL,
  CONSTRAINT pk_grupo PRIMARY KEY (id_grupo),
  CONSTRAINT fk_grupo_creador FOREIGN KEY (id_usuario_creador) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE servicio (
  id_servicio INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  id_tipo_servicio INT NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  duracion VARCHAR(50) NULL,
  CONSTRAINT pk_servicio PRIMARY KEY (id_servicio),
  CONSTRAINT fk_servicio_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_servicio_tipo FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio(id_tipo_servicio)
) ENGINE=InnoDB;

CREATE TABLE producto (
  id_producto INT NOT NULL AUTO_INCREMENT,
  id_usuario_vendedor INT NOT NULL,
  id_tipo_producto INT NOT NULL,
  nombre VARCHAR(150) NOT NULL,
  precio DECIMAL(10,2) NOT NULL,
  cantidad INT NOT NULL,
  CONSTRAINT pk_producto PRIMARY KEY (id_producto),
  CONSTRAINT fk_producto_vendedor FOREIGN KEY (id_usuario_vendedor) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_producto_tipo FOREIGN KEY (id_tipo_producto) REFERENCES tipo_producto(id_tipo_producto)
) ENGINE=InnoDB;

CREATE TABLE usuario_servicio (
  id_solicitud INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  id_servicio INT NOT NULL,
  fecha_solicitud DATETIME NOT NULL,
  estado VARCHAR(30) NOT NULL,
  CONSTRAINT pk_usuario_servicio PRIMARY KEY (id_solicitud),
  CONSTRAINT fk_usuario_servicio_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_usuario_servicio_servicio FOREIGN KEY (id_servicio) REFERENCES servicio(id_servicio)
) ENGINE=InnoDB;

CREATE TABLE usuario_producto (
  id_adquisicion INT NOT NULL AUTO_INCREMENT,
  id_producto INT NOT NULL,
  id_usuario INT NOT NULL,
  cantidad INT NOT NULL,
  fecha_adquisicion DATETIME NOT NULL,
  CONSTRAINT pk_usuario_producto PRIMARY KEY (id_adquisicion),
  CONSTRAINT fk_usuario_producto_producto FOREIGN KEY (id_producto) REFERENCES producto(id_producto),
  CONSTRAINT fk_usuario_producto_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE evento (
  id_evento INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  id_tipo_evento INT NOT NULL,
  nombre VARCHAR(100) NOT NULL,
  fecha DATETIME NOT NULL,
  descripcion VARCHAR(100) NULL,
  ubicacion VARCHAR(100) NULL,
  CONSTRAINT pk_evento PRIMARY KEY (id_evento),
  CONSTRAINT fk_evento_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_evento_tipo FOREIGN KEY (id_tipo_evento) REFERENCES tipo_evento(id_tipo_evento)
) ENGINE=InnoDB;

CREATE TABLE reaccion (
  id_reaccion INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  id_publicacion INT NOT NULL,
  id_tipo_reaccion INT NOT NULL,
  CONSTRAINT pk_reaccion PRIMARY KEY (id_reaccion),
  CONSTRAINT fk_reaccion_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_reaccion_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion),
  CONSTRAINT fk_reaccion_tipo FOREIGN KEY (id_tipo_reaccion) REFERENCES tipo_reaccion(id_tipo_reaccion)
) ENGINE=InnoDB;

CREATE TABLE notificacion (
  id_notificacion INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  id_tipo_notificacion INT NOT NULL,
  id_publicacion INT NULL,
  mensaje VARCHAR(50) NOT NULL,
  fecha DATETIME NOT NULL,
  CONSTRAINT pk_notificacion PRIMARY KEY (id_notificacion),
  CONSTRAINT fk_notificacion_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_notificacion_tipo FOREIGN KEY (id_tipo_notificacion) REFERENCES tipo_notificacion(id_tipo_notificacion),
  CONSTRAINT fk_notificacion_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion)
) ENGINE=InnoDB;

CREATE TABLE solicitud_amistad (
  id_solicitud INT NOT NULL AUTO_INCREMENT,
  id_remitente INT NOT NULL,
  id_destinatario INT NOT NULL,
  estado VARCHAR(20) NOT NULL,
  fecha_solicitud DATETIME NOT NULL,
  CONSTRAINT pk_solicitud_amistad PRIMARY KEY (id_solicitud),
  CONSTRAINT fk_amistad_remitente FOREIGN KEY (id_remitente) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_amistad_destinatario FOREIGN KEY (id_destinatario) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE mensaje_chat (
  id_mensaje CHAR(36) NOT NULL,
  id_emisor INT NOT NULL,
  id_receptor INT NOT NULL,
  contenido VARCHAR(1000) NULL,
  tipo_contenido VARCHAR(20) NOT NULL,
  fecha_envio DATETIME NOT NULL,
  fecha_lectura DATETIME NULL,
  CONSTRAINT pk_mensaje_chat PRIMARY KEY (id_mensaje),
  CONSTRAINT fk_mensaje_emisor FOREIGN KEY (id_emisor) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_mensaje_receptor FOREIGN KEY (id_receptor) REFERENCES usuario(id_usuario)
) ENGINE=InnoDB;

CREATE TABLE denuncia (
  id_denuncia INT NOT NULL AUTO_INCREMENT,
  id_usuario INT NOT NULL,
  id_publicacion INT NOT NULL,
  id_tipo_denuncia INT NOT NULL,
  evidencia TEXT NULL,
  estado VARCHAR(15) NOT NULL,
  fecha_reporte DATETIME NOT NULL,
  accion_tomada VARCHAR(100) NULL,
  CONSTRAINT pk_denuncia PRIMARY KEY (id_denuncia),
  CONSTRAINT fk_denuncia_usuario FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario),
  CONSTRAINT fk_denuncia_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion(id_publicacion),
  CONSTRAINT fk_denuncia_tipo FOREIGN KEY (id_tipo_denuncia) REFERENCES tipo_denuncia(id_tipo_denuncia)
) ENGINE=InnoDB;

-- Verificación rápida: debe devolver 23 tablas.
SELECT COUNT(*) AS total_tablas
FROM information_schema.tables
WHERE table_schema = 'red_social_pascualina';
