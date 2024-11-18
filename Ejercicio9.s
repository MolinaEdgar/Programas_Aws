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
// #include <stdio.h> // Biblioteca estándar para funciones de entrada y salida

// int is_prime(int number) { // Función para verificar si un número es primo
//     if (number <= 1)
//         return 0; // No es primo si es 1 o menos

//     for (int i = 2; i * i <= number; i++) { // Bucle para verificar divisibilidad
//         if (number % i == 0)
//             return 0; // No es primo si es divisible por i
//     }
//     return 1; // Es primo si no se encontraron divisores
// }

// int main() { // Función principal
//     int number; // Variable para almacenar el número ingresado por el usuario

//     // Solicitar al usuario que ingrese un número
//     printf("Enter a number: ");
//     scanf("%d", &number); // Leer el número ingresado por el usuario

//     // Verificar si es primo e imprimir el resultado
//     if (is_prime(number)) // Llamar a la función is_prime para verificar
//         printf("%d is a prime number.\n", number); // Imprimir si es primo
//     else
//         printf("%d is not a prime number.\n", number); // Imprimir si no es primo

//     return 0; // Terminar el programa
// }




    .data
    msg_prompt_n: .asciz "Ingresa un número para verificar si es primo: " // Mensaje para solicitar N
    msg_prime: .asciz "El número %d es primo.\n" // Mensaje cuando el número es primo
    msg_not_prime: .asciz "El número %d no es primo.\n" // Mensaje cuando el número no es primo
    fmt_int: .asciz "%d" // Formato para leer enteros

    .text
    .global main

    main:
    // Guardar el puntero de marco y el enlace de retorno
    stp x29, x30, [sp, -16]! // Reservar espacio en la pila
    mov x29, sp // Establecer el puntero de marco
    sub sp, sp, #16 // Reservar espacio para N y el resultado en la pila

    // Solicitar el valor de N
    ldr x0, =msg_prompt_n // Cargar el mensaje para solicitar N
    bl printf // Imprimir el mensaje
    ldr x0, =fmt_int // Cargar el formato para leer un entero
    mov x1, sp // Dirección donde se guardará N en la pila
    bl scanf // Leer el valor de N desde el usuario

    // Cargar N desde la pila
    ldr w1, [sp] // Cargar N en w1

    // Verificar si el número es menor o igual a 1 (no primo)
    cmp w1, #1 // Comparar N con 1
    ble not_prime // Si N <= 1, no es primo

    // Inicializar el contador i en 2
    mov w2, #2 // w2 será el contador i

    // Bucle para verificar si N es divisible por algún número desde 2 hasta √N
    check_prime_loop:
    mul w3, w2, w2 // w3 = i * i
    cmp w3, w1 // Comparar i * i con N
    bgt prime // Si i * i > N, el número es primo

    // Verificar si N es divisible por i
    udiv w4, w1, w2 // w4 = N / i
    mul w5, w4, w2 // w5 = (N / i) * i
    cmp w5, w1 // Comparar (N / i) * i con N
    beq not_prime // Si son iguales, N es divisible por i, no es primo

    // Incrementar el contador i
    add w2, w2, #1 // i = i + 1
    b check_prime_loop // Repetir el bucle

    prime:
    // El número es primo
    ldr x0, =msg_prime // Cargar el mensaje "es primo"
    ldr w1, [sp] // Cargar N en w1 para mostrarlo en el mensaje
    bl printf // Imprimir el mensaje

    b end_program // Saltar al final del programa

    not_prime:
    // El número no es primo
    ldr x0, =msg_not_prime // Cargar el mensaje "no es primo"
    ldr w1, [sp] // Cargar N en w1 para mostrarlo en el mensaje
    bl printf // Imprimir el mensaje

    end_program:
    // Restaurar el puntero de pila y regresar
    add sp, sp, #16 // Restaurar el puntero de pila
    ldp x29, x30, [sp], 16 // Restaurar el puntero de marco y el enlace de retorno
    ret // Regresar del programa
