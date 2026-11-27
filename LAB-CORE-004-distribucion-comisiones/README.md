# LAB-CORE-004 — Distribución de comisiones

**Cuando redondear correctamente no es suficiente**

Autor: Luis Ferrioli — Desarrollador de Sistemas e Integración de Datos.

## Objetivo
Distribuir las comisiones de agentes y promotores entre las parcialidades (cuotas de emisión) de una póliza sin alterar sus totales, en ausencia de pagos previos u otros ajustes.

## Requisitos y ejecución
Oracle SQL. Ejecutar los cuatro scripts de `sql/` en orden. Los scripts 01, 02 y 04 son autónomos; el 03 requiere los datos ficticios de LAB-CORE-003 en `AGENTES_LAB` y `COMISIONES_LAB` (póliza 101, anexo 0). No se ejecuta DDL ni DML. Las parcialidades se simulan mediante CTE; no se acredita el pago de recibos.

## Reglas
- Distribución independiente por póliza, anexo y concepto de comisión.
- Una cuota recibe el importe íntegro; en múltiples cuotas, las anteriores a la última reciben el importe proporcional redondeado a dos decimales.
- La última cuota recibe el saldo restante. La suma debe coincidir con el importe original.

## Evidencia comunicada de ejecución en Oracle

| Parcialidad | Agente | Promotor |
|---|---:|---:|
| 1/3 | 66.67 | 10.00 |
| 2/3 | 66.67 | 10.00 |
| 3/3 | 66.66 | 10.00 |
| Total | 200.00 | 30.00 |

Sin ajuste: 230.01; con ajuste: 230.00. De las 245 unidades de origen, 15 quedaron fuera de clasificación en el laboratorio anterior y no se distribuyen.

| Caso | Comisión | Cuotas | Sin ajuste | Con ajuste | Diferencia final | Validación |
|---|---:|---:|---:|---:|---:|---|
| CA-001 | 200 | 1 | 200 | 200 | 0 | OK |
| CA-002 | 200 | 3 | 200.01 | 200 | 0 | OK |
| CA-003 | 100 | 3 | 99.99 | 100 | 0 | OK |
| CA-004 | 30 | 3 | 30 | 30 | 0 | OK |

## Alcance y evolución
Los resultados corresponden a los escenarios probados, no a una certificación de producción. El script 03 identifica promotores desde el catálogo de agentes; su equivalencia general con otras reglas de clasificación no ha sido probada. Los controles de tolerancia, duplicidad, importes negativos y alertas son propuestas de evolución, no funcionalidades implementadas. Los pagos previos quedan fuera del alcance.

## Material
En `docs/` se incluye el video horizontal de cinco escenas y un borrador de publicación.
