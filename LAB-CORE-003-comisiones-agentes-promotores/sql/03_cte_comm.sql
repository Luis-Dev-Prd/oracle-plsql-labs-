-- LAB-CORE-003: CTE y clasificación ficticia de comisiones.
-- Consulta ejecutada por el autor con la salida documentada.
WITH base_comm AS (
    SELECT
        c.policy_id,
        c.annex_id,
        c.agent_id,
        a.main_agent,
        c.commission_type,
        c.comm_amount
    FROM COMISIONES_LAB c
    LEFT JOIN AGENTES_LAB a
        ON a.agent_id = c.agent_id
),
agente_base AS (
    SELECT b.*
    FROM base_comm b
    WHERE NOT EXISTS (
        SELECT 1
        FROM AGENTES_LAB x
        WHERE x.main_agent = b.agent_id
    )
),
promotor_directo AS (
    SELECT DISTINCT
        ab.main_agent AS agent_id
    FROM agente_base ab
    WHERE ab.main_agent IS NOT NULL
),
comm AS (
    SELECT
        b.policy_id,
        b.annex_id,
        ROUND(SUM(
            CASE
                WHEN b.commission_type = 'REGULAR'
                THEN b.comm_amount
                ELSE 0
            END
        ), 2) AS commission_agent,
        ROUND(SUM(
            CASE
                WHEN b.commission_type = 'OVERRIDE'
                 AND b.agent_id IN (
                     SELECT agent_id
                     FROM promotor_directo
                 )
                THEN b.comm_amount
                ELSE 0
            END
        ), 2) AS commission_promoter
    FROM base_comm b
    GROUP BY b.policy_id, b.annex_id
)
SELECT *
FROM comm
ORDER BY policy_id, annex_id;
