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
#include <stdio.h>    // Incluir la biblioteca estándar para entrada y salida
#include <string.h>    // Incluir la biblioteca para trabajar con cadenas de caracteres

int main() {    // Inicio de la función principal

    // Declaraciones de mensajes y buffers
    char msg_input[] = "Ingrese una palabra o frase (máximo 100 caracteres): ";    // Mensaje de solicitud de entrada al usuario
    char msg_error[] = "Error: Entrada demasiado larga o inválida.\n";    // Mensaje de error si la entrada excede el límite
    char msg_vocales[] = "Número de vocales: %d\n";    // Mensaje para mostrar el número de vocales
    char msg_consonantes[] = "Número de consonantes: %d\n";    // Mensaje para mostrar el número de consonantes
    char vocales[] = "aeiouAEIOU";    // Cadena de caracteres que contiene las vocales en mayúsculas y minúsculas para comparación
    char input_buffer[101];    // Buffer para almacenar la entrada del usuario con un límite de 100 caracteres + el terminador null
    int contador_vocales = 0;    // Inicializar el contador de vocales a cero
    int contador_consonantes = 0;    // Inicializar el contador de consonantes a cero

    printf("%s", msg_input);    // Mostrar el mensaje de solicitud de entrada al usuario

    // Leer la entrada del usuario, restringiendo a 100 caracteres y capturando hasta el salto de línea
    if (scanf("%100[^\n]", input_buffer) != 1) {    // Si no se puede leer correctamente, ejecutar el bloque de error
        printf("%s", msg_error);    // Mostrar el mensaje de error
        return 1;    // Terminar el programa con un código de error
    }

    // Recorrer cada carácter en la entrada para contar vocales y consonantes
    for (char *ptr = input_buffer; *ptr != '\0'; ptr++) {    // Inicializa ptr en el inicio del buffer, recorre hasta el final de la cadena
        char c = *ptr;    // Almacena el carácter actual en la variable c

        // Comprobar si el carácter actual es una letra
        if ((c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z')) {    // Verificar si c es una letra (mayúscula o minúscula)
            
            // Comprobar si es vocal o consonante
            if (strchr(vocales, c) != NULL) {    // Usar strchr para ver si c es una vocal buscando en la cadena "vocales"
                contador_vocales++;    // Si es vocal, incrementar el contador de vocales
            } else {
                contador_consonantes++;    // Si no es vocal, incrementar el contador de consonantes
            }
        }
    }

    printf(msg_vocales, contador_vocales);    // Imprimir el número total de vocales encontradas en la entrada
    printf(msg_consonantes, contador_consonantes);    // Imprimir el número total de consonantes encontradas en la entrada

    return 0;    // Terminar el programa con código de éxito
}
*/

.global main
.data
    // Mensajes y buffers
    msg_input: .string "Ingrese una palabra o frase (máximo 100 caracteres): "
    msg_error: .string "Error: Entrada demasiado larga o inválida.\n"
    msg_vocales: .string "Número de vocales: %d\n"
    msg_consonantes: .string "Número de consonantes: %d\n"
    input_format: .string "%[^\n]"  // Leer hasta encontrar un salto de línea
    input_buffer: .skip 101     // Buffer para entrada (100 chars + null)
    vocales: .string "aeiouAEIOU"

.text
main:
    // Prólogo
    stp     x29, x30, [sp, -48]!
    mov     x29, sp

    // Reservar espacio para variables locales
    // x19 = contador de vocales
    // x20 = contador de consonantes
    // x21 = puntero al buffer de entrada
    mov     x19, #0     // Inicializar contador de vocales
    mov     x20, #0     // Inicializar contador de consonantes

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
    adr     x21, input_buffer   // x21 = puntero al inicio de la cadena

process_loop:
    // Cargar carácter actual
    ldrb    w22, [x21]         // w22 = carácter actual
    
    // Si es null terminator, terminar
    cbz     w22, print_results
    
    // Verificar si es una letra
    bl      is_letter
    cbz     x0, next_char      // Si no es letra, siguiente carácter
    
    // Verificar si es vocal
    bl      is_vowel
    cbnz    x0, count_vowel    // Si es vocal, contar vocal
    
    // Si llegamos aquí, es consonante
    add     x20, x20, #1       // Incrementar contador de consonantes
    b       next_char

count_vowel:
    add     x19, x19, #1       // Incrementar contador de vocales

next_char:
    add     x21, x21, #1       // Avanzar al siguiente carácter
    b       process_loop

print_results:
    // Limpiar el buffer de entrada
    mov     x0, #0
    bl      getchar

    // Imprimir resultados
    adr     x0, msg_vocales
    mov     x1, x19
    bl      printf
    
    adr     x0, msg_consonantes
    mov     x1, x20
    bl      printf
    
    // Epílogo y retorno
    mov     w0, #0
    ldp     x29, x30, [sp], 48
    ret

error_input:
    // Mostrar mensaje de error
    adr     x0, msg_error
    bl      printf
    mov     w0, #1
    ldp     x29, x30, [sp], 48
    ret

// Función para verificar si un carácter es letra
is_letter:
    // Verificar si está entre 'A' y 'Z' o 'a' y 'z'
    and     w0, w22, #0xFF
    sub     w1, w0, #'A'
    cmp     w1, #26
    b.ls    1f
    sub     w1, w0, #'a'
    cmp     w1, #26
    b.ls    1f
    mov     x0, #0
    ret
1:  mov     x0, #1
    ret

// Función para verificar si un carácter es vocal
is_vowel:
    adr     x23, vocales       // x23 = puntero a string de vocales
    mov     x24, #0            // x24 = índice

check_vowel_loop:
    ldrb    w25, [x23, x24]    // Cargar vocal actual
    cbz     w25, not_vowel     // Si llegamos al final, no es vocal
    cmp     w22, w25           // Comparar con carácter actual
    b.eq    is_vowel_true      // Si son iguales, es vocal
    add     x24, x24, #1       // Siguiente vocal
    b       check_vowel_loop

is_vowel_true:
    mov     x0, #1
    ret

not_vowel:
    mov     x0, #0
    ret
