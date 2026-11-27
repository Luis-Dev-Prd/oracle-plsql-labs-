WITH promotores AS (
    SELECT DISTINCT main_agent AS agent_id
    FROM agentes_lab a
    WHERE a.main_agent IS NOT NULL
      AND NOT EXISTS (SELECT 1 FROM agentes_lab x WHERE x.main_agent = a.agent_id)
),
comisiones AS (
    SELECT c.policy_id, c.annex_id,
        SUM(CASE WHEN c.commission_type = 'REGULAR' THEN c.comm_amount ELSE 0 END) AS total_agent,
        SUM(CASE WHEN c.commission_type = 'OVERRIDE'
                  AND c.agent_id IN (SELECT agent_id FROM promotores)
                 THEN c.comm_amount ELSE 0 END) AS total_promoter
    FROM comisiones_lab c
    WHERE c.policy_id = 101 AND c.annex_id = 0
    GROUP BY c.policy_id, c.annex_id
),
parcialidades AS (
    SELECT LEVEL AS numero FROM dual CONNECT BY LEVEL <= 3
),
calc AS (
    SELECT c.*,
        ROW_NUMBER() OVER (PARTITION BY c.policy_id, c.annex_id ORDER BY p.numero) AS rn,
        COUNT(*) OVER (PARTITION BY c.policy_id, c.annex_id) AS cnt_docs
    FROM comisiones c CROSS JOIN parcialidades p
)
SELECT policy_id, annex_id, rn || '/' || cnt_docs AS parcialidad,
    total_agent, total_promoter,
    CASE
        WHEN rn < cnt_docs THEN ROUND(total_agent / cnt_docs, 2)
        ELSE ROUND(total_agent - ROUND(total_agent / cnt_docs, 2) * (cnt_docs - 1), 2)
    END AS commission_agent,
    CASE
        WHEN rn < cnt_docs THEN ROUND(total_promoter / cnt_docs, 2)
        ELSE ROUND(total_promoter - ROUND(total_promoter / cnt_docs, 2) * (cnt_docs - 1), 2)
    END AS commission_promoter
FROM calc ORDER BY policy_id, annex_id, rn;
