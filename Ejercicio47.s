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
    prompt1:    .string "Ingresa el primer número: "
    prompt2:    .string "Ingresa el segundo número: "
    result:     .string "La suma es: %ld\n"
    overflow:   .string "¡Hubo desbordamiento!\n"
    no_overflow: .string "No hubo desbordamiento\n"
    format:     .string "%ld"
    
    // Constantes para límites de 64 bits
    LONG_MAX:   .quad 9223372036854775807
    LONG_MIN:   .quad -9223372036854775808
    
.text
.global main
main:
    // Preservar registros
    stp x29, x30, [sp, #-16]!
    mov x29, sp
    
    // Reservar espacio para variables locales
    sub sp, sp, #32
    
    // Pedir primer número
    adr x0, prompt1
    bl printf
    
    // Leer primer número
    mov x1, sp
    adr x0, format
    bl scanf
    ldr x19, [sp]        // x19 = primer número
    
    // Pedir segundo número
    adr x0, prompt2
    bl printf
    
    // Leer segundo número
    mov x1, sp
    adr x0, format
    bl scanf
    ldr x20, [sp]        // x20 = segundo número
    
    // Cargar límites de 64 bits
    adr x0, LONG_MAX
    ldr x21, [x0]        // x21 = LONG_MAX
    adr x0, LONG_MIN
    ldr x22, [x0]        // x22 = LONG_MIN
    
    // Realizar la suma
    adds x23, x19, x20   // x23 = suma, actualiza flags
    
    // Verificar desbordamiento usando el flag de carry
    b.vs overflow_detected   // Branch if overflow set
    
no_overflow_detected:
    // Imprimir resultado
    adr x0, result
    mov x1, x23
    bl printf
    
    // Imprimir mensaje de no desbordamiento
    adr x0, no_overflow
    bl printf
    b end
    
overflow_detected:
    // Imprimir resultado
    adr x0, result
    mov x1, x23
    bl printf
    
    // Imprimir mensaje de desbordamiento
    adr x0, overflow
    bl printf
    
end:
    // Restaurar stack y registros
    add sp, sp, #32
    ldp x29, x30, [sp], #16
    ret
