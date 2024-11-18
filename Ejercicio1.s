// ***************************************************************
// *                                                             *
// *                   Instituto Tecnico De Tijuana              *
// *                                                             *
// *                     Edgar Fabian Molina Fabela              *
// *                                                             *
// *                     Número de Control: 22210780             *
// *                                                             *
// *                        Fecha: 19/11/24                      *
// *                                                             *
// *                  Proyecto: 50 Programas AWS                 *
// *                                                             *
// ***************************************************************

.data
    prompt:     .string "Ingresa la temperatura en Celsius: "
    scan_fmt:   .string "%f"                    // Formato para scanf
    print_fmt:  .string "%.2f°C = %.2f°F\n"    // Formato para printf
    celsius:    .single 0.0                     // Variable para guardar entrada
    fahrenheit: .single 0.0                     // Variable para resultado

    // Constantes para el cálculo
    const_nine:      .single 9.0
    const_five:      .single 5.0
    const_thirtytwo: .single 32.0

   .text
    .global main
    main:
    // Prólogo
    stp     x29, x30, [sp, #-16]!    // Guardar frame pointer y link register
    mov     x29, sp                   // Establecer frame pointer

   // Mostrar prompt
    adr     x0, prompt
    bl      printf

    // Leer temperatura en Celsius
    adr     x0, scan_fmt             // Formato para scanf
    adr     x1, celsius              // Dirección donde guardar el valor
    bl      scanf

    // Cargar valor ingresado y constantes
    adr     x0, celsius
    ldr     s0, [x0]                 // Cargar temperatura Celsius
    
    adr     x0, const_nine
    ldr     s1, [x0]                 // Cargar 9.0
    
    adr     x0, const_five
    ldr     s2, [x0]                 // Cargar 5.0
    
    adr     x0, const_thirtytwo
    ldr     s3, [x0]                 // Cargar 32.0

    // Realizar el cálculo: (C * 9/5) + 32
    fmul    s0, s0, s1               // Multiplicar por 9
    fdiv    s0, s0, s2               // Dividir por 5
    fadd    s0, s0, s3               // Sumar 32

    // Guardar resultado
    adr     x0, fahrenheit
    str     s0, [x0]

    // Preparar argumentos para printf
    adr     x0, print_fmt            // Formato para imprimir
    adr     x1, celsius        
    ldr     s0, [x1]                 // Cargar valor Celsius
    fcvt    d0, s0                   // Convertir a double para printf
    adr     x1, fahrenheit
    ldr     s1, [x1]                 // Cargar resultado Fahrenheit
    fcvt    d1, s1                   // Convertir a double para printf
    
    // Imprimir resultado
    bl      printf

    // Epílogo y retorno
    mov     w0, #0                   // Código de retorno 0
    ldp     x29, x30, [sp], #16      // Restaurar frame pointer y link register
    ret
