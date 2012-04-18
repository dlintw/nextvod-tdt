#ifndef CRC32_H_
#define CRC32_H_

#include <stdint.h>

uint64_t crc32(uint64_t crc, uint8_t *buf, uint32_t size);

#endif /* CRC32_H_ */
