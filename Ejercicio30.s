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
// #include <stdio.h> // Biblioteca estándar de entrada y salida para funciones como printf

// // Función que calcula el MCD de dos números usando el algoritmo de Euclides
// int mcd(int a, int b) {
//     while (b != 0) { // Bucle para aplicar el algoritmo de Euclides hasta que b sea 0
//         int temp = a % b; // Calcula el resto de a / b y lo almacena en una variable temporal
//         a = b;            // Asigna el valor de b a a
//         b = temp;         // Asigna el resto calculado (temp) a b
//     }
//     return a; // Devuelve el valor de a, que contiene el MCD cuando b es 0
// }

// // Función que imprime el proceso paso a paso del cálculo del MCD
// void print_steps(int a, int b) {
//     while (b != 0) { // Itera hasta que b sea 0
//         printf("Dividiendo %d entre %d\n", a, b); // Imprime el paso actual de a dividido entre b
//         int temp = a % b; // Calcula el resto de a / b
//         a = b;            // Actualiza a con el valor de b
//         b = temp;         // Actualiza b con el valor del resto
//     }
// }

// int main() { // Función principal
//     int num1 = 48; // Primer número para calcular el MCD
//     int num2 = 18; // Segundo número para calcular el MCD

//     printf("\nCalculando el MCD de %d y %d\n", num1, num2); // Imprime el mensaje inicial con los números

//     print_steps(num1, num2); // Llama a la función para imprimir los pasos del cálculo

//     int resultado = mcd(num1, num2); // Calcula el MCD de num1 y num2 usando la función mcd

//     printf("\nEl MCD es: %d\n", resultado); // Imprime el resultado final del MCD

//     return 0; // Finaliza el programa principal
// }

.global main
.text

// Función para calcular el MCD usando el algoritmo de Euclides
mcd:
    // x0 y x1 contienen los números para calcular el MCD
    // Guardamos los registros que vamos a usar
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

mcd_loop:
    // Si b (x1) es 0, el MCD está en a (x0)
    cmp     x1, #0
    beq     mcd_end
    
    // Dividir a entre b para obtener el resto
    udiv    x2, x0, x1      // x2 = a / b
    msub    x2, x2, x1, x0  // x2 = a - (a / b) * b (resto)
    
    // a = b, b = resto
    mov     x0, x1
    mov     x1, x2
    
    b       mcd_loop

mcd_end:
    ldp     x29, x30, [sp], #16
    ret

main:
    // Guardamos el link register
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Números para calcular el MCD
    mov     x19, #48        // Primer número
    mov     x20, #18        // Segundo número

    // Imprimir mensaje inicial
    adr     x0, msg1
    mov     x1, x19
    mov     x2, x20
    bl      printf

    // Calcular MCD
    mov     x0, x19
    mov     x1, x20
    bl      mcd
    mov     x21, x0         // Guardamos el resultado

    // Imprimir el proceso paso a paso
    mov     x0, x19
    mov     x1, x20
    bl      print_steps

    // Imprimir resultado
    adr     x0, msg2
    mov     x1, x21
    bl      printf

    // Restauramos el stack y retornamos
    ldp     x29, x30, [sp], #16
    mov     w0, #0
    ret

// Función para imprimir los pasos del algoritmo
print_steps:
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp
    
    // Guardamos los valores originales
    stp     x19, x20, [sp, #-16]!
    mov     x19, x0
    mov     x20, x1

print_loop:
    cmp     x20, #0
    beq     print_end
    
    // Imprimir paso actual
    adr     x0, step_msg
    mov     x1, x19
    mov     x2, x20
    bl      printf
    
    // Calcular siguiente paso
    udiv    x2, x19, x20
    msub    x2, x2, x20, x19
    
    // Actualizar valores para siguiente iteración
    mov     x19, x20
    mov     x20, x2
    
    b       print_loop

print_end:
    ldp     x19, x20, [sp], #16
    ldp     x29, x30, [sp], #16
    ret

.section .rodata
msg1:
    .string "\nCalculando el MCD de %d y %d\n"
msg2:
    .string "\nEl MCD es: %d\n"
step_msg:
    .string "Dividiendo %d entre %d\n"
