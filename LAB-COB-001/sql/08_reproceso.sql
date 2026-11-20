-- LAB-COB-001 | Segunda ejecucion sin modificar la fuente
SET SERVEROUTPUT ON;

DECLARE
    v_recibo_id NUMBER;
BEGIN
    SP_GENERAR_RECIBO_LAB(
        p_oficina_id    => '001',
        p_obligacion_id => 'OBL-001',
        p_recibo_id     => v_recibo_id
    );
    DBMS_OUTPUT.PUT_LINE('RECIBO PROCESADO: ' || v_recibo_id);
    COMMIT;
END;
/
