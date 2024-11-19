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

//     // Declaración de variables y mensajes
//     const char* msg1 = "Valor original en decimal (binario 1010): %d\n"; // Mensaje para el valor original
//     const char* msg2 = "Después de establecer bit 1: %d\n"; // Mensaje para resultado después de establecer bit
//     const char* msg3 = "Después de borrar bit 1: %d\n"; // Mensaje para resultado después de borrar bit
//     const char* msg4 = "Después de alternar bit 3: %d\n"; // Mensaje para resultado después de alternar bit
//     int num = 10; // Inicializamos un número con el valor 10 (1010 en binario)
//     int resultado; // Variable para almacenar resultados de manipulación de bits

//     printf(msg1, num); // Imprimir el valor original de num

//     // ESTABLECER BIT (Usando OR)
//     // Creamos una máscara para el bit 1 y lo establecemos en num
//     int mascara_establecer = 1 << 1; // Máscara para el bit 1 (0010 en binario)
//     resultado = num | mascara_establecer; // Establecer el bit 1 en num
//     printf(msg2, resultado); // Imprimir resultado después de establecer bit 1

//     // BORRAR BIT (Usando AND con máscara invertida)
//     // Creamos una máscara para el bit 1 y lo borramos en num
//     int mascara_borrar = ~(1 << 1); // Máscara invertida para borrar el bit 1 (1101 en binario)
//     resultado = num & mascara_borrar; // Borrar el bit 1 en num
//     printf(msg3, resultado); // Imprimir resultado después de borrar bit 1

//     // ALTERNAR BIT (Usando XOR)
//     // Creamos una máscara para el bit 3 y lo alternamos en num
//     int mascara_alternar = 1 << 3; // Máscara para el bit 3 (1000 en binario)
//     resultado = num ^ mascara_alternar; // Alternar el bit 3 en num
//     printf(msg4, resultado); // Imprimir resultado después de alternar bit 3

//     return 0; // Finalizar el programa
// }

.global main
.text

main:
    // Guardamos el link register
    stp     x29, x30, [sp, #-16]!
    mov     x29, sp

    // Inicializamos un número para manipular sus bits
    mov     x19, #10         // x19 = 10 (1010 en binario)

    // Imprimir valor original
    adr     x0, msg1
    mov     x1, x19
    bl      printf

    // ESTABLECER BIT (Usando OR)
    // Establecemos el bit 1 (segundo bit)
    // 1010 OR 0010 = 1010 (no cambia porque ya estaba en 1)
    mov     x20, x19        // Copiamos el valor original
    mov     x4, #2          // Creamos la máscara para el bit 1
    orr     x20, x20, x4    // Establecer bit 1
    
    // Imprimir resultado después de establecer bit
    adr     x0, msg2
    mov     x1, x20
    bl      printf

    // BORRAR BIT (Usando AND con máscara invertida)
    // Borramos el bit 1 (segundo bit)
    mov     x21, x19        // Copiamos el valor original
    mov     x4, #2          // Bit que queremos borrar
    mvn     x4, x4          // Invertimos la máscara
    and     x21, x21, x4    // Borrar bit 1
    
    // Imprimir resultado después de borrar bit
    adr     x0, msg3
    mov     x1, x21
    bl      printf

    // ALTERNAR BIT (Usando XOR)
    // Alternamos el bit 3 (cuarto bit)
    // 1010 XOR 1000 = 0010
    mov     x22, x19        // Copiamos el valor original
    mov     x4, #8          // Creamos la máscara para el bit 3
    eor     x22, x22, x4    // Alternar bit 3
    
    // Imprimir resultado después de alternar bit
    adr     x0, msg4
    mov     x1, x22
    bl      printf

    // Restauramos el stack y retornamos
    ldp     x29, x30, [sp], #16
    mov     w0, #0
    ret

.section .rodata
msg1:
    .string "Valor original en decimal (binario 1010): %d\n"
msg2:
    .string "Después de establecer bit 1: %d\n"
msg3:
    .string "Después de borrar bit 1: %d\n"
msg4:
    .string "Después de alternar bit 3: %d\n"
