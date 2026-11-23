# LAB-CORE-002 | Pólizas maestras y dependientes con Oracle SQL

**CTE · LEFT JOIN · NVL · Cardinalidad · Análisis técnico-funcional**

## Problema de negocio

En un sistema de seguros, algunas pólizas tienen una referencia explícita a otra póliza y otras no. Un proceso de integración necesita obtener un identificador de referencia para cada póliza **sin perder las que no tienen vínculo registrado**.

La pregunta técnica es: ¿cómo resolver ese identificador conservando todas las pólizas y sin confundir una referencia calculada con una relación contractual verificada?

## Modelo ficticio y reutilizable

Este laboratorio **continúa LAB-CORE-001**. Reutiliza `POLIZAS_LAB` y agrega una única tabla ficticia:

- `POLIZAS_LAB`: `POLICY_ID` (PK), `POLICY_NO`, `INSR_TYPE`, `POLICY_STATE`, entre otros campos del LAB-CORE-001.
- `POLIZAS_VINCULOS_LAB`: `POLICY_ID` (PK y FK a `POLIZAS_LAB`), `MASTER_POLICY_ID` (`NOT NULL`, sin FK a la maestra).

Solo se registran **vínculos explícitos**. Una póliza sin vínculo no necesita una fila en `POLIZAS_VINCULOS_LAB`.

> Esta es una simplificación pedagógica para los datos de prueba; no representa la estructura física ni las restricciones de ningún core asegurador comercial. La PK por `POLICY_ID` asegura como máximo un vínculo registrado por póliza **en este laboratorio**.

## Solución Oracle SQL

La CTE `policy_ctx`:

1. Recupera las pólizas de `POLIZAS_LAB`.
2. Utiliza un `LEFT JOIN` para obtener su vínculo, si existe.
3. Aplica `NVL(v.MASTER_POLICY_ID, p.POLICY_ID)` para obtener `POLICY_MASTER_ID`.

```sql
WITH policy_ctx AS (
    SELECT
        p.POLICY_ID,
        p.POLICY_NO,
        p.INSR_TYPE,
        p.POLICY_STATE,
        v.MASTER_POLICY_ID,
        NVL(
            v.MASTER_POLICY_ID,
            p.POLICY_ID
        ) AS POLICY_MASTER_ID
    FROM POLIZAS_LAB p
    LEFT JOIN POLIZAS_VINCULOS_LAB v
        ON v.POLICY_ID = p.POLICY_ID
)
SELECT *
FROM policy_ctx
ORDER BY POLICY_ID;
```

**Importante:** en este ejercicio no filtramos por `POLICY_STATE`; buscamos aislar la lógica del vínculo. No asignamos interpretaciones funcionales a códigos de estado sin su catálogo.

## Orden de ejecución

Ejecutar en un **esquema de laboratorio**, después de crear y cargar las tablas del LAB-CORE-001:

| Orden | Archivo | Propósito |
| --- | --- | --- |
| 1 | [`sql/01_crear_tabla_vinculos.sql`](sql/01_crear_tabla_vinculos.sql) | Crear `POLIZAS_VINCULOS_LAB` |
| 2 | [`sql/02_cargar_vinculos.sql`](sql/02_cargar_vinculos.sql) | Cargar tres relaciones ficticias |
| 3 | [`sql/03_cte_policy_ctx.sql`](sql/03_cte_policy_ctx.sql) | Ejecutar la consulta del caso |

Los dos primeros scripts son de **ejecución inicial, no idempotentes**. Si ya creaste la tabla y cargaste los tres vínculos, ejecutá solo el tercer script.

## Evidencia de ejecución

Resultado compartido de la ejecución en Oracle con cuatro pólizas de prueba:

| POLICY_ID | POLICY_NO | INSR_TYPE | POLICY_STATE | MASTER_POLICY_ID | POLICY_MASTER_ID |
| ---: | ---: | :--- | ---: | ---: | ---: |
| 101 | 50001 | AUTO | 0 | NULL | 101 |
| 102 | 50002 | HOGAR | 0 | 101 | 101 |
| 103 | 50003 | VIDA | 0 | 101 | 101 |
| 104 | 50004 | AUTO | 30 | 999 | 999 |

Véase [`docs/EVIDENCIA_VALIDACION.md`](docs/EVIDENCIA_VALIDACION.md).

## Interpretación técnica

- **Póliza 101:** no tiene vínculo registrado; `NVL` conserva su propio `POLICY_ID`. Esto **no demuestra** que sea una maestra contractual.
- **Pólizas 102 y 103:** ambas referencian a `101`. El `LEFT JOIN` no multiplica filas con el modelo y datos utilizados.
- **Póliza 104:** tiene la referencia `999`; `NVL` la conserva aunque no recupere datos de esa póliza maestra. **Resolver un ID no equivale a comprobar existencia o vigencia.**

En esta muestra la salida contiene cuatro filas y cuatro identificadores de póliza distintos; no se observaron duplicaciones. La unicidad se apoya también en la PK de `POLIZAS_VINCULOS_LAB`.

## Conclusión

`LEFT JOIN` permite conservar las pólizas sin relación y `NVL` resuelve un identificador de referencia. La calidad de un proceso de integración depende también de distinguir **una referencia informada** de **una entidad maestra validada**.

**Todos los identificadores, datos y estructuras de este laboratorio son ficticios.** No se incluyen datos ni código de clientes o plataformas comerciales.
