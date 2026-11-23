# Evidencia de ejecución | LAB-CORE-001

Resultados de consultas ejecutadas por el autor del laboratorio y compartidos durante la validación. Los valores pertenecen a un escenario **completamente ficticio**. No son registros de una aseguradora real.

## 1. Datos de oficinas

| REGISTRO_ID | OFFICE_ID | OFFICE_NO |
| ---: | ---: | :--- |
| 1 | 10 | 001 |
| 2 | 10 | 005 |
| 3 | 20 | 002 |
| 4 | 30 | NULL |

**Observación:** el identificador de oficina `10` tiene dos números posibles. La oficina `30` no tiene un número informado.

## 2. Resultado ejecutado de `03_cte_off.sql`

| OFFICE_ID | OFFICE_NO |
| ---: | ---: |
| 10 | 1 |
| 20 | 2 |

La CTE descarta `NULL`, usa `ROW_NUMBER()` por `OFFICE_ID` y conserva `rn=1`. `TO_NUMBER()` convierte `'001'` en `1` y `'002'` en `2`.

## 3. Datos de pólizas

| POLICY_ID | POLICY_NO | OFFICE_ID | INSR_TYPE | INSR_END | POLICY_STATE |
| ---: | ---: | ---: | :--- | :--- | ---: |
| 101 | 50001 | 10 | AUTO | 2027-01-01 | 0 |
| 102 | 50002 | 20 | HOGAR | 2027-06-01 | 0 |
| 103 | 50003 | 30 | VIDA | 2027-12-01 | 0 |
| 104 | 50004 | 10 | AUTO | 2027-03-01 | 30 |

## 4. Resultado ejecutado de `04_cte_policy_ctx.sql`

| POLICY_ID | POLICY_NO | INSR_TYPE | INSR_END | OFFICE_NO |
| ---: | ---: | :--- | :--- | ---: |
| 101 | 50001 | AUTO | 2027-01-01 | 1 |
| 102 | 50002 | HOGAR | 2027-06-01 | 2 |

**Lectura técnico-funcional:**

- Póliza `101`: recuperada una sola vez, aunque `OFFICE_ID=10` tenga dos correspondencias de oficina en los datos de origen.
- Póliza `102`: recuperada con `OFFICE_NO=2`.
- Póliza `103`: no tiene coincidencia en `off` porque su único `OFFICE_NO` es `NULL`.
- Póliza `104`: excluida por `POLICY_STATE=30`, fuera de `IN (0, 10, 11, 12)`.

## Alcance de lo validado

Se ejecutaron la creación y carga de las tablas ficticias, la CTE `off` y la consulta `policy_ctx`, y se contrastaron las salidas mostradas arriba. El laboratorio **no** prueba rendimiento, concurrencia, vigencia real del número de oficina ni las equivalencias de estados de una plataforma comercial.

En particular, si `OFFICE_NO` contiene datos no numéricos, `TO_NUMBER` puede producir un error de conversión. El ordenamiento de `OFFICE_NO` ocurre como texto y se selecciona una sola correspondencia por oficina; este criterio no equivale a seleccionar la más reciente o vigente.
