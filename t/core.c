#include <m42/core.h>

#undef NDEBUG
#include <assert.h>

int main(void)
{
	{
		enum { A = 42, B = -5 };

		static const m42_val CODE[] = {
			{ .cp = m42_core__set_ia }, { .i = A },
			{ .cp = m42_core__set_ib }, { .i = B },
			{ .cp = m42_core__add_ia },
			{ .cp = m42_core__ret_ia },
		};

		assert(m42_core(CODE).i == A + B);
	}

	return 0;
}
