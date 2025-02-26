# ✨ Proyecto de Base de Datos en AWS con PostgreSQL y DBeaver ✨

---
## 📄 Información del Proyecto

**👨‍🎓 Estudiante:** Mariana Osorio Rojas  
**🌟 ID:** 464679  
**📧 Correo:** mariana.osorioro@upb.edu.co  
**🏫 Universidad:** Pontificia Bolivariana  
**📚 Facultad:** Ingenierías - Ingeniería de Sistemas e Informática  
**📈 Materia:** Tópicos Avanzados en Bases de Datos  

---
## 📚 Introducción

Este proyecto tiene como objetivo la implementación de una base de datos en la nube utilizando **Amazon Web Services (AWS)** con **PostgreSQL**. Se establecerá una conexión remota mediante **DBeaver**, permitiendo diseñar e implementar un modelo de datos para ejecutar consultas avanzadas, funciones y procedimientos almacenados para el análisis eficiente de la información.

---
## 🛠️ Tecnologías Utilizadas

- 🏢 **Arquitectura en la nube:** AWS (Amazon Web Services)
- 📝 **Motor de base de datos:** PostgreSQL
- 💻 **IDE utilizado:** DBeaver

---
## 📁 Estructura del Proyecto

El proyecto está organizado en las siguientes carpetas y archivos:

- **1_docs/** 📚 - Documentación relevante, incluyendo el enunciado del proyecto y manuales.
- **2_diagrama/** 🎨 - Diagramas relacionales y representaciones visuales del modelo de datos.
- **3_scripts/** ⚙️ - Scripts SQL para la implementación del esquema y consultas.
- **4_datos/** 📂 - Archivos CSV con datos de empleados, cargos, departamentos, etc.
- **5_archivos_salida/** 📄 - Archivos generados con los resultados de consultas y funciones.
- **README.md** - Documentación general del proyecto.
- **.gitignore** - Archivo para excluir archivos innecesarios del control de versiones.

---
## 🌟 Fases de Ejecución

### 🛠️ Etapa 1: Abastecimiento
Se despliega una instancia de **PostgreSQL en AWS RDS**, configurando los parámetros de seguridad y accesibilidad necesarios.

### 🔑 Etapa 2: Configuración de Conexiones Remotas
Se establece la conexión remota desde **DBeaver** utilizando credenciales de AWS, asegurando la autenticación y el cifrado adecuado.

### 📚 Etapa 3: Diseño e Implementación del Modelo de Datos
Se crean las **tablas y relaciones** del modelo de datos, asegurando la integridad y optimización del esquema.

### 🔖 Etapa 4: Implementación de Consultas SQL
Se desarrollan consultas utilizando **CTE y funciones ventana** para analizar los datos y realizar cálculos.

### ⚙️ Etapa 5: Funciones y Procedimientos
Se implementan **funciones y procedimientos almacenados** para automatizar el cálculo de costos y nóminas.

---
## 🛠️ Instrucciones de Instalación y Uso

1. **Descargar el Repositorio**  
   ```bash
   git clone <URL_DEL_REPOSITORIO>
   cd <NOMBRE_DEL_PROYECTO>
   ```

2. **Instalar PostgreSQL y DBeaver**  
   - Descargar e instalar **PostgreSQL** desde su [sitio oficial](https://www.postgresql.org/download/).
   - Descargar e instalar **DBeaver** desde su [sitio oficial](https://dbeaver.io/download/).

3. **Configurar la Base de Datos en AWS**  
   - Crear una **instancia RDS** con PostgreSQL en AWS.
   - Configurar reglas de seguridad para acceso remoto.

4. **Conectar DBeaver a la Base de Datos**  
   - Agregar una **nueva conexión PostgreSQL** en DBeaver.
   - Ingresar las **credenciales de AWS**.
   - Verificar la conexión.

5. **Ejecutar los Scripts**  
   - Importar y ejecutar los **scripts SQL** desde la carpeta `3_scripts/`.
   - Analizar los datos y verificar los resultados en `5_archivos_salida/`.

---
## 💼 Colaboración

Si deseas contribuir a este proyecto:

1. **Forkea** el repositorio y clona una copia local.
2. Crea una **rama** para tu contribución (`git checkout -b mi-nueva-funcionalidad`).
3. Realiza tus cambios y confírmalos (`git commit -m "Agregado nueva funcionalidad"`).
4. Sube tus cambios (`git push origin mi-nueva-funcionalidad`).
5. Crea un **Pull Request** para su revisión.

---
## 📚 Conclusión

Este proyecto demuestra la implementación de una **base de datos en la nube** utilizando **PostgreSQL en AWS**, con conexión remota a través de **DBeaver**. Se desarrollaron consultas avanzadas y funciones para el análisis eficiente de datos en un entorno seguro y escalable.

---
