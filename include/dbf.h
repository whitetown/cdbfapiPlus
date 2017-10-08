#ifndef DBF_H
#define DBF_H

/*******************************
 target OS
 THE_LINUX_ - linux
 THE_DOS_32_    - DOS32, OS/2
 THE_WINDOWS_   - windows
*******************************/

//#define THE_LINUX_
//#define THE_DOS32_
//#define THE_WINDOWS_
//#define THE_IOS_

///////////////////////////////


#ifdef __cplusplus
#include <time.h>

extern "C"{
#endif

#ifdef  THE_LINUX_

#include <inttypes.h>
//#define _toupper  toupper
#define DeleteFile unlink


#define _MAX_DRIVE  16
#define _MAX_DIR    1024
#define _MAX_PATH   1024
#define _MAX_FNAME  1024
#define _MAX_EXT    128
#define O_BINARY    0
#define __int64     int64_t

#define PDWORD DWORD*
    
#define SH_DENYNO       0

#endif

#ifdef THE_WINDOWS_

#include <windows.h>

////// these defines are necessary to avoid warnings in MSVC 2012
#define stricmp  _stricmp
#define strnicmp _strnicmp
#define strdup _strdup
#define strupr _strupr

#define __attribute__(...)
#else

#include <stdio.h>

#ifndef THE_DOS32_

//#include </usr/include/iodbcunix.h>

#else

typedef int     BOOL; 
typedef unsigned long DWORD, *PDWORD, *LPDWORD;

#define SH_DENYNO 0x40


#endif

#include <objc/objc.h>
#include <unistd.h>

#define HANDLE      FILE*
    
int    ReadFile(HANDLE h, char *s, int l);
int    WriteFile(HANDLE h, char *s, int l);

    
#define __stdcall
#define HWND        int

//#ifndef BOOL
//#define BOOL      unsigned int
//#endif

#define DWORD       unsigned int
#define LONG        long
#define FALSE       0
#define TRUE        1

#ifndef FILE_BEGIN
#define FILE_BEGIN  0
#endif
#ifndef FILE_END
#define FILE_END    2
#endif

//#ifdef THE_IOS_
#define CloseHandle fclose
//#define write fwrite
//#define read fread
//#else
//#define CloseHandle   close
//#endif
    
int     SetFilePointer(HANDLE h, int pos, DWORD *reserve, int code);
void    OemToCharBuff(char *s, char *d, int l);
void    CharToOemBuff(char *s, char *d, int l);

#ifdef  THE_LINUX_
void    _splitpath(char *s, char *, char*, char*, char*);
#endif

typedef struct  RECT    {
    int top;
    int left;
    int right;
    int bottom;
    } RECT;


#endif

#ifdef  THE_LINUX_
#define stricmp strcasecmp
#define strnicmp strncasecmp
#define chsize ftruncate
#define sopen open

char*   strupr(char *str);

#endif

union i64 {
    __int64      big;
    struct {
        int low, high;
    } twolong;
    char    s[8];
    };


#include <stdio.h>
///////////////////////////////////////////////

#define THE_128K        128*1024

#define dBase_III       0
#define FoxPro          1
#define dBase_IV        2
#define VisualFox       3
#define SMT             4
#define dbLevel7        5

//////////////////////////////////////////////////////////

struct  DBF;

typedef void   __stdcall Fxlat(char*, char*, int);
typedef void   __stdcall Fupper(char*);
typedef int    __stdcall FCallBack(void);
typedef int    __stdcall FAfterRead(struct DBF*);
typedef int    __stdcall FBeforeWrite(struct DBF*);
typedef int    __stdcall FAfterReadField(struct DBF*, int);
typedef int    __stdcall FBeforeWriteField(struct DBF*, int);
typedef int    __stdcall FAfterReadOneByte(struct DBF*);
typedef int    __stdcall FBeforeWriteOneByte(struct DBF*);

//////////////////////////////////////////////////////////

#ifndef  THE_LINUX_
#pragma pack(1)
#endif


struct  Header {            //DBF file header
    unsigned char   id;

    unsigned char   last_year;
    unsigned char   last_month;
    unsigned char   last_day;

    unsigned int    num_rec;
    unsigned short  offset_first;
    unsigned short  rec_len;
    char        reserve[16];
    unsigned char   cdx;
    unsigned char   codepage;
    char        reserve2[2];

    char        level7[36];
} __attribute__((packed)) ;

struct  Header_8b {         //DBT file header - dBase IV
    unsigned int    last_block;
    char        reserve[14];
    unsigned short  id;
    unsigned short  blocksize;
} __attribute__((packed)) ;

struct  Data_8b {           //DBT file header before memo info
    unsigned int    id;
    unsigned int    size;
} __attribute__((packed)) ;


struct  Header_e5 {         //SMT file header - SixMemo
    unsigned int    last_block;
    unsigned short  blocksize;
    char    six[8];         //SIxMemo
} __attribute__((packed)) ;

struct  Header_f5 {         //FPT file header - FoxPro
    unsigned char   last_4;
    unsigned char   last_3;
    unsigned char   last_2;
    unsigned char   last_1;
    short       reserve;
    unsigned char   blocksize_2;
    unsigned char   blocksize_1;
} __attribute__((packed)) ;

struct  Data_f5 {
    unsigned int    id;     //FPT file header before memo info
    unsigned char   size_4;
    unsigned char   size_3;
    unsigned char   size_2;
    unsigned char   size_1;
} __attribute__((packed)) ;

union   int_char {
    unsigned short  len;
    unsigned char   l[2];
};

struct  _Field {            //field description for all DBFs except level7
    unsigned char   name[11];
    char        type;
    unsigned short  offset;
    char        reserve[2];
    union int_char  length;
    unsigned char   reserve2[2];
    char        workarea;   //dbase III = 1
    unsigned char   reserve3[11];
} __attribute__((packed)) ;

struct  Field {             //field description level7
    unsigned char   name[32];
    char        type;
    union int_char  length;
    unsigned short  offset;     //reserved in DBF file
    char        mdx;
    unsigned char   reserve[2];
    int     autoincrement;
    unsigned char   reserve2[2];
    char        workarea;   //dbase III = 1
    unsigned char   reserve3[1];
} __attribute__((packed)) ;

struct OneColumn {
    BOOL    visible;
    BOOL    readonly;
    BOOL    calculated;

    char*   name;
    char*   calcstring;
};

struct ColSetup {
    int     showtotal;
    int     calctotal;
    int     fixedcols;
    int     reserve[13];

    struct OneColumn    Columns[2048];
};


struct  Options {
    int     dt_type;        //0-as_is, 1-dmy, 2-mdy, 3-ymd
    int     memo_view;      //0-state, 1-as_is
    int     memo_blocksize;     //default block size for dbase4, foxpro
    int     charset;        //0-OEM, 1-Ansi
    int     memo_charset;       //0-OEM, 1-Ansi
    BOOL    ignore_case;        //0-no, 1-ignore
    BOOL    descending;     //0-false, 1=true

    int     viewtype;       //0-browse 1-fields
    int     alias;          //0-none 1-alias
    int     trimspace;      //trim spaces in each string field 0,1,2,3=none,right,left,all
    int     nodeleted;      //do not show deleted records
    int     cur_rec;        //last number go record

    int     start_field;
    int     start_record;

    int     search_field;

    int     reverse;        //1-reverse view
    int     locked;         //1-locked
    int     bak_files;      //0-none, 1-create
    int     bak_already;        //1- .bak file already has been created
    char    *filename_bak;      //name of .bak file
    int brackets;       //1-do not use brackets in the filter's expression.
    int real_value;     //1-returns real text for 'F','N' fields in GetStr

    int     reserve[21];        //reserve

    char    *description;

    char    *normal_case;
    char    *upper_case;
    char    *lower_case;

    char    *ansi_case;
    char    *oem_case;

    Fxlat   *UserOemToChar;
    Fxlat   *UserCharToOem;
    Fupper  *UserUpper;
    FCallBack   *CallBack;
};

struct FilterVar {
    char    v[1024];      //result string
    char    c[1024];      //temporary simple condition
    int t[1024];      //offset's of |&
    int vr;       //offset in result string
    char    left[1024];   //left operand
    char    right[1024];      //right operand
    };

#define flt_c       d->filvar->c
#define flt_v       d->filvar->v
#define flt_t       d->filvar->t
#define flt_vr      d->filvar->vr
#define flt_left    d->filvar->left
#define flt_right   d->filvar->right

#ifndef RC4_KEY
#define RC4_KEY

typedef struct rc4_key
{
   unsigned char state[256];
   unsigned char x;
   unsigned char y;
} rc4_key;

#endif



struct  DBF {
    HANDLE  h;          //handle of .dbf
    HANDLE  h_memo;         //handle of .fpt, .dbt
    
    int     errors;         //not used

    char    *filename;      //name of .dbf-file
    char    *filename_memo;     //name of .dbt or .fpt file
    char    *filename_hdr;      //name of .hdr file

    struct  Header  hdr;        //header of .dbf-file
    struct  Field   fld[2048];  //fields of .dbf-file

    char    als[2048][32];      //aliases from .hdr file

    int     Fieldorder[2048];   //field order

    struct  Options opt;        //view options

    unsigned short  num_fld;    //fields count
    int     current_row;        //current row in the .dbf-file
    int     current_field;      //current field in the .dbf-file
    int     memo_field;     //current memo-field in the .dbf-file

    char    one_byte;       //one byte for delete/recall operations

    char    *record_block;      //memory for read/write records
    char    *str;           //memory for field extract
    char    *memo_block;        //memory for memo-editor

    int     *filter;        //array of filtered records
    int     num_filter;     //count of filtered records

    struct  FilterVar *filvar;  //pointer to filter structure

    int     order_num;
    int     order_var[20];
    int     *order;

    int     work_num;
    int     *work_var;

    char    group_line[255];    //defined group
    char    *copy_of_record;
    char    *filter_str;

    char    *s1, *s2;       //tmp pointers for sort
    int     sa, sb;         //tmp rec nums for sort

    BOOL    type_n;         //internal

    char    *d_fmt[5];      //date format string
    char    *t_fmt[5];      //time format string

    struct  ColSetup* pcol;     //settings of columns   ;1.06

    int level7;         //0 - usual DBF file, 1 - level 7 DBF file
    int hdr_length;     //size of header
    int fld_length;     //size of field
    int excel_compatible;   //Character fields less than 256 symbols

    int last_record;    //last read record in GetRecord
    
    int     readonly;   //readonly. disallow editing
    int     has_changes;  //was editing
    
    int     reserve[19];        //reserve
    
    char    *edit_block;        //for editing

    rc4_key *rc_key;        //key for encode/decode
    FAfterRead   *AR;           //function after read record    ;1.06
    FBeforeWrite *BW;           //function before write record  ;1.06
    FAfterReadField *ARF;       //function after read field ;1.06
    FBeforeWriteField   *BWF;       //function before write field   ;1.06
    FAfterReadOneByte   *AR1;       //function after read mark of del   ;1.06
    FBeforeWriteOneByte *BW1;       //function before write mark of del ;1.06
};

#ifndef  THE_LINUX_
#pragma pack()
#endif

#define high_len    length.l[0]
#define low_len     length.l[1]
#define all_len     length.len


#ifndef __max
#define __max(a,b)  (((a) > (b)) ? (a) : (b))
#endif

#ifndef __min
#define __min(a,b)  (((a) < (b)) ? (a) : (b))
#endif

//////////////////////////////////////////////////////////

typedef BOOL      __stdcall TAppendBlank     (struct DBF *d, BOOL empty);
typedef void      __stdcall TClearField  (struct DBF *d, int n);
typedef void      __stdcall TClearFilter     (struct DBF *d);
typedef void      __stdcall TClearRecord     (struct DBF *d);
typedef void      __stdcall TClearSort   (struct DBF *d);
typedef void      __stdcall TClose_File  (struct DBF *d);
typedef int   __stdcall TCompare     (const void *a, const void *b, struct DBF *d);
typedef BOOL      __stdcall TCreateDatabase  (char *filename, struct Field *fld, int n, int _type, int blocksize, BOOL memo);
typedef void      __stdcall TCreateField     (struct Field *fld, char *name, char type, int size);
typedef BOOL      __stdcall TCreateMemoFile  (char *filename, int _type, int blocksize);
typedef char*     __stdcall TDStrTrim    (struct DBF *d, int trim);
typedef BOOL      __stdcall TDelete      (struct DBF *d, int n);
typedef BOOL      __stdcall TDeleteRecord    (struct DBF *d, int n);
typedef void      __stdcall TDupRecord   (struct DBF *d);
typedef void      __stdcall TDupToRecord     (struct DBF *d);
typedef double    __stdcall TEvaluate    (char *s, int *att);
typedef char      __stdcall TFieldBlankChar  (struct DBF *d, int n);
typedef int   __stdcall TFoxPro_BlockSize(struct DBF *d);
typedef void      __stdcall TFreeMemo    (struct DBF *d);
typedef int   __stdcall TGetBlockSize    (struct DBF *d);
typedef BOOL      __stdcall TGetBool     (struct DBF *d, int n);
typedef void      __stdcall TGetCompStr  (char *s, char *t, struct DBF *d);
typedef double    __stdcall TGetCurrency     (struct DBF *d, int n);
typedef struct tm __stdcall TGetDT       (struct DBF *d, int n);
typedef int   __stdcall TGetDateTime     (struct DBF *d, int n);
typedef int   __stdcall TGetTimeStamp    (struct DBF *d, int n);
typedef double    __stdcall TGetDouble   (struct DBF *d, int n);
typedef int   __stdcall TGetFieldNum     (struct DBF *d, char *s);
typedef double    __stdcall TGetFloat    (struct DBF *d, int n);
typedef char*     __stdcall TGetHeader   (struct DBF *d, int n);
typedef int   __stdcall TGetInt      (struct DBF *d, int n);
typedef int   __stdcall TGetLenField     (struct DBF *d, int n);
typedef int   __stdcall TGetLenHeader    (struct DBF *d, int n);
typedef int   __stdcall TGetLenMax   (struct DBF *d, int n);
typedef int   __stdcall TGetLenView  (struct DBF *d, int n);
typedef char*     __stdcall TGetMemo     (struct DBF *d, int n);
typedef int   __stdcall TGetMemoType     (struct DBF *d);
typedef double    __stdcall TGetNumeric  (struct DBF *d, int n);
typedef unsigned int      __stdcall TGetOrder    (struct DBF *d, unsigned int i);
typedef int   __stdcall TGetSign     (struct DBF *d, int n);
typedef char*     __stdcall TGetStr      (struct DBF *d, int n);
typedef char*     __stdcall TGetString   (struct DBF *d, int n);
typedef char*     __stdcall TGetTypeName     (struct DBF *d, int n);
typedef int   __stdcall TGetVerCDBFlib   (int i);
typedef char*     __stdcall TGet_FoxPro  (struct DBF *d, int n);
typedef char*     __stdcall TGet_dBase3  (struct DBF *d, int n);
typedef char*     __stdcall TGet_dBase4  (struct DBF *d, int n);
typedef BOOL      __stdcall TInsert      (struct DBF *d, int n, BOOL empty);
typedef BOOL      __stdcall TInverseRecord   (struct DBF *d, int n);
typedef HANDLE    __stdcall TOpen_File   (char* filename);
typedef BOOL      __stdcall TPack        (struct DBF *d, int what);
typedef void      __stdcall TReadAlias   (struct DBF *d);
typedef BOOL      __stdcall TReadByte    (struct DBF *d, unsigned int n);
typedef BOOL      __stdcall TReadField   (struct DBF *d, unsigned int n, int field);
typedef BOOL      __stdcall TReadFields  (struct DBF *d);
typedef BOOL      __stdcall TReadHeader  (struct DBF *d);
typedef BOOL      __stdcall TReadRecord  (struct DBF *d, unsigned int n);
typedef BOOL      __stdcall TRecallRecord    (struct DBF *d, int n);
typedef BOOL      __stdcall TRefreshDatabase (struct DBF *d);
typedef BOOL      __stdcall TSeekField   (struct DBF *d, unsigned int n, int field);
typedef BOOL      __stdcall TSeekMemo    (struct DBF *d, int blocksize, int block);
typedef BOOL      __stdcall TSeekMemoZero    (struct DBF *d);
typedef BOOL      __stdcall TSeekRecord  (struct DBF *d, unsigned int n);
typedef int   __stdcall TSeekValue   (struct DBF *d, int n, char *s, BOOL exact);
typedef void      __stdcall TSetAliasName    (struct DBF *d, char *s);
typedef void      __stdcall TSetBool     (struct DBF *d, int n, BOOL value);
typedef void      __stdcall TSetCurrency     (struct DBF *d, int n, double x);
typedef void      __stdcall TSetDate     (struct DBF *d, int n, int year, int mon, int day);
typedef void      __stdcall TSetDateS    (struct DBF *d, int n, char *s);
typedef void      __stdcall TSetDateSeparator(struct DBF *d, char c);
typedef void      __stdcall TSetDateTime     (struct DBF *d, int n, int year, int mon, int day, int hr, int min, int sec);
typedef void      __stdcall TSetTimeStamp    (struct DBF *d, int n, int year, int mon, int day, int hr, int min, int sec);
typedef void      __stdcall TSetDateTimeI    (struct DBF *d, int n, int t);
typedef void      __stdcall TSetDateTimeS    (struct DBF *d, int n, char *s);
typedef void      __stdcall TSetTimeStampS   (struct DBF *d, int n, char *s);
typedef void      __stdcall TSetDefOptions   (struct DBF *d);
typedef void      __stdcall TSetDouble   (struct DBF *d, int n, double x);
typedef void      __stdcall TSetFloat    (struct DBF *d, int n, double l);
typedef void      __stdcall TSetInt      (struct DBF *d, int n, int x);
typedef void      __stdcall TSetLogical  (struct DBF *d, int n, char c);
typedef BOOL      __stdcall TSetMemo     (struct DBF *d, int n, char *s);
typedef void      __stdcall TSetNumeric  (struct DBF *d, int n, double l);
typedef void      __stdcall TSetString   (struct DBF *d, int n, char *s);
typedef int   __stdcall TSet_FoxPro  (struct DBF *d, char *s);
typedef int   __stdcall TSet_dBase3  (struct DBF *d, char *s);
typedef int   __stdcall TSet_dBase4  (struct DBF *d, char *s);
typedef BOOL      __stdcall TTruncate    (struct DBF *d, int n);
typedef BOOL      __stdcall TValidField  (char   c);
typedef BOOL      __stdcall TValidRecord     (struct DBF *d, char *s);
typedef void      __stdcall TWriteAlias  (struct DBF *d);
typedef BOOL      __stdcall TWriteByte   (struct DBF *d, unsigned int n);
typedef BOOL      __stdcall TWriteField  (struct DBF *d, unsigned int n, int field);
typedef BOOL      __stdcall TWriteHeader     (struct DBF *d);
typedef BOOL      __stdcall TWriteRecord     (struct DBF *d, unsigned int n);
typedef BOOL      __stdcall TZap         (struct DBF *d);
typedef int   __stdcall Tanalizator  (struct DBF *d, char *s);
typedef char      __stdcall Tcnd         (struct DBF *d, char *s);
typedef int   __stdcall TdBase4_BlockSize(struct DBF *d);
typedef void      __stdcall Teval        (struct DBF *d, char  o);
typedef int   __stdcall Tfieldcount  (struct DBF *d);
typedef int   __stdcall Tfieldno     (struct DBF *d, int   i);
typedef BOOL      __stdcall Tif_digit_type   (struct DBF *d, int n);
typedef BOOL      __stdcall Tif_leap_year    (int year);
typedef BOOL      __stdcall Tif_memo_type    (struct DBF *d, int n);
typedef int   __stdcall Tmakecalcstring  (struct DBF *d, char *s, char *z, int *cn);
typedef void      __stdcall Treal_sort   (struct DBF *d, int **tb, FCallBack* fn);
typedef unsigned int      __stdcall Treccount    (struct DBF *d);
typedef int   __stdcall Trecno       (struct DBF *d, int   i);
typedef void      __stdcall Tset_filter  (struct DBF *d, char *s, FCallBack* fn);
typedef void      __stdcall TSetValue    (struct DBF *d, int i, char *s, double b);
typedef double    __stdcall TGetValue    (struct DBF *d, int n);

typedef char      __stdcall TGetFieldType    (struct DBF *d, int n);
typedef int   __stdcall TGetLowLen   (struct DBF *d, int n);
typedef int   __stdcall TGetHighLen  (struct DBF *d, int n);
typedef int   __stdcall TGetAllLen   (struct DBF *d, int n);
typedef char*     __stdcall TGetFieldName    (struct DBF *d, int n);

typedef BOOL      __stdcall Tif_digit_calc   (struct DBF *d, char *name);
typedef BOOL      __stdcall Tif_digit_calci  (struct DBF *d, int i);


typedef void      __stdcall TGetSelectedArea (RECT *r);


#include "simple.h"

//////////////////////////////////////////////////////////

void           __stdcall    InitLibrary(int magicNumber, char *email);

void           __stdcall    Init        (int i);        // internal
int            __stdcall    GetVerCDBFlib   (int i);        // version, datetime compilation, sizeof struct DBF

BOOL           __stdcall    if_leap_year    (int year);     //1-leap, 0-no leap
void           __stdcall    SetDefOptions   (struct DBF *d);    //set default options for file

HANDLE         __stdcall    Open_File   (char* filename);   //0-fail, other-success open .dbf-file
HANDLE         __stdcall    Open_FileRO (char* filename);

void           __stdcall    Close_File  (struct DBF *d);    //close .dbf-file
BOOL           __stdcall    ReadHeader  (struct DBF *d);    //read header (32 bytes)
BOOL           __stdcall    ReadFields  (struct DBF *d);    //read fields, get memory
int            __stdcall    GetMemoType (struct DBF *d);    //detect memo field type
BOOL           __stdcall    ValidField  (char   c);     //TRUE if field is right
BOOL           __stdcall    GetRecord   (struct DBF *d, unsigned int n);
BOOL           __stdcall    ReadRecord  (struct DBF *d, unsigned int n);    //read record #n into record_block
BOOL           __stdcall    SeekRecord  (struct DBF *d, unsigned int n);    //seek to record #n
BOOL           __stdcall    SeekField   (struct DBF *d, unsigned int n, int field); //seek to record #n, field #field
BOOL           __stdcall    WriteRecord (struct DBF *d, unsigned int n);    //write record #n from record_block

void           __stdcall    ResetLastRecord(struct DBF *d);


BOOL           __stdcall    SeekMemo    (struct DBF *d, int blocksize, int block);  //seek to memo info
BOOL           __stdcall    SeekMemoZero    (struct DBF *d);    //internal
void           __stdcall    FreeMemo    (struct DBF *d);    //release memory for memo

int            __stdcall    GetLenField (struct DBF *d, int n);     //return real length of field
int            __stdcall    GetLenView  (struct DBF *d, int n);     //return length of field for view
int            __stdcall    GetLenMax   (struct DBF *d, int n);     //return max value beetween earlier functions
char*          __stdcall    GetTypeName (struct DBF *d, int n);     //type as string

BOOL           __stdcall    if_digit_type   (struct DBF *d, int n);     //TRUE for numeric
BOOL           __stdcall    if_memo_type    (struct DBF *d, int n);     //TRUE for memo
BOOL           __stdcall    if_date_type    (struct DBF *d, int n);     //TRUE for D, T

char*          __stdcall    GetString   (struct DBF *d, int n);     //Character as string
double         __stdcall    GetNumeric  (struct DBF *d, int n);     //Numeric, Float, Memo, General as double
int            __stdcall    GetInt      (struct DBF *d, int n);     //Integer, Memo, General as int
double         __stdcall    GetFloat    (struct DBF *d, int n);     //Numeric   or Float as double
int            __stdcall    GetDateTime (struct DBF *d, int n);     //Date      as integer
int            __stdcall    GetTimeStamp    (struct DBF *d, int n);     //Date      as integer
BOOL           __stdcall    GetBool     (struct DBF *d, int n);     //Logical   as bool
double         __stdcall    GetDouble   (struct DBF *d, int n);     //Double    as double
double         __stdcall    GetInvertedDouble(struct DBF *d, int n);
double         __stdcall    GetCurrency (struct DBF *d, int n);     //Currency  as double
time_t         __stdcall    GetUnixTimeStamp(struct DBF *d, int n);     //DateTime  as struct tm
struct tm      __stdcall    GetStructTM (struct DBF *d, int n);     //DateTime  as struct tm
struct tm      __stdcall    GetTm       (struct DBF *d, int n);
char*          __stdcall    GetStr      (struct DBF *d, int n);     //Any field as string

char*          __stdcall    GetMemo     (struct DBF *d, int n);     //any memo as string
char*          __stdcall    Get_dBase3  (struct DBF *d, int n);     //dbaseIII memo as string, internal
char*          __stdcall    Get_dBase4  (struct DBF *d, int n);     //dbaseIV  memo as string, internal
char*          __stdcall    Get_FoxPro  (struct DBF *d, int n);     //FoxPro   memo as string, internal

char*          __stdcall    GetMemoBuf  (struct DBF *d, int n, int *len);   //any memo as string
char*          __stdcall    Get_dBase4Buf   (struct DBF *d, int n, int *len);   //dbaseIV  memo as string, internal
char*          __stdcall    Get_FoxProBuf   (struct DBF *d, int n, int *len);   //FoxPro   memo as string, internal

char           __stdcall    FieldBlankChar  (struct DBF *d, int n);     //blank char for this field type

////////////////////////////////////////////////////////

void           __stdcall    ClearRecord (struct DBF *d);        //clear record in read/write area (record_block)
void           __stdcall    ClearField  (struct DBF *d, int n);     //clear field in read/write area (record_block)
BOOL           __stdcall    WriteHeader (struct DBF *d);        //write header of .dbf
BOOL           __stdcall    AppendBlank (struct DBF *d, BOOL empty);    //append empty (TRUE) or current (FALSE)

void           __stdcall    SetString   (struct DBF *d, int n, char *s);    //insert string into read/write area
void           __stdcall    SetNumeric  (struct DBF *d, int n, double l);   //insert int into read/write area
void           __stdcall    SetFloat    (struct DBF *d, int n, double l);   //insert int into read/write area
void           __stdcall    SetBool     (struct DBF *d, int n, BOOL value); //insert BOOL into read/write area
void           __stdcall    SetLogical  (struct DBF *d, int n, char c);     //insert BOOL into read/write area

void           __stdcall    SetInt      (struct DBF *d, int n, int x);  //insert integer into read/write area
void           __stdcall    SetDouble   (struct DBF *d, int n, double x);   //insert double into read/write area
void           __stdcall    SetCurrency (struct DBF *d, int n, double x);   //insert currency into read/write area

void           __stdcall    SetDate     (struct DBF *d, int n, int year, int mon, int day); //set date into read/write area
void           __stdcall    SetDateTime (struct DBF *d, int n, int year, int mon, int day, int hr, int min, int sec);   //set datetime into read/write area
void           __stdcall    SetDateTimeI    (struct DBF *d, int n, int t);  //set datetime as integer into read/write area
void           __stdcall    SetTimeStamp    (struct DBF *d, int n, int year, int mon, int day, int hr, int min, int sec);   //set datetime into read/write area

void           __stdcall    SetDateS    (struct DBF *d, int n, char *s);    //set date as string into read/write area
void           __stdcall    SetDateTimeS    (struct DBF *d, int n, char *s);    //set datetime as string into read/write area

BOOL           __stdcall    ReadField   (struct DBF *d, unsigned int n, int field); //read 1 field
BOOL           __stdcall    WriteField  (struct DBF *d, unsigned int n, int field); //write 1 field

BOOL           __stdcall    SetMemo     (struct DBF *d, int n, char *s);    //write memo
int            __stdcall    Set_dBase3  (struct DBF *d, char *s);       //write dbase3 memo, internal
int            __stdcall    Set_dBase4  (struct DBF *d, char *s);       //write dbase4 memo, internal
int            __stdcall    Set_FoxPro  (struct DBF *d, char *s);       //write foxpro memo, internal

BOOL           __stdcall    Truncate    (struct DBF *d, int n);     //truncate database
BOOL           __stdcall    Pack        (struct DBF *d, int what);  //pack database, what= 0-all, 1-dbf, 2-memo
BOOL           __stdcall    Zap     (struct DBF *d);        //zap database

BOOL           __stdcall    DeleteRecord    (struct DBF *d, int n);     //mark record as deleted
BOOL           __stdcall    RecallRecord    (struct DBF *d, int n);     //recall record
BOOL           __stdcall    InverseRecord   (struct DBF *d, int n);     //inverse record

BOOL           __stdcall    WriteByte   (struct DBF *d, unsigned int n);    //write marker of deleting
BOOL           __stdcall    ReadByte    (struct DBF *d, unsigned int n);    //read marker of deleting

BOOL           __stdcall    Delete      (struct DBF *d, int n);         //delete record
BOOL           __stdcall    Insert      (struct DBF *d, int n, BOOL empty); //insert record, if empty=FALSE - duplicate current

int            __stdcall    GetFieldNum (struct DBF *d, char *s);       //get number of field or -1

int            __stdcall    SeekValue   (struct DBF *d, int n, char *s, BOOL exact);    //seek string, if database is sorted

BOOL           __stdcall    CreateDatabase7 (char *filename, struct Field *fld, int n, int _type, int blocksize, BOOL memo, char *driver);
BOOL           __stdcall    CreateDatabase  (char *filename, struct Field *fld, int n, int _type, int blocksize, BOOL memo);    //create new database
BOOL           __stdcall    CreateMemoFile  (char *filename, int _type, int blocksize);         //create new memo-file
void           __stdcall    CreateField (struct Field *fld, char *name, char type, int size);       //create one field

unsigned int   __stdcall    reccount    (struct DBF *d);    //record count
int            __stdcall    fieldcount  (struct DBF *d);    //field count
void           __stdcall    set_filter  (struct DBF *d, char *s, FCallBack* fn);    //set filter
int            __stdcall    recno       (struct DBF *d, int   i);       //real nuber of record
int            __stdcall    fieldno     (struct DBF *d, int   i);       //real number of field

BOOL           __stdcall    ValidRecord (struct DBF *d, char *s);   //check on conformity to the given condition

int            __stdcall    analizator  (struct DBF *d, char *s);   //internal
char           __stdcall    cnd     (struct DBF *d, char *s);   //internal
void           __stdcall    eval        (struct DBF *d, char  o);   //internal

void           __stdcall    GetCompStr  (char *s, char *t, struct DBF *d);  //internal
int            __stdcall    Compare     (const void *a, const void *b, struct DBF *d);  //internal

void           __stdcall    real_sort   (struct DBF *d, int **tb, FCallBack* fn);   //internal

int            __stdcall    dBase4_BlockSize(struct DBF *d);    //internal
int            __stdcall    FoxPro_BlockSize(struct DBF *d);    //internal
int            __stdcall    GetBlockSize    (struct DBF *d);    //get blocksize of current memo

int            __stdcall    makecalcstring  (struct DBF *d, char *s, char *z, int *cn); //internal

void                UpperCase   (unsigned char *s); //internal

int            __stdcall    GetLenHeader    (struct DBF *d, int n); //lenght of field name
char*          __stdcall    GetHeader   (struct DBF *d, int n); //field name

void           __stdcall    DupRecord   (struct DBF *d);    //cut record to copy_of_record
void           __stdcall    DupToRecord (struct DBF *d);    //paste record from copy_of_record

void           __stdcall    ClearSort   (struct DBF *d);    //switch off sorting
void           __stdcall    ClearFilter (struct DBF *d);    //switch off filter

void           __stdcall    ReadAlias   (struct DBF *d);    //read file of headers .hdr
void           __stdcall    WriteAlias  (struct DBF *d);    //write file of headers .hdr
void           __stdcall    SetAliasName    (struct DBF *d, char *s);   //set name of file of headers, NULL - default

double         __stdcall    Evaluate    (char *s, int *att);    //calculate s, att=1 if error found

void           __stdcall    SetDateSeparator(struct DBF *d, char c);    //set date separator
BOOL           __stdcall    RefreshDatabase (struct DBF *d);        //check number of records
unsigned int   __stdcall    GetOrder    (struct DBF *d, unsigned int i);    //real number of record
int            __stdcall    GetSign     (struct DBF *d, int n);     // -1,0,1 for digital fields
char*          __stdcall    DStrTrim    (struct DBF *d, int trim);  //deletes spaces from strings area (struct DBF->str)

void           __stdcall    SetValue    (struct DBF *d, int i, char *s, double b);  //set any value to read/write area (record_block)
double         __stdcall    GetValue    (struct DBF *d, int n);     //get value from any digital field

BOOL           __stdcall    get_fields  (struct DBF *d, char *s, int *sn, int* sv); //internal
struct DBF*    __stdcall    OpenBase    (char *filename);           //open database
struct DBF*    __stdcall    OpenBaseRO  (char *filename);

void           __stdcall    CloseBase   (struct DBF *d);            //close database
BOOL           __stdcall    SortBase    (struct DBF *d, char *s, FCallBack* fn);    //sort database

//char*      __stdcall  cdbfstrtok  (char *string, const char *control);    //internal
void           __stdcall    ClearAllFilter  (struct DBF *d);        //remove filter and clear old filter string

char*          __stdcall    StrEval     (char *s, struct DBF *d);

void           __stdcall    CheckBrackets   (struct DBF *d, char *s);

char           __stdcall    GetFieldType    (struct DBF *d, int n);
int            __stdcall    GetLowLen   (struct DBF *d, int n);
int            __stdcall    GetHighLen  (struct DBF *d, int n);
int            __stdcall    GetAllLen   (struct DBF *d, int n);
char*          __stdcall    GetFieldName    (struct DBF *d, int n);

int*           __stdcall    ExternalFilter  (struct DBF *d, int n);
void           __stdcall    IgnoreCase  (struct DBF *d, char *s, int charset);

int            __stdcall    MakeBakFile (struct DBF* d, BOOL always);
void           __stdcall    MakeExt     (char *newname, char *oldname, char *newext, char *fullname);

int            __stdcall    Set_FoxProBuf   (struct DBF *d, char *s, int len);
int            __stdcall    Set_dBase4Buf   (struct DBF *d, char *s, int len);
int            __stdcall    Set_dBase3Buf   (struct DBF *d, char *s, int len);
BOOL           __stdcall    SetMemoBuf  (struct DBF *d, int n, char *s, int len);

void           __stdcall    SetByte (struct DBF *d, int offset, char b);
char           __stdcall    GetByte (struct DBF *d, int offset);

void           __stdcall    WriteBackLink   (struct DBF *dd, struct DBF *ds);

char*          __stdcall    Get_SMT     (struct DBF *d, int n);
int            __stdcall    SMT_BlockSize   (struct DBF *d);
char*          __stdcall    Get_SMTBuf  (struct DBF *d, int n, int *len);
int            __stdcall    Set_SMT     (struct DBF *d, char *s);
int            __stdcall    Set_SMTBuf  (struct DBF *d, char *s, int len);

char*          __stdcall    FileTypeAsText(struct DBF *d);
char*          __stdcall    FieldTypeAsText(char c);

#ifndef THE_WINDOWS_
void        CharToOemBuff(char *s, char *d, int l);
void        OemToCharBuff(char *s, char *d, int l);
#endif

#ifdef  THE_REXX_
//#undef BOOL
#undef HWND

#undef FILE_BEGIN
#undef FILE_END
#endif

#ifdef __cplusplus
}
#endif


#endif //DBF_H

