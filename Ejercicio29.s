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
// #include <stdio.h> // Biblioteca para funciones de entrada y salida

// int main() { // Función principal

//     // Declaración de mensajes para la salida
//     const char* msg1 = "Número decimal: %d\n"; // Mensaje para el número decimal
//     const char* msg2 = "Cantidad de bits activados: %d\n"; // Mensaje para cantidad de bits activados
//     const char* msg3 = "Representación binaria: 0b"; // Mensaje para inicio de representación binaria
//     const char* one = "1"; // Mensaje para bit activado
//     const char* zero = "0"; // Mensaje para bit desactivado
//     const char* newline = "\n"; // Mensaje para nueva línea

//     int num = 42; // Número a manipular (42 en decimal = 101010 en binario)
//     int copia = num; // Copia de num para manipulación
//     int contador_bits = 0; // Contador para bits activados

//     // Contar los bits activados en num
//     while (copia != 0) { // Bucle hasta procesar todos los bits
//         if (copia & 1) { // Verificar si el bit menos significativo está activado
//             contador_bits++; // Incrementar contador si está activado
//         }
//         copia >>= 1; // Desplazar bits a la derecha para verificar el siguiente
//     }

//     printf(msg1, num); // Imprimir el número original en decimal
//     printf(msg2, contador_bits); // Imprimir el conteo de bits activados

//     // Imprimir el formato de la representación binaria
//     printf(msg3);

//     // Restaurar el valor de num y preparar para impresión de bits
//     copia = num; // Restaurar valor original para imprimir en binario

//     // Imprimir los bits en formato binario
//     for (int i = 31; i >= 0; i--) { // Contador de bits (32 bits en total)
//         int bit = (copia >> i) & 1; // Extraer el bit i-ésimo más significativo
//         if (bit) {
//             printf(one); // Imprimir "1" si el bit está activado
//         } else {
//             printf(zero); // Imprimir "0" si el bit está desactivado
//         }
//     }

//     printf(newline); // Nueva línea al final de la representación binaria

//     return 0; // Finalizar el programa
// }

.global main
.text

main:
    // Guardamos el link register
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Inicializamos el número para contar sus bits
    mov     x19, #42        // 42 en decimal = 101010 en binario
    mov     x20, x19        // Copia para manipular
    mov     x21, #0         // Contador de bits

loop_count:
    // Comprobamos si hemos procesado todos los bits
    cmp     x20, #0
    beq     end_count

    // Verificamos el bit menos significativo
    // usando AND con 1 (0001)
    and     x22, x20, #1
    
    // Si el resultado es 1, incrementamos el contador
    cmp     x22, #1
    bne     skip_increment
    add     x21, x21, #1

skip_increment:
    // Desplazamos a la derecha para verificar el siguiente bit
    lsr     x20, x20, #1
    b       loop_count

end_count:
    // Imprimir el número original
    adr     x0, msg1
    mov     x1, x19
    bl      printf

    // Imprimir el conteo de bits
    adr     x0, msg2
    mov     x1, x21
    bl      printf

    // Imprimir representación binaria
    mov     x20, x19        // Restauramos el número original
    mov     x22, #32        // Contador para 32 bits

    // Imprimimos el inicio del formato binario
    adr     x0, msg3
    bl      printf

print_binary:
    cbz     x22, end_print  // Si el contador llega a 0, terminamos

    // Obtener el bit más significativo
    mov     x23, #1
    lsl     x23, x23, #31   // Crear máscara para el bit más significativo
    and     x24, x20, x23   // Extraer el bit
    
    // Imprimir 1 o 0
    cmp     x24, #0
    beq     print_zero

print_one:
    adr     x0, one
    bl      printf
    b       continue_print

print_zero:
    adr     x0, zero
    bl      printf

continue_print:
    lsl     x20, x20, #1    // Desplazar a la izquierda
    sub     x22, x22, #1    // Decrementar contador
    b       print_binary

end_print:
    // Nueva línea al final
    adr     x0, newline
    bl      printf

    // Restauramos el stack y retornamos
    ldp     x29, x30, [sp], #16
    mov     w0, #0
    ret

.section .rodata
msg1:
    .string "Número decimal: %d\n"
msg2:
    .string "Cantidad de bits activados: %d\n"
msg3:
    .string "Representación binaria: 0b"
one:
    .string "1"
zero:
    .string "0"
newline:
    .string "\n"
