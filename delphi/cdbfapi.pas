unit cdbfapi;

interface

uses
  windows;

type
  Header = packed record
    id            : byte;
    last_year     : byte;
    last_month    : byte;
    last_day      : byte;
    num_rec       : dword;
    offset_first  : word;
    rec_len       : word;
    reserve       : array[0..15] of char;
    cdx           : byte;
    codepage      : byte;
    reserve2      : array[0..1] of char;
    level7        : array[0..35] of char;
  end;

  {DBT file header - dBase IV }
  Header_8b = packed record
    last_block    : dword;
    reserve       : array[0..13] of char;
    id            : word;
    blocksize     : word;
  end;

  {DBT file header before memo info }
  Data_8b = packed record
    id            : dword;
    size          : dword;
  end;

  {FPT file header - FoxPro }
  Header_f5 = packed record
    last_4        : byte;
    last_3        : byte;
    last_2        : byte;
    last_1        : byte;
    reserve       : smallint;
    blocksize_2   : byte;
    blocksize_1   : byte;
  end;

  {FPT file header before memo info }
  Data_f5 = packed record
    id            : dword;
    size_4        : byte;
    size_3        : byte;
    size_2        : byte;
    size_1        : byte;
  end;

  int_char = packed record
    case longint of
      0: ( len    : word );
      1: ( l      : array[0..1] of byte );
  end;

  {field description }
  PField = ^Field;
  Field = packed record
    name          : array[0..31] of char;
    ttype         : char;
    length        : int_char;
    offset        : word;
    mdx           : char;
    reserve       : array[0..1] of char;
    autoincrement : integer;
    reserve2      : array[0..1] of byte;
    workarea      : byte;
    reserve3      : byte;
  end;

  {field description all except level 7}
  P_Field = ^_Field;
  _Field = packed record
    name          : array[0..10] of char;
    ttype         : char;
    offset        : word;
    reserve       : array[0..1] of char;
    length        : int_char;
    reserve2      : array[0..1] of byte;
    workarea      : byte;
    reserve3      : array[0..10] of byte;
  end;

  POneColumn = ^TOneColumn;
  TOneColumn = packed record
    visible    :integer;
    readonly   :integer;
    calculated :integer;

    name       :PChar;
    calcstring :PChar;
  end;

  PColSetup = ^TColSetup;
  TColSetup = packed record
    showtotal     :integer;
    calctotal     :integer;
    fixedcols     :integer;
    reserve       :array[0..12] of integer;

    Columns       :array[0..2047] of TOneColumn;
  end;

  Txlat            = procedure( s1: Pchar; s2 :PChar; l :integer);   far stdcall;

  Options = packed record
    dt_type       : longint;      {0-as_is, 1-dmy, 2-mdy, 3-ymd }
    memo_view     : longint;      {0-state, 1-as_is }
    memo_blocksize: longint;      {default block size for dbase4, foxpro }
    charset       : longint;      {0-OEM, 1-Ansi }
    memo_charset  : longint;      {0-OEM, 1-Ansi }
    ignore_case   : BOOL;     {0-no, 1-ignore }
    descending    : BOOL;     {0-false, 1=true }

    viewtype      : longint;      {0-browse 1-fields }
    alias         : longint;      {0-none 1-alias }
    trimspace     : longint;      {0-none 1-left, 2-right 3-all }
    nodeleted     : longint;      {do not show deleted records }
    cur_rec       : dword;        {last number go record }

    start_field   : integer;
    start_record  : integer;
    search_field  : integer;

    reverse       : integer;    //1-reverse view
    locked    : integer;    //1-locked

    bak_files     : integer;    //0-none, 1-create
    bak_already   : integer;    //1- .bak file already has been created
    filename_bak  : PChar;  //name of .bak file
    brackets      : integer;    //1-do not use brackets in the filter's expression.
    real_value    : integer;    //1=show real value for 'N','F' in GetStr

    reserve       : array[0..19] of integer;

    hdr_charset   : longint;      {0-OEM, 1-Ansi }
    description   : PChar;

    normal_case   : PChar;
    upper_case    : PChar;
    lower_case    : PChar;

    ansi_case     : PChar;
    oem_case      : PChar;

    UserOemToChar : TXlat;
    UserCharToOem : TXlat;
    UserUpper     : Pointer;
    FCallBack     : Pointer;

  end;


  FilterVar = packed record
        v     : array[0..1023] of char;          //result string
        c     : array[0..1023] of char;          //temporary simple condition
        t         : array[0..1023] of integer;       //offset's of |&
        vr        : integer;                     //offset in result string
        left      : array[0..1023] of char;          //left operand
        right     : array[0..1023] of char;          //right operand
  end;

  tm = packed record
        tm_sec: Integer;     // seconds after the minute - [0,59]
        tm_min: Integer;     // minutes after the hour - [0,59]
        tm_hour: Integer;    // hours since midnight - [0,23]
        tm_mday: Integer;    // day of the month - [1,31]
        tm_mon: Integer;     // months since January - [0,11]
        tm_year: Integer;    // years since 1900
        tm_wday: Integer;    // days since Sunday - [0,6]
        tm_yday: Integer;    // days since January 1 - [0,365]
        tm_isdst: Integer;   // daylight savings time flag
  end;

  PDBF = ^DBF;

