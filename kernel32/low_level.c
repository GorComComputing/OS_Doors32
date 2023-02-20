// Функции для работы с портами устройств


// Читает байт из порта
unsigned char port_byte_in(unsigned short port){
	// "=a" (result) put AL in result
	// "d" (port) load EDX with port
	unsigned char result;
	__asm__("in %%dx,%%al" : "=a" (result) : "d" (port));
	return result;
}


// Пишет байт в порт
void port_byte_out(unsigned short port, unsigned char data){
	// "a" (data) load EAX with data
	// "d" (port) load EDX with port
	__asm__("out %%al,%%dx" : : "a" (data), "d" (port));
}


// Читает слово из порта
unsigned short port_word_in(unsigned short port){
	unsigned short result;
	__asm__("in %%dx,%%ax" : "=a" (result) : "d" (port));
	return result;
}


// Пишет слово в порт
void port_word_out(unsigned short port, unsigned short data){
	__asm__("out %%ax,%%dx" : : "a" (data), "d" (port));
}
