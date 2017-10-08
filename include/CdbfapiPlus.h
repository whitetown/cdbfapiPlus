// CdbfapiPlus.h : Defines the exported functions for the DLL application.
//

//#include "stdafx.h"
#define WIN32_LEAN_AND_MEAN             // Exclude rarely-used stuff from Windows headers
// Windows Header Files:
#include <windows.h>
#include <time.h>

#define cdbfapiPlus_type

class __declspec(dllexport) cdbfapiPlus 
{
  private:

    int     *dbfHandle;
    int     fld_count;
    void    *fld;
    int     charset;
        //
    int     typeOfNewFile;
    int     sizeOfMemo;
    char    *driverString;
    BOOL    readonly;

  public:
        
    cdbfapiPlus();

    void    initLibrary(int magicNumber, char *email);

    BOOL    openDBFfile(char* filename);
    void    closeDBFfile();

    int     recCount();
    int     fieldCount();

    BOOL    getRecord(int recno);
    BOOL    readRecord(int recno);
    BOOL    writeRecord(int recno);

    BOOL    readField (int recno, int fieldno);
    BOOL    writeField(int recno, int fieldno);

    int     indexOfField(char* fieldname);

    char*   getString(int fieldno);
    double  getValue(int fieldno);

    struct  tm getDateTime(int fieldno);
    __int64 getTicks(int fieldno);

    char*   getMemoBuf(int fieldno, int *len);

    BOOL    isMemoField(int fieldno);
    BOOL    isNumericField(int fieldno);
    BOOL    isDateField(int fieldno);

    BOOL    isDeleted();
    BOOL    isDeleted(int recno);

    void    clearRecord();
    void    clearField(int fieldno);

    void    setField(int fieldno, char* string);
    void    setField(int fieldno, double value);
    void    setField(int fieldno, char* string, double value);

    void    setMemoBuf(int fieldno, char *string, int len);

    BOOL    markAsDeleted(int recno);
    BOOL    recallDeleted(int recno);

    BOOL    deleteRecord(int recno);
    BOOL    appendRecord(BOOL blankrecord);
    BOOL    insertRecord(int recno, BOOL blankrecord);

    void    setOrder(char* fieldlist);
    void    setOrderA(char* fields[]);
    void    unsetOrder();
    void    descendingMode(BOOL descending);

    void    setFilter(char* expression);
    void    unsetFilter();
    void    caseSensitiveMode(BOOL sensitive);

    BOOL    pack();
    BOOL    truncate(int recno);
    BOOL    zap();

    int     fileType();
    char*   filetypeAsText();

    int     recordLength();
    char*   lastUpdated();
    int     headerSize();

    char*   driverName();
    char*   filename();
    char*   filenameMemo();

    void    resetLastRecord();

    char*   fieldName(int fieldno);
    char    fieldType(int fieldno);
    int     fieldLength(int fieldno);
    int     fieldDecimal(int fieldno);

    static char*    typeAsText(char c);

    void    setEncoding(int e);
    void    setDateFormat(char* format);
    void    setDateDelimiter(char delimiter);

    BOOL    isReadOnly();
    void    setReadOnly(BOOL value);

    BOOL    prepareNewTable(int fileType);
    BOOL    prepareNewTable(int fileType, int memoSize, char* driver);

    void    addField(char* fieldname, char fieldType, int length);
    void    addField(char* fieldname, char fieldType, int length, int dec);

    BOOL    createTable(char* filename);
    BOOL    createAndOpenTable(char* filename);

    void    setByte(int offset, char b);
    char    getByte(int offset);


};

