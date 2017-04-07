#include <stdio.h>

int main()
{
	char name[100];
	printf("Name: ");
	scanf("%s",name);
	printf("Hello %s, I was build with yocto. Just so you know it\n", name);
	return 0;
}
