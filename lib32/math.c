#include "math.h"

// синус
/*float Sinus(float x){
    float s = x;
    float d = x;
    for(float n = 3; Abs(d) > 0.0000001; n+=2){
        d *= -x*x/n/(n-1);
        s += d;
    }
    return s;
}*/


// модуль числа
int abs(int x){
    return x >= 0 ? x : -x;
}
