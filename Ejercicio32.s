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

//     // Inicializar variables
//     int base = 2; // Base para la potencia (2)
//     int exponente = 5; // Exponente (5)
//     int resultado = 1; // Resultado inicializado en 1, usado para calcular la potencia
//     int exponente_original = exponente; // Guardar el valor original del exponente

//     // Si el exponente es 0, el resultado es 1
//     if (exponente == 0) { // Verificar si el exponente es cero
//         printf("%d^%d = %d\n", base, exponente_original, resultado); // Imprimir el resultado (1)
//         return 0; // Salir del programa
//     }

//     // Bucle para calcular la potencia
//     while (exponente > 0) { // Continuar mientras el exponente sea mayor que cero
//         resultado *= base; // Multiplicar el resultado por la base
//         exponente--; // Disminuir el exponente en 1
//     }

//     // Imprimir el resultado final
//     printf("%d^%d = %d\n", base, exponente_original, resultado); // Imprimir el cálculo final

//     return 0; // Finalizar el programa
// }


.section .rodata
format: .asciz "%d^%d = %d\n"

.text
.global main
.type main, %function

main:
    // Prólogo de la función
    stp     x29, x30, [sp, -16]!   // Guardar frame pointer y link register
    mov     x29, sp                 // Establecer frame pointer
    
    // Guardar registros callee-saved
    stp     x19, x20, [sp, -16]!
    stp     x21, x22, [sp, -16]!
    
    // Inicializar valores
    mov     x19, #2                 // base = 2
    mov     x20, #5                 // exponente = 5
    mov     x21, #1                 // resultado = 1
    mov     x22, x20               // guardar exponente original
    
    // Si el exponente es 0, saltar al final
    cbz     x20, print_result
    
loop:
    // Multiplicar resultado por base
    mul     x21, x21, x19          // resultado *= base
    
    // Decrementar contador y continuar si no es cero
    subs    x20, x20, #1           // exponente--
    b.ne    loop                   // si no es cero, continuar loop
    
print_result:
    // Cargar dirección del formato
    adrp    x0, format             // Cargar página de la dirección
    add     x0, x0, :lo12:format   // Añadir el offset dentro de la página
    mov     x1, x19                // base
    mov     x2, x22                // exponente original
    mov     x3, x21                // resultado
    bl      printf
    
    // Restaurar registros callee-saved
    ldp     x21, x22, [sp], 16
    ldp     x19, x20, [sp], 16
    
    // Epílogo de la función
    mov     w0, #0                 // Valor de retorno
    ldp     x29, x30, [sp], 16
    ret

.size main, .-main
