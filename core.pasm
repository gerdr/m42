chunk @m42_core
ptr %ip = $0
i64 %ia, %ib
f64 %fa, %fb
ptr %pa, %pb

jmp ptr(%ip)

@.set_ia:
lea %ip, val(%ip[1])
mov %ia, i64(%ip)
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.set_ib:
lea %ip, val(%ip[1])
mov %ib, i64(%ip)
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.add_ia:
add %ia, %ia, %ib
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.set_fa:
lea %ip, val(%ip[1])
mov %fa, f64(%ip)
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.set_fb:
lea %ip, val(%ip[1])
mov %fb, f64(%ip)
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.add_fa:
fadd %fa, %fa, %fb
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.ret_ia:
ret %ia

@.ret_fa:
ret %fa
