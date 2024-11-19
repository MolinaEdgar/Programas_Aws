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
    // Mensajes del sistema
    msg_creando: .asciz "Creando Archivo\n"
    msg_exito_crear: .asciz "Archivo creado con éxito\n"
    msg_error_crear: .asciz "Error en creación de archivo\n"
    msg_pedir: .asciz "Introduce mensaje para escribir en el archivo: "
    msg_exito_escribir: .asciz "Mensaje introducido con éxito\n"
    msg_error_escribir: .asciz "Error en introducción de mensaje\n"
    
    // Archivo y buffer
    filename: .asciz "salida.txt"
    mode: .asciz "w"
    input: .space 100
    formato: .asciz "%[^\n]"
    
    // Descriptor de archivo
    .align 8
    fileptr: .skip 8

.text
.global main
.extern fopen
.extern fprintf
.extern printf
.extern scanf
.extern fclose

main:
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Mostrar "Creando Archivo"
    adrp x0, msg_creando
    add x0, x0, :lo12:msg_creando
    bl printf
    
    // Abrir archivo
    adrp x0, filename
    add x0, x0, :lo12:filename
    adrp x1, mode
    add x1, x1, :lo12:mode
    bl fopen
    
    // Guardar file pointer
    adrp x1, fileptr
    add x1, x1, :lo12:fileptr
    str x0, [x1]
    
    // Verificar si se abrió correctamente
    cmp x0, #0
    beq error_crear
    
    // Mostrar éxito en creación
    adrp x0, msg_exito_crear
    add x0, x0, :lo12:msg_exito_crear
    bl printf
    
    // Pedir mensaje al usuario
    adrp x0, msg_pedir
    add x0, x0, :lo12:msg_pedir
    bl printf
    
    // Leer mensaje del usuario
    adrp x0, formato
    add x0, x0, :lo12:formato
    adrp x1, input
    add x1, x1, :lo12:input
    bl scanf
    
    // Verificar lectura exitosa
    cmp x0, #1
    bne error_escribir
    
    // Escribir en archivo
    adrp x0, fileptr
    add x0, x0, :lo12:fileptr
    ldr x0, [x0]
    adrp x1, input
    add x1, x1, :lo12:input
    bl fprintf
    
    // Cerrar archivo
    adrp x0, fileptr
    add x0, x0, :lo12:fileptr
    ldr x0, [x0]
    bl fclose
    
    // Mostrar éxito en escritura
    adrp x0, msg_exito_escribir
    add x0, x0, :lo12:msg_exito_escribir
    bl printf
    
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret

error_crear:
    // Mostrar error en creación
    adrp x0, msg_error_crear
    add x0, x0, :lo12:msg_error_crear
    bl printf
    mov w0, #1
    ldp x29, x30, [sp], #16
    ret

error_escribir:
    // Mostrar error en escritura
    adrp x0, msg_error_escribir
    add x0, x0, :lo12:msg_error_escribir
    bl printf
    // Cerrar archivo antes de salir
    adrp x0, fileptr
    add x0, x0, :lo12:fileptr
    ldr x0, [x0]
    bl fclose
    mov w0, #1
    ldp x29, x30, [sp], #16
    ret
