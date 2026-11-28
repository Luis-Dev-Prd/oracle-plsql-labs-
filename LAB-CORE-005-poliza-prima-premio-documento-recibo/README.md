# LAB-CORE-005 — De la póliza a la cobranza

Publicación DEC-01 | 01/12/2026 | Funcional 100%

## Objetivo
Diferenciar póliza, prima base, premio, periodicidad, documento y recibo mediante un escenario ficticio de seguro de hogar con vigencia anual y pago trimestral.

## Escenario
Póliza POL-1001; vigencia de 12 meses; prima base anual $40.000; premio anual $46.400; cuatro cuotas trimestrales de $11.600.

| Concepto | Trimestral | Anual |
|---|---:|---:|
| Prima base | 10.000 | 40.000 |
| Impuestos | 2.100 | 8.400 |
| Gastos administrativos | 500 | 2.000 |
| Descuentos | -1.000 | -4.000 |
| Total | 11.600 | 46.400 |

| Parcialidad | Documento | Recibo | Importe |
|---|---|---|---:|
| 1/4 | 5001 | 9001 | 11.600 |
| 2/4 | 5002 | 9002 | 11.600 |
| 3/4 | 5003 | 9003 | 11.600 |
| 4/4 | 5004 | 9004 | 11.600 |

## Alcance
Modelo conceptual simplificado: un documento por cuota y un recibo por documento. Las relaciones y los conceptos pueden variar por implementación. Emitido no equivale a pagado. Los endosos quedan fuera del alcance de este caso introductorio. Los importes e identificadores son ficticios y no representan tasas reales.

## Materiales
- [Infografía](docs/DEC-01_infografia.png)
- [Texto LinkedIn](docs/publicacion_linkedin.txt)

No contiene SQL ni estructuras propietarias: es un laboratorio exclusivamente funcional.
