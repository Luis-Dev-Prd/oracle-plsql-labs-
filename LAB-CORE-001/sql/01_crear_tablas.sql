-- LAB-CORE-001 | 01 | Estructura ficticia de oficinas y polizas
-- Ejecutar una sola vez en un esquema de laboratorio Oracle.
-- La duplicidad de OFFICE_ID en OFICINAS_LAB es intencional para estudiar cardinalidad.

CREATE TABLE OFICINAS_LAB (
    REGISTRO_ID NUMBER PRIMARY KEY,
    OFFICE_ID   NUMBER NOT NULL,
    OFFICE_NO   VARCHAR2(10)
);

CREATE TABLE POLIZAS_LAB (
    POLICY_ID    NUMBER PRIMARY KEY,
    POLICY_NO    NUMBER NOT NULL,
    OFFICE_ID    NUMBER NOT NULL,
    INSR_TYPE    VARCHAR2(20),
    INSR_END     DATE,
    POLICY_STATE NUMBER
);
