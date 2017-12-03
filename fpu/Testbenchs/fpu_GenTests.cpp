#include <iostream>
#include "stdint.h"
#include "stdlib.h"
#include <bitset>

using namespace std; 

uint32_t flAdd(uint32_t opA, uint32_t opB) { 

	float flA = reinterpret_cast<float&>(opA); 

	float flB = reinterpret_cast<float&>(opB); 

	float res = flA + flB; 

	return reinterpret_cast<uint32_t&>(res);

}

uint32_t flSub(uint32_t opA, uint32_t opB) { 

	float flA = reinterpret_cast<float&>(opA); 

	float flB = reinterpret_cast<float&>(opB); 

	float res = flA - flB; 

	return reinterpret_cast<uint32_t&>(res);

}

uint32_t flMult(uint32_t opA, uint32_t opB) { 

	float flA = reinterpret_cast<float&>(opA); 

	float flB = reinterpret_cast<float&>(opB); 

	float res = flA * flB; 

	return reinterpret_cast<uint32_t&>(res);

}

int main() { 

	uint16_t NUM_OPS = 50; 

	uint32_t ops[NUM_OPS]; 

	for(uint16_t i = 0U; i < NUM_OPS; i++) {
		ops[i] = 0U; 

		ops[i] = 0x80000000 & ((rand() % 2)==1); 

		ops[i] |= ((rand() % 254)+1)<<23U; 

		ops[i] |= ((rand() % 0x7FFFFF)); 

	}

	for(uint16_t i = 0U; i < NUM_OPS; i++) {
		if(rand() % 2 == 1) {
			if( rand() % 2 == 1) {
				cout << bitset<32>(ops[i]) << " 00\n" << bitset<32>(ops[i+1]) << "\n"
				 << bitset<32>(flAdd(ops[i],ops[i+1])) << endl;
			}
			else {
				cout << bitset<32>(ops[i]) << " 01\n" << bitset<32>(ops[i+1]) << "\n"
				 << bitset<32>(flSub(ops[i],ops[i+1])) << endl;
			}
		}
		else {
			cout << bitset<32>(ops[i]) << " 10\n" << bitset<32>(ops[i+1]) << "\n"
				 << bitset<32>(flMult(ops[i],ops[i+1])) << endl;
		}
	} 

	return 0;
} 
