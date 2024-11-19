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
// #include <stdio.h>    // Incluir biblioteca estándar de entrada/salida

// int main() {    // Función principal

//     char msg_input[] = "Ingrese un número entero: ";    // Mensaje de entrada
//     char msg_output[] = "El número en ASCII es: ";    // Mensaje de salida
//     char newline[] = "\n";    // Nueva línea
//     char buffer[20];    // Buffer para almacenar los dígitos ASCII del número
//     long numero;    // Variable para almacenar el número ingresado

//     printf("%s", msg_input);    // Mostrar mensaje de entrada
//     scanf("%ld", &numero);    // Leer número entero desde la entrada

//     char *ptr = buffer;    // Puntero al buffer para almacenar los dígitos
//     int divisor = 10;    // Divisor para extraer dígitos
//     int contador = 0;    // Contador de dígitos en el buffer

//     do {    // Bucle para convertir el número a caracteres ASCII
//         int residuo = numero % divisor;    // Calcular residuo (último dígito)
//         *ptr++ = residuo + '0';    // Convertir dígito a ASCII y almacenar en buffer
//         contador++;    // Incrementar contador
//         numero /= divisor;    // Actualizar número dividiéndolo por 10
//     } while (numero != 0);    // Repetir mientras el número no sea cero

//     printf("%s", msg_output);    // Mostrar mensaje de salida

//     while (contador > 0) {    // Bucle para imprimir los dígitos en orden inverso
//         putchar(*(ptr - 1));    // Imprimir el último dígito almacenado
//         ptr--;    // Retroceder al dígito anterior
//         contador--;    // Decrementar contador
//     }

//     printf("%s", newline);    // Imprimir nueva línea

//     return 0;    // Terminar el programa
// }



.global main
.data
    // Mensajes y buffers
    msg_input: .string "Ingrese un número entero: "
    msg_output: .string "El número en ASCII es: "
    input_format: .string "%ld"
    newline: .string "\n"
    buffer: .skip 20    // Buffer para almacenar los dígitos ASCII

.text
main:
    // Prólogo
    stp     x29, x30, [sp, -32]!
    mov     x29, sp

    // Imprimir mensaje de entrada
    adr     x0, msg_input
    bl      printf

    // Leer número entero
    sub     sp, sp, 16          // Espacio para variable local
    mov     x2, sp              // Dirección para almacenar el número
    adr     x0, input_format
    mov     x1, x2
    bl      scanf

    // Cargar el número ingresado
    ldr     x19, [sp]           // x19 = número ingresado
    
    // Preparar para la conversión
    adr     x20, buffer         // x20 = dirección del buffer
    mov     x21, 10             // x21 = divisor (10)
    mov     x22, 0              // x22 = contador de dígitos

convert_loop:
    // Dividir el número por 10
    udiv    x23, x19, x21       // x23 = cociente
    msub    x24, x23, x21, x19  // x24 = residuo
    
    // Convertir dígito a ASCII
    add     x24, x24, '0'       // Convertir a ASCII
    strb    w24, [x20, x22]     // Almacenar en buffer
    add     x22, x22, 1         // Incrementar contador
    
    // Actualizar número para siguiente iteración
    mov     x19, x23            // Número = cociente
    
    // Continuar si el número no es cero
    cbnz    x19, convert_loop

    // Imprimir mensaje de salida
    adr     x0, msg_output
    bl      printf

    // Imprimir dígitos en orden inverso
print_loop:
    sub     x22, x22, 1         // Decrementar contador
    ldrb    w0, [x20, x22]      // Cargar dígito
    bl      putchar             // Imprimir dígito
    cbnz    x22, print_loop     // Continuar si no hemos terminado

    // Imprimir nueva línea
    adr     x0, newline
    bl      printf

    // Epílogo y retorno
    mov     w0, 0
    ldp     x29, x30, [sp], 32
    ret
