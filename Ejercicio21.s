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
// #include <stdio.h>    // Incluir la biblioteca estándar para entrada y salida

// #define N 3    // Definir una constante para el tamaño de la matriz

// // Matriz original 3x3
// int matriz[N][N] = {    // Declarar e inicializar la matriz original de 3x3
//     {1, 2, 3},    // Primera fila
//     {4, 5, 6},    // Segunda fila
//     {7, 8, 9}     // Tercera fila
// };

// // Espacio para la matriz transpuesta
// int transpuesta[N][N];    // Declarar la matriz transpuesta de 3x3

// int main() {    // Función principal del programa
//     int i, j;    // Declarar variables para los índices de los bucles

//     // Imprimir mensaje inicial
//     printf("Matriz Original:\n");    // Imprimir el mensaje para la matriz original

//     // Mostrar matriz original
//     for (i = 0; i < N; i++) {    // Bucle externo para las filas de la matriz
//         for (j = 0; j < N; j++) {    // Bucle interno para las columnas de la matriz
//             printf("%d ", matriz[i][j]);    // Imprimir el elemento en la posición [i][j]
//         }
//         printf("\n");    // Imprimir una nueva línea al final de cada fila
//     }

//     // Realizar transposición
//     for (i = 0; i < N; i++) {    // Bucle externo para recorrer las filas de la matriz original
//         for (j = 0; j < N; j++) {    // Bucle interno para recorrer las columnas de la matriz original
//             transpuesta[j][i] = matriz[i][j];    // Asignar el valor transpuesto en la nueva posición
//         }
//     }

//     // Imprimir mensaje de matriz transpuesta
//     printf("Matriz Transpuesta:\n");    // Imprimir el mensaje para la matriz transpuesta

//     // Mostrar matriz transpuesta
//     for (i = 0; i < N; i++) {    // Bucle externo para las filas de la matriz transpuesta
//         for (j = 0; j < N; j++) {    // Bucle interno para las columnas de la matriz transpuesta
//             printf("%d ", transpuesta[i][j]);    // Imprimir el elemento en la posición [i][j]
//         }
//         printf("\n");    // Imprimir una nueva línea al final de cada fila
//     }

//     return 0;    // Finalizar el programa con un valor de retorno 0
// }

.data
    // Mensajes y formatos
    format: .asciz "%d "
    newline: .asciz "\n"
    msg1: .asciz "Matriz Original:\n"
    msg2: .asciz "Matriz Transpuesta:\n"
    
    // Matriz original 3x3
    .align 4
    matriz: .word 1, 2, 3
           .word 4, 5, 6
           .word 7, 8, 9
    
    // Espacio para matriz transpuesta
    .align 4
    transpuesta: .zero 36    // 9 elementos * 4 bytes

.text
.global main
.extern printf

main:
    // Prólogo
    stp x29, x30, [sp, -16]!
    mov x29, sp

    // Imprimir mensaje inicial
    adrp x0, msg1
    add x0, x0, :lo12:msg1
    bl printf

    // Mostrar matriz original
    mov x19, #0              // i = 0
loop1:
    cmp x19, #3
    bge end_loop1
    mov x20, #0              // j = 0
loop1_inner:
    cmp x20, #3
    bge end_loop1_inner

    // Calcular offset
    mov x21, #3
    mul x21, x19, x21
    add x21, x21, x20
    lsl x21, x21, #2

    // Cargar y mostrar elemento
    adrp x22, matriz
    add x22, x22, :lo12:matriz
    ldr w1, [x22, x21]
    adrp x0, format
    add x0, x0, :lo12:format
    bl printf

    add x20, x20, #1
    b loop1_inner

end_loop1_inner:
    // Nueva línea
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf
    add x19, x19, #1
    b loop1

end_loop1:
    // Realizar transposición
    mov x19, #0              // i = 0
trans_loop:
    cmp x19, #3
    bge end_trans
    mov x20, #0              // j = 0

trans_inner:
    cmp x20, #3
    bge end_trans_inner

    // Calcular índices
    mov x21, #3
    mul x21, x19, x21
    add x21, x21, x20
    lsl x21, x21, #2

    mov x22, #3
    mul x22, x20, x22
    add x22, x22, x19
    lsl x22, x22, #2

    // Realizar transposición
    adrp x23, matriz
    add x23, x23, :lo12:matriz
    ldr w24, [x23, x21]
    
    adrp x23, transpuesta
    add x23, x23, :lo12:transpuesta
    str w24, [x23, x22]

    add x20, x20, #1
    b trans_inner

end_trans_inner:
    add x19, x19, #1
    b trans_loop

end_trans:
    // Imprimir mensaje de matriz transpuesta
    adrp x0, msg2
    add x0, x0, :lo12:msg2
    bl printf

    // Mostrar matriz transpuesta
    mov x19, #0              // i = 0
loop2:
    cmp x19, #3
    bge end_loop2
    mov x20, #0              // j = 0

loop2_inner:
    cmp x20, #3
    bge end_loop2_inner

    // Calcular offset
    mov x21, #3
    mul x21, x19, x21
    add x21, x21, x20
    lsl x21, x21, #2

    // Cargar y mostrar elemento
    adrp x22, transpuesta
    add x22, x22, :lo12:transpuesta
    ldr w1, [x22, x21]
    adrp x0, format
    add x0, x0, :lo12:format
    bl printf

    add x20, x20, #1
    b loop2_inner

end_loop2_inner:
    // Nueva línea
    adrp x0, newline
    add x0, x0, :lo12:newline
    bl printf
    add x19, x19, #1
    b loop2

end_loop2:
    // Epílogo
    mov w0, #0
    ldp x29, x30, [sp], #16
    ret
