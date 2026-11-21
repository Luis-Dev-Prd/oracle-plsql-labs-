# LAB-CORE-001 | Oficinas y pólizas con Oracle SQL

**CTE · ROW_NUMBER() · JOIN · Control de cardinalidad · Análisis técnico-funcional**

## Problema de negocio

En un core asegurador, una **oficina** representa una unidad organizativa y comercial de la aseguradora, que puede intervenir en la comercialización, administración o gestión de pólizas. Una **póliza** representa el contrato de seguro y puede estar asociada a una oficina mediante un identificador interno.

Un proceso de integración necesita recuperar el número de oficina (`OFFICE_NO`) asociado a la póliza. Si el origen tiene más de una correspondencia por identificador (`OFFICE_ID`), un `JOIN` directo podría multiplicar las filas.

## Modelo ficticio

- `OFICINAS_LAB`: `REGISTRO_ID` (PK), `OFFICE_ID`, `OFFICE_NO`.
- `POLIZAS_LAB`: `POLICY_ID` (PK), `POLICY_NO`, `OFFICE_ID`, `INSR_TYPE`, `INSR_END`, `POLICY_STATE`.
- Relación lógica: `POLIZAS_LAB.OFFICE_ID = OFICINAS_LAB.OFFICE_ID`.

**Nota de modelado:** los registros duplicados de `OFFICE_ID` en el origen son intencionales para explicar el riesgo de multiplicación. La tabla de oficinas utiliza `REGISTRO_ID` como clave primaria y, por eso, este modelo didáctico no define una FK directa por `OFFICE_ID`.

## Solución SQL

1. La CTE `off` descarta números de oficina nulos, usa `ROW_NUMBER() OVER (PARTITION BY office_id ORDER BY office_no)` y conserva `rn=1`.
2. La CTE `policy_ctx` relaciona pólizas y oficinas usando `INNER JOIN` por `OFFICE_ID`, con un filtro explícito por estados.
3. La salida devuelve los datos de póliza y su número de oficina, sin multiplicar las filas por las correspondencias repetidas del origen en este caso de prueba.

## Ejecutar en Oracle

Usar un **esquema de laboratorio**, sin datos reales. Ejecutar estos archivos en orden:

| Orden | Script | Propósito |
| --- | --- | --- |
| 1 | [`sql/01_crear_tablas.sql`](sql/01_crear_tablas.sql) | Crear las dos tablas ficticias |
| 2 | [`sql/02_datos_ficticios.sql`](sql/02_datos_ficticios.sql) | Insertar los datos del caso |
| 3 | [`sql/03_cte_off.sql`](sql/03_cte_off.sql) | Recuperar una correspondencia por oficina |
| 4 | [`sql/04_cte_policy_ctx.sql`](sql/04_cte_policy_ctx.sql) | Relacionar pólizas y oficinas |

> **Importante:** los scripts de creación y carga están pensados para una ejecución inicial en un esquema sin estas tablas ni filas. No son migraciones repetibles.

## Resultado verificado

| POLICY_ID | POLICY_NO | INSR_TYPE | INSR_END | OFFICE_NO |
| ---: | ---: | :--- | :--- | ---: |
| 101 | 50001 | AUTO | 2027-01-01 | 1 |
| 102 | 50002 | HOGAR | 2027-06-01 | 2 |

Las pólizas `103` y `104` se excluyen por causas distintas: ausencia de número de oficina y estado fuera del filtro, respectivamente.

Ver [`docs/EVIDENCIA_VALIDACION.md`](docs/EVIDENCIA_VALIDACION.md) para los datos ejecutados y la interpretación de cada caso.

## Consideraciones y límites

- El criterio `ORDER BY office_no` selecciona el primer valor de texto de cada `OFFICE_ID`; **no demuestra vigencia** del número elegido.
- `TO_NUMBER` convierte el identificador textual y elimina ceros iniciales; requiere entradas numéricas.
- `POLICY_STATE IN (0, 10, 11, 12)` se utiliza como criterio del caso. No asignamos significados funcionales a esos códigos sin el catálogo correspondiente.
- Las estructuras y los datos son **ficticios**; no representan tablas, datos ni documentación oficial de una plataforma comercial. INSIS puede mencionarse como ejemplo de core asegurador, no como fuente de estas tablas.

## Conclusión

Un `JOIN` técnicamente válido puede multiplicar filas si no se controla la cardinalidad del origen. En este laboratorio, comprender la relación entre pólizas y oficinas fue tan importante como escribir la consulta.
