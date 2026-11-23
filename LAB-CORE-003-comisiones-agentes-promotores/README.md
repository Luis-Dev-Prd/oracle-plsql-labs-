# LAB-CORE-003 | Comisiones de agentes y promotores con Oracle SQL

**CTE · NOT EXISTS · DISTINCT · IN · SUM(CASE WHEN) · GROUP BY · Análisis técnico-funcional**

## Desafío

En un escenario asegurador completamente ficticio, una póliza tiene comisiones `REGULAR` y `OVERRIDE`. No todas las comisiones `OVERRIDE` cumplen las condiciones del ejemplo para clasificarse como comisión de promotor. La lógica debe identificar la relación comercial y separar los importes por categoría, sin confundir lo excluido con un importe inexistente.

## Continuidad del modelo

- **Se reutiliza** `POLIZAS_LAB` del LAB-CORE-001 y el identificador ficticio `POLICY_ID = 101`.
- **Se agregan** `AGENTES_LAB` (agente y referencia `MAIN_AGENT`) y `COMISIONES_LAB` (movimientos por póliza, anexo, agente y tipo).
- No se usan nombres, datos, estructuras ni código de sistemas reales en los scripts.

## Modelo de ejemplo

`AGENTES_LAB`: promotor 900, agentes 201 y 202 con `MAIN_AGENT = 900`, e intermediario 901 sin subordinados registrados.

| Agente | Tipo | Importe |
|---:|---|---:|
| 201 | REGULAR | 120.00 |
| 202 | REGULAR | 80.00 |
| 900 | OVERRIDE | 30.00 |
| 901 | OVERRIDE | 15.00 |

## Algoritmo SQL

1. `base_comm` relaciona los movimientos con la jerarquía de agentes.
2. `agente_base` aplica `NOT EXISTS` para seleccionar agentes que no figuran como `MAIN_AGENT` de otro agente en el conjunto ficticio.
3. `promotor_directo` obtiene mediante `DISTINCT` los `MAIN_AGENT` informados en esos registros.
4. `comm` agrupa por póliza y anexo, usando `SUM(CASE WHEN)` e `IN` para diferenciar las comisiones.

## Ejecutar en Oracle

Se requiere un esquema de laboratorio con `POLIZAS_LAB` y la póliza ficticia `101` ya cargadas. Ejecutar en este orden:

| Orden | Archivo | Propósito |
|---|---|---|
| 1 | `sql/01_crear_tablas.sql` | Crear agentes y comisiones ficticios |
| 2 | `sql/02_datos_ficticios.sql` | Cargar 4 agentes y 4 movimientos |
| 3 | `sql/03_cte_comm.sql` | Calcular comisiones de agentes y promotor |

Los scripts de DDL y de carga son para una **ejecución inicial**; no son idempotentes ni migraciones repetibles. Usar exclusivamente en un esquema ficticio.

## Resultado comprobado en Oracle

| POLICY_ID | ANNEX_ID | COMMISSION_AGENT | COMMISSION_PROMOTER |
|---:|---:|---:|---:|
| 101 | 0 | 200 | 30 |

**Nota funcional:** el total de movimientos de la prueba es **245**. De ese total, **230** se clasifican en las dos columnas anteriores y **15** corresponden a la comisión `OVERRIDE` del agente 901, que **no cumple la condición de promotor** definida en este ejercicio. La consulta no elimina ese movimiento de la tabla; lo excluye de la suma de promotor. En un desarrollo real, el tratamiento de esas diferencias requiere una regla de negocio expresa.

Consulte `docs/EVIDENCIA_VALIDACION.md` para la entrada y la salida que fueron ejecutadas y compartidas por el autor.

## Alcance y limitaciones

- `REGULAR` y `OVERRIDE`, la jerarquía y los importes son **ficticios**. No equivalen a catálogos comerciales de una plataforma real.
- La definición de promotor es **la regla didáctica de este caso**; no debe generalizarse a cualquier producto de seguros.
- La consulta **no** demuestra rendimiento, unicidad universal, conciliación contable ni reglas de aprobación de comisiones.
- Una relación jerárquica puede necesitar vigencia, fechas y otras reglas no modeladas aquí.

## Conclusión

En una integración, **agrupar importes** y **determinar cuáles cumplen una condición funcional** son operaciones distintas. Una clasificación SQL debe permitir explicar también los importes que quedaron fuera de las categorías calculadas.
