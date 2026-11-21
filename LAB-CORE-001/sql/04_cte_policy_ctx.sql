-- LAB-CORE-001 | 04 | Relacion entre poliza y numero de oficina
-- Ejecutado y contrastado con los datos ficticios del laboratorio.
-- Los codigos POLICY_STATE son valores de seleccion del caso de prueba;
-- no se documentan equivalencias funcionales sin un catalogo verificado.

WITH off AS (
    SELECT
        office_id,
        TO_NUMBER(office_no) AS office_no
    FROM (
        SELECT
            office_id,
            office_no,
            ROW_NUMBER() OVER (
                PARTITION BY office_id
                ORDER BY office_no
            ) AS rn
        FROM OFICINAS_LAB
        WHERE office_no IS NOT NULL
    )
    WHERE rn = 1
),
policy_ctx AS (
    SELECT
        p.policy_id,
        p.policy_no,
        p.insr_type,
        p.insr_end,
        o.office_no
    FROM POLIZAS_LAB p
    JOIN off o
      ON o.office_id = p.office_id
    WHERE p.policy_state IN (0, 10, 11, 12)
)
SELECT *
FROM policy_ctx
ORDER BY policy_id;
