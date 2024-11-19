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

// int main() { // Función principal

//     // Inicializar el arreglo con valores específicos y su longitud
//     long arreglo[] = {15, 7, 23, 9, 12, 3, 18, 45, 6, 11}; // Arreglo de números
//     int longitud = 10; // Longitud del arreglo (10 elementos)

//     // Imprimir mensaje inicial
//     printf("Arreglo: "); // Mensaje para indicar los elementos del arreglo
    
//     // Imprimir todos los elementos del arreglo
//     for (int i = 0; i < longitud; i++) { // Bucle para recorrer el arreglo
//         printf("%ld ", arreglo[i]); // Imprimir cada elemento seguido de un espacio
//     }
//     printf("\n"); // Nueva línea después de imprimir todos los elementos

//     // Encontrar el valor mínimo en el arreglo
//     long minimo = arreglo[0]; // Inicializar 'minimo' con el primer elemento del arreglo
//     for (int i = 1; i < longitud; i++) { // Recorrer el arreglo desde el segundo elemento
//         if (arreglo[i] < minimo) { // Comparar cada elemento con el mínimo actual
//             minimo = arreglo[i]; // Actualizar el mínimo si el actual es menor
//         }
//     }

//     // Imprimir el valor mínimo encontrado en el arreglo
//     printf("\nEl mínimo es: %ld\n", minimo); // Mensaje para mostrar el valor mínimo

//     return 0; // Finalizar el programa correctamente
// }


  
    .data
    arreglo:    .quad   15, 7, 23, 9, 12, 3, 18, 45, 6, 11  // Arreglo de números
    longitud:   .quad   10                                   // Longitud del arreglo
    msg_arr:    .asciz  "Arreglo: "
    msg_num:    .asciz  "%ld "                              // Formato para imprimir números
    msg_min:    .asciz  "\nEl mínimo es: %ld\n"            // Mensaje para el mínimo
    newline:    .asciz  "\n"

    .text
    .global main
    main:
    // Prólogo
    stp     x29, x30, [sp, -48]!
    mov     x29, sp

    // Imprimir mensaje inicial
    ldr     x0, =msg_arr
    bl      printf

    // Inicializar variables
    ldr     x19, =arreglo         // x19 = dirección base del arreglo
    ldr     x20, =longitud        // Cargar dirección de longitud
    ldr     x20, [x20]            // x20 = longitud del arreglo
    mov     x21, #0               // x21 = contador (i)
    
    // Imprimir todos los números del arreglo
    print_loop:
    cmp     x21, x20
    bge     print_done            // Si i >= longitud, terminar impresión
    
    // Imprimir número actual
    ldr     x0, =msg_num
    ldr     x1, [x19, x21, lsl #3]  // Cargar arreglo[i]
    bl      printf
    
    add     x21, x21, #1         // i++
    b       print_loop
    
    print_done:
    // Inicializar mínimo con el primer elemento
    ldr     x22, [x19]           // x22 = mínimo = arreglo[0]
    mov     x21, #1              // x21 = contador = 1 (empezamos desde el segundo elemento)

    find_min_loop:
    cmp     x21, x20
    bge     find_min_done        // Si i >= longitud, terminar búsqueda
    
    // Cargar elemento actual
    ldr     x23, [x19, x21, lsl #3]  // x23 = arreglo[i]
    
    // Comparar con el mínimo actual
    cmp     x23, x22
    bge     not_smaller          // Si arreglo[i] >= mínimo, continuar
    mov     x22, x23             // Si arreglo[i] < mínimo, actualizar mínimo
    
    not_smaller:
    add     x21, x21, #1         // i++
    b       find_min_loop

    find_min_done:
    // Imprimir el mínimo
    ldr     x0, =msg_min
    mov     x1, x22
    bl      printf

    // Epílogo y retorno
    mov     w0, #0
    ldp     x29, x30, [sp], 48
    ret
