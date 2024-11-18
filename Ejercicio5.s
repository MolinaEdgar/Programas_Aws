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
    prompt1:    .string "Ingrese el dividendo (primer número): "
    prompt2:    .string "Ingrese el divisor (segundo número): "
    error_msg:  .string "Error: No se puede dividir por cero\n"
    format_in:  .string "%ld"                    // Formato para leer enteros largos
    format_out: .string "El cociente es: %ld\nEl resto es: %ld\n" // Formato para mostrar resultados
    num1:       .quad 0                          // Dividendo
    num2:       .quad 0                          // Divisor
    result:     .quad 0                          // Cociente
    resto:      .quad 0                          // Resto

    .text
    .global main

    main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!    // Guardar frame pointer y link register
    mov     x29, sp                   // Establecer frame pointer

    // Mostrar primer prompt y leer dividendo
    adr     x0, prompt1
    bl      printf

    adr     x0, format_in            // Formato para scanf
    adr     x1, num1                 // Donde guardar el número
    bl      scanf

    // Mostrar segundo prompt y leer divisor
    adr     x0, prompt2
    bl      printf

    adr     x0, format_in            // Formato para scanf
    adr     x1, num2                 // Donde guardar el segundo número
    bl      scanf

    // Cargar números en registros
    adr     x0, num1
    ldr     x19, [x0]                // Cargar dividendo
    adr     x0, num2
    ldr     x20, [x0]                // Cargar divisor

    // Verificar división por cero
    cmp     x20, #0
    bne     realizar_division        // Si no es cero, realizar la división
    
    // Si es cero, mostrar error y salir
    adr     x0, error_msg
    bl      printf
    b       fin

    realizar_division:
    // Realizar la división
    sdiv    x21, x19, x20           // x21 = x19 / x20 (cociente)
    
    // Calcular el resto
    msub    x22, x21, x20, x19      // x22 = x19 - (x21 * x20) (resto)
    
    // Guardar resultados
    adr     x0, result
    str     x21, [x0]
    adr     x0, resto
    str     x22, [x0]

    // Mostrar resultados
    adr     x0, format_out          // Formato para printf
    mov     x1, x21                 // Pasar cociente como primer argumento
    mov     x2, x22                 // Pasar resto como segundo argumento
    bl      printf

    fin:
    // Epílogo y retorno
    mov     w0, #0                  // Código de retorno
    ldp     x29, x30, [sp], #16     // Restaurar frame pointer y link register
    ret
