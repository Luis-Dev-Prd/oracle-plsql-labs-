-- LAB-CORE-002 | Resolver una referencia de póliza
-- Esta consulta fue ejecutada por el autor con los datos ficticios del caso.
-- No se aplican filtros de estado para aislar la lógica de vínculo.

WITH policy_ctx AS (
    SELECT
        p.POLICY_ID,
        p.POLICY_NO,
        p.INSR_TYPE,
        p.POLICY_STATE,
        v.MASTER_POLICY_ID,
        NVL(
            v.MASTER_POLICY_ID,
            p.POLICY_ID
        ) AS POLICY_MASTER_ID
    FROM POLIZAS_LAB p
    LEFT JOIN POLIZAS_VINCULOS_LAB v
        ON v.POLICY_ID = p.POLICY_ID
)
SELECT *
FROM policy_ctx
ORDER BY POLICY_ID;
