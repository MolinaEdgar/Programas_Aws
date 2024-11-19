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
// #include <stdio.h>    // Incluir la biblioteca estándar para entrada y salida

// int main() {    // Función principal

//     char prompt[] = "Ingrese un número (máximo 5 dígitos): ";    // Mensaje de prompt
//     char result[] = "El número convertido es: %d\n";    // Mensaje de resultado
//     char error_msg[] = "Error: Entrada inválida. Solo se permiten dígitos.\n";    // Mensaje de error
//     char formato_scan[] = "%s";    // Formato para leer entrada como cadena
//     char buffer[6];    // Búfer de entrada (5 dígitos + null terminator)
//     int x19 = 0;    // Variable para el resultado final de la conversión

//     printf("%s", prompt);    // Mostrar prompt
//     scanf(formato_scan, buffer);    // Leer entrada en el búfer

//     char *x20 = buffer;    // Apuntar al inicio del búfer

//     while (*x20 != '\0') {    // Bucle para procesar cada carácter en el búfer
//         if (*x20 < '0' || *x20 > '9') {    // Verificar si el carácter no es un dígito
//             printf("%s", error_msg);    // Mostrar mensaje de error si el carácter no es válido
//             return 1;    // Terminar con código de error
//         }
        
//         int w21 = *x20 - '0';    // Convertir carácter ASCII a valor numérico

//         x19 = x19 * 10 + w21;    // Multiplicar resultado acumulado por 10 y sumar dígito convertido
//         x20++;    // Avanzar al siguiente carácter en el búfer
//     }

//     printf(result, x19);    // Mostrar el resultado final de la conversión
//     return 0;    // Finalizar el programa exitosamente
// }

.data
    // Mensajes y formatos
    prompt: .asciz "Ingrese un número (máximo 5 dígitos): "
    result: .asciz "El número convertido es: %d\n"
    error_msg: .asciz "Error: Entrada inválida. Solo se permiten dígitos.\n"
    formato_scan: .asciz "%s"
    
    // Buffer para almacenar la entrada
    .align 4
    buffer: .skip 6     // 5 dígitos + null terminator
    
.text
.global main
.extern printf
.extern scanf

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp
    
    // Mostrar prompt
    adrp x0, prompt
    add x0, x0, :lo12:prompt
    bl printf
    
    // Leer entrada
    adrp x0, formato_scan
    add x0, x0, :lo12:formato_scan
    adrp x1, buffer
    add x1, x1, :lo12:buffer
    bl scanf
    
    // Inicializar resultado
    mov x19, #0      // x19 será nuestro resultado
    
    // Preparar para procesar la cadena
    adrp x20, buffer
    add x20, x20, :lo12:buffer
    
proceso_loop:
    // Cargar byte actual
    ldrb w21, [x20]
    
    // Verificar si es fin de cadena
    cmp w21, #0
    beq fin_conversion
    
    // Verificar si es dígito (ASCII 48-57)
    cmp w21, #48
    blt error
    cmp w21, #57
    bgt error
    
    // Convertir ASCII a dígito
    sub w21, w21, #48
    
    // Multiplicar resultado actual por 10 y sumar nuevo dígito
    mov x22, #10
    mul x19, x19, x22
    add x19, x19, x21
    
    // Avanzar al siguiente carácter
    add x20, x20, #1
    b proceso_loop
    
error:
    // Mostrar mensaje de error
    adrp x0, error_msg
    add x0, x0, :lo12:error_msg
    bl printf
    mov w0, #1
    b fin
    
fin_conversion:
    // Mostrar resultado
    adrp x0, result
    add x0, x0, :lo12:result
    mov x1, x19
    bl printf
    
    mov w0, #0
    
fin:
    // Epílogo
    ldp x29, x30, [sp], #16
    ret
