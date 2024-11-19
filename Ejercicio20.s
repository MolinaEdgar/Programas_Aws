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
#include <stdio.h>
void multiply_matrices(long matrix1[2][3], long matrix2[3][2], long result[2][2], int rows1, int cols1, int cols2);
void print_matrix(long matrix[][2], int rows, int cols);
int main() {
// Definir matrices y sus dimensiones
long matrix1[2][3] = {
    {1, 2, 3},
    {4, 5, 6}
};
long matrix2[3][2] = {
    {7, 8},
    {9, 10},
    {11, 12}
};
long result[2][2] = {0}; // Inicializar matriz de resultados a cero
// Dimensiones de las matrices
int rows1 = 2, cols1 = 3, rows2 = 3, cols2 = 2;
// Imprimir matrices originales
printf("Matriz 1:\n");
print_matrix(matrix1, rows1, cols1);
printf("Matriz 2:\n");
print_matrix(matrix2, rows2, cols2);
// Multiplicar matrices
multiply_matrices(matrix1, matrix2, result, rows1, cols1, cols2);
// Imprimir el resultado de la multiplicación
printf("Resultado:\n");
print_matrix(result, rows1, cols2);
return 0;
}
void multiply_matrices(long matrix1[2][3], long matrix2[3][2], long result[2][2], int rows1, int cols1, int cols2) {
for (int i = 0; i < rows1; i++) {
    for (int j = 0; j < cols2; j++) {
        result[i][j] = 0; // Inicializar el valor en 0
        for (int k = 0; k < cols1; k++) {
            result[i][j] += matrix1[i][k] * matrix2[k][j];
        }
    }
}
}
void print_matrix(long matrix[][2], int rows, int cols) {
for (int i = 0; i < rows; i++) {
    for (int j = 0; j < cols; j++) {
        printf("%ld ", matrix[i][j]);
    }
    printf("\n");
}
}
Programa en ARM64
            // matrix_mult.s
              .data
// Primera matriz (2x3)
matrix1:    .quad   1, 2, 3
            .quad   4, 5, 6
// Segunda matriz (3x2)
matrix2:    .quad   7, 8
            .quad   9, 10
            .quad   11, 12
// Matriz resultado (2x2)
result:     .fill   4, 8, 0      // 4 elementos de 8 bytes inicializados en 0

// Dimensiones
rows1:      .quad   2            // Filas de matrix1
cols1:      .quad   3            // Columnas de matrix1
rows2:      .quad   3            // Filas de matrix2
cols2:      .quad   2            // Columnas de matrix2

// Formato para imprimir
fmt_str:    .string "%ld "
newline:    .string "\n"
msg1:       .string "Matriz 1:\n"
msg2:       .string "Matriz 2:\n"
msg3:       .string "Resultado:\n"

.global main
.text

main:
stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
mov     x29, sp                  // Actualizar frame pointer

// Imprimir matriz 1
adrp    x0, msg1
add     x0, x0, :lo12:msg1
bl      printf
adrp    x0, matrix1
add     x0, x0, :lo12:matrix1
mov     x1, #2                   // rows
mov     x2, #3                   // cols
bl      print_matrix

// Imprimir matriz 2
adrp    x0, msg2
add     x0, x0, :lo12:msg2
bl      printf
adrp    x0, matrix2
add     x0, x0, :lo12:matrix2
mov     x1, #3                   // rows
mov     x2, #2                   // cols
bl      print_matrix

// Llamar a la multiplicación de matrices
bl      multiply_matrices

// Imprimir resultado
adrp    x0, msg3
add     x0, x0, :lo12:msg3
bl      printf
adrp    x0, result
add     x0, x0, :lo12:result
mov     x1, #2                   // rows
mov     x2, #2                   // cols
bl      print_matrix

mov     w0, #0                   // Retornar 0
ldp     x29, x30, [sp], 16      // Restaurar registros
ret

// Función para multiplicar matrices
multiply_matrices:
stp     x29, x30, [sp, -64]!
mov     x29, sp

// Registros:
// x9: índice i (filas matrix1)
// x10: índice j (columnas matrix2)
// x11: índice k (columnas matrix1/filas matrix2)
// x12: acumulador temporal
// x13-x15: direcciones base y offsets

mov     x9, #0                   // i = 0
outer_loop:
cmp     x9, #2                   // comparar i con rows1
bge     mult_end

mov     x10, #0                  // j = 0
middle_loop:
cmp     x10, #2                  // comparar j con cols2
bge     outer_next

mov     x12, #0                  // acumulador = 0
mov     x11, #0                  // k = 0
inner_loop:
cmp     x11, #3                  // comparar k con cols1
bge     store_result

// Calcular matrix1[i][k]
adrp    x13, matrix1
add     x13, x13, :lo12:matrix1
mov     x14, #3                  // cols1
mul     x14, x9, x14             // i * cols1
add     x14, x14, x11           // + k
ldr     x14, [x13, x14, lsl #3] // cargar valor

// Calcular matrix2[k][j]
adrp    x13, matrix2
add     x13, x13, :lo12:matrix2
mov     x15, #2                  // cols2
mul     x15, x11, x15           // k * cols2
add     x15, x15, x10           // + j
ldr     x15, [x13, x15, lsl #3] // cargar valor

// Multiplicar y acumular
mul     x14, x14, x15
add     x12, x12, x14

add     x11, x11, #1            // k++
b       inner_loop

store_result:
// Guardar resultado en result[i][j]
adrp    x13, result
add     x13, x13, :lo12:result
mov     x14, #2                  // cols_result
mul     x14, x9, x14            // i * cols_result
add     x14, x14, x10           // + j
str     x12, [x13, x14, lsl #3]

add     x10, x10, #1            // j++
b       middle_loop

outer_next:
add     x9, x9, #1              // i++
b       outer_loop

mult_end:
ldp     x29, x30, [sp], 64
ret

// Función para imprimir matriz
print_matrix:
stp     x29, x30, [sp, -48]!
mov     x29, sp

// Guardar parámetros
str     x0, [sp, 16]            // dirección matriz
str     x1, [sp, 24]            // filas
str     x2, [sp, 32]            // columnas

mov     x19, #0                  // i = 0
print_outer:
ldr     x1, [sp, 24]            // cargar filas
cmp     x19, x1
bge     print_end

mov     x20, #0                  // j = 0
print_inner:
ldr     x2, [sp, 32]            // cargar columnas
cmp     x20, x2
bge     print_next_row

// Calcular offset
ldr     x21, [sp, 32]           // cargar columnas
mul     x21, x19, x21           // i * cols
add     x21, x21, x20           // + j
ldr     x0, [sp, 16]            // cargar dirección base
ldr     x1, [x0, x21, lsl #3]   // cargar elemento

// Imprimir elemento
adrp    x0, fmt_str
add     x0, x0, :lo12:fmt_str
bl      printf

add     x20, x20, #1            // j++
b       print_inner

print_next_row:
// Imprimir nueva línea
adrp    x0, newline
add     x0, x0, :lo12:newline
bl      printf

add     x19, x19, #1            // i++
b       print_outer

print_end:
ldp     x29, x30, [sp], 48
ret
50-Programas-ARM64/Programa20.md at main · MayaDios21/50-Programas-ARM64
