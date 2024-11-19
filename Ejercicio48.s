***************************************************************
*                                                             *
*                Instituto Tecnico De Tijuana                 *
*                                                             *
*                  Edgar Fabian Molina Fabela                 *
*                                                             *
*                 Número de Control: 22210780                 *
*                                                             *
*                      Fecha: 19/11/24                        *
*                                                             *
*                  Proyecto: 50 Programas AWS                 *
*                                                             *
***************************************************************
.data
    msg_start:  .asciz "\n  Iniciando medición de tiempo...\n"
    msg_end:    .asciz "\n Función completada.\n"
    msg_time:   .asciz " Tiempo de ejecución: %ld nanosegundos\n"
    msg_time_ms:.asciz " Tiempo en milisegundos: %ld.%03ld\n"
    msg_result: .asciz " Resultado del cálculo: %ld\n"
    // Constantes
    .equ CLOCK_MONOTONIC, 1
    
    // Valores para cálculos temporales
    billion: .quad 1000000000
    million: .quad 1000000
    thousand: .quad 1000
    
    // Estructura timespec para clock_gettime
    .align 8
    start_time: .space 16    // Estructura para tiempo inicial
    end_time:   .space 16    // Estructura para tiempo final

.text
.global main
.extern printf
.extern clock_gettime

// Función que queremos medir
test_function:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    mov x0, #0          // Inicializar contador
    mov x19, #1000      // Para construir 1000000
    mov x20, #1000
    mul x1, x19, x20    // x1 = 1000000
    
loop:
    add x0, x0, #1      // Incrementar contador
    mul x2, x0, x0      // Multiplicar por sí mismo
    udiv x2, x2, x0     // Dividir por el contador
    sub x1, x1, #1      // Decrementar iteraciones
    cbnz x1, loop       // Continuar si no hemos terminado
    
    ldp x29, x30, [sp], #16
    ret

main:
    stp x29, x30, [sp, -32]!
    mov x29, sp
    
    // Imprimir mensaje de inicio
    adrp x0, msg_start
    add x0, x0, :lo12:msg_start
    bl printf
    
    // Obtener tiempo inicial
    mov w0, #CLOCK_MONOTONIC
    adrp x1, start_time
    add x1, x1, :lo12:start_time
    bl clock_gettime
    
    // Ejecutar la función a medir
    bl test_function
    str x0, [sp, #16]   // Guardar resultado
    
    // Obtener tiempo final
    mov w0, #CLOCK_MONOTONIC
    adrp x1, end_time
    add x1, x1, :lo12:end_time
    bl clock_gettime
    
    // Imprimir mensaje de finalización
    adrp x0, msg_end
    add x0, x0, :lo12:msg_end
    bl printf
    
    // Calcular diferencia de tiempo
    adrp x0, end_time
    add x0, x0, :lo12:end_time
    ldr x2, [x0]        // Cargar segundos final
    ldr x3, [x0, #8]    // Cargar nanosegundos final
    
    adrp x0, start_time
    add x0, x0, :lo12:start_time
    ldr x4, [x0]        // Cargar segundos inicial
    ldr x5, [x0, #8]    // Cargar nanosegundos inicial
    
    // Calcular diferencia
    sub x2, x2, x4      // Diferencia en segundos
    sub x3, x3, x5      // Diferencia en nanosegundos
    
    // Convertir segundos a nanosegundos y sumar
    adrp x0, billion
    add x0, x0, :lo12:billion
    ldr x4, [x0]        // Cargar 1000000000
    mul x2, x2, x4      // Convertir segundos a nanosegundos
    add x3, x3, x2      // x3 contiene el total de nanosegundos
    
    // Imprimir tiempo en nanosegundos
    adrp x0, msg_time
    add x0, x0, :lo12:msg_time
    mov x1, x3
    bl printf
    
    // Calcular milisegundos
    mov x1, x3          // Copiar nanosegundos
    adrp x0, million
    add x0, x0, :lo12:million
    ldr x2, [x0]        // Cargar 1000000
    udiv x4, x1, x2     // Parte entera de milisegundos
    msub x5, x4, x2, x1 // Resto en nanosegundos
    
    adrp x0, thousand
    add x0, x0, :lo12:thousand
    ldr x2, [x0]        // Cargar 1000
    udiv x5, x5, x2     // Convertir resto a microsegundos
    
    // Imprimir tiempo en milisegundos
    adrp x0, msg_time_ms
    add x0, x0, :lo12:msg_time_ms
    mov x1, x4          // Milisegundos
    mov x2, x5          // Microsegundos
    bl printf
    
    // Mostrar resultado del cálculo
    adrp x0, msg_result
    add x0, x0, :lo12:msg_result
    ldr x1, [sp, #16]   // Cargar resultado guardado
    bl printf
    
    // Salir
    mov w0, #0
    ldp x29, x30, [sp], #32
    ret
