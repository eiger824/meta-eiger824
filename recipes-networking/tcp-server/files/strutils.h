#ifndef STRUTILS_H_
#define STRUTILS_H_

#include <string.h>
#include <stdlib.h>

char* msg_app_int(const char* msg1, int n)
{
	char* p = malloc(200);
	int b = sprintf(p, msg1, n);
	return p;
}

char* msg_app_string(const char* msg1, const char* msg2)
{
	char *p = malloc(200);
	int b = sprintf(p, msg1, msg2);
	return p;
}
#endif /*STRUTILS_H_*/
