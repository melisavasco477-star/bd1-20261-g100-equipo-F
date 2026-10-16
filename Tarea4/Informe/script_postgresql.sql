-- =====================================================================
-- Script PostgreSQL - Red social (generado desde el diccionario de datos)
-- =====================================================================
-- Notas:
--  * Las columnas FK se definen como INTEGER (solo las PK son IDENTITY).
--  * Se corrigió "INTERGER" -> INTEGER.
--  * Los nombres de las tablas "rol" y "tipo_usuario" se infirieron del
--    contenido (la hoja 'Inventario de Tablas' no venía en el archivo).
-- =====================================================================

-- ---------------------------------------------------------------------
-- TABLAS CATÁLOGO
-- ---------------------------------------------------------------------
CREATE TABLE rol (
    id_rol       INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre       VARCHAR(50) NOT NULL UNIQUE,
    descripcion  TEXT,
    estado       VARCHAR(20) NOT NULL
);

CREATE TABLE tipo_usuario (
    id_tipo_usuario INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre          VARCHAR(50) NOT NULL UNIQUE,
    descripcion     TEXT,
    estado          VARCHAR(20) NOT NULL
);

CREATE TABLE tipo_servicio (
    id_tipo_servicio INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre           VARCHAR(50) NOT NULL UNIQUE,
    descripcion      TEXT,
    estado           VARCHAR(20) NOT NULL
);

CREATE TABLE tipo_producto (
    id_tipo_producto INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre           VARCHAR(50) NOT NULL UNIQUE,
    descripcion      TEXT,
    estado           VARCHAR(20) NOT NULL
);

CREATE TABLE tipo_evento (
    id_tipo_evento INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre         VARCHAR(50) NOT NULL UNIQUE,
    descripcion    TEXT,
    estado         VARCHAR(20) NOT NULL
);

CREATE TABLE tipo_reaccion (
    id_tipo_reaccion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre           VARCHAR(50) NOT NULL UNIQUE,
    descripcion      TEXT
);

CREATE TABLE tipo_notificacion (
    id_tipo_notificacion INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre               VARCHAR(50) NOT NULL UNIQUE,
    descripcion          TEXT
);

CREATE TABLE tipo_denuncia (
    id_tipo_denuncia INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    nombre           VARCHAR(50) NOT NULL UNIQUE,
    descripcion      TEXT
);

-- ---------------------------------------------------------------------
-- USUARIOS
-- ---------------------------------------------------------------------
CREATE TABLE usuario (
    id_usuario      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_rol          INTEGER      NOT NULL,
    id_tipo_usuario INTEGER      NOT NULL,
    nombres         VARCHAR(50)  NOT NULL,
    apellidos       VARCHAR(50)  NOT NULL,
    correo          VARCHAR(255) NOT NULL UNIQUE,
    contrasena      VARCHAR(255) NOT NULL,
    telefono        VARCHAR(20)  NOT NULL UNIQUE,
    fecha_registro  TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado          VARCHAR(30)  NOT NULL,
    CONSTRAINT fk_usuario_rol          FOREIGN KEY (id_rol)          REFERENCES rol (id_rol),
    CONSTRAINT fk_usuario_tipo_usuario FOREIGN KEY (id_tipo_usuario) REFERENCES tipo_usuario (id_tipo_usuario)
);

CREATE TABLE perfil (
    id_perfil           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario          INTEGER   NOT NULL UNIQUE,
    informacion         JSONB,
    fecha_actualizacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_perfil_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
);

-- ---------------------------------------------------------------------
-- CONTENIDO
-- ---------------------------------------------------------------------
CREATE TABLE publicacion (
    id_publicacion    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario        INTEGER     NOT NULL,
    contenido         TEXT        NOT NULL,
    tipo_contenido    VARCHAR(20) NOT NULL,
    fecha_publicacion TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_publicacion_usuario FOREIGN KEY (id_usuario) REFERENCES usuario (id_usuario)
);

