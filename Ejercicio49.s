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
    prompt: .asciz "🖊  Por favor, ingrese un texto: "
    input: .space 100       // Buffer para almacenar la entrada (100 bytes)
    formato: .asciz "%[^\n]" // Formato para scanf que lee hasta encontrar un newline
    output: .asciz " Usted escribió: %s\n"
    error_msg: .asciz " Error al leer la entrada\n"

.text
.global main
.extern printf
.extern scanf
.extern gets
.extern puts

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Mostrar prompt
    adrp x0, prompt
    add x0, x0, :lo12:prompt
    bl printf
    
    // Leer entrada usando scanf
    adrp x0, formato
    add x0, x0, :lo12:formato    // Primer argumento: formato
    adrp x1, input
    add x1, x1, :lo12:input      // Segundo argumento: buffer
    bl scanf
    
    // Verificar si scanf fue exitoso
    cmp x0, #1
    bne error_reading
    
    // Mostrar lo que se leyó
    adrp x0, output
    add x0, x0, :lo12:output
    adrp x1, input
    add x1, x1, :lo12:input
    bl printf
    
    // Epílogo y retorno exitoso
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
    
error_reading:
    // Mostrar mensaje de error
    adrp x0, error_msg
    add x0, x0, :lo12:error_msg
    bl printf
    
    // Retornar con código de error
    mov w0, #1
    ldp x29, x30, [sp], #16
    ret
