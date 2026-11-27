WITH parcialidades AS (
    SELECT 101 AS policy_id, 0 AS annex_id, LEVEL AS parcialidad
    FROM dual CONNECT BY LEVEL <= 3
),
calc AS (
    SELECT p.*,
           ROW_NUMBER() OVER (PARTITION BY policy_id, annex_id ORDER BY parcialidad) AS rn,
           COUNT(*) OVER (PARTITION BY policy_id, annex_id) AS cnt_docs
    FROM parcialidades p
)
SELECT policy_id, annex_id, rn || '/' || cnt_docs AS parcialidad,
    CASE
        WHEN rn < cnt_docs THEN ROUND(200 / cnt_docs, 2)
        ELSE ROUND(200 - ROUND(200 / cnt_docs, 2) * (cnt_docs - 1), 2)
    END AS commission_agent,
    CASE
        WHEN rn < cnt_docs THEN ROUND(30 / cnt_docs, 2)
        ELSE ROUND(30 - ROUND(30 / cnt_docs, 2) * (cnt_docs - 1), 2)
    END AS commission_promoter
FROM calc ORDER BY rn;
