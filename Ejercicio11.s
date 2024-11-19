// #include <stdio.h> // Biblioteca para funciones de entrada y salida
// #include <string.h> // Biblioteca para manipulación de cadenas

// // Función para verificar si una cadena es un palíndromo
// // Retorna 1 si es palíndromo, 0 si no lo es
// int is_palindrome(char *str, int length) {
//     int start = 0; // Índice inicial
//     int end = length - 1; // Índice final (última posición de la cadena)

//     // Bucle que compara los caracteres desde ambos extremos hacia el centro
//     while (start < end) {
//         if (str[start] != str[end]) { // Si los caracteres no coinciden
//             return 0; // No es palíndromo
//         }
//         start++; // Avanzar desde el inicio
//         end--; // Retroceder desde el final
//     }
//     return 1; // Es palíndromo
// }

// int main() { // Función principal
//     char prompt[] = "Introduce una palabra: "; // Mensaje para solicitar entrada
//     char str_palindrome[] = "Es palindromo\n"; // Mensaje si es palíndromo
//     char str_not_palindrome[] = "No es palindromo\n"; // Mensaje si no es palíndromo
//     char buffer[100]; // Buffer para almacenar la entrada del usuario

//     // Imprimir prompt al usuario
//     printf("%s", prompt);

//     // Leer la entrada del usuario y almacenarla en el buffer
//     scanf("%99s", buffer); // Limitar a 99 caracteres para evitar desbordamiento

//     // Calcular la longitud de la cadena introducida
//     int length = strlen(buffer); // Obtener longitud de la cadena

//     // Verificar si la cadena es un palíndromo
//     if (is_palindrome(buffer, length)) { // Llamada a la función is_palindrome
//         printf("%s", str_palindrome); // Imprimir mensaje si es palíndromo
//     } else {
//         printf("%s", str_not_palindrome); // Imprimir mensaje si no es palíndromo
//     }

//     return 0; // Finalizar el programa
// }


    .data
    prompt:          .string "Introduce una palabra: "
    str_palindrome:  .string "Es palindromo\n"
    str_not_palindrome: .string "No es palindromo\n"
    format_string:   .string "%s"
    buffer:          .skip 100       // Buffer para almacenar la entrada del usuario

    .text
    .global main

    main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!   // Guardar frame pointer y link register
    mov     x29, sp

    // Imprimir prompt
    adr     x0, prompt
    bl      printf

    // Leer entrada del usuario
    adr     x0, format_string       // Formato para scanf
    adr     x1, buffer              // Buffer donde se guardará la entrada
    bl      scanf

    // Limpiar el buffer de entrada
    bl      getchar                 // Limpiar el carácter newline


    // Calcular longitud de la cadena introducida
    adr     x0, buffer
    bl      strlen                  // Llamar función strlen
    mov     x19, x0                 // Guardar longitud en x19

    // Preparar parámetros para verificar palíndromo
    adr     x0, buffer             // x0 = dirección de la cadena
    mov     x1, x19                // x1 = longitud de la cadena
    bl      is_palindrome          // Llamar a la función is_palindrome

    // Verificar resultado
    cbnz    w0, print_palindrome   // Si resultado != 0, es palíndromo

    print_not_palindrome:
    adr     x0, str_not_palindrome
    bl      printf
    b       end

    print_palindrome:
    adr     x0, str_palindrome
    bl      printf

    end:
    // Epílogo
    ldp     x29, x30, [sp], #16    // Restaurar frame pointer y link register
    mov     w0, #0                 // Retornar 0
    ret

    // Función para verificar si es palíndromo
    // x0 = dirección de la cadena
    // x1 = longitud de la cadena
    // Retorna: 1 si es palíndromo, 0 si no lo es
    is_palindrome:
    stp     x29, x30, [sp, #-16]!  // Guardar registros
    mov     x29, sp

    mov     x2, x0                 // x2 = inicio de la cadena
    add     x3, x0, x1             // x3 = fin de la cadena
    sub     x3, x3, #1             // Ajustar para índice base 0

    compare_loop:
    cmp     x2, x3                 // Comparar punteros
    b.ge    is_palindrome_true     // Si se cruzaron, es palíndromo

    ldrb    w4, [x2]               // Cargar carácter del inicio
    ldrb    w5, [x3]               // Cargar carácter del final

    cmp     w4, w5                 // Comparar caracteres
    b.ne    is_palindrome_false    // Si son diferentes, no es palíndromo
    add     x2, x2, #1             // Mover puntero inicio
    sub     x3, x3, #1             // Mover puntero final
    b       compare_loop

    is_palindrome_true:
    mov     w0, #1                 // Retornar 1 (verdadero)
    b       is_palindrome_end

    is_palindrome_false:
    mov     w0, #0                 // Retornar 0 (falso)

    is_palindrome_end:
    ldp     x29, x30, [sp], #16    // Restaurar registros
    ret
