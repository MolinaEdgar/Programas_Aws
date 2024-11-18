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
#include <stdio.h>      // Biblioteca estándar de entrada y salida para usar printf y scanf
// #include <stdint.h>     // Biblioteca para usar tipos de datos con tamaño específico como int64_t

// int main() { // Función principal del programa
//     int64_t n = 0;       // Variable para almacenar el número de términos a sumar, de tipo entero largo
//     int64_t result = 0;  // Variable para almacenar el resultado de la suma
//     int64_t i = 1;       // Variable de control para el bucle de suma, comenzando en 1

//     // Solicitar al usuario el número de términos (N) para sumar
//     printf("Ingrese el número de términos a sumar (N): "); // Mensaje para pedir el valor de N
//     if (scanf("%ld", &n) != 1) { // Leer el valor de N desde el teclado; verifica si la entrada es válida
//         printf("Error al leer el número\n"); // Mensaje de error si no se pudo leer correctamente
//         return 1; // Finaliza el programa con un código de error
//     }

//     // Verificar que N sea un número positivo
//     if (n <= 0) { // Condición para asegurar que el número ingresado es positivo
//         printf("Error: Por favor ingrese un número positivo\n"); // Mensaje de error si N no es positivo
//         return 1; // Finaliza el programa con un código de error
//     }

//     // Calcular la suma de los primeros N números
//     for (i = 1; i <= n; ++i) { // Bucle para sumar los números desde 1 hasta N
//         result += i; // Acumula el valor de i en result en cada iteración
//     }

//     // Imprimir el resultado de la suma
//     printf("La suma de los primeros %ld números es: %ld\n", n, result); // Muestra el resultado de la suma

//     return 0; // Finaliza el programa correctamente
// }
      .data
    prompt:     .string "Ingrese el número de términos a sumar (N): "
    format_in:  .string "%ld"
    format_out: .string "La suma de los primeros %ld números es: %ld\n"
    error_msg:  .string "Error: Por favor ingrese un número positivo\n"
    n:          .quad 0      // Número de términos a sumar
    result:     .quad 0      // Resultado de la suma
    i:          .quad 1      // Contador para el bucle

    .text
    .global main

    main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!    // Guardar frame pointer y link register
    mov     x29, sp                   // Establecer frame pointer

    // Mostrar prompt y leer N
    adr     x0, prompt
    bl      printf

    adr     x0, format_in            // Formato para scanf
    adr     x1, n                    // Donde guardar N
    bl      scanf

    // Cargar N en registro
    adr     x0, n
    ldr     x19, [x0]                // x19 = N

    // Verificar si N es positivo
    cmp     x19, #0
    ble     error                    // Si N ≤ 0, mostrar error

    // Inicializar registros
    mov     x20, #0                  // x20 = suma (inicializada a 0)
    mov     x21, #1                  // x21 = i (contador, inicia en 1)

    loop:
    // Verificar si hemos llegado al final
    cmp     x21, x19           
    bgt     end_loop                 // Si i > n, salir del bucle
    
    // Sumar el número actual
    add     x20, x20, x21            // suma += i
    
    // Incrementar contador
    add     x21, x21, #1             // i++
    
    // Repetir bucle
    b       loop

    end_loop:
    // Guardar el resultado en memoria
    adr     x0, result
    str     x20, [x0]

    // Mostrar resultado
    adr     x0, format_out           // Formato para printf
    mov     x1, x19                  // N como primer argumento
    mov     x2, x20                  // suma como segundo argumento
    bl      printf
    b       fin

    error:
    // Mostrar mensaje de error
    adr     x0, error_msg
    bl      printf

    fin:
    // Epílogo y retorno
    mov     w0, #0                   // Código de retorno
    ldp     x29, x30, [sp], #16      // Restaurar frame pointer y link register
    ret