//functions reference
      TAppendBlank     = function ( d: PDBF; empty: BOOL ): BOOL;  stdcall;
      TClearField      = procedure( d: PDBF; n: longint );          stdcall;
      TClearFilter     = procedure( d: PDBF);           stdcall;
      TClearRecord     = procedure( d: PDBF );                     stdcall;
      TClearSort       = procedure( d: PDBF);             stdcall;
      TClose_File      = procedure( d: PDBF );                    stdcall;
      TCreateDatabase  = function ( filename: PChar; fld: PField; n: integer; _type: integer; blocksize: integer; memo: BOOL): BOOL;       stdcall;
      TCreateField     = procedure( d: PField; name: PChar; _type: char; size: integer);      stdcall;
      TCreateMemoFile  = function ( filename: PChar; _type: integer; blocksize: integer): BOOL;    stdcall;
      TDStrTrim        = function ( d: PDBF; i: integer): PChar;       stdcall;
      TDelete          = function ( d: PDBF;  n: longint): BOOL;  stdcall;
      TDeleteRecord    = function ( d: PDBF;  n: longint): BOOL;    stdcall;
      TDupRecord       = procedure( d: PDBF);             stdcall;
      TDupToRecord     = procedure( d: PDBF);           stdcall;
      TEvaluate        = function ( s: PChar; var err): double;  stdcall;
      TFieldBlankChar  = function ( d: PDBF; n: longint ): char; stdcall;
      TFoxPro_BlockSize= function ( d: PDBF): integer;   stdcall;
      TFreeMemo        = procedure( d: PDBF );                        stdcall;
      TGetBlockSize    = function ( d: PDBF): integer;       stdcall;
      TGetBool         = function ( d: PDBF; n: longint ): BOOL;       stdcall;
      TGetCurrency     = function ( d: PDBF; n: longint ): double; stdcall;
      TGetDateTime     = function ( d: PDBF; n: longint ): longint; stdcall;
      TGetDouble       = function ( d: PDBF; n: longint ): double;   stdcall;
      TGetFieldNum     = function ( d: PDBF; s: PChar): integer;     stdcall;
      TGetFloat        = function ( d: PDBF; n: longint ): double;    stdcall;
      TGetHeader       = function ( d: PDBF; n: integer): PChar;        stdcall;
      TGetInt          = function ( d: PDBF; n: longint ): longint;     stdcall;
      TGetLenField     = function ( d: PDBF; n: longint ): longint; stdcall;
      TGetLenHeader    = function ( d: PDBF; n: integer): integer;   stdcall;
      TGetLenMax       = function ( d: PDBF; n: longint ): longint;  stdcall;
      TGetLenView      = function ( d: PDBF; n: longint ): longint; stdcall;
      TGetMemo         = function ( d: PDBF; n: longint ): Pchar;      stdcall;
      TGetMemoBuf      = function ( d: PDBF; n: longint; var len :longint): Pchar;      stdcall;
      TGetMemoType     = function ( d: PDBF ): integer;            stdcall;
      TGetNumeric      = function ( d: PDBF; n: longint ): double; stdcall;
      TGetOrder        = function ( d: PDBF; i: integer): integer;       stdcall;
      TGetSign         = function ( d: PDBF; i: integer): integer;        stdcall;
      TGetStr          = function ( d: PDBF; n: longint ): Pchar;       stdcall;
      TGetString       = function ( d: PDBF; n: longint ): Pchar;    stdcall;
      TGetTypeName     = function ( d: PDBF; n: longint ): Pchar;  stdcall;
      TGetVerCDBFlib   = function ( i: integer ): integer;        stdcall;
      TGet_FoxPro      = function ( d: PDBF; n: longint ): Pchar;   stdcall;
      TGet_dBase3      = function ( d: PDBF; n: longint ): Pchar;   stdcall;
      TGet_dBase4      = function ( d: PDBF; n: longint ): Pchar;   stdcall;
      TInsert          = function ( d: PDBF;  n: longint; empty: boolean): BOOL;  stdcall;
      TInverseRecord   = function ( d: PDBF;  n: longint): BOOL;   stdcall;
      TOpen_File       = function ( filename: Pchar ): integer;   stdcall;
      TPack            = function ( d: PDBF; what: integer): BOOL;      stdcall;
      TReadAlias       = procedure( d: PDBF);             stdcall;
      TReadByte        = function ( d: PDBF;  n: longint): BOOL;        stdcall;
      TReadField       = function ( d: PDBF; n: dword; field: longint ): BOOL; stdcall;
      TReadFields      = function ( d: PDBF ): BOOL;                stdcall;
      TReadHeader      = function ( d: PDBF ): BOOL;              stdcall;
      TReadRecord      = function ( d: PDBF; n: dword ): BOOL;      stdcall;
      TRecallRecord    = function ( d: PDBF;  n: longint): BOOL;    stdcall;
      TRefreshDatabase = function ( d: PDBF): BOOL;         stdcall;
      TSeekField       = function ( d: PDBF; n: dword; field: longint ): BOOL; stdcall;
      TSeekMemo        = function ( d: PDBF; blocksize: longint; block: longint ): BOOL; stdcall;
      TSeekMemoZero    = function ( d: PDBF): BOOL;               stdcall;
      TSeekRecord      = function ( d: PDBF; n: dword ): BOOL;      stdcall;
      TSeekValue       = function ( d: PDBF; n: longint; s: Pchar; exact: BOOL): integer;      stdcall;
      TSetAliasName    = procedure( d: PDBF; s: PChar);      stdcall;
      TSetBool         = procedure( d: PDBF; n: longint; value: BOOL ); stdcall;
      TSetCurrency     = procedure( d: PDBF; n: longint; x: double ); stdcall;
      TSetDate         = procedure( d: PDBF; n: longint; year: longint; mon: longint; day: longint ); stdcall;
      TSetDateS        = procedure( d: PDBF; n: longint; s: Pchar ); stdcall;
      TSetDateSeparator= procedure( d: PDBF; c: char);      stdcall;
      TSetDateTime     = procedure( d: PDBF; n: longint; year: longint; mon: longint; day: longint; hr: longint; min: longint; sec: longint ); stdcall;
      TSetDateTimeI    = procedure( d: PDBF; n: longint; t: longint ); stdcall;
      TSetDateTimeS    = procedure( d: PDBF; n: longint; s: Pchar ); stdcall;
      TSetDefOptions   = procedure( d: PDBF );                    stdcall;
      TSetDouble       = procedure( d: PDBF; n: longint; x: double ); stdcall;
      TSetInvertedDouble=procedure( d: PDBF; n: longint; x: double ); stdcall;
      TSetFloat        = procedure( d: PDBF; n: longint; l: double ); stdcall;
      TSetInt          = procedure( d: PDBF; n: longint; x: longint );  stdcall;
      TSetLogical      = procedure( d: PDBF; n: longint; c: char ); stdcall;
      TSetMemo         = function ( d: PDBF; n: longint; s: PChar): BOOL;        stdcall;
      TSetNumeric      = procedure( d: PDBF; n: longint; l: double ); stdcall;
      TSetString       = procedure( d: PDBF; n: longint; s: Pchar ); stdcall;
      TSet_FoxPro      = function ( d: PDBF; s: PChar): longint;              stdcall;
      TSet_dBase3      = function ( d: PDBF; s: PChar): longint;              stdcall;
      TSet_dBase4      = function ( d: PDBF; s: PChar): longint;              stdcall;
      TTruncate        = function ( d: PDBF;  n: longint): BOOL;        stdcall;
      TValidField      = function ( c: char ): BOOL;                stdcall;
      TValidRecord     = function ( d: PDBF; s: PChar): BOOL; stdcall;
      TWriteAlias      = procedure( d: PDBF);            stdcall;
      TWriteByte       = function ( d: PDBF; n: longint): BOOL;        stdcall;
      TWriteField      = function ( d: PDBF; n: dword; field: longint ): BOOL; stdcall;
      TWriteHeader     = function ( d: PDBF ): BOOL;               stdcall;
      TWriteRecord     = function ( d: PDBF; n: dword ): BOOL;     stdcall;
      TZap             = function ( d: PDBF): BOOL;       stdcall;
      Tanalizator      = function ( d: PDBF; s: PChar): BOOL;  stdcall;
      Tcnd             = function ( d: PDBF; s: PChar): PChar;  stdcall;
      TdBase4_BlockSize= function ( d: PDBF): integer;   stdcall;
      Teval            = procedure( d: PDBF; o: char);  stdcall;
      Tfieldcount      = function ( d: PDBF): integer; stdcall;
      Tfieldno         = function ( d: PDBF; i: integer): integer;        stdcall;
      Tif_digit_type   = function ( d: PDBF; n: longint): BOOL;     stdcall;
      Tif_leap_year    = function ( year: longint ): BOOL;        stdcall;
      Tif_memo_type    = function ( d: PDBF; n: longint): BOOL;     stdcall;
      Tmakecalcstring  = function ( d: PDBF; s: PChar; z: PChar; cn: Pointer): integer;  stdcall;
      Treal_sort       = procedure( d: PDBF; tb: Pointer; fn: Pointer); stdcall;
      Treccount        = function ( d: PDBF): integer;   stdcall;
      Trecno           = function ( d: PDBF; i: integer): integer;  stdcall;
      Tset_filter      = procedure( d: PDBF; s: PChar; fn: Pointer);   stdcall;
      TSetValue        = procedure( d: PDBF; i: integer; s: PChar; b: double);   stdcall;
      TGetValue        = function ( d: PDBF; n: integer): double;   stdcall;

      TGetFieldType    = function ( d: PDBF; n: integer): char;   stdcall;
      TGetLowLen       = function ( d: PDBF; n: integer): integer;   stdcall;
      TGetHighLen      = function ( d: PDBF; n: integer): integer;   stdcall;
      TGetAllLen       = function ( d: PDBF; n: integer): integer;   stdcall;
      TGetFieldName    = function ( d: PDBF; n: integer): Pchar;   stdcall;

      Tif_digit_calc   = function ( d: PDBF; s: PChar): BOOL;     stdcall;
      Tif_digit_calcI  = function ( d: PDBF; n: longint): BOOL;     stdcall;

      TPreparePassword = function ( d: PDBF; s: PChar): BOOL;     stdcall;
      TRemovePassword  = procedure( d: PDBF);     stdcall;

      TAfterRead       = function ( d: PDBF): integer;     stdcall;
      TBeforeWrite     = function ( d: PDBF): integer;     stdcall;
      TAfterReadField  = function ( d: PDBF; n: integer): integer;     stdcall;
      TBeforeWriteField= function ( d: PDBF; n: integer): integer;     stdcall;
      TAfterReadOneByte   = function ( d: PDBF): integer;     stdcall;
      TBeforeWriteOneByte = function ( d: PDBF): integer;     stdcall;
      TGetSelectedArea  = procedure (var r :TRect);     stdcall;


