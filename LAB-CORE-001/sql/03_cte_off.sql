-- LAB-CORE-001 | 03 | Seleccionar una correspondencia por oficina
-- Ejecutado y contrastado con los datos ficticios del laboratorio.
-- OFFICE_NO es texto y se ordena como texto antes de convertirse a numero.
-- La seleccion no implica vigencia; los valores se eligieron numericos en el ejemplo.

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
)
SELECT
    office_id,
    office_no
FROM off
ORDER BY office_id;
