#ifndef M42_CORE_H_
#define M42_CORE_H_

#include "base.h"

#define m42_core(IP) (m42_core)((void *)(const m42_val *){ IP })
extern m42_val (m42_core)(void *);

extern const char m42_core__pushi[];
extern const char m42_core__addi[];
extern const char m42_core__muli[];
extern const char m42_core__reti[];

extern const char m42_core__pushf[];
extern const char m42_core__addf[];
extern const char m42_core__retf[];

extern const char m42_core__base[];
extern const char m42_core__index[];
extern const char m42_core__offset[];

extern const char m42_core__loadi64[];

#endif
