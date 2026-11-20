-- LAB-COB-001 | Validacion funcional del primer recibo
SELECT
    r.oficina_id,
    r.recibo_id,
    r.obligacion_id,
    r.poliza_id,
    r.importe_total AS importe_maestro,
    r.estado,
    r.parcialidad,
    COUNT(d.doc_id) AS cant_documentos,
    NVL(SUM(d.importe), 0) AS importe_detalle,
    LISTAGG(d.doc_id, ', ') WITHIN GROUP (ORDER BY d.doc_id) AS documentos,
    CASE
        WHEN COUNT(d.doc_id) = 2
         AND NVL(SUM(d.importe), 0) = r.importe_total
        THEN 'OK'
        ELSE 'REVISAR'
    END AS validacion
FROM RECIBOS_LAB r
LEFT JOIN RECIBO_DETALLE_LAB d
    ON d.oficina_id = r.oficina_id
   AND d.recibo_id = r.recibo_id
WHERE r.oficina_id = '001'
  AND r.obligacion_id = 'OBL-001'
GROUP BY
    r.oficina_id, r.recibo_id, r.obligacion_id, r.poliza_id,
    r.importe_total, r.estado, r.parcialidad;
