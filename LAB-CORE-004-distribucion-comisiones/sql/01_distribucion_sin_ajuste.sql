WITH parcialidades AS (
    SELECT 101 AS policy_id, 0 AS annex_id, LEVEL AS parcialidad
    FROM dual CONNECT BY LEVEL <= 3
),
calc AS (
    SELECT p.*, COUNT(*) OVER (PARTITION BY policy_id, annex_id) AS cnt_docs
    FROM parcialidades p
)
SELECT policy_id, annex_id, parcialidad, cnt_docs,
       ROUND(200 / cnt_docs, 2) AS commission_agent,
       ROUND(30 / cnt_docs, 2) AS commission_promoter
FROM calc ORDER BY parcialidad;
