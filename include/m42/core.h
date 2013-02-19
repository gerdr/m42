#ifndef M42_CORE_H_
#define M42_CORE_H_

#include "base.h"

#define m42_core(IP) (m42_core)((void *)(const m42_val *){ IP })
extern m42_val (m42_core)(void *);

#endif
