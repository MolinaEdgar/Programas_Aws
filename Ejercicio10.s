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
//#include <stdio.h> // Biblioteca para funciones de entrada y salida
// #include <string.h> // Biblioteca para manipulación de cadenas

// int main() { // Función principal
//     char str[256]; // Declaración de un arreglo de caracteres para la cadena de texto

//     // Solicitar la cadena de texto al usuario
//     printf("Ingresa una cadena de texto: ");
//     scanf("%255s", str); // Leer la cadena, con un límite de 255 caracteres para evitar desbordamiento

//     // Encontrar el final de la cadena (longitud de la cadena)
//     int length = strlen(str); // Usar strlen para obtener la longitud de la cadena

//     // Invertir la cadena
//     for (int i = 0, j = length - 1; i < j; i++, j--) { // Bucle para recorrer desde ambos extremos
//         // Intercambiar los caracteres en las posiciones i y j
//         char temp = str[i]; // Guardar temporalmente el carácter en la posición i
//         str[i] = str[j]; // Colocar el carácter de j en i
//         str[j] = temp; // Colocar el carácter temporal en j
//     }

//     // Imprimir la cadena invertida
//     printf("La cadena invertida es: %s\n", str); // Mostrar la cadena después de invertirla

//     return 0; // Finalizar el programa
// }


    .data
    msg_prompt: .asciz "Ingresa una cadena de texto: " // Mensaje para solicitar la cadena
    msg_result: .asciz "La cadena invertida es: %s\n" // Mensaje para imprimir la cadena invertida

    .text
    .global main

    main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -16]! // Reservar espacio en la pila
    mov x29, sp // Establecer el puntero de marco
    sub sp, sp, #256 // Reservar espacio para la cadena de entrada (máximo 255 caracteres)

    // Solicitar la cadena de texto
    ldr x0, =msg_prompt // Cargar el mensaje para solicitar la cadena
    bl printf // Imprimir el mensaje
    ldr x0, =input_format // Cargar el formato para leer una cadena
    mov x1, sp // Dirección donde se guardará la cadena en la pila
    bl scanf // Leer la cadena desde el usuario

    // Encontrar el final de la cadena (buscando el carácter nulo '\0')
    mov x2, sp // Dirección de la cadena
    find_end:
    ldrb w3, [x2] // Cargar el siguiente byte de la cadena
    cmp w3, #0 // Verificar si es el carácter nulo ('\0')
    beq reverse_string // Si es el final de la cadena, salir del bucle
    add x2, x2, #1 // Avanzar al siguiente carácter
    b find_end // Continuar buscando

    reverse_string:
    // x2 contiene la dirección del carácter nulo ('\0'), retrocedemos una posición
    sub x2, x2, #1 // Retroceder una posición, apuntar al último carácter válido

    // Iniciar el proceso de invertir la cadena
    mov x3, sp // Dirección inicial de la cadena
    reverse_loop:
    cmp x3, x2 // Comparar los punteros
    bge end_reverse // Si los punteros se cruzan, terminamos
    ldrb w4, [x3] // Cargar el carácter de la posición inicial
    ldrb w5, [x2] // Cargar el carácter de la posición final
    strb w5, [x3] // Colocar el carácter final en la posición inicial
    strb w4, [x2] // Colocar el carácter inicial en la posición final
    add x3, x3, #1 // Avanzar el puntero inicial
    sub x2, x2, #1 // Retroceder el puntero final
    b reverse_loop // Continuar invirtiendo

    end_reverse:
    // Imprimir la cadena invertida
    ldr x0, =msg_result // Cargar el mensaje para mostrar el resultado
    mov x1, sp // Dirección de la cadena invertida
    bl printf // Imprimir la cadena invertida

    // Restaurar el puntero de pila y regresar
    add sp, sp, #256 // Restaurar el puntero de pila
    ldp x29, x30, [sp], 16 // Restaurar el puntero de marco y el enlace de retorno
    ret // Regresar del programa

    .data
    input_format: .asciz "%255s" // Formato para leer una cadena de hasta 255 caracteres
