#ifndef M42_CORE_H_
#define M42_CORE_H_

#include "base.h"

#define m42_core(IP) (m42_core)((void *)(const m42_val *){ IP })
extern m42_val (m42_core)(void *);

extern const char m42_core__set_ia[];
extern const char m42_core__set_ib[];
extern const char m42_core__add_ia[];
extern const char m42_core__ret_ia[];

#endif