//  PDBF = ^DBF;
  DBF = packed record
    h             : integer;                                  {handle of .dbf }
    h_memo        : integer;                                  {handle of .fpt, .dbt }
    errors        : longint;
    filename      : Pchar;                                    {name of .dbf-file }
    filename_memo : Pchar;                                    {name of .dbt or .fpt file }
    filename_hdr  : Pchar;                                    {name of .hdr file }
    hdr           : Header;                                   {header of .dbf-file }
    fld           : array[0..2047] of Field;                  {fields of .dbf-file }
    als           : array[0..2047] of array[0..31] of char;   {aliases from .hdr file }
    Fieldorder    : array[0..2047] of longint;                {drawing order }
    opt           : Options;                                  {view options }
    num_fld       : word;                                     {fields count }
    current_row   : longint;                                  {current row in the .dbf-file }
    current_field : longint;                                  {current field in the .dbf-file }
    memo_field    : longint;                                  {current memo-field in the .dbf-file }
    one_byte      : char;                                     {for delete/recall operations}
    record_block  : Pchar;                                    {memory for read/write records }
    str           : Pchar;                                    {memory for field extract }
    memo_block    : Pchar;                                    {memory for memo-editor }

    filter    : Pointer;                      {array of filtered records }
    num_filter    : integer;                          {count of filtered records }
    filvar    : ^FilterVar;                   {pointer to filter structure}

    order_num     : integer;
    order_var     : array[0..19] of integer;
    order     : Pointer;

    work_num      : integer;
    work_var      : Pointer;

    group_line    : array[0..254] of char;                    {defined group }
    copy_of_record: Pchar;                                    {memory for field extract }
    filter_str    : Pointer;                                  {������� ������� }

    s1,
    s2            : PChar;                                     {tmp pointers for sort }
    sa, sb        : integer;

    type_n        : BOOL;

    d_fmt         : array[0..4] of PChar;
    t_fmt         : array[0..4] of PChar;

    PCol          : PColSetup;

    level7        : integer;        //0 - usual DBF file, 1 - level 7 DBF file
    hdr_length    : integer;        //size of header
    fld_length    : integer;        //size of field

    excel_compatible :integer;  //Character fields less than 256 symbols
    last_record   :integer;    //last read record in GetRecord

    readonly      :integer;   //readonly. disallow editing
    has_changes   :integer;  //was editing
    

    reserve       : array[0..19] of integer;


    rc_key        : Pointer;            //key for encode/decode
    AR            : TAfterRead;         //function after read record    ;1.06
    BW            : TBeforeWrite;       //function before write record  ;1.06
    ARF           : TAfterReadField;    //function after read field     ;1.06
    BWF           : TBeforeWriteField;  //function after read field     ;1.06
    AR1           : TAfterReadOneByte;  //function after read field     ;1.06
    BW1           : TBeforeWriteOneByte;//function after read field     ;1.06

