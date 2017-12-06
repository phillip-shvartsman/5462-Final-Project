#include <iostream>
#include "stdint.h"
#include "stdlib.h"
#include <bitset>

using namespace std; 

uint64_t Add(uint64_t opA, uint64_t opB) { 

	uint64_t res = opA + opB; 

	return reinterpret_cast<uint64_t&>(res);
}

int main() { 

	uint16_t NUM_OPS = 50; 

	uint64_t ops[NUM_OPS]; 

	for(uint16_t i = 0U; i < NUM_OPS; i++) {
		ops[i] = 0U; 

		ops[i] = 0x8000000000000000 & ((rand() % 2)==1); 

		ops[i] |= ((rand() % 254)+1)<<23U; 

		ops[i] |= ((rand() % 0x7FFFFFFFFFFFFF)); 

	}

	for(uint16_t i = 0U; i < NUM_OPS; i++) {
		cout << bitset<64>(ops[i]) << "\n" << bitset<64>(ops[i+1]) << "\n"
			 << bitset<64>(Add(ops[i],ops[i+1])) << endl;
	}

	return 0;
} 
