-- LAB-COB-001 | Integrador Oracle PL/SQL
-- Compilado y probado por el autor en Oracle FreeSQL con el escenario OBL-001.
-- La transaccion queda bajo control del llamador.

CREATE OR REPLACE PROCEDURE SP_GENERAR_RECIBO_LAB (
    p_oficina_id     IN  VARCHAR2,
    p_obligacion_id  IN  VARCHAR2,
    p_recibo_id      OUT NUMBER
)
AS
    v_recibo_id       RECIBOS_LAB.RECIBO_ID%TYPE;
    v_poliza_id       RECIBOS_LAB.POLIZA_ID%TYPE;
    v_importe_total   RECIBOS_LAB.IMPORTE_TOTAL%TYPE;
    v_parcialidad     RECIBOS_LAB.PARCIALIDAD%TYPE;

    v_cant_polizas    NUMBER;
    v_cant_documentos NUMBER;

    v_poliza_mdm      RECIBOS_LAB.POLIZA_ID%TYPE;
    v_importe_mdm     RECIBOS_LAB.IMPORTE_TOTAL%TYPE;
    v_parcialidad_mdm RECIBOS_LAB.PARCIALIDAD%TYPE;
    v_estado_mdm      RECIBOS_LAB.ESTADO%TYPE;

    v_cant_detalle    NUMBER;
    v_total_detalle   NUMBER;
    v_faltantes       NUMBER;
BEGIN
    p_recibo_id := NULL;
    SAVEPOINT sp_inicio_recibo_lab;

    -- 1. Consultar la obligacion consolidada.
    BEGIN
        SELECT poliza_id, cant_polizas, cant_documentos,
               importe_total, parcialidad
        INTO   v_poliza_id, v_cant_polizas, v_cant_documentos,
               v_importe_total, v_parcialidad
        FROM VW_EMISION_RECIBOS_LAB
        WHERE oficina_id = p_oficina_id
          AND obligacion_id = p_obligacion_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001, 'Obligacion no encontrada');
    END;

    -- 2. Validar las reglas del caso.
    IF v_cant_polizas <> 1 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Obligacion asociada a varias polizas');
    END IF;

    IF v_cant_documentos = 0 OR v_importe_total <= 0 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Documentos o importe no validos');
    END IF;

    -- 3. Reutilizar recibo o insertar maestro nuevo.
    BEGIN
        SELECT recibo_id, poliza_id, importe_total, parcialidad, estado
        INTO   v_recibo_id, v_poliza_mdm, v_importe_mdm,
               v_parcialidad_mdm, v_estado_mdm
        FROM RECIBOS_LAB
        WHERE oficina_id = p_oficina_id
          AND obligacion_id = p_obligacion_id
        FOR UPDATE;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            BEGIN
                INSERT INTO RECIBOS_LAB (
                    oficina_id, recibo_id, obligacion_id, poliza_id,
                    importe_total, parcialidad, estado
                )
                VALUES (
                    p_oficina_id, SEQ_RECIBOS_LAB.NEXTVAL,
                    p_obligacion_id, v_poliza_id, v_importe_total,
                    v_parcialidad, 'EMITIDO'
                )
                RETURNING recibo_id INTO v_recibo_id;

                v_poliza_mdm      := v_poliza_id;
                v_importe_mdm     := v_importe_total;
                v_parcialidad_mdm := v_parcialidad;
                v_estado_mdm      := 'EMITIDO';
            EXCEPTION
                WHEN DUP_VAL_ON_INDEX THEN
                    SELECT recibo_id, poliza_id, importe_total,
                           parcialidad, estado
                    INTO   v_recibo_id, v_poliza_mdm, v_importe_mdm,
                           v_parcialidad_mdm, v_estado_mdm
                    FROM RECIBOS_LAB
                    WHERE oficina_id = p_oficina_id
                      AND obligacion_id = p_obligacion_id
                    FOR UPDATE;
            END;
    END;

    -- 4. El maestro existente debe reflejar el origen sin cambios.
    IF v_poliza_mdm <> v_poliza_id
       OR v_importe_mdm <> v_importe_total
       OR v_parcialidad_mdm <> v_parcialidad
       OR v_estado_mdm <> 'EMITIDO' THEN
        RAISE_APPLICATION_ERROR(-20004, 'Recibo maestro inconsistente');
    END IF;

    -- 5. Preservar todos los identificadores de documentos de origen.
    INSERT INTO RECIBO_DETALLE_LAB (
        oficina_id, recibo_id, doc_id, importe
    )
    SELECT c.oficina_id, v_recibo_id, c.doc_id, c.importe
    FROM CORE_EMISION_LAB c
    WHERE c.oficina_id = p_oficina_id
      AND c.obligacion_id = p_obligacion_id
      AND c.poliza_id = v_poliza_id
      AND NOT EXISTS (
          SELECT 1
          FROM RECIBO_DETALLE_LAB d
          WHERE d.oficina_id = c.oficina_id
            AND d.doc_id = c.doc_id
      );

    -- 6. Conciliar maestro y detalle.
    SELECT COUNT(*), NVL(SUM(importe), 0)
    INTO v_cant_detalle, v_total_detalle
    FROM RECIBO_DETALLE_LAB
    WHERE oficina_id = p_oficina_id
      AND recibo_id = v_recibo_id;

    IF v_cant_detalle <> v_cant_documentos
       OR v_total_detalle <> v_importe_total THEN
        RAISE_APPLICATION_ERROR(-20005, 'Maestro y detalle no coinciden');
    END IF;

    -- 7. Verificar correspondencia documental e importes.
    SELECT COUNT(*)
    INTO v_faltantes
    FROM CORE_EMISION_LAB c
    WHERE c.oficina_id = p_oficina_id
      AND c.obligacion_id = p_obligacion_id
      AND NOT EXISTS (
          SELECT 1
          FROM RECIBO_DETALLE_LAB d
          WHERE d.oficina_id = c.oficina_id
            AND d.recibo_id = v_recibo_id
            AND d.doc_id = c.doc_id
            AND d.importe = c.importe
      );

    IF v_faltantes > 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Trazabilidad documental incompleta');
    END IF;

    p_recibo_id := v_recibo_id;
    -- COMMIT controlado por quien llama.
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK TO sp_inicio_recibo_lab;
        p_recibo_id := NULL;
        RAISE;
END SP_GENERAR_RECIBO_LAB;
/