end;



    PCDBFPlugin = ^TCDBFPlugin;
    TCDBFPlugin = packed record
      hwnd                : HWND;
      dbf                 : PDBF;
      col                 : integer;
      row                 : integer;

      AppendBlank         : TAppendBlank;
      ClearField          : TClearField;
      ClearFilter         : TClearFilter;
      ClearRecord         : TClearRecord;
      ClearSort           : TClearSort;
      Close_File          : TClose_File;
      CreateDatabase      : TCreateDatabase;
      CreateField         : TCreateField;
      CreateMemoFile      : TCreateMemoFile;
      DStrTrim            : TDStrTrim;
      Delete              : TDelete;
      DeleteRecord        : TDeleteRecord;
      DupRecord           : TDupRecord;
      DupToRecord         : TDupToRecord;
      Evaluate            : TEvaluate;
      FieldBlankChar      : TFieldBlankChar;
      FoxPro_BlockSize    : TFoxPro_BlockSize;
      FreeMemo            : TFreeMemo;
      GetBlockSize        : TGetBlockSize;
      GetBool             : TGetBool;
      GetCurrency         : TGetCurrency;
      GetDateTime         : TGetDateTime;
      GetDouble           : TGetDouble;
      GetFieldNum         : TGetFieldNum;
      GetFloat            : TGetFloat;
      GetHeader           : TGetHeader;
      GetInt              : TGetInt;
      GetLenField         : TGetLenField;
      GetLenHeader        : TGetLenHeader;
      GetLenMax           : TGetLenMax;
      GetLenView          : TGetLenView;
      GetMemo             : TGetMemo;
      GetMemoType         : TGetMemoType;
      GetNumeric          : TGetNumeric;
      GetOrder            : TGetOrder;
      GetSign             : TGetSign;
      GetStr              : TGetStr;
      GetString           : TGetString;
      GetTypeName         : TGetTypeName;
      GetVerCDBFlib       : TGetVerCDBFlib;
      Get_FoxPro          : TGet_FoxPro;
      Get_dBase3          : TGet_dBase3;
      Get_dBase4          : TGet_dBase4;
      Insert              : TInsert;
      InverseRecord       : TInverseRecord;
      Open_File           : TOpen_File;
      Pack                : TPack;
      ReadAlias           : TReadAlias;
      ReadByte            : TReadByte;
      ReadField           : TReadField;
      ReadFields          : TReadFields;
      ReadHeader          : TReadHeader;
      ReadRecord          : TReadRecord;
      RecallRecord        : TRecallRecord;
      RefreshDatabase     : TRefreshDatabase;
      SeekField           : TSeekField;
      SeekMemo            : TSeekMemo;
      SeekMemoZero        : TSeekMemoZero;
      SeekRecord          : TSeekRecord;
      SeekValue           : TSeekValue;
      SetAliasName        : TSetAliasName;
      SetBool             : TSetBool;
      SetCurrency         : TSetCurrency;
      SetDate             : TSetDate;
      SetDateS            : TSetDateS;
      SetDateSeparator    : TSetDateSeparator;
      SetDateTime         : TSetDateTime;
      SetDateTimeI        : TSetDateTimeI;
      SetDateTimeS        : TSetDateTimeS;
      SetDefOptions       : TSetDefOptions;
      SetDouble           : TSetDouble;
      SetFloat            : TSetFloat;
      SetInt              : TSetInt;
      SetLogical          : TSetLogical;
      SetMemo             : TSetMemo;
      SetNumeric          : TSetNumeric;
      SetString           : TSetString;
      Set_FoxPro          : TSet_FoxPro;
      Set_dBase3          : TSet_dBase3;
      Set_dBase4          : TSet_dBase4;
      Truncate            : TTruncate;
      ValidField          : TValidField;
      ValidRecord         : TValidRecord;
      WriteAlias          : TWriteAlias;
      WriteByte           : TWriteByte;
      WriteField          : TWriteField;
      WriteHeader         : TWriteHeader;
      WriteRecord         : TWriteRecord;
      Zap                 : TZap;
      analizator          : Tanalizator;
      cnd                 : Tcnd;
      dBase4_BlockSize    : TdBase4_BlockSize;
      eval                : Teval;
      fieldcount          : Tfieldcount;
      fieldno             : Tfieldno;
      if_digit_type       : Tif_digit_type;
      if_leap_year        : Tif_leap_year;
      if_memo_type        : Tif_memo_type;
      makecalcstring      : Tmakecalcstring;
      real_sort           : Treal_sort;
      reccount            : Treccount;
      recno               : Trecno;
      set_filter          : Tset_filter;
//0.3
      SetValue            : TSetValue;
      GetValue            : TGetValue;
//0.5
      GetFieldType        : TGetFieldType;
      GetLowLen           : TGetLowLen;
      GetHighLen          : TGetHighLen;
      GetAllLen           : TGetAllLen;
      GetFieldName        : TGetFieldName;
//1.07
      GetSelectedArea     : TGetSelectedArea;

    end;

    PExportPlugin = ^TExportPlugin;
    TExportPlugin = packed record
        hwnd                    : HWND;
        dbf                     : PDBF;
        filename                : PChar;    //output filename

        out_h                   : Pointer;  //Handle of output filename, if text format
        out_dbf                 : PDBF;       //Handle of output filename, if dbf  format
        ole                     : OleVariant; //Ole object
