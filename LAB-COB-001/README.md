# LAB-COB-001 · Documentos de emisión → recibo de cobranza

**Portafolio técnico Oracle SQL/PLSQL · Laboratorio ficticio y reproducible**

## Problema funcional

Un core asegurador ficticio genera documentos con distintos conceptos (prima e impuesto) asociados a una misma obligación de cobranza. Los sistemas consumidores necesitan **un recibo maestro consolidado** sin perder la relación individual con los documentos que lo componen.

**Pregunta del laboratorio:** ¿cómo crear un recibo de 120 a partir de dos documentos (100 + 20) y evitar duplicaciones al reprocesar exactamente el mismo origen?

## Resultado demostrado

| Control | Resultado obtenido en Oracle FreeSQL |
| --- | --- |
| Obligación | `OBL-001` |
| Oficina / póliza | `001` / `101` |
| Documentos fuente | `501` (prima 100), `502` (impuesto 20) |
| Recibo maestro | `1001` — importe `120`, estado `EMITIDO`, parcialidad `1/1` |
| Detalle | 2 documentos, importe total `120` |
| Segunda ejecución sucesiva | Mismo recibo `1001` y cardinalidad inalterada |
| Validación | `IDEMPOTENCIA OK` para este escenario |

> Resultados respaldados por una ejecución manual compartida por el autor en Oracle FreeSQL. El paquete se ha organizado a partir de esos scripts; no se ha vuelto a ejecutar automáticamente en un entorno Oracle al empaquetarlo.

## Modelo de datos

```text
CORE_EMISION_LAB (documentos ficticios)
         |  agrupación por oficina + obligación
         v
VW_EMISION_RECIBOS_LAB (1 fila consolidada por obligación)
         |
         v
SP_GENERAR_RECIBO_LAB
         |
         +--> RECIBOS_LAB (1 recibo maestro por obligación)
         |           |
         |           | 1:N
         +--> RECIBO_DETALLE_LAB (todos los DOC_ID)
```

- `CORE_EMISION_LAB`: identifica cada documento con `(OFICINA_ID, DOC_ID)`.
- `RECIBOS_LAB`: identifica cada recibo con `(OFICINA_ID, RECIBO_ID)`; restringe una fila por `(OFICINA_ID, OBLIGACION_ID)`.
- `RECIBO_DETALLE_LAB`: conserva relaciones recibo-documento con PK/FK y una restricción que evita reutilizar el mismo documento en otro recibo.
- `VW_EMISION_RECIBOS_LAB`: agrupa importes por obligación; comprueba cuántas pólizas distintas están asociadas y expone el total para el integrador.
- `SP_GENERAR_RECIBO_LAB`: reutiliza o crea el maestro, vincula documentos individuales y verifica cantidades, importes y correspondencia documental.

## Requisitos

- Un esquema Oracle de laboratorio con permisos para `CREATE TABLE`, `CREATE VIEW`, `CREATE SEQUENCE` y `CREATE PROCEDURE`.
- Un cliente que permita ejecutar scripts PL/SQL (por ejemplo, Oracle FreeSQL / SQL Worksheet).
- Ejecutar **por primera vez en un esquema donde no existan los objetos del laboratorio**. Los scripts de creación y carga no son scripts de reseteo y no deben repetirse sobre el mismo esquema.

## Reproducción paso a paso

Abrí los archivos de `sql/` en orden y ejecutalos individualmente:

| Orden | Archivo | Acción |
| --- | --- | --- |
| 1 | `01_tablas.sql` | Crear las tres tablas y restricciones |
| 2 | `02_datos_ficticios.sql` | Insertar documentos 501 y 502 (una sola vez) |
| 3 | `03_vista_emision.sql` | Crear la vista consolidada |
| 4 | `04_secuencia.sql` | Crear secuencia que comienza en 1001 |
| 5 | `05_procedimiento.sql` | Compilar el integrador PL/SQL |
| 6 | `06_generacion_inicial.sql` | Generar recibo y confirmar la transacción |
| 7 | `07_validar_recibo.sql` | Verificar maestro, detalle y total |
| 8 | `08_reproceso.sql` | Volver a ejecutar sin cambiar documentos |
| 9 | `09_validar_idempotencia.sql` | Confirmar un maestro y dos detalles |

**Salida esperada** de `07_validar_recibo.sql`: un recibo de 120 con los documentos `501, 502` y `VALIDACION = OK`.

**Salida esperada** de `09_validar_idempotencia.sql`: `CANT_RECIBOS = 1`, `CANT_DETALLE = 2`, `DOCS_DISTINTOS = 2`, `IMPORTE_MAESTRO = 120`, `IMPORTE_DETALLE = 120`, `RESULTADO = IDEMPOTENCIA OK`.

## Decisiones técnicas

1. **Grano distinto en origen y destino:** documentos individuales frente a recibo consolidado.
2. **No perder la trazabilidad al agrupar:** la vista calcula el total, pero el procedimiento vuelve al origen para registrar cada `DOC_ID`.
3. **Separar transformación SQL e integración PL/SQL:** reglas de agregación en la vista y persistencia/control en el procedimiento.
4. **Reprocesamiento del mismo origen:** claves, comprobación de existencia y reconciliación de cantidades/importes.
5. **Transacción controlada por el llamador:** el procedimiento no ejecuta `COMMIT` y utiliza un `SAVEPOINT` para revertir sus propios cambios si falla.

## Límites del caso

Este es un **laboratorio de emisión anual con documentos positivos e inmutables**. No es una solución productiva ni una reproducción del framework de ningún cliente. No se probaron alta concurrencia, cargas masivas, cambios posteriores en documentos, cancelaciones, endosos, cambio de periodicidad ni streaming. La unicidad funcional y la secuencia global se eligieron para el caso acotado; no sustituyen un diseño de numeración por oficina.

## Uso responsable

Todos los nombres, datos y scripts de este repositorio son ficticios y están redactados para el laboratorio. No se incluyen procedimientos, esquemas ni identificadores propietarios de terceros.
