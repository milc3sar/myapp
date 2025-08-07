# App de Supervisión de Obras - Android (Flutter)

## 🎯 Objetivo del sistema
Desarrollar una aplicación móvil en Flutter (solo Android) para que los **supervisores técnicos de obras eléctricas** puedan generar de forma estructurada y automática un **informe en PDF**, siguiendo el formato oficial del área de Gestión de Pérdidas y Conexiones (GPC).
Ademas se usara el patron BLOC.

---

## 🧩 Funcionalidades clave

### 1. Creación de reporte diario
- Nombre del supervisor (técnico)
- Fecha de visita
- Asunto del informe
- Acciones realizadas del día (checkbox):
  - Control de pérdidas
  - Barreras técnicas
  - Mantenimiento preventivo
  - Mantenimiento correctivo

---

### 2. Registro de evidencias por suministro
- Código de suministro (8 dígitos)
- Tomar fotos
- Capturar automáticamente la ubicación donde se tomó la foto
- usar el microfono para describir la imagen y sea transcrita automaticamene del audio, no es necesario guardar el audio.
- Edición manual del texto si es necesario

---

### 3. Conclusiones y recomendaciones
- Conclusiones generales basadas en las observaciones
- Recomendaciones:
  - La contratista debe ejecutar los correctivos encontrados
  - Actuar según contrato

---

### 4. Generación de PDF
- Generado localmente (sin servidores)
- Sigue exactamente el formato oficial (ver más abajo)
- Incluye:
  - Encabezado formal
  - Secciones numeradas (1–5)
  - Bloques por suministro (fotos + mapas de ubicación + observaciones)
  - Firma al final

---

### 5. Envío del informe
- El PDF generado se puede compartir por:
  - WhatsApp
  - Correo
  - Bluetooth
- Todo el procesamiento ocurre localmente

---

## 🔐 Restricciones del proyecto
- **No se permite** uso de Firebase, servidores externos ni servicios pagos
- El sistema puede requerir conexión solo para:
  - Transcripción de voz
  - Descargar imagen del mapa
  - Obtener ubicación precisa (GPS)
- El resto debe funcionar sin conexión
- Solo para dispositivos **Android**

---

## 🧾 Formato del informe (.md equivalente)

```markdown
Trujillo, [FECHA]

INFORME GPC – [N° DE REPORTE] – 2025

**Para**:  
Jefe de Gestión de Pérdidas y Conexiones (e)

**De**:  
[Nombre del supervisor] – Técnico Electricista

**Asunto**:  
Supervisión de actividades realizadas el [FECHA]

---

## 1. OBJETIVO:
Informar las actividades desarrolladas el día [FECHA].

---

## 2. ACCIONES REALIZADAS:
Se han supervisado las siguientes actividades:
- [x] Actividades de Control de Pérdidas  
- [x] Actividades de Barreras Técnicas  
- [x] Actividades de Mantenimiento Preventivo  
- [x] Actividades de Mantenimiento Correctivo

---

## 3. RESULTADOS: TOMAS FOTOGRÁFICAS

### 3.1 Suministro: [Código de 8 dígitos]
- **Foto 1**
- **Mapa de ubicación 1**
- **Foto 2**
- **Mapa de ubicación 2**
- **Foto 3**
- **Mapa de ubicación 3**

**Observaciones:**
1. [Texto transcrito 1]  
2. [Texto transcrito 2]  
3. [Texto transcrito 3]  

---

### 3.2 Suministro: [Otro suministro]
- **Foto 1**
- **Mapa de ubicación 1**
- **Foto 2**
- **Mapa de ubicación 2**
- **Foto 3**
- **Mapa de ubicación 3**

**Observaciones:**
1. [Texto transcrito 1]  
2. [Texto transcrito 2]  
3. [Texto transcrito 3]  

---

## 4. CONCLUSIONES:
Se ha logrado evidenciar los siguientes incumplimientos:
- 4.1 [Conclusión 1]  
- 4.2 [Conclusión 2]  
- 4.3 [Conclusión 3]

---

## 5. RECOMENDACIONES:
- 5.1 La contratista debe ejecutar los correctivos y el levantamiento de las observaciones encontradas.  
- 5.2 Actuar según contrato.

---

Firma:  
[Nombre del supervisor]

Dpto. de Gestión de Pérdidas y Conexiones

Trujillo, [FECHA]