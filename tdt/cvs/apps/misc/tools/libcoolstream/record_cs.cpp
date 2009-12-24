#include <stdio.h>

#include "record_cs.h"

static const char * FILENAME = "record_cs.cpp";

cRecord::cRecord(int num) { printf("%s:%s\n", FILENAME, __FUNCTION__); }
cRecord::~cRecord() { printf("%s:%s\n", FILENAME, __FUNCTION__); }

bool cRecord::Open(int numpids) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }
void cRecord::Close(void) { printf("%s:%s\n", FILENAME, __FUNCTION__); }
bool cRecord::Start(int fd, unsigned short vpid, unsigned short * apids, int numpids) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }
bool cRecord::Stop(void) { printf("%s:%s\n", FILENAME, __FUNCTION__); return 0; }
void cRecord::RecordNotify(int Event, void *pData) { printf("%s:%s\n", FILENAME, __FUNCTION__); }

