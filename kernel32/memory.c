#include "memory.h"

//  опирует байты из одного места в другое
void memory_copy(uint8* source, uint8* dest, int no_bytes){
	for(int i = 0; i < no_bytes; i++)
		*(dest + i) = *(source + i);
}