//options
        memo_text               : integer;
        mark_del                : integer;
        line_num                : integer;
        sum_columns             : integer;
        comment                 : PChar;
        oem                     : integer;
         
        reserve                 : array[0..23] of integer;
        ini_file                : PChar;
        lnum                    : integer;
//functions
        ClearField              : TClearField;
        ClearRecord             : TClearRecord;
        Close_File              : TClose_File;
        CreateDatabase          : TCreateDatabase;
        CreateField             : TCreateField;
        CreateMemoFile          : TCreateMemoFile;
        DStrTrim                : TDStrTrim;
        Evaluate                : TEvaluate;
        FreeMemo                : TFreeMemo;
        GetBlockSize            : TGetBlockSize;
        GetBool                 : TGetBool;
        GetCurrency             : TGetCurrency;
        GetDateTime             : TGetDateTime;
        GetDouble               : TGetDouble;
        GetFieldNum             : TGetFieldNum;
        GetFloat                : TGetFloat;
        GetHeader               : TGetHeader;
        GetInt                  : TGetInt;
        GetLenField             : TGetLenField;
        GetLenHeader            : TGetLenHeader;
        GetLenMax               : TGetLenMax;
        GetLenView              : TGetLenView;
        GetMemo                 : TGetMemo;
        GetMemoType             : TGetMemoType;
        GetNumeric              : TGetNumeric;
        GetSign                 : TGetSign;
        GetStr                  : TGetStr;
        GetString               : TGetString;
        GetTypeName             : TGetTypeName;
        GetVerCDBFlib           : TGetVerCDBFlib;
        Open_File               : TOpen_File;
        ReadFields              : TReadFields;
        ReadHeader              : TReadHeader;
        SetAliasName            : TSetAliasName;
        SetBool                 : TSetBool;
        SetCurrency             : TSetCurrency;
        SetDate                 : TSetDate;
        SetDateS                : TSetDateS;
        SetDateTime             : TSetDateTime;
        SetDateTimeI            : TSetDateTimeI;
        SetDateTimeS            : TSetDateTimeS;
        SetDefOptions           : TSetDefOptions;
        SetDouble               : TSetDouble;
        SetFloat                : TSetFloat;
        SetInt                  : TSetInt;
        SetLogical              : TSetLogical;
        SetMemo                 : TSetMemo;
        SetNumeric              : TSetNumeric;
        SetString               : TSetString;
        WriteAlias              : TWriteAlias;
        WriteHeader             : TWriteHeader;
        WriteRecord             : TWriteRecord;
        fieldcount              : Tfieldcount;
        fieldno                 : Tfieldno;
        if_digit_type           : Tif_digit_type;
        if_memo_type            : Tif_memo_type;
        reccount                : Treccount;
        recno                   : Trecno;
        SetValue                : TSetValue;
        GetValue                : TGetValue;
        AppendBlank             : TAppendBlank;
//0.5
        GetFieldType            : TGetFieldType;
        GetLowLen               : TGetLowLen;
        GetHighLen              : TGetHighLen;
        GetAllLen               : TGetAllLen;
        GetFieldName            : TGetFieldName;
        if_digit_calc       : Tif_digit_calc;
        if_digit_calcI      : Tif_digit_calcI;
        end;



//TPluginAction  = function(h :HWND; dbf :PDBF; row :integer; col :integer): integer stdcall;

TGetNamePlugin = function(s: Pchar): PChar; stdcall;
TSimplePlugin  = function(plg :PCDBFPlugin): integer; stdcall;
TOutputPlugin  = function(plg :PExportPlugin): BOOL; stdcall;


const
       PLUGIN_ERROR = 0;
       PLUGIN_OK    = 1;
       PLUGIN_REPAINT   = 2;
       PLUGIN_REFRESH   = 3;



//////////////////////////////////////////////////////////////////////////////

procedure InitLibrary(magicNumber: Integer; email: PChar); stdcall; external 'cdbfapi.dll'
procedure Init(i :integer);         stdcall; external 'cdbfapi.dll';
function  GetVerCDBFlib(i :integer): integer;         stdcall; external 'cdbfapi.dll';

        {1-leap, 0-no leap }
function  if_leap_year( year: longint ): BOOL;        stdcall; external 'cdbfapi.dll';
        {set default options for view }
procedure SetDefOptions( d: PDBF );                   stdcall; external 'cdbfapi.dll';
        {0-fail, other-success open .dbf-file }
function  Open_File( filename: Pchar ): integer;      stdcall; external 'cdbfapi.dll';
        {close .dbf-file }
procedure Close_File( d: PDBF );                      stdcall; external 'cdbfapi.dll';
        {read header (32 bytes) }
function  ReadHeader( d: PDBF ): BOOL;                stdcall; external 'cdbfapi.dll';
        {read fields, get memory }
function  ReadFields( d: PDBF ): BOOL;                stdcall; external 'cdbfapi.dll';
        {detect memo field type }
function  GetMemoType( d: PDBF ): integer;            stdcall; external 'cdbfapi.dll';
        {TRUE if field is right }
