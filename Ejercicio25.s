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
// #include <stdio.h> // Incluir la biblioteca estándar para entrada y salida
// #include <string.h> // Incluir la biblioteca para manipulación de cadenas

// int main() { // Función principal

//     // Declaración de mensajes y buffers
//     char msg_input[] = "Ingrese una cadena de texto (máximo 100 caracteres): "; // Mensaje de entrada para el usuario
//     char msg_error[] = "Error: Entrada demasiado larga o inválida.\n"; // Mensaje de error si la entrada es demasiado larga o inválida
//     char msg_length[] = "La longitud de la cadena es: %d caracteres\n"; // Mensaje que muestra la longitud de la cadena
//     char msg_details[] = "Desglose:\n- Letras: %d\n- Números: %d\n- Espacios: %d\n- Otros caracteres: %d\n"; // Mensaje con desglose de tipos de caracteres
//     char input_buffer[101]; // Buffer para almacenar la entrada del usuario, con capacidad para 100 caracteres + null terminador
//     int total = 0; // Contador para el total de caracteres
//     int letras = 0; // Contador de letras
//     int numeros = 0; // Contador de números
//     int espacios = 0; // Contador de espacios
//     int otros = 0; // Contador de otros caracteres

//     printf("%s", msg_input); // Mostrar el mensaje de solicitud de entrada

//     // Leer la entrada del usuario (hasta 100 caracteres)
//     if (scanf("%100[^\n]", input_buffer) != 1) { // Si la entrada falla, mostrar mensaje de error
//         printf("%s", msg_error); // Imprimir mensaje de error
//         return 1; // Finalizar el programa con código de error
//     }

//     // Procesar cada carácter en la cadena ingresada
//     for (int i = 0; input_buffer[i] != '\0'; i++) { // Iterar sobre cada carácter hasta el terminador null
//         total++; // Incrementar el contador total de caracteres

//         if ((input_buffer[i] >= 'A' && input_buffer[i] <= 'Z') || (input_buffer[i] >= 'a' && input_buffer[i] <= 'z')) { // Verificar si el carácter es una letra
//             letras++; // Incrementar contador de letras
//         }
//         else if (input_buffer[i] >= '0' && input_buffer[i] <= '9') { // Verificar si el carácter es un número
//             numeros++; // Incrementar contador de números
//         }
//         else if (input_buffer[i] == ' ') { // Verificar si el carácter es un espacio
//             espacios++; // Incrementar contador de espacios
//         }
//         else { // Si no es letra, número ni espacio, es otro carácter
//             otros++; // Incrementar contador de otros caracteres
//         }
//     }

//     // Imprimir el mensaje con la longitud total de la cadena
//     printf(msg_length, total); // Imprimir la longitud de la cadena

//     // Imprimir el desglose de letras, números, espacios y otros caracteres
//     printf(msg_details, letras, numeros, espacios, otros); // Mostrar el desglose de caracteres

//     return 0; // Finalizar el programa con éxito
// }

.global main
.data
    // Mensajes y buffers
    msg_input: .string "Ingrese una cadena de texto (máximo 100 caracteres): "
    msg_error: .string "Error: Entrada demasiado larga o inválida.\n"
    msg_length: .string "La longitud de la cadena es: %d caracteres\n"
    msg_details: .string "Desglose:\n- Letras: %d\n- Números: %d\n- Espacios: %d\n- Otros caracteres: %d\n"
    input_format: .string "%[^\n]"
    input_buffer: .skip 101     // Buffer para entrada (100 chars + null)

.text
main:
    // Prólogo
    stp     x29, x30, [sp, -64]!
    mov     x29, sp

    // Inicializar contadores
    // x19 = contador total
    // x20 = contador de letras
    // x21 = contador de números
    // x22 = contador de espacios
    // x23 = contador de otros caracteres
    mov     x19, #0     // Total
    mov     x20, #0     // Letras
    mov     x21, #0     // Números
    mov     x22, #0     // Espacios
    mov     x23, #0     // Otros

    // Mostrar mensaje de entrada
    adr     x0, msg_input
    bl      printf

    // Leer entrada del usuario usando scanf
    adr     x0, input_format
    adr     x1, input_buffer
    bl      scanf

    // Verificar si la entrada fue exitosa
    cmp     x0, #1
    b.ne    error_input

    // Preparar para procesar la cadena
    adr     x24, input_buffer   // x24 = puntero al buffer

count_loop:
    // Cargar carácter actual
    ldrb    w25, [x24]         // w25 = carácter actual
    
    // Si es null terminator, terminar
    cbz     w25, print_results
    
    // Incrementar contador total
    add     x19, x19, #1
    
    // Clasificar el carácter
    bl      classify_char
    
    // Siguiente carácter
    add     x24, x24, #1
    b       count_loop

print_results:
    // Limpiar el buffer de entrada
    mov     x0, #0
    bl      getchar

    // Imprimir longitud total
    adr     x0, msg_length
    mov     x1, x19
    bl      printf
    
    // Imprimir desglose
    adr     x0, msg_details
    mov     x1, x20        // Letras
    mov     x2, x21        // Números
    mov     x3, x22        // Espacios
    mov     x4, x23        // Otros
    bl      printf
    
    // Epílogo y retorno
    mov     w0, #0
    ldp     x29, x30, [sp], 64
    ret

error_input:
    // Mostrar mensaje de error
    adr     x0, msg_error
    bl      printf
    mov     w0, #1
    ldp     x29, x30, [sp], 64
    ret

// Función para clasificar caracteres
classify_char:
    // Preservar enlace de retorno
    stp     x30, xzr, [sp, -16]!

    // Verificar si es letra
    cmp     w25, #'A'
    b.lt    check_number
    cmp     w25, #'Z'
    b.le    is_letter
    cmp     w25, #'a'
    b.lt    check_number
    cmp     w25, #'z'
    b.le    is_letter

check_number:
    // Verificar si es número
    cmp     w25, #'0'
    b.lt    check_space
    cmp     w25, #'9'
    b.le    is_number

check_space:
    // Verificar si es espacio
    cmp     w25, #' '
    b.eq    is_space
    
    // Si llegamos aquí, es otro carácter
    add     x23, x23, #1
    b       classify_end

is_letter:
    add     x20, x20, #1
    b       classify_end

is_number:
    add     x21, x21, #1
    b       classify_end

is_space:
    add     x22, x22, #1

classify_end:
    // Restaurar enlace de retorno y retornar
    ldp     x30, xzr, [sp], 16
    ret
