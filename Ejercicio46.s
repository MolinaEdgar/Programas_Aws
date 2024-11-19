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
    // Mensajes del programa
    prompt_count: .string "Ingresa 3 cadenas\n"
    prompt_str:   .string "Ingresa la cadena %d: "
    result_msg:   .string "El sufijo común más largo es: "
    no_prefix:    .string "No hay sufijo común\n"
    newline:      .string "\n"
    format_str:   .string "%s"
    read_str:     .string " %99s"
    
    // Buffers para almacenar las cadenas
    str1:         .skip 100
    str2:         .skip 100
    str3:         .skip 100
    
    // Variables
    suffix:       .skip 100

.text
.global main

strlen:
    mov x2, #0                // Contador
1:
    ldrb w1, [x0, x2]        // Cargar byte
    cbz w1, 2f               // Si es 0, terminar
    add x2, x2, #1           // Incrementar contador
    b 1b                     // Siguiente byte
2:
    mov x0, x2               // Retornar longitud
    ret

main:
    // Preservar registros
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Mostrar mensaje inicial
    adr x0, prompt_count
    bl printf

    // Leer las 3 cadenas
    mov x20, #0              // Contador de cadenas
read_strings:
    // Imprimir prompt
    adr x0, prompt_str
    add x1, x20, #1
    bl printf

    // Leer cadena
    adr x21, str1
    cmp x20, #1
    b.eq use_str2
    cmp x20, #2
    b.eq use_str3
    b continue_read
use_str2:
    adr x21, str2
    b continue_read
use_str3:
    adr x21, str3
continue_read:
    adr x0, read_str
    mov x1, x21
    bl scanf
    
    // Limpiar buffer
    bl getchar

    add x20, x20, #1
    cmp x20, #3             
    b.lt read_strings

    // Obtener longitudes de las cadenas
    adr x0, str1
    bl strlen
    mov x21, x0             // x21 = longitud str1
    
    adr x0, str2
    bl strlen
    mov x22, x0             // x22 = longitud str2
    
    adr x0, str3
    bl strlen
    mov x23, x0             // x23 = longitud str3

find_suffix:
    mov x20, #0              // Contador de caracteres coincidentes
check_char:
    // Comparar caracteres desde el final
    adr x0, str1
    sub x1, x21, x20
    sub x1, x1, #1
    ldrb w24, [x0, x1]     // Cargar carácter de str1
    
    adr x0, str2
    sub x1, x22, x20
    sub x1, x1, #1
    ldrb w25, [x0, x1]     // Cargar carácter de str2

    cmp w24, w25
    b.ne print_result      // Si son diferentes, terminar
    
    adr x0, str3
    sub x1, x23, x20
    sub x1, x1, #1
    ldrb w25, [x0, x1]     // Cargar carácter de str3

    cmp w24, w25
    b.ne print_result      // Si son diferentes, terminar

    // Guardar carácter en el sufijo (desde el final)
    adr x0, suffix
    strb w24, [x0, x20]    
    
    add x20, x20, #1       // Incrementar contador
    
    // Verificar si hemos llegado al inicio de alguna cadena
    cmp x20, x21
    b.ge print_result
    cmp x20, x22
    b.ge print_result
    cmp x20, x23
    b.ge print_result
    
    b check_char

print_result:
    // Verificar si hay sufijo
    cmp x20, #0
    b.eq no_common_suffix

    // Imprimir mensaje de resultado
    adr x0, result_msg
    bl printf

    // Revertir el sufijo (ya que lo guardamos al revés)
    adr x0, suffix
    mov x1, #0              // índice inicio
    sub x2, x20, #1         // índice final
reverse_loop:
    cmp x1, x2
    b.ge end_reverse
    ldrb w3, [x0, x1]      // temp = str[i]
    ldrb w4, [x0, x2]      // temp2 = str[j]
    strb w4, [x0, x1]      // str[i] = temp2
    strb w3, [x0, x2]      // str[j] = temp
    add x1, x1, #1
    sub x2, x2, #1
    b reverse_loop
end_reverse:    

    // Agregar null terminator
    adr x0, suffix
    strb wzr, [x0, x20]

    // Imprimir sufijo
    adr x0, suffix
    bl printf

    // Imprimir nueva línea
    adr x0, newline
    bl printf
    b exit

no_common_suffix:
    adr x0, no_prefix
    bl printf

exit:
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
