#include <m42/core.h>

#undef NDEBUG
#include <assert.h>

int main(void)
{
	{
		enum { A = 42, B = -5 };

		const m42_val CODE[] = {
			{ .cp = m42_core__pushi }, { .i = A },
			{ .cp = m42_core__pushi }, { .i = B },
			{ .cp = m42_core__addi },
			{ .cp = m42_core__reti },
		};

		assert(m42_core(CODE).i == A + B);
	}

	{
		static const uint64_t A = 0xDEAD;
		static const uint64_t B = 0xBEEF;

		const m42_val CODE[] = {
			{ .cp = m42_core__base }, { .cp = &A },
			{ .cp = m42_core__loadi64 },
			{ .cp = m42_core__base }, { .cp = &B },
			{ .cp = m42_core__loadi64 },
			{ .cp = m42_core__muli },
			{ .cp = m42_core__reti },
		};

		assert(m42_core(CODE).i == A * B);
	}

	{
		static const double A = 0.25;
		static const double B = -0.5;

		const m42_val CODE[] = {
			{ .cp = m42_core__pushf }, { .f = A },
			{ .cp = m42_core__pushf }, { .f = B },
			{ .cp = m42_core__addf },
			{ .cp = m42_core__retf },
		};

		assert(m42_core(CODE).f == A + B);
	}

	return 0;
}
