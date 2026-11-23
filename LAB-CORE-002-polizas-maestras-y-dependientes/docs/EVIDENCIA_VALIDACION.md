# Evidencia de validación | LAB-CORE-002

**Origen de la evidencia:** salida JSON compartida por el autor tras ejecutar `sql/03_cte_policy_ctx.sql` en su esquema de laboratorio Oracle. Los valores aquí se presentan en tablas legibles.

## Resultado observado

| POLICY_ID | POLICY_NO | INSR_TYPE | POLICY_STATE | MASTER_POLICY_ID | POLICY_MASTER_ID |
| ---: | ---: | :--- | ---: | ---: | ---: |
| 101 | 50001 | AUTO | 0 | NULL | 101 |
| 102 | 50002 | HOGAR | 0 | 101 | 101 |
| 103 | 50003 | VIDA | 0 | 101 | 101 |
| 104 | 50004 | AUTO | 30 | 999 | 999 |

## Comprobaciones respaldadas por la salida

1. La póliza `101`, sin relación informada, se conserva en el resultado: `POLICY_MASTER_ID = 101`.
2. Las pólizas `102` y `103` conservan la referencia explícita `101`.
3. La póliza `104` conserva el identificador explícito `999` aunque no se realiza un JOIN de recuperación a esa póliza maestra.
4. La salida reportada tiene **4 filas para 4 `POLICY_ID` distintos**: no se observó duplicación en esta ejecución.
5. La salida incluye `POLICY_STATE = 30` para la póliza `104`: la consulta no filtra por estado.

## Alcance / precauciones

- `NVL` implementa un fallback para el **identificador**; no clasifica por sí mismo la póliza como maestra contractual.
- La consulta no valida la existencia, tipo, vigencia ni estado de la maestra referenciada.
- La PK por `POLICY_ID` en `POLIZAS_VINCULOS_LAB` es una decisión del modelo ficticio, no una afirmación sobre el origen real.
- Los scripts de creación y carga se proporcionan para **reproducir** el caso, pero en esta evidencia solamente se atribuye ejecución confirmada a la consulta de salida compartida por el autor.
- No se incluyen registros, nombres de estructuras ni código propietario de ningún cliente.
