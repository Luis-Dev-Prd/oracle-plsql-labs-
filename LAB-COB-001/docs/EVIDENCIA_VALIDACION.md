# Evidencia de validación — LAB-COB-001

**Origen de la evidencia:** ejecuciones manuales compartidas en esta conversación, realizadas en Oracle FreeSQL (20/11/2026). No se presentan como resultados de ejecución automatizada ni como pruebas de producción.

## Entrada

| OFICINA_ID | POLIZA_ID | OBLIGACION_ID | DOC_ID | TIPO_DOCUMENTO | IMPORTE |
| --- | ---: | --- | ---: | --- | ---: |
| 001 | 101 | OBL-001 | 501 | PRIMA | 100 |
| 001 | 101 | OBL-001 | 502 | IMPUESTO | 20 |

## Consulta de vista

Se obtuvo `CANT_POLIZAS = 1`, `CANT_DOCUMENTOS = 2`, `IMPORTE_PRIMA = 100`, `IMPORTE_IMPUESTO = 20`, `IMPORTE_TOTAL = 120`, `PARCIALIDAD = 1/1`.

## Compilación

`SP_GENERAR_RECIBO_LAB` figuró con `OBJECT_TYPE = PROCEDURE` y `STATUS = VALID` en `USER_OBJECTS`.

## Primera ejecución

Salida: `RECIBO GENERADO: 1001` y `PL/SQL procedure successfully completed.`

La consulta de integridad devolvió:

```text
RECIBO_ID         1001
CANT_DOCUMENTOS      2
IMPORTE_MAESTRO    120
IMPORTE_DETALLE    120
DOCUMENTOS        501, 502
VALIDACION        OK
```

## Segunda ejecución sin modificar el origen

Salida: `RECIBO PROCESADO: 1001` y `PL/SQL procedure successfully completed.`

Consulta final:

```text
RECIBO_ID            1001
CANT_RECIBOS            1
CANT_DETALLE            2
DOCS_DISTINTOS          2
IMPORTE_MAESTRO       120
IMPORTE_DETALLE       120
RESULTADO           IDEMPOTENCIA OK
```

## Alcance de la conclusión

Se comprobó que dos **ejecuciones sucesivas** con documentos sin modificaciones mantuvieron un único maestro y dos detalles, con importes consistentes. Esta evidencia **no** prueba comportamiento bajo concurrencia, cambios en el origen o volúmenes elevados.
