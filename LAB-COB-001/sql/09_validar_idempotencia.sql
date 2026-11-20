-- LAB-COB-001 | Validacion acotada de idempotencia, caso OBL-001
WITH maestro AS (
    SELECT
        COUNT(*) AS cant_recibos,
        MIN(recibo_id) AS recibo_id,
        MIN(importe_total) AS importe_maestro
    FROM RECIBOS_LAB
    WHERE oficina_id = '001'
      AND obligacion_id = 'OBL-001'
),
detalle AS (
    SELECT
        COUNT(*) AS cant_detalle,
        COUNT(DISTINCT d.doc_id) AS docs_distintos,
        NVL(SUM(d.importe), 0) AS importe_detalle
    FROM RECIBO_DETALLE_LAB d
    JOIN RECIBOS_LAB r
      ON r.oficina_id = d.oficina_id
     AND r.recibo_id = d.recibo_id
    WHERE r.oficina_id = '001'
      AND r.obligacion_id = 'OBL-001'
)
SELECT
    m.recibo_id,
    m.cant_recibos,
    d.cant_detalle,
    d.docs_distintos,
    m.importe_maestro,
    d.importe_detalle,
    CASE
        WHEN m.cant_recibos = 1
         AND d.cant_detalle = 2
         AND d.docs_distintos = 2
         AND m.importe_maestro = 120
         AND d.importe_detalle = 120
        THEN 'IDEMPOTENCIA OK'
        ELSE 'REVISAR'
    END AS resultado
FROM maestro m
CROSS JOIN detalle d;
