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
#define SIZE 8
void print_array(long *array, int n);
void merge_sort(long *array, long *temp, int left, int right);
void merge(long *array, long *temp, int left, int mid, int right);
int main() {
long array[SIZE] = {64, 34, 25, 12, 22, 11, 90, 1};
long temp[SIZE];
// Imprimir array original
printf("Array original:\n");
print_array(array, SIZE);
// Llamar a merge sort
merge_sort(array, temp, 0, SIZE - 1);
// Imprimir array ordenado
printf("Array ordenado:\n");
print_array(array, SIZE);
return 0;
}
// Función para imprimir el array
void print_array(long *array, int n) {
for (int i = 0; i < n; i++) {
    printf("%ld ", array[i]);
}
printf("\n");
}
// Función merge_sort (ordenación por mezcla)
void merge_sort(long *array, long *temp, int left, int right) {
if (left >= right) {
    return;
}
int mid = (left + right) / 2;
// Ordenar la mitad izquierda
merge_sort(array, temp, left, mid);
// Ordenar la mitad derecha
merge_sort(array, temp, mid + 1, right);
// Mezclar las dos mitades
merge(array, temp, left, mid, right);
}
// Función merge (mezcla dos mitades ordenadas)
void merge(long *array, long *temp, int left, int mid, int right) {
int i = left;        // Índice para la mitad izquierda
int j = mid + 1;     // Índice para la mitad derecha
int k = left;        // Índice para el array temporal
// Comparar elementos y copiar el menor al array temporal
while (i <= mid && j <= right) {
    if (array[i] <= array[j]) {
        temp[k++] = array[i++];
    } else {
        temp[k++] = array[j++];
    }
}
// Copiar el resto de la mitad izquierda, si hay
while (i <= mid) {
    temp[k++] = array[i++];
}
// Copiar el resto de la mitad derecha, si hay
while (j <= right) {
    temp[k++] = array[j++];
}
// Copiar del array temporal de vuelta al array original
for (i = left; i <= right; i++) {
    array[i] = temp[i];
}
}
Programa en ARM64
// merge_sort.s
.data
array:      .quad   64, 34, 25, 12, 22, 11, 90, 1    // Array inicial
temp:       .fill   8, 8, 0                          // Array temporal para merge
n:          .quad   8                                // Tamaño del array
fmt_str:    .string "%ld "                          // Formato para imprimir
newline:    .string "\n"
msg1:       .string "Array original:\n"
msg2:       .string "Array ordenado:\n"
.global main
.text
// Función principal
main:
stp     x29, x30, [sp, -16]!    // Guardar frame pointer y link register
mov     x29, sp                  // Actualizar frame pointer
// Imprimir mensaje inicial
adrp    x0, msg1
add     x0, x0, :lo12:msg1
bl      printf
// Imprimir array original
adrp    x0, fmt_str
add     x0, x0, :lo12:fmt_str
bl      print_array
// Llamar a merge sort
mov     x0, #0                   // left = 0
adrp    x1, n
add     x1, x1, :lo12:n
ldr     x1, [x1]
sub     x1, x1, #1              // right = n-1
bl      merge_sort
// Imprimir mensaje final
adrp    x0, msg2
add     x0, x0, :lo12:msg2
bl      printf
// Imprimir array ordenado
adrp    x0, fmt_str
add     x0, x0, :lo12:fmt_str
bl      print_array
mov     w0, #0                   // Retornar 0
ldp     x29, x30, [sp], 16      // Restaurar registros
ret
// Función merge_sort(left, right)
merge_sort:
stp     x29, x30, [sp, -48]!    // Guardar registros
mov     x29, sp
str     x0, [sp, 16]            // Guardar left
str     x1, [sp, 24]            // Guardar right
cmp     x0, x1                  // Si left >= right, retornar
bge     merge_sort_end
// Calcular medio = (left + right) / 2
add     x2, x0, x1
lsr     x2, x2, #1              // x2 = mid
str     x2, [sp, 32]            // Guardar mid
// Llamada recursiva izquierda: merge_sort(left, mid)
mov     x1, x2                  // right = mid
bl      merge_sort
// Llamada recursiva derecha: merge_sort(mid+1, right)
ldr     x0, [sp, 32]            // Recuperar mid
add     x0, x0, #1              // left = mid + 1
ldr     x1, [sp, 24]            // Recuperar right original
bl      merge_sort
// Merge de las dos mitades
ldr     x0, [sp, 16]            // Recuperar left original
ldr     x1, [sp, 32]            // Recuperar mid
ldr     x2, [sp, 24]            // Recuperar right original
bl      merge
merge_sort_end:
ldp     x29, x30, [sp], 48
ret
// Función merge(left, mid, right)
merge:
stp     x29, x30, [sp, -64]!
mov     x29, sp
// Guardar parámetros
str     x0, [sp, 16]            // left
str     x1, [sp, 24]            // mid
str     x2, [sp, 32]            // right
// Inicializar índices
mov     x9, x0                  // i = left
add     x10, x1, #1             // j = mid + 1
mov     x11, #0                  // k = 0 (índice para temp)
merge_loop:
ldr     x0, [sp, 16]            // Cargar left
ldr     x1, [sp, 24]            // Cargar mid
ldr     x2, [sp, 32]            // Cargar right
cmp     x9, x1                  // Si i > mid, copiar resto de derecha
bgt     copy_right
cmp     x10, x2                 // Si j > right, copiar resto de izquierda
bgt     copy_left
// Comparar elementos
adrp    x12, array
add     x12, x12, :lo12:array
ldr     x13, [x12, x9, lsl #3]  // array[i]
ldr     x14, [x12, x10, lsl #3] // array[j]
cmp     x13, x14
bgt     copy_right_element
copy_left_element:
adrp    x12, temp
add     x12, x12, :lo12:temp
str     x13, [x12, x11, lsl #3] // temp[k] = array[i]
add     x9, x9, #1              // i++
add     x11, x11, #1            // k++
b       merge_loop
copy_right_element:
adrp    x12, temp
add     x12, x12, :lo12:temp
str     x14, [x12, x11, lsl #3] // temp[k] = array[j]
add     x10, x10, #1            // j++
add     x11, x11, #1            // k++
b       merge_loop
copy_left:
cmp     x9, x1                  // Si i > mid, terminar
bgt     merge_end
adrp    x12, array
add     x12, x12, :lo12:array
ldr     x13, [x12, x9, lsl #3]  // array[i]
adrp    x12, temp
add     x12, x12, :lo12:temp
str     x13, [x12, x11, lsl #3] // temp[k] = array[i]
add     x9, x9, #1              // i++
add     x11, x11, #1            // k++
b       copy_left
copy_right:
cmp     x10, x2                 // Si j > right, terminar
bgt     merge_end
adrp    x12, array
add     x12, x12, :lo12:array
ldr     x13, [x12, x10, lsl #3] // array[j]
adrp    x12, temp
add     x12, x12, :lo12:temp
str     x13, [x12, x11, lsl #3] // temp[k] = array[j]
add     x10, x10, #1            // j++
add     x11, x11, #1            // k++
b       copy_right
merge_end:
// Copiar temp back to array
ldr     x9, [sp, 16]            // i = left
mov     x10, #0                  // k = 0
copy_back:
ldr     x2, [sp, 32]            // Cargar right
cmp     x9, x2                  // Si i > right, terminar
bgt     merge_done
adrp    x12, temp
add     x12, x12, :lo12:temp
ldr     x13, [x12, x10, lsl #3] // temp[k]
adrp    x12, array
add     x12, x12, :lo12:array
str     x13, [x12, x9, lsl #3]  // array[i] = temp[k]
add     x9, x9, #1              // i++
add     x10, x10, #1            // k++
b       copy_back
merge_done:
ldp     x29, x30, [sp], 64
ret
// Función para imprimir array
print_array:
stp     x29, x30, [sp, -32]!
mov     x29, sp
str     x0, [sp, 16]            // Guardar formato
mov     x19, #0                  // i = 0
adrp    x20, array
add     x20, x20, :lo12:array
adrp    x21, n
add     x21, x21, :lo12:n
ldr     x21, [x21]
print_loop:
cmp     x19, x21                // Comparar i con n
bge     print_end
ldr     x1, [x20, x19, lsl #3]  // Cargar array[i]
ldr     x0, [sp, 16]            // Cargar formato
bl      printf
add     x19, x19, #1            // i++
b       print_loop
print_end:
adrp    x0, newline
add     x0, x0, :lo12:newline
bl      printf
ldp     x29, x30, [sp], 32
ret