function  ValidField( c: char ): BOOL;                stdcall; external 'cdbfapi.dll';
        {read record #n into record_block }
function  GetRecord( d: PDBF; n: dword ): BOOL;      stdcall; external 'cdbfapi.dll';
        {read record #n into record_block }
function  ReadRecord( d: PDBF; n: dword ): BOOL;      stdcall; external 'cdbfapi.dll';
        {seek to record #n }
function  SeekRecord( d: PDBF; n: dword ): BOOL;      stdcall; external 'cdbfapi.dll';
        {seek to record #n, field #field }
function  SeekField( d: PDBF; n: dword; field: longint ): BOOL; stdcall; external 'cdbfapi.dll';
        {write record #n from record_block }
function  WriteRecord( d: PDBF; n: dword ): BOOL;     stdcall; external 'cdbfapi.dll';
        {seek to memo info }
function  SeekMemo( d: PDBF; blocksize: longint; block: longint ): BOOL; stdcall; external 'cdbfapi.dll';
        {seek to start memo file}
function  SeekMemoZero( d: PDBF): BOOL;               stdcall; external 'cdbfapi.dll';
        {close memo file and release memory for memo }
procedure FreeMemo( d: PDBF );                        stdcall; external 'cdbfapi.dll';
        {return real length of field }
function  GetLenField( d: PDBF; n: longint ): longint; stdcall; external 'cdbfapi.dll';
        {return length of field for view }
function  GetLenView( d: PDBF; n: longint ): longint; stdcall; external 'cdbfapi.dll';
        {return max value beetween earlier functions }
function  GetLenMax( d: PDBF; n: longint ): longint;  stdcall; external 'cdbfapi.dll';
        {string value of type }
function  GetTypeName( d: PDBF; n: longint ): Pchar;  stdcall; external 'cdbfapi.dll';
        {TRUE for numeric }
function  if_digit_type( d: PDBF; n: longint): BOOL;     stdcall; external 'cdbfapi.dll';
        {TRUE for memo }
function  if_memo_type( d: PDBF; n: longint): BOOL;     stdcall; external 'cdbfapi.dll';
        {TRUE for D,T }
function  if_date_type( d: PDBF; n: longint): BOOL;     stdcall; external 'cdbfapi.dll';
        {Character as string }
function  GetString( d: PDBF; n: longint ): Pchar;    stdcall; external 'cdbfapi.dll';
        {Numeric, Float, Memo, General as long }
function  GetNumeric( d: PDBF; n: longint ): double; stdcall; external 'cdbfapi.dll';
        {Integer, Memo, General as long }
function  GetInt( d: PDBF; n: longint ): longint;     stdcall; external 'cdbfapi.dll';
        {Numeric, float as double }
function  GetFloat( d: PDBF; n: longint ): double;    stdcall; external 'cdbfapi.dll';
        {Date           as integer }
function  GetDateTime( d: PDBF; n: longint ): longint; stdcall; external 'cdbfapi.dll';
        {Logical        as bool }
function  GetBool( d: PDBF; n: longint ): BOOL;       stdcall; external 'cdbfapi.dll';
        {Double as double }
function  GetDouble( d: PDBF; n: longint ): double;   stdcall; external 'cdbfapi.dll';
        {Currency as double }
function  GetCurrency( d: PDBF; n: longint ): double; stdcall; external 'cdbfapi.dll';
        {TimeStamp }
function  GetUnixTimeStamp( d: PDBF; n: longint ): int64; stdcall; external 'cdbfapi.dll';
        {struct tm }
function  GetStructTM( d: PDBF; n: longint ): double; stdcall; external 'cdbfapi.dll';
        {Any field as string }
function  GetStr( d: PDBF; n: longint ): Pchar;       stdcall; external 'cdbfapi.dll';
        {any memo as string }
function  GetMemo( d: PDBF; n: longint ): Pchar;      stdcall; external 'cdbfapi.dll';
        {any memo as buf }
function  GetMemoBuf( d: PDBF; n: longint; var len :longint): Pchar;      stdcall; external 'cdbfapi.dll';
        {dbaseIII memo as string }
function  Get_dBase3( d: PDBF; n: longint ): Pchar;   stdcall; external 'cdbfapi.dll';
        {dbaseIV  memo as string }
function  Get_dBase4( d: PDBF; n: longint ): Pchar;   stdcall; external 'cdbfapi.dll';
        {FoxPro   memo as string }
function  Get_FoxPro( d: PDBF; n: longint ): Pchar;   stdcall; external 'cdbfapi.dll';
        {blank char for this field type }
function  FieldBlankChar( d: PDBF; n: longint ): char; stdcall; external 'cdbfapi.dll';
        {clear all record in record_block }
procedure ClearRecord( d: PDBF );                     stdcall; external 'cdbfapi.dll';
        {clear field in record_block by blank char }
procedure ClearField( d: PDBF; n: longint );          stdcall; external 'cdbfapi.dll';
        {write header of .dbf }
function  WriteHeader( d: PDBF ): BOOL;               stdcall; external 'cdbfapi.dll';
        {append empty (TRUE) or current (FALSE) }
function  AppendBlank( d: PDBF; empty: BOOL ): BOOL;  stdcall; external 'cdbfapi.dll';
        {insert string }
procedure SetString( d: PDBF; n: longint; s: Pchar ); stdcall; external 'cdbfapi.dll';
        {insert long }
procedure SetNumeric( d: PDBF; n: longint; l: double ); stdcall; external 'cdbfapi.dll';
        {insert long }
procedure SetFloat( d: PDBF; n: longint; l: double ); stdcall; external 'cdbfapi.dll';
        {insert BOOL }
procedure SetBool( d: PDBF; n: longint; value: BOOL ); stdcall; external 'cdbfapi.dll';
        {insert BOOL }
procedure SetLogical( d: PDBF; n: longint; c: char ); stdcall; external 'cdbfapi.dll';
        {insert integer }
procedure SetInt( d: PDBF; n: longint; x: longint );  stdcall; external 'cdbfapi.dll';
        {insert double }
procedure SetDouble( d: PDBF; n: longint; x: double ); stdcall; external 'cdbfapi.dll';
        {insert inverted double }
procedure SetInvertedDouble( d: PDBF; n: longint; x: double ); stdcall; external 'cdbfapi.dll';
        {insert currency }
procedure SetCurrency( d: PDBF; n: longint; x: double ); stdcall; external 'cdbfapi.dll';
        {insert date}
procedure SetDate( d: PDBF; n: longint; year: longint; mon: longint; day: longint ); stdcall; external 'cdbfapi.dll';
        {insert date and time}
procedure SetDateTime( d: PDBF; n: longint; year: longint; mon: longint; day: longint; hr: longint; min: longint; sec: longint ); stdcall; external 'cdbfapi.dll';
        {insert date and time as integer}
procedure SetDateTimeI( d: PDBF; n: longint; t: longint ); stdcall; external 'cdbfapi.dll';
        {insert date as string}
procedure SetDateS( d: PDBF; n: longint; s: Pchar ); stdcall; external 'cdbfapi.dll';
        {insert date and time as string}
procedure SetDateTimeS( d: PDBF; n: longint; s: Pchar ); stdcall; external 'cdbfapi.dll';
        {read 1 field}
function  ReadField( d: PDBF; n: dword; field: longint ): BOOL; stdcall; external 'cdbfapi.dll';
        {write 1 field}
function  WriteField( d: PDBF; n: dword; field: longint ): BOOL; stdcall; external 'cdbfapi.dll';
        {write memo}
function  SetMemo( d: PDBF; n :longint; s :PChar): BOOL;    stdcall; external 'cdbfapi.dll';
        {write dbaseIII memo}
function  Set_dBase3( d: PDBF; s :PChar): longint;  stdcall; external 'cdbfapi.dll';
        {write dbaseIV memo}
function  Set_dBase4( d: PDBF; s :PChar): longint;  stdcall; external 'cdbfapi.dll';
        {write FoxPro memo}
function  Set_FoxPro( d: PDBF; s :PChar): longint;  stdcall; external 'cdbfapi.dll';
        {truncate to record n}
function  Truncate( d: PDBF;  n :longint): BOOL;    stdcall; external 'cdbfapi.dll';
        {delete marked for delete records}
function  Pack( d: PDBF; what :integer): BOOL;      stdcall; external 'cdbfapi.dll';
        {delete all records}
function  Zap( d: PDBF): BOOL;              stdcall; external 'cdbfapi.dll';
        {mark as delete}
function  DeleteRecord( d: PDBF;  n :longint): BOOL;    stdcall; external 'cdbfapi.dll';
        {recall deleted record}
function  RecallRecord( d: PDBF;  n :longint): BOOL;    stdcall; external 'cdbfapi.dll';
        {inverse mark deleted}
function  InverseRecord( d: PDBF;  n :longint): BOOL;   stdcall; external 'cdbfapi.dll';
        {write first byte of record}
function  WriteByte( d: PDBF; n :longint): BOOL;    stdcall; external 'cdbfapi.dll';
        {read first byte of record}
function  ReadByte( d: PDBF;  n :longint): BOOL;    stdcall; external 'cdbfapi.dll';
        {delete record now}
function  Delete( d: PDBF;  n :longint): BOOL;      stdcall; external 'cdbfapi.dll';
        {insert record, empty or duplicate}
function  Insert( d: PDBF;  n :longint; empty: boolean): BOOL;  stdcall; external 'cdbfapi.dll';
        {return field number by name or -1}
function  GetFieldNum( d: PDBF; s :PChar): integer; stdcall; external 'cdbfapi.dll';
        {find string, return near number or -1 if not found and exact = 0}
function  SeekValue( d: PDBF; n: longint; s :Pchar; exact: BOOL): integer;  stdcall; external 'cdbfapi.dll';
        {create empty database}
function  CreateDatabase(filename :PChar; fld :PField; n :integer; _type :integer; blocksize: integer; memo: BOOL): BOOL;   stdcall; external 'cdbfapi.dll';
        {create empty database}
function  CreateDatabase7(filename :PChar; fld :PField; n :integer; _type :integer; blocksize: integer; memo: BOOL; driver : String): BOOL; stdcall; external 'cdbfapi.dll';
        {create memo file}
function  CreateMemoFile(filename :PChar; _type :integer; blocksize: integer): BOOL;    stdcall; external 'cdbfapi.dll';
        {create field description}
procedure CreateField( d :PField; name :PChar; _type: char; size :integer); stdcall; external 'cdbfapi.dll';
        {return record count}
function  reccount( d :PDBF): integer;  stdcall; external 'cdbfapi.dll';
        {return field count}
function  fieldcount( d :PDBF): integer;    stdcall; external 'cdbfapi.dll';
        {set filter}
procedure set_filter( d :PDBF; s :PChar; fn :Pointer);  stdcall; external 'cdbfapi.dll';
//procedure set_filter( d :PDBF; s :PChar); stdcall; external 'cdbfapi.dll';
        {return real record number from filter}
function  recno( d :PDBF; i: integer): integer; stdcall; external 'cdbfapi.dll';
        {return real record number from order}
function  GetOrder( d :PDBF; i: integer): integer;  stdcall; external 'cdbfapi.dll';
        {return sign for numeric values: -1;0;1}
function  GetSign( d :PDBF; i: integer): integer;   stdcall; external 'cdbfapi.dll';
        {return real field number}
function  fieldno( d :PDBF; i: integer): integer;   stdcall; external 'cdbfapi.dll';
        {return true if record valid}
function  ValidRecord( d :PDBF; s: PChar): BOOL;    stdcall; external 'cdbfapi.dll';
        {internal - analize filter condition}
function  analizator( d :PDBF; s: PChar): BOOL; stdcall; external 'cdbfapi.dll';
        {internal - analize filter condition}
function  cnd( d :PDBF; s: PChar): PChar;   stdcall; external 'cdbfapi.dll';
        {internal - analize filter condition}
procedure eval( d :PDBF; o: char);  stdcall; external 'cdbfapi.dll';
        {sorting array tb}
procedure real_sort( d :PDBF; tb :Pointer; fn :Pointer);    stdcall; external 'cdbfapi.dll';
//procedure real_sort( d :PDBF; tb :Pointer);   stdcall; external 'cdbfapi.dll';
        {return blocksize}
function  dBase4_BlockSize( d :PDBF): integer;  stdcall; external 'cdbfapi.dll';
        {return blocksize}
function  FoxPro_BlockSize( d :PDBF): integer;  stdcall; external 'cdbfapi.dll';
        {return blocksize}
function  GetBlockSize( d :PDBF): integer;  stdcall; external 'cdbfapi.dll';
        {create string for calc or filter}
function  makecalcstring( d :PDBF; s: PChar; z: PChar; cn :Pointer): integer;   stdcall; external 'cdbfapi.dll';
    {name or alias length}
function  GetLenHeader( d :PDBF; n :integer): integer;  stdcall; external 'cdbfapi.dll';
    {name or alias}
function  GetHeader( d :PDBF; n :integer): PChar;   stdcall; external 'cdbfapi.dll';
        {copy current record to internal buffer}
procedure DupRecord( d :PDBF);            stdcall; external 'cdbfapi.dll';
        {copy internal buffer to current record}
procedure DupToRecord( d :PDBF);              stdcall; external 'cdbfapi.dll';
        {switch off order}
procedure ClearSort( d :PDBF);            stdcall; external 'cdbfapi.dll';
        {read columns headers}
procedure ReadAlias( d :PDBF);            stdcall; external 'cdbfapi.dll';
        {write columns headers}
procedure WriteAlias( d :PDBF);           stdcall; external 'cdbfapi.dll';
        {set name of columns header, if s='' default}
procedure SetAliasName( d :PDBF; s: PChar); stdcall; external 'cdbfapi.dll';
        {calculate s, err>0 if no errors}
function  Evaluate(s :PChar; var err): double;  stdcall; external 'cdbfapi.dll';
        {switch off filter}
procedure ClearFilter( d :PDBF);              stdcall; external 'cdbfapi.dll';
        {set separator in the date field}  
procedure SetDateSeparator( d :PDBF; c :char);      stdcall; external 'cdbfapi.dll';
        {check reccount}
function  RefreshDatabase( d :PDBF): BOOL;      stdcall; external 'cdbfapi.dll';
        {trim d->str}
function  DStrTrim( d :PDBF; i: integer): PChar;    stdcall; external 'cdbfapi.dll';
    {set any field }
procedure SetValue( d: PDBF; i: integer; s: PChar; b: double);       stdcall; external 'cdbfapi.dll';
    {get any digit field }
function  GetValue( d: PDBF; n: integer): double;   stdcall; external 'cdbfapi.dll';

        {parse fieldslist to array}
function  get_fields( d :PDBF; s :Pchar;  sn :Pointer; sv :Pointer): BOOL;  stdcall; external 'cdbfapi.dll';
        {open database}
function  OpenBase( filename :PChar ): PDBF;    stdcall; external 'cdbfapi.dll';
        {open database}
function  OpenBaseRO( filename :PChar ): PDBF;    stdcall; external 'cdbfapi.dll';
        {cloae database}
procedure CloseBase( d :PDBF);          stdcall; external 'cdbfapi.dll';
        {sort base by s}
function  SortBase( d :PDBF; s :PChar; fn :Pointer): BOOL;  stdcall; external 'cdbfapi.dll';
        {internal strtok function}
function  cdbfstrtok(s1, s2 :PChar): PChar;   stdcall; external 'cdbfapi.dll';
        {switch off filter and clear filter string}
procedure ClearAllFilter( d :PDBF);           stdcall; external 'cdbfapi.dll';
        {calculate string functions}
function  StrEval( s :PChar; d :PDBF): PChar;   stdcall; external 'cdbfapi.dll';

function  GetMemCalcField ( d :PDBF): BOOL; stdcall; external 'cdbfapi.dll';
procedure FreeMemCalcField( d :PDBF);   stdcall; external 'cdbfapi.dll';
function  GetCalcI  ( d :PDBF; name :PChar): integer;   stdcall; external 'cdbfapi.dll';
function  AddCalcField  ( d :PDBF; name :PChar; expr :PChar): BOOL; stdcall; external 'cdbfapi.dll';
procedure DelCalcField  ( d :PDBF; name :PChar);    stdcall; external 'cdbfapi.dll';
procedure DelCalcFieldI ( d :PDBF; i :integer); stdcall; external 'cdbfapi.dll';
function  if_digit_calc ( d :PDBF; name :PChar): BOOL;  stdcall; external 'cdbfapi.dll';
function  if_digit_calci( d :PDBF; i :integer): BOOL;   stdcall; external 'cdbfapi.dll';
function  GetCalcString ( d :PDBF; name :PChar): PChar; stdcall; external 'cdbfapi.dll';
function  GetCalcStringI( d :PDBF; i :integer): PChar;  stdcall; external 'cdbfapi.dll';
function  GetCalcValue  ( d :PDBF; name :PChar): double;    stdcall; external 'cdbfapi.dll';
function  GetCalcValueI ( d :PDBF; i :integer): double; stdcall; external 'cdbfapi.dll';

function  GetFieldType  ( d: PDBF; n: integer): char;   stdcall; external 'cdbfapi.dll';
function  GetLowLen     ( d: PDBF; n: integer): integer;   stdcall; external 'cdbfapi.dll';
function  GetHighLen    ( d: PDBF; n: integer): integer;   stdcall; external 'cdbfapi.dll';
function  GetAllLen     ( d: PDBF; n: integer): integer;   stdcall; external 'cdbfapi.dll';
function  GetFieldName  ( d: PDBF; n: integer): Pchar;   stdcall;  external 'cdbfapi.dll';

function  PreparePassword ( d: PDBF; s: PChar): BOOL;     stdcall;  external 'cdbfapi.dll';
procedure RemovePassword  ( d: PDBF);     stdcall;  external 'cdbfapi.dll';

function  ExternalFilter  ( d: PDBF; n: integer): Pointer;     stdcall;  external 'cdbfapi.dll';
function  MakeBakFile     ( d: PDBF; always: Boolean): integer;     stdcall;  external 'cdbfapi.dll';
procedure MakeExt    ( newname :Pchar; oldname :Pchar; newext :Pchar; fullname :Pchar);     stdcall;  external 'cdbfapi.dll';

function  ExecSQL( d :PDBF; s :PChar; fn :Pointer): BOOL;   stdcall; external 'cdbfapi.dll';

        {write memo buf}
function  SetMemoBuf( d: PDBF; n :longint; s :PChar; len :integer): BOOL;   stdcall; external 'cdbfapi.dll';

procedure WriteBackLink(dd, ds :PDBF);  stdcall; external 'cdbfapi.dll';
procedure SetByte   ( d: PDBF; offset: Integer; b: byte);   stdcall; external 'cdbfapi.dll';
function  GetByte   ( d: PDBF; offset: Integer): byte;  stdcall; external 'cdbfapi.dll';

procedure ResetLastRecord ( d: PDBF);   stdcall; external 'cdbfapi.dll';
function  FiletypeAsText ( d: PDBF): string;    stdcall; external 'cdbfapi.dll';
function  TypeAsText ( c : char): string;   stdcall; external 'cdbfapi.dll';

implementation


end.

