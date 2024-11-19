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
//     char pregunta_tam[] = "¿Cuántos números deseas introducir? (máximo 100): "; // Mensaje para pedir tamaño del arreglo
//     char pedir_num[] = "Introduce el número %ld: "; // Mensaje para solicitar cada número
//     char mensaje_max[] = "El valor máximo es: %ld\n"; // Mensaje para mostrar el valor máximo
//     long arreglo[100];  // Espacio para almacenar hasta 100 números
//     long tam;           // Variable para almacenar el tamaño del arreglo

//     // Solicitar tamaño del arreglo al usuario
//     printf("%s", pregunta_tam);
//     scanf("%ld", &tam); // Leer el tamaño y almacenarlo en 'tam'

//     // Validar que el tamaño esté dentro del límite permitido (hasta 100)
//     if (tam > 100) {
//         printf("Error: El tamaño máximo permitido es 100.\n"); // Mensaje de error si el tamaño supera 100
//         return 1; // Finalizar el programa con código de error
//     }

//     // Leer los números y almacenarlos en el arreglo
//     for (long i = 0; i < tam; i++) { // Ciclo para pedir cada número
//         printf(pedir_num, i + 1); // Mostrar mensaje de solicitud de número
//         scanf("%ld", &arreglo[i]); // Guardar cada número en la posición correspondiente del arreglo
//     }

//     // Encontrar el valor máximo en el arreglo
//     long max = arreglo[0]; // Inicializar 'max' con el primer elemento del arreglo
//     for (long i = 1; i < tam; i++) { // Recorrer el arreglo desde el segundo elemento
//         if (arreglo[i] > max) { // Comparar el elemento actual con el máximo encontrado
//             max = arreglo[i]; // Actualizar el valor máximo si el actual es mayor
//         }
//     }

//     // Imprimir el valor máximo encontrado
//     printf(mensaje_max, max);

//     return 0; // Finalizar el programa correctamente
// }



    .data
    pregunta_tam: .string "¿Cuántos números deseas introducir? (máximo 100): "
    formato_tam: .string "%ld"
    pedir_num: .string "Introduce el número %ld: "
    formato_num: .string "%ld"
    mensaje_max: .string "El valor máximo es: %ld\n"
    
    // Buffer para almacenar los números
    .align 8
    arreglo: .skip 800          // Espacio para 100 números (100 * 8 bytes)
    tam: .quad 0                // Variable para almacenar el tamaño del arreglo

    .global main
    .text

    main:
    // Prólogo
    stp x29, x30, [sp, #-16]!
    mov x29, sp

    // Pedir tamaño del arreglo
    adr x0, pregunta_tam
    bl printf

    // Leer tamaño
    adr x0, formato_tam
    adr x1, tam
    bl scanf

    // Limpiar el buffer de entrada
    bl getchar

    // Cargar el tamaño en x19
    adr x0, tam
    ldr x19, [x0]               // x19 = tamaño del arreglo

    // Inicializar contador en x20
    mov x20, #0                 // x20 = contador

    leer_numeros:
    // Verificar si hemos terminado
    cmp x20, x19
    b.ge encontrar_max

    // Imprimir mensaje para pedir número
    adr x0, pedir_num
    add x1, x20, #1            // Número actual + 1 para mostrar
    bl printf

    // Leer número
    adr x0, formato_num
    adr x1, arreglo
    add x1, x1, x20, lsl #3    // Calcular dirección del elemento actual
    bl scanf

    // Limpiar el buffer de entrada
    bl getchar

    // Incrementar contador
    add x20, x20, #1
    b leer_numeros

    encontrar_max:
    // Inicializar con el primer elemento como máximo
    adr x0, arreglo
    ldr x21, [x0]              // x21 = máximo actual
    mov x20, #1                // x20 = índice para búsqueda

    bucle_max:
    cmp x20, x19
    b.ge imprimir_resultado

    // Cargar siguiente número
    adr x0, arreglo
    add x0, x0, x20, lsl #3
    ldr x22, [x0]              // x22 = número actual

    // Comparar con máximo
    cmp x22, x21
    b.le no_actualizar
    mov x21, x22               // Actualizar máximo si es mayor

    no_actualizar:
    add x20, x20, #1
    b bucle_max

    imprimir_resultado:
    // Imprimir el máximo
    adr x0, mensaje_max
    mov x1, x21
    bl printf

    // Epílogo y retorno
    mov x0, #0
    ldp x29, x30, [sp], #16
    ret
