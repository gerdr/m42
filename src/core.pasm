chunk @m42_core
ptr %ip = $0

ptr %dp
ptrdiff %di

i64 %ia, %ib
f64 %fa, %fb
ptr %pa, %pb

jmp ptr(%ip)

@.pushi:
mov %ib, %ia
lea %ip, val(%ip[1])
mov %ia, i64(%ip)
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.addi:
add %ia, %ia, %ib
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.muli:
mul %ia, %ia, %ib
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.pushf:
mov %fb, %fa
lea %ip, val(%ip[1])
mov %fa, f64(%ip)
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.addf:
fadd %fa, %fa, %fb
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.reti:
ret %ia

@.retf:
ret %fa

@.base:
lea %ip, val(%ip[1])
mov %dp, ptr(%ip)
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.index:
lea %ip, val(%ip[1])
mov %di, ptrdiff(%ip)
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.offset:
lea %ip, val(%ip[1])
mul %di, %di, ptrdiff(%ip)
lea %dp, i8(%dp[%di])
lea %ip, val(%ip[1])
jmp ptr(%ip)

@.loadi64:
mov %ib, %ia
mov %ia, i64(%dp)
lea %ip, val(%ip[1])
jmp ptr(%ip)
