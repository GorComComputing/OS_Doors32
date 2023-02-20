#ifndef STRING_H
#define STRING_H

typedef unsigned int size_t;  // Предположительно это int

//#include "stddef.h"

char* ctos(char s[2], const char c);
int memcmp(const void* aptr, const void* bptr, size_t size);
void* memset(void* bufptr, int value, size_t size);
size_t strlen(const char* str);
char* strcpy(char* dest, const char* src);
int strcmp(const char* s1, const char* s2);
int strncmp(const char* s1, const char* s2, size_t n);
char* strchr(const char* s, int c);
char* strstr(char *s1, const char* s2);
char* strcat(char* dest, const char* src);
int isupper(char c);
int islower(char c);
int isalpha(char c);
int isspace(char c);
int isdigit(char c);
char* ltrim(char* s);
char* rtrim(char* s);
char* trim(char* s);

#endif
