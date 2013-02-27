#ifndef M42_BASE_H_
#define M42_BASE_H_

#include <stddef.h>
#include <stdint.h>

typedef union m42_val_ m42_val;

union m42_val_
{
	uint64_t u;
	int64_t i;
	double f;
	void *p;
	const void *cp;
	ptrdiff_t pd;
	size_t sz;
};

#endif
