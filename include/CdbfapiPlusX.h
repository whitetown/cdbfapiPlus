#include    <time.h>

#if !defined(cdbfapiPlus_type)
typedef     int cdbfapiPlus;
#endif

#ifndef     BOOL  
typedef     int BOOL;
#endif


#ifdef __cplusplus
extern "C" { 
#endif
 
__declspec(dllexport) cdbfapiPlus* cdbfapiCreate();             
__declspec(dllexport) void cdbfapiRelease(cdbfapiPlus* handle);

__declspec(dllexport) void  initLibrary(cdbfapiPlus* handle, int magicNumber, char *email);

__declspec(dllexport) BOOL  openDBFfile(cdbfapiPlus* handle, char *filename);
__declspec(dllexport) void  closeDBFfile(cdbfapiPlus* handle);

__declspec(dllexport) int   recCount(cdbfapiPlus* handle);
__declspec(dllexport) int   fieldCount(cdbfapiPlus* handle);

__declspec(dllexport) BOOL  getRecord(cdbfapiPlus* handle, int recno);
__declspec(dllexport) BOOL  readRecord(cdbfapiPlus* handle, int recno);
__declspec(dllexport) BOOL  writeRecord(cdbfapiPlus* handle, int recno);

__declspec(dllexport) BOOL  readField(cdbfapiPlus* handle, int recno, int fieldno);
__declspec(dllexport) BOOL  writeField(cdbfapiPlus* handle, int recno, int fieldno);

__declspec(dllexport) int   indexOfField(cdbfapiPlus* handle, char* fieldname);

__declspec(dllexport) char*   getString(cdbfapiPlus* handle, int fieldno);
__declspec(dllexport) double  getValue(cdbfapiPlus* handle, int fieldno);
__declspec(dllexport) struct  tm getDateTime(cdbfapiPlus* handle, int fieldno);
__declspec(dllexport) __int64 getTicks(cdbfapiPlus* handle, int fieldno);

__declspec(dllexport) int   getData(cdbfapiPlus* handle, int fieldno, char **output);

__declspec(dllexport) int   getMemoBuf(cdbfapiPlus* handle, int fieldno, char **output);

__declspec(dllexport) BOOL  isMemoField(cdbfapiPlus* handle, int fieldno);
__declspec(dllexport) BOOL  isNumericField(cdbfapiPlus* handle, int fieldno);
__declspec(dllexport) BOOL  isDateField(cdbfapiPlus* handle, int fieldno);

__declspec(dllexport) BOOL  isCurrentDeleted(cdbfapiPlus* handle);
__declspec(dllexport) BOOL  isDeleted(cdbfapiPlus* handle, int fieldno);

__declspec(dllexport) void  clearRecord(cdbfapiPlus* handle);
__declspec(dllexport) void  clearField(cdbfapiPlus* handle, int fieldno);

__declspec(dllexport) void  setFieldString(cdbfapiPlus* handle, int fieldno, char* string);
__declspec(dllexport) void  setFieldDouble(cdbfapiPlus* handle, int fieldno, double value);
__declspec(dllexport) void  setField(cdbfapiPlus* handle, int fieldno, char* string, double value);

__declspec(dllexport) void  setMemoData(cdbfapiPlus* handle, int fieldno, char *input, int len);

__declspec(dllexport) BOOL  markAsDeleted(cdbfapiPlus* handle, int fieldno);
__declspec(dllexport) BOOL  recallDeleted(cdbfapiPlus* handle, int fieldno);

__declspec(dllexport) BOOL  deleteRecord(cdbfapiPlus* handle, int recno);
__declspec(dllexport) BOOL  appendRecord(cdbfapiPlus* handle, BOOL blankrecord);
__declspec(dllexport) BOOL  insertRecord(cdbfapiPlus* handle, int recno, BOOL blankrecord);

__declspec(dllexport) void  setOrder(cdbfapiPlus* handle, char* fieldlist);
__declspec(dllexport) void  setOrderA(cdbfapiPlus* handle, char* fields[]);
__declspec(dllexport) void  unsetOrder(cdbfapiPlus* handle);
__declspec(dllexport) void  descendingMode(cdbfapiPlus* handle, BOOL descending);

__declspec(dllexport) void  setFilter(cdbfapiPlus* handle, char* expression);
__declspec(dllexport) void  unsetFilter(cdbfapiPlus* handle);
__declspec(dllexport) void  caseSensitiveMode(cdbfapiPlus* handle, BOOL sensitive);

__declspec(dllexport) BOOL  pack(cdbfapiPlus* handle);
_declspec(dllexport)  BOOL  truncate(cdbfapiPlus* handle, int recno);
__declspec(dllexport) BOOL  zap(cdbfapiPlus* handle);

__declspec(dllexport) int   fileType(cdbfapiPlus* handle);
__declspec(dllexport) char* filetypeAsText(cdbfapiPlus* handle);

__declspec(dllexport) int   recordLength(cdbfapiPlus* handle);
__declspec(dllexport) char* lastUpdated(cdbfapiPlus* handle);
__declspec(dllexport) int   headerSize(cdbfapiPlus* handle);

__declspec(dllexport) char* filename(cdbfapiPlus* handle);
__declspec(dllexport) char* filenameMemo(cdbfapiPlus* handle);
__declspec(dllexport) char* driverName(cdbfapiPlus* handle);

__declspec(dllexport) void  resetLastRecord(cdbfapiPlus* handle);

__declspec(dllexport) char* fieldName(cdbfapiPlus* handle, int fieldno);
__declspec(dllexport) int   fieldData(cdbfapiPlus* handle, int fieldno, char **output);
__declspec(dllexport) char  fieldType(cdbfapiPlus* handle, int fieldno);
__declspec(dllexport) int   fieldLength(cdbfapiPlus* handle, int fieldno);
__declspec(dllexport) int   fieldDecimal(cdbfapiPlus* handle, int fieldno);

__declspec(dllexport) char* typeAsText(char c);

__declspec(dllexport) void  setEncoding(cdbfapiPlus* handle, int e);
__declspec(dllexport) void  setDateFormat(cdbfapiPlus* handle, char* format);
__declspec(dllexport) void  setDateDelimiter(cdbfapiPlus* handle, char delimiter);

__declspec(dllexport) BOOL  isReadOnly(cdbfapiPlus* handle);
__declspec(dllexport) void  setReadOnly(cdbfapiPlus* handle, BOOL value);

__declspec(dllexport) BOOL  prepareNewTable(cdbfapiPlus* handle, int fileType);
__declspec(dllexport) BOOL  prepareNewTableExtended(cdbfapiPlus* handle, int fileType, int memoSize, char *driver);

__declspec(dllexport) void  addField(cdbfapiPlus* handle, char* fieldname, char fieldType, int length);
__declspec(dllexport) void  addFieldX(cdbfapiPlus* handle, char* fieldname, char fieldType, int length, int decimal);

__declspec(dllexport) BOOL  createTable(cdbfapiPlus* handle, char* filename);
__declspec(dllexport) BOOL  createAndOpenTable(cdbfapiPlus* handle, char* filename);

__declspec(dllexport) void  setByte(cdbfapiPlus* handle, int offset, char b);
__declspec(dllexport) char  getByte(cdbfapiPlus* handle, int offset);


#ifdef __cplusplus
}
#endif
