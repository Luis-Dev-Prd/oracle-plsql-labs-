-- LAB-COB-001 | Vista de consolidacion funcional
-- Grano: una fila por oficina y obligacion de cobranza.
-- Los DOC_ID individuales se conservan en CORE_EMISION_LAB.

CREATE OR REPLACE VIEW VW_EMISION_RECIBOS_LAB AS
SELECT
    oficina_id,
    obligacion_id,
    MIN(poliza_id) AS poliza_id,
    COUNT(DISTINCT poliza_id) AS cant_polizas,
    COUNT(*) AS cant_documentos,
    SUM(CASE WHEN tipo_documento = 'PRIMA' THEN importe ELSE 0 END)
        AS importe_prima,
    SUM(CASE WHEN tipo_documento = 'IMPUESTO' THEN importe ELSE 0 END)
        AS importe_impuesto,
    SUM(importe) AS importe_total,
    '1/1' AS parcialidad
FROM CORE_EMISION_LAB
GROUP BY oficina_id, obligacion_id;