CREATE TABLE comentario (
    id_comentario    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_publicacion   INTEGER   NOT NULL,
    id_usuario       INTEGER   NOT NULL,
    contenido        TEXT      NOT NULL,
    fecha_comentario TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_comentario_publicacion FOREIGN KEY (id_publicacion) REFERENCES publicacion (id_publicacion),
    CONSTRAINT fk_comentario_usuario     FOREIGN KEY (id_usuario)     REFERENCES usuario (id_usuario)
);

CREATE TABLE reaccion (
    id_reaccion      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario       INTEGER NOT NULL,
    id_publicacion   INTEGER NOT NULL,
    id_tipo_reaccion INTEGER NOT NULL,
    CONSTRAINT fk_reaccion_usuario      FOREIGN KEY (id_usuario)       REFERENCES usuario (id_usuario),
    CONSTRAINT fk_reaccion_publicacion  FOREIGN KEY (id_publicacion)   REFERENCES publicacion (id_publicacion),
    CONSTRAINT fk_reaccion_tipo         FOREIGN KEY (id_tipo_reaccion) REFERENCES tipo_reaccion (id_tipo_reaccion)
);

CREATE TABLE grupo (
    id_grupo           INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario_creador INTEGER     NOT NULL,
    nombre             VARCHAR(50) NOT NULL,
    descripcion        TEXT,
    categoria          VARCHAR(30),
    privacidad         VARCHAR(30) NOT NULL,
    fecha_creacion     TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado             VARCHAR(30) NOT NULL,
    CONSTRAINT fk_grupo_usuario_creador FOREIGN KEY (id_usuario_creador) REFERENCES usuario (id_usuario)
);

-- ---------------------------------------------------------------------
-- SERVICIOS Y PRODUCTOS
-- ---------------------------------------------------------------------
CREATE TABLE servicio (
    id_servicio      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario       INTEGER       NOT NULL,
    id_tipo_servicio INTEGER       NOT NULL,
    nombre           VARCHAR(50)   NOT NULL,
    precio           NUMERIC(12,2) NOT NULL CHECK (precio >= 0),
    descripcion      TEXT,
    CONSTRAINT fk_servicio_usuario       FOREIGN KEY (id_usuario)       REFERENCES usuario (id_usuario),
    CONSTRAINT fk_servicio_tipo_servicio FOREIGN KEY (id_tipo_servicio) REFERENCES tipo_servicio (id_tipo_servicio)
);

CREATE TABLE producto (
    id_producto      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario       INTEGER       NOT NULL,
    id_tipo_producto INTEGER       NOT NULL,
    nombre           VARCHAR(50)   NOT NULL,
    descripcion      TEXT,
    precio           NUMERIC(12,2) NOT NULL CHECK (precio >= 0),
    cantidad         INTEGER       NOT NULL CHECK (cantidad >= 0),
    estado           VARCHAR(30)   NOT NULL,   -- Disponible o vendido
    CONSTRAINT fk_producto_usuario       FOREIGN KEY (id_usuario)       REFERENCES usuario (id_usuario),
    CONSTRAINT fk_producto_tipo_producto FOREIGN KEY (id_tipo_producto) REFERENCES tipo_producto (id_tipo_producto)
);

CREATE TABLE usuario_servicio (
    id_solicitud    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario      INTEGER     NOT NULL,
    id_servicio     INTEGER     NOT NULL,
    fecha_solicitud TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado          VARCHAR(30) NOT NULL,      -- Pendiente, aceptada o rechazada
    CONSTRAINT fk_usuario_servicio_usuario  FOREIGN KEY (id_usuario)  REFERENCES usuario (id_usuario),
    CONSTRAINT fk_usuario_servicio_servicio FOREIGN KEY (id_servicio) REFERENCES servicio (id_servicio)
);

CREATE TABLE usuario_producto (
    id_adquisicion    INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario        INTEGER   NOT NULL,
    id_producto       INTEGER   NOT NULL,
    cantidad          INTEGER   NOT NULL CHECK (cantidad > 0),
    fecha_adquisicion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuario_producto_usuario  FOREIGN KEY (id_usuario)  REFERENCES usuario (id_usuario),
    CONSTRAINT fk_usuario_producto_producto FOREIGN KEY (id_producto) REFERENCES producto (id_producto)
);

