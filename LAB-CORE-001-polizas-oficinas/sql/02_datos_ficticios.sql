-- LAB-CORE-001 | 02 | Datos enteramente ficticios
-- Ejecutar una sola vez, despues de 01_crear_tablas.sql.
-- '001' y '005' comparten OFFICE_ID=10 para demostrar el riesgo de multiplicacion.
-- La oficina 30 no tiene numero; el estado 30 no pertenece al filtro seleccionado.

INSERT INTO OFICINAS_LAB VALUES (1, 10, '001');
INSERT INTO OFICINAS_LAB VALUES (2, 10, '005');
INSERT INTO OFICINAS_LAB VALUES (3, 20, '002');
INSERT INTO OFICINAS_LAB VALUES (4, 30, NULL);

INSERT INTO POLIZAS_LAB
VALUES (101, 50001, 10, 'AUTO', DATE '2027-01-01', 0);

INSERT INTO POLIZAS_LAB
VALUES (102, 50002, 20, 'HOGAR', DATE '2027-06-01', 0);

INSERT INTO POLIZAS_LAB
VALUES (103, 50003, 30, 'VIDA', DATE '2027-12-01', 0);

INSERT INTO POLIZAS_LAB
VALUES (104, 50004, 10, 'AUTO', DATE '2027-03-01', 30);

COMMIT;
