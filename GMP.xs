#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include "gmp.h"

static int
not_here(char *s)
{
    croak("%s not implemented on this architecture", s);
    return -1;
}

static double
constant(char *name, int arg)
{
    errno = 0;
    switch (*name) {
    }
    errno = EINVAL;
    return 0;

not_there:
    errno = ENOENT;
    return 0;
}


MODULE = Math::GMP		PACKAGE = Math::GMP		


double
constant(name,arg)
	char *		name
	int		arg

mpz_t *
new_from_scalar(s)
	char *	s

  CODE:
    RETVAL = malloc (sizeof(mpz_t));
    mpz_init_set_str(*RETVAL, s, 0);
  OUTPUT:
    RETVAL

void
destroy(n)
	mpz_t *n

  CODE:
    mpz_clear(*n);
    free(n);

SV *
stringify_gmp(n)
	mpz_t *	n

  PREINIT:
    int len;
    
  CODE:
    len = mpz_sizeinbase(*n, 10);
    {
      char buf[len + 2];
      mpz_get_str(buf, 10, *n);
      RETVAL = newSVpv(buf, strlen(buf));
    }
  OUTPUT:
    RETVAL

long 
intify_gmp(n)
	mpz_t *	n

  CODE:
    RETVAL = mpz_get_si(*n);
  OUTPUT:
    RETVAL

mpz_t *
add_two(m,n)
	mpz_t *		m
	mpz_t *		n

  CODE:
    RETVAL = malloc (sizeof(mpz_t));
    mpz_init(*RETVAL);
    mpz_add(*RETVAL, *m, *n);
  OUTPUT:
    RETVAL


mpz_t *
sub_two(m,n)
	mpz_t *		m
	mpz_t *		n

  CODE:
    RETVAL = malloc (sizeof(mpz_t));
    mpz_init(*RETVAL);
    mpz_sub(*RETVAL, *m, *n);
  OUTPUT:
    RETVAL


mpz_t *
mul_two(m,n)
	mpz_t *		m
	mpz_t *		n

  CODE:
    RETVAL = malloc (sizeof(mpz_t));
    mpz_init(*RETVAL);
    mpz_mul(*RETVAL, *m, *n);
  OUTPUT:
    RETVAL


mpz_t *
div_two(m,n)
	mpz_t *		m
	mpz_t *		n

  CODE:
    RETVAL = malloc (sizeof(mpz_t));
    mpz_init(*RETVAL);
    mpz_div(*RETVAL, *m, *n);
  OUTPUT:
    RETVAL


mpz_t *
mod_two(m,n)
	mpz_t *		m
	mpz_t *		n

  CODE:
    RETVAL = malloc (sizeof(mpz_t));
    mpz_init(*RETVAL);
    mpz_mod(*RETVAL, *m, *n);
  OUTPUT:
    RETVAL


int
cmp_two(m,n)
	mpz_t *		m
	mpz_t *		n

  CODE:
    RETVAL = mpz_cmp(*m, *n);
  OUTPUT:
    RETVAL


mpz_t *
pow_two(m,n)
	mpz_t *		m
	long		n

  CODE:
    RETVAL = malloc (sizeof(mpz_t));
    mpz_init(*RETVAL);
/*    fprintf(stderr, "n is %ld\n", n);*/
    mpz_pow_ui(*RETVAL, *m, n);
  OUTPUT:
    RETVAL


mpz_t *
gcd_two(m,n)
	mpz_t *		m
	mpz_t *		n

  CODE:
    RETVAL = malloc (sizeof(mpz_t));
    mpz_init(*RETVAL);
    mpz_gcd(*RETVAL, *m, *n);
  OUTPUT:
    RETVAL