-- ---------------------------------------------------------------------
-- EVENTOS
-- ---------------------------------------------------------------------
CREATE TABLE evento (
    id_evento      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario     INTEGER     NOT NULL,
    id_tipo_evento INTEGER     NOT NULL,
    nombre         VARCHAR(50) NOT NULL,
    descripcion    TEXT,
    fecha          TIMESTAMP   NOT NULL,
    lugar          VARCHAR(50),
    estado         VARCHAR(30) NOT NULL,       -- Activo o cancelado
    CONSTRAINT fk_evento_usuario     FOREIGN KEY (id_usuario)     REFERENCES usuario (id_usuario),
    CONSTRAINT fk_evento_tipo_evento FOREIGN KEY (id_tipo_evento) REFERENCES tipo_evento (id_tipo_evento)
);

-- ---------------------------------------------------------------------
-- INTERACCIÓN SOCIAL
-- ---------------------------------------------------------------------
CREATE TABLE notificacion (
    id_notificacion      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario           INTEGER   NOT NULL,
    id_usuario_creador   INTEGER,              -- puede ser automático
    id_tipo_notificacion INTEGER   NOT NULL,
    mensaje              TEXT      NOT NULL,
    fecha                TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notificacion_usuario  FOREIGN KEY (id_usuario)           REFERENCES usuario (id_usuario),
    CONSTRAINT fk_notificacion_creador  FOREIGN KEY (id_usuario_creador)   REFERENCES usuario (id_usuario),
    CONSTRAINT fk_notificacion_tipo     FOREIGN KEY (id_tipo_notificacion) REFERENCES tipo_notificacion (id_tipo_notificacion)
);

CREATE TABLE solicitud_amistad (
    id_solicitud       INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario_emisor  INTEGER     NOT NULL,
    id_usuario_receptor INTEGER    NOT NULL,
    fecha_solicitud    TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado             VARCHAR(30) NOT NULL,   -- Pendiente, aceptada o rechazada
    CONSTRAINT fk_amistad_emisor   FOREIGN KEY (id_usuario_emisor)   REFERENCES usuario (id_usuario),
    CONSTRAINT fk_amistad_receptor FOREIGN KEY (id_usuario_receptor) REFERENCES usuario (id_usuario),
    CONSTRAINT ck_amistad_distintos CHECK (id_usuario_emisor <> id_usuario_receptor)
);

CREATE TABLE mensaje_chat (
    id_mensaje          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario_emisor   INTEGER     NOT NULL,
    id_usuario_receptor INTEGER     NOT NULL,
    contenido           TEXT        NOT NULL,
    tipo_contenido      VARCHAR(30) NOT NULL,  -- Texto, imagen o archivo
    fecha_envio         TIMESTAMP   NOT NULL DEFAULT CURRENT_TIMESTAMP,
    fecha_lectura       TIMESTAMP,             -- NULL = sin leer
    CONSTRAINT fk_mensaje_emisor   FOREIGN KEY (id_usuario_emisor)   REFERENCES usuario (id_usuario),
    CONSTRAINT fk_mensaje_receptor FOREIGN KEY (id_usuario_receptor) REFERENCES usuario (id_usuario)
);

CREATE TABLE denuncia (
    id_denuncia      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    id_usuario       INTEGER   NOT NULL,
    id_publicacion   INTEGER   NOT NULL,
    id_tipo_denuncia INTEGER   NOT NULL,
    evidencia        TEXT,
    fecha_reporte    TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    estado           TEXT      NOT NULL,       -- Pendiente, revisada o cerrada
    accion_tomada    TEXT,
    CONSTRAINT fk_denuncia_usuario     FOREIGN KEY (id_usuario)       REFERENCES usuario (id_usuario),
    CONSTRAINT fk_denuncia_publicacion FOREIGN KEY (id_publicacion)   REFERENCES publicacion (id_publicacion),
    CONSTRAINT fk_denuncia_tipo        FOREIGN KEY (id_tipo_denuncia) REFERENCES tipo_denuncia (id_tipo_denuncia)
);
