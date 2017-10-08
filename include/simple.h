#ifndef  THE_LINUX_
#pragma pack(1)
#endif

//plugin structure

struct	TCDBFPlugin {
	HWND			h;
	struct	DBF		*dbf;
	int			col;
	int			row;
//functions
        TAppendBlank            *AppendBlank;
        TClearField             *ClearField;
        TClearFilter            *ClearFilter;
        TClearRecord            *ClearRecord;
        TClearSort              *ClearSort;
        TClose_File             *Close_File;
        TCreateDatabase         *CreateDatabase;
        TCreateField            *CreateField;
        TCreateMemoFile         *CreateMemoFile;
        TDStrTrim               *DStrTrim;
        TDelete                 *Delete;
        TDeleteRecord           *DeleteRecord;
        TDupRecord              *DupRecord;
        TDupToRecord            *DupToRecord;
        TEvaluate               *Evaluate;
        TFieldBlankChar         *FieldBlankChar;
        TFoxPro_BlockSize       *FoxPro_BlockSize;
        TFreeMemo               *FreeMemo;
        TGetBlockSize           *GetBlockSize;
        TGetBool                *GetBool;
        TGetCurrency            *GetCurrency;
        TGetDateTime            *GetDateTime;
        TGetDouble              *GetDouble;
        TGetFieldNum            *GetFieldNum;
        TGetFloat               *GetFloat;
        TGetHeader              *GetHeader;
        TGetInt                 *GetInt;
        TGetLenField            *GetLenField;
        TGetLenHeader           *GetLenHeader;
        TGetLenMax              *GetLenMax;
        TGetLenView             *GetLenView;
        TGetMemo                *GetMemo;
        TGetMemoType            *GetMemoType;
        TGetNumeric             *GetNumeric;
        TGetOrder               *GetOrder;
        TGetSign                *GetSign;
        TGetStr                 *GetStr;
        TGetString              *GetString;
        TGetTypeName            *GetTypeName;
        TGetVerCDBFlib          *GetVerCDBFlib;
        TGet_FoxPro             *Get_FoxPro;
        TGet_dBase3             *Get_dBase3;
        TGet_dBase4             *Get_dBase4;
        TInsert                 *Insert;
        TInverseRecord          *InverseRecord;
        TOpen_File              *Open_File;
        TPack                   *Pack;
        TReadAlias              *ReadAlias;
        TReadByte               *ReadByte;
        TReadField              *ReadField;
        TReadFields             *ReadFields;
        TReadHeader             *ReadHeader;
        TReadRecord             *ReadRecord;
        TRecallRecord           *RecallRecord;
        TRefreshDatabase        *RefreshDatabase;
        TSeekField              *SeekField;
        TSeekMemo               *SeekMemo;
        TSeekMemoZero           *SeekMemoZero;
        TSeekRecord             *SeekRecord;
        TSeekValue              *SeekValue;
        TSetAliasName           *SetAliasName;
        TSetBool                *SetBool;
        TSetCurrency            *SetCurrency;
        TSetDate                *SetDate;
        TSetDateS               *SetDateS;
        TSetDateSeparator       *SetDateSeparator;
        TSetDateTime            *SetDateTime;
        TSetDateTimeI           *SetDateTimeI;
        TSetDateTimeS           *SetDateTimeS;
        TSetDefOptions          *SetDefOptions;
        TSetDouble              *SetDouble;
        TSetFloat               *SetFloat;
        TSetInt                 *SetInt;
        TSetLogical             *SetLogical;
        TSetMemo                *SetMemo;
        TSetNumeric             *SetNumeric;
        TSetString              *SetString;
        TSet_FoxPro             *Set_FoxPro;
        TSet_dBase3             *Set_dBase3;
        TSet_dBase4             *Set_dBase4;
        TTruncate               *Truncate;
        TValidField             *ValidField;
        TValidRecord            *ValidRecord;
        TWriteAlias             *WriteAlias;
        TWriteByte              *WriteByte;
        TWriteField             *WriteField;
        TWriteHeader            *WriteHeader;
        TWriteRecord            *WriteRecord;
        TZap                    *Zap;
        Tanalizator             *analizator;
        Tcnd                    *cnd;
        TdBase4_BlockSize       *dBase4_BlockSize;
        Teval                   *eval;
        Tfieldcount             *fieldcount;
        Tfieldno                *fieldno;
        Tif_digit_type          *if_digit_type;
        Tif_leap_year           *if_leap_year;
        Tif_memo_type           *if_memo_type;
        Tmakecalcstring         *makecalcstring;
        Treal_sort              *real_sort;
        Treccount               *reccount;
        Trecno                  *recno;
        Tset_filter             *set_filter;
//0.3
	TSetValue		*SetValue;
	TGetValue		*GetValue;
//0.5
	TGetFieldType		*GetFieldType;
	TGetLowLen		*GetLowLen;
	TGetHighLen		*GetHighLen;
	TGetAllLen		*GetAllLen;
	TGetFieldName		*GetFieldName;
//1.07
	TGetSelectedArea	*GetSelectedArea;
        };

#ifndef  THE_LINUX_
#pragma pack()
#endif


//Plugins return code
#define	PLUGIN_ERROR	0
#define	PLUGIN_OK	1
#define	PLUGIN_REPAINT	2
#define	PLUGIN_REFRESH	3

//Plugins functions
typedef	char*	__stdcall	TPluginGetName	(char *s);
typedef int	__stdcall	TPluginSimple	(struct TCDBFPlugin *plg);

