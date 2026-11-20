# Oracle SQL/PLSQL · Laboratorios técnico-funcionales

**Portafolio de Luis Ferrioli · Desarrollo de Sistemas e Integración de Datos**

Este repositorio reúne laboratorios **originales, ficticios y reproducibles** para demostrar cómo transformar requerimientos funcionales en soluciones de datos con Oracle SQL/PLSQL.

Cada caso documenta el problema, las reglas de negocio, el modelo de datos, la implementación y las pruebas. El objetivo no es presentar ejemplos aislados de sintaxis, sino explicar **las decisiones técnicas y su validación**.

## Laboratorios

| Caso | Desafío | Tecnologías y conceptos | Evidencia |
| --- | --- | --- | --- |
| [LAB-COB-001 · Emisión de recibos](LAB-COB-001/) | Consolidar documentos de prima e impuesto en un recibo conservando la trazabilidad 1:N | Oracle SQL, PL/SQL, vistas, PK/FK, validaciones e idempotencia | Ejecución manual y pruebas documentadas en Oracle FreeSQL |

### LAB-COB-001 · Resultado del escenario validado

- **Entrada:** 2 documentos ficticios (prima 100 + impuesto 20).
- **Salida:** 1 recibo maestro por 120 con 2 registros de detalle.
- **Reprocesamiento:** una segunda ejecución sucesiva, sin modificar los documentos, mantuvo 1 recibo y 2 detalles.

[Ver código, instrucciones y evidencia del laboratorio](LAB-COB-001/README.md).

## Método de trabajo

1. Definir un problema y sus criterios funcionales.
2. Diseñar el modelo de datos ficticio y sus restricciones.
3. Implementar la transformación SQL y la lógica PL/SQL.
4. Ejecutar pruebas y contrastar los resultados con los esperados.
5. Documentar alcance, decisiones y limitaciones.

## Alcance y uso responsable

Este repositorio contiene **ejercicios educativos independientes**: no reproduce sistemas productivos ni incluye estructuras, datos o código propietario de terceros. Las pruebas documentadas corresponden a los escenarios indicados en cada laboratorio; no constituyen pruebas de carga, certificación de concurrencia ni validación productiva.
