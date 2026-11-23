# Evidencia de ejecución | LAB-CORE-003

Resultados copiados de las ejecuciones realizadas por el autor en Oracle y compartidos en la conversación. Los nombres e importes pertenecen a un **laboratorio ficticio**.

## 1. Movimientos recuperados

| POLICY_ID | ANNEX_ID | AGENT_ID | MAIN_AGENT | COMMISSION_TYPE | COMM_AMOUNT |
|---:|---:|---:|---:|---|---:|
| 101 | 0 | 201 | 900 | REGULAR | 120 |
| 101 | 0 | 202 | 900 | REGULAR | 80 |
| 101 | 0 | 900 | NULL | OVERRIDE | 30 |
| 101 | 0 | 901 | NULL | OVERRIDE | 15 |

**Validación de carga:** 4 filas; suma de importes = 245.

## 2. Resultado de las CTE `base_comm`, `agente_base`, `promotor_directo`, `comm`

```json
[
  {
    "policy_id": 101,
    "annex_id": 0,
    "commission_agent": 200,
    "commission_promoter": 30
  }
]
```

**Validación principal:** `REGULAR` = 120 + 80 = 200; `OVERRIDE` elegible por relación de promotor = 30. Una fila observada para `(POLICY_ID, ANNEX_ID) = (101, 0)`.

## 3. Diferencia de clasificación

- Total de los 4 movimientos: **245**.
- Total asignado a las dos categorías: **230**.
- Diferencia: **15** del agente 901, que no figura como superior (`MAIN_AGENT`) de los agentes seleccionados.
- La diferencia está **fuera de las dos sumas**; el registro sigue existiendo en `COMISIONES_LAB`.

El ejercicio no determina si esa diferencia debe rechazarse, informarse, conservarse en una tercera categoría o tratarse de otra forma. Eso exigiría un requisito funcional adicional.

## 4. Límites de la evidencia

No se han demostrado pruebas de volumen, performance, concurrencia ni comportamiento para otros conjuntos de datos. La jerarquía y las clasificaciones son simplificaciones didácticas, no reglas contractuales universales.
