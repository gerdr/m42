chunk parrot2_core
ptr %ip = $0
i64 %ia, %ib
f64 %ia, %ib
ptr %pa, %pb

jmp ptr(*%ip)

@.add_ia:
add %ia, %ia, %ib
lea %ip, ptr(*%ip:sizeof(reg))
jmp ptr(*%ip)

@.add_fa:
fadd %fa, %fa, %fb
lea %ip, ptr(*%ip:sizeof(reg))
jmp ptr(*%ip)
