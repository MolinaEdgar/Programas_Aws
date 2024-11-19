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

//     // Declaración de mensajes y variables
//     char msg_menu[] = "\nOperaciones a nivel de bits:\n1. AND\n2. OR\n3. XOR\n4. Salir\nSeleccione una opción: "; // Menú de opciones
//     char msg_num1[] = "Ingrese el primer número: "; // Mensaje para ingresar el primer número
//     char msg_num2[] = "Ingrese el segundo número: "; // Mensaje para ingresar el segundo número
//     char msg_resultado[] = "Resultado: %ld\n"; // Mensaje para mostrar el resultado
//     char msg_binario[] = "En binario: "; // Mensaje que indica el resultado en binario
//     char msg_error[] = "Error: Entrada inválida. Intente nuevamente.\n"; // Mensaje de error
//     long option = 0; // Variable para almacenar la opción seleccionada
//     long num1 = 0; // Primer número ingresado por el usuario
//     long num2 = 0; // Segundo número ingresado por el usuario
//     long resultado = 0; // Resultado de la operación seleccionada

//     do { // Iniciar bucle del menú

//         printf("%s", msg_menu); // Mostrar menú de opciones
//         if (scanf("%ld", &option) != 1) { // Leer la opción seleccionada
//             printf("%s", msg_error); // Si la entrada es inválida, mostrar mensaje de error
//             while (getchar() != '\n'); // Limpiar el buffer de entrada
//             continue; // Volver al inicio del menú
//         }

//         if (option == 4) { // Si la opción es 4, salir del programa
//             break; // Terminar el bucle del menú
//         }

//         if (option < 1 || option > 3) { // Verificar si la opción está fuera de rango
//             printf("%s", msg_error); // Mostrar mensaje de error
//             while (getchar() != '\n'); // Limpiar el buffer de entrada
//             continue; // Volver al inicio del menú
//         }

//         printf("%s", msg_num1); // Pedir al usuario el primer número
//         if (scanf("%ld", &num1) != 1) { // Leer el primer número
//             printf("%s", msg_error); // Si la entrada es inválida, mostrar mensaje de error
//             while (getchar() != '\n'); // Limpiar el buffer de entrada
//             continue; // Volver al inicio del menú
//         }

//         printf("%s", msg_num2); // Pedir al usuario el segundo número
//         if (scanf("%ld", &num2) != 1) { // Leer el segundo número
//             printf("%s", msg_error); // Si la entrada es inválida, mostrar mensaje de error
//             while (getchar() != '\n'); // Limpiar el buffer de entrada
//             continue; // Volver al inicio del menú
//         }

//         switch (option) { // Realizar operación basada en la opción seleccionada
//             case 1: // Opción AND
//                 resultado = num1 & num2; // Realizar operación AND
//                 break; // Salir del switch

//             case 2: // Opción OR
//                 resultado = num1 | num2; // Realizar operación OR
//                 break; // Salir del switch

//             case 3: // Opción XOR
//                 resultado = num1 ^ num2; // Realizar operación XOR
//                 break; // Salir del switch
//         }

//         printf(msg_resultado, resultado); // Mostrar el resultado de la operación
//         printf("%s", msg_binario); // Mostrar mensaje de resultado en binario

//         for (int i = 63; i >= 0; i--) { // Ciclo para mostrar cada bit del resultado en binario
//             printf("%d", (resultado >> i) & 1); // Imprimir bit por bit del número
//         }
//         printf("\n"); // Nueva línea después de mostrar el binario

//     } while (1); // Continuar el bucle hasta que el usuario elija salir

//     return 0; // Finalizar el programa
// }

.global main
.data
    // Mensajes del menú y entrada
    msg_menu: .string "\nOperaciones a nivel de bits:\n1. AND\n2. OR\n3. XOR\n4. Salir\nSeleccione una opción: "
    msg_num1: .string "Ingrese el primer número: "
    msg_num2: .string "Ingrese el segundo número: "
    msg_resultado: .string "Resultado: %ld\n"
    msg_binario: .string "En binario: "
    msg_error: .string "Error: Entrada inválida. Intente nuevamente.\n"
    msg_bit: .string "%d"
    msg_newline: .string "\n"
    input_format: .string "%ld"

.text
main:
    // Prólogo
    stp     x29, x30, [sp, -48]!
    mov     x29, sp

menu_loop:
    // Mostrar menú
    adr     x0, msg_menu
    bl      printf

    // Leer opción
    sub     sp, sp, 16
    mov     x1, sp
    adr     x0, input_format
    bl      scanf
    
    // Verificar entrada válida
    cmp     x0, #1
    b.ne    input_error

    // Cargar opción
    ldr     x19, [sp]          // x19 = opción seleccionada
    
    // Verificar si es salir
    cmp     x19, #4
    b.eq    exit_program
    
    // Verificar opción válida
    cmp     x19, #1
    b.lt    input_error
    cmp     x19, #3
    b.gt    input_error

    // Leer primer número
    adr     x0, msg_num1
    bl      printf
    
    mov     x1, sp
    adr     x0, input_format
    bl      scanf
    cmp     x0, #1
    b.ne    input_error
    
    ldr     x20, [sp]          // x20 = primer número

    // Leer segundo número
    adr     x0, msg_num2
    bl      printf
    
    mov     x1, sp
    adr     x0, input_format
    bl      scanf
    cmp     x0, #1
    b.ne    input_error
    
    ldr     x21, [sp]          // x21 = segundo número

    // Realizar operación según la opción
    cmp     x19, #1
    b.eq    do_and
    cmp     x19, #2
    b.eq    do_or
    b       do_xor

do_and:
    and     x22, x20, x21
    b       print_result

do_or:
    orr     x22, x20, x21
    b       print_result

do_xor:
    eor     x22, x20, x21

print_result:
    // Imprimir resultado en decimal
    adr     x0, msg_resultado
    mov     x1, x22
    bl      printf

    // Imprimir mensaje para binario
    adr     x0, msg_binario
    bl      printf

    // Imprimir resultado en binario
    mov     x23, #63           // Contador para 64 bits
    mov     x24, x22           // Copia del resultado para manipular

print_binary:
    // Obtener bit más significativo
    lsr     x25, x24, x23
    and     x25, x25, #1
    
    // Imprimir bit
    adr     x0, msg_bit
    mov     x1, x25
    bl      printf
    
    // Continuar con siguiente bit
    sub     x23, x23, #1
    cmp     x23, #-1
    b.ne    print_binary

    // Nueva línea después del binario
    adr     x0, msg_newline
    bl      printf

    // Limpiar buffer de entrada
    mov     x0, #0
    bl      getchar

    b       menu_loop

input_error:
    // Mostrar mensaje de error
    adr     x0, msg_error
    bl      printf
    
    // Limpiar buffer de entrada
    mov     x0, #0
    bl      getchar
    
    b       menu_loop

exit_program:
    // Epílogo y retorno
    mov     w0, #0
    ldp     x29, x30, [sp], 48
    ret
