WITH escenarios AS (
    SELECT 'CA-001' AS caso, 200 AS comision, 1 AS cuotas FROM dual
    UNION ALL SELECT 'CA-002', 200, 3 FROM dual
    UNION ALL SELECT 'CA-003', 100, 3 FROM dual
    UNION ALL SELECT 'CA-004', 30, 3 FROM dual
),
numeros AS (
    SELECT LEVEL AS numero FROM dual CONNECT BY LEVEL <= 3
),
calc AS (
    SELECT e.caso, e.comision, e.cuotas, n.numero,
        ROUND(e.comision / e.cuotas, 2) AS importe_sin_ajuste,
        CASE WHEN n.numero < e.cuotas THEN ROUND(e.comision / e.cuotas, 2)
             ELSE ROUND(e.comision - ROUND(e.comision / e.cuotas, 2) * (e.cuotas - 1), 2)
        END AS importe_ajustado
    FROM escenarios e JOIN numeros n ON n.numero <= e.cuotas
)
SELECT caso, comision, cuotas,
    SUM(importe_sin_ajuste) AS total_sin_ajuste,
    SUM(importe_ajustado) AS total_ajustado,
    SUM(importe_sin_ajuste) - comision AS diferencia_original,
    SUM(importe_ajustado) - comision AS diferencia_final,
    CASE WHEN SUM(importe_ajustado) = comision THEN 'OK' ELSE 'ERROR' END AS validacion
FROM calc GROUP BY caso, comision, cuotas ORDER BY caso;
