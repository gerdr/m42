chunk @parrot2_core
ptr %ip = $0
i64 %ia, %ib
f64 %fa, %fb
ptr %pa, %pb

jmp ptr(%ip)

@.add_ia:
add %ia, %ia, %ib
lea %ip, reg(%ip[1])
jmp ptr(%ip)

@.add_fa:
fadd %fa, %fa, %fb
lea %ip, reg(%ip[1])
jmp ptr(%ip)
