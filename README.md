# Oracle SQL/PLSQL · Laboratorios técnico-funcionales

**Portafolio de Luis Ferrioli · Desarrollador de Sistemas e Integración de Datos**

Este repositorio reúne laboratorios **originales, ficticios y reproducibles** de Oracle SQL/PLSQL, análisis funcional y arquitectura de datos. Cada caso combina contexto de negocio, modelo de datos, consultas y resultados documentados.

## Laboratorios publicados

| Laboratorio | Problema y conceptos | Documentación |
| --- | --- | --- |
| **[LAB-CORE-001 · Oficinas y pólizas](LAB-CORE-001/)** | Recuperar la oficina asociada a una póliza, usando CTE, `ROW_NUMBER()` y `JOIN` para controlar cardinalidad | [Código, instrucciones y evidencia](LAB-CORE-001/README.md) |

### LAB-CORE-001 · Resultado validado

- **Origen:** cuatro filas ficticias de oficinas y cuatro pólizas.
- **CTE `off`:** dos oficinas con número seleccionado.
- **CTE `policy_ctx`:** dos pólizas recuperadas (`101` y `102`) sin duplicación en la salida del escenario ejecutado.
- **Reglas verificadas:** tratamiento de un número de oficina nulo, selección única por oficina y filtro de estados.

## Método de trabajo

1. Definir el problema funcional.
2. Diseñar tablas y datos ficticios.
3. Implementar el SQL o PL/SQL.
4. Ejecutar y contrastar resultados.
5. Documentar decisiones, alcance y limitaciones.

## Alcance y uso responsable

Laboratorios educativos independientes. No reproducen estructuras oficiales, datos, sistemas productivos ni documentación propietaria de terceros. Las pruebas documentadas corresponden únicamente a los escenarios descritos; no equivalen a certificación productiva o de rendimiento.
