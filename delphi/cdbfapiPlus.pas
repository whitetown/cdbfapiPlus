unit cdbfapiPlus;

interface

uses
    Windows, sysutils, cdbfapi;

type
  TcdbfapiPlus = class(TObject)

        constructor Create;
        destructor  Destroy; override;

  private

        dbf         : PDBF;

        fld_count   : integer;
        fld, fld2   : PField;
        charset     : Integer;

        typeOfNewFile : Integer;
        sizeOfMemo    : Integer;
        driverString  : String;

        readonly    : Boolean;

  public

        procedure   initLibrary(magicNumber : Integer; email : String);

        function    openDBFfile(filename : String): Boolean;
        procedure   closeDBFfile;

        function    recCount: Integer;
        function    fieldCount: Integer;

        function    getRecord(recno : Integer): Boolean;
        function    readRecord(recno : Integer): Boolean;
        function    writeRecord(recno : Integer): Boolean;

        function    readField(recno : Integer; fieldno : Integer): Boolean;
        function    writeField(recno : Integer; fieldno : Integer): Boolean;

        function    indexOfField(fieldname : String): Integer;

        function    getString(fieldno : Integer): String;
        function    getValue(fieldno : Integer): double;

        function    getDateTime(fieldno : Integer): TDateTime;
        function    getTicks(fieldno : Integer): int64;

        function    getMemoBuf(fieldno : Integer; var len : Integer): Pointer;
 
        function    isMemoField(fieldno : Integer): Boolean;
        function    isNumericField(fieldno : Integer): Boolean;
        function    isDateField(fieldno : Integer): Boolean;

        function    isCurrentDeleted: Boolean;
        function    isDeleted(recno : Integer): Boolean;

        procedure   clearRecord;
        procedure   clearField(fieldno : Integer);

        procedure   setFieldString  (fieldno : Integer; s : string);
        procedure   setFieldDouble  (fieldno : Integer; value : double);
        procedure   setField (fieldno : Integer; s : string; value : double);

        procedure   setMemoBuf(field : Integer; src : Pointer; len : Integer);

        function    markAsDeleted(recno : Integer): Boolean;
        function    recallDeleted(recno : Integer): Boolean;

        function    deleteRecord(recno : Integer): Boolean;
        function    appendRecord(blankrecord : Boolean): Boolean;
        function    insertRecord(recno : Integer; blankrecord : Boolean): Boolean;

        procedure   setOrder (fieldlist : String);
        procedure   setOrderA(fields    : array of String);
        procedure   unsetOrder;
        procedure   descendingMode(descending : Boolean);

        procedure   setFilter (expression : String );
        procedure   unsetFilter;
        procedure   caseSensitiveMode(sensitive : Boolean);

        function    pack: Boolean;
        function    truncate(recno : Integer): Boolean;
        function    zap: Boolean;

        function    fileType: Integer;
        function    filetypeAsText: string;

        function    recordLength: Integer;
        function    lastUpdated: string;
        function    headerSize: Integer;

        function    filename: string;
        function    filenameMemo: string;
        function    driverName: String;

        procedure   resetLastRecord;

        function    fieldName(fieldno : Integer): String;
        function    fieldType(fieldno : Integer): char;
        function    fieldLength(fieldno : Integer): Integer;
        function    fieldDecimal(fieldno : Integer): Integer;

        function    typeAsText(c :char): string;

        procedure   setEncoding(e : Integer);
        procedure   setDateFormat(format : String);
        procedure   setDateDelimiter(delimiter : char);

        function    isReadOnly: Boolean;
        procedure   setReadOnly(value : Boolean);

        function    prepareNewTable(fileType : Integer): Boolean;
        function    prepareNewTableX(fileType : Integer; memoSize : Integer; driver : String): Boolean;

        procedure   addField (fieldname : String; fieldType : char; length : Integer);
        procedure   addFieldX(fieldname : String; fieldType : char; length : Integer; dec : Integer);

        function    createTable(filename : String): Boolean;
        function    createAndOpenTable(filename : String): Boolean;

        procedure   setByte(offset : Integer; b : byte);
        function    getByte(offset : Integer): byte;

  end;

implementation

function  atof(s1 :PChar): double;        stdcall;
var
   i      :integer;
   t      :string;
begin
  try
  t := s1;
  for i := 1 to length(t) do
   if t[i] in [',','.'] then
      t[i] := DecimalSeparator;

  result := strtofloat(t);
  except
  result := 0;
  end;
end;

function  atoi(s1 :PChar): integer;       stdcall;
begin
  try
  result := strtoint(s1);
  except
  result := 0;
  end;
end;

        constructor TcdbfapiPlus.Create;
        begin
        end;

        destructor  TcdbfapiPlus.Destroy;
        begin
        end;

        procedure   TcdbfapiPlus.initLibrary(magicNumber : Integer; email : String);
        begin
            InitLibrary(magicNumber, PChar(email));
        end;

        function    TcdbfapiPlus.openDBFfile(filename : String): Boolean;
        var
            ret  : PDBF;
        begin
            result := False;

            if readonly then
                ret := OpenBaseRO(PChar(filename))
            else
                ret := OpenBase(PChar(filename));
            if (ret <> nil) then
            begin
                closeDBFfile;
                dbf := ret;
                result := True;
            end;

        end;

        procedure   TcdbfapiPlus.closeDBFfile;
        begin
            if (dbf <> nil) then CloseBase(dbf);
            dbf := nil;
        end;

        function    TcdbfapiPlus.recCount: Integer;
        begin
            if (dbf <> nil) then
                result := cdbfapi.reccount(dbf)
            else
                result := 0;
        end;

        function    TcdbfapiPlus.fieldCount: Integer;
        begin
            if (dbf <> nil) then
                result := cdbfapi.fieldcount(dbf)
            else
                result := 0;
        end;

        function    TcdbfapiPlus.getRecord(recno : Integer): Boolean;
        begin
             if (dbf <> nil) then
                result := cdbfapi.GetRecord(dbf, recno)
            else
                result := False;
        end;

        function    TcdbfapiPlus.readRecord(recno : Integer): Boolean;
        begin
             if (dbf <> nil) then
                result := cdbfapi.ReadRecord(dbf, recno)
            else
                result := False;
        end;

        function    TcdbfapiPlus.writeRecord(recno : Integer): Boolean;
        begin
             if (dbf <> nil) then
                result := cdbfapi.WriteRecord(dbf, recno)
            else
                result := False;
        end;

        function    TcdbfapiPlus.readField(recno : Integer; fieldno : Integer): Boolean;
        begin
             if (dbf <> nil) then
                result := cdbfapi.ReadField(dbf, recno, fieldno)
            else
                result := False;
        end;

        function    TcdbfapiPlus.writeField(recno : Integer; fieldno : Integer): Boolean;
        begin
             if (dbf <> nil) then
                result := cdbfapi.WriteField(dbf, recno, fieldno)
            else
                result := False;
        end;

        function    TcdbfapiPlus.indexOfField(fieldname : String): Integer;
        begin
            result := -1;

            if (dbf <> nil) then
                result := GetFieldNum(dbf, PChar(fieldname));
        end;

        function    TcdbfapiPlus.getString(fieldno : Integer): String;
        begin
            result := '';

            if (dbf <> nil) then
            begin
                if (if_memo_type(dbf, fieldno)) then
                begin
                    FreeMemo(dbf);
                    dbf.memo_block := GetMemo(dbf, fieldno);
                    if (dbf.memo_block <> nil) then
                        result := dbf.memo_block;
                end
                else
                begin
                    GetStr(dbf, fieldno);
                    result := dbf.str;
                end;
            end;
        end;
 
        function    TcdbfapiPlus.getValue(fieldno : Integer): double;
        begin
            if (dbf <> nil) then
                result := cdbfapi.GetValue(dbf, fieldno)
            else
                result := 0;
        end;

        function    TcdbfapiPlus.getDateTime(fieldno : Integer): TDateTime;
        begin
            Result := (getTicks(fieldno) / 86400) + 25569;
        end;

        function    TcdbfapiPlus.getTicks(fieldno : Integer): int64;
        begin
            if (dbf <> nil) then
                result := GetUnixTimeStamp(dbf, fieldno)
            else
                result := 0;
        end;

        function    TcdbfapiPlus.getMemoBuf(fieldno : Integer; var len : Integer): Pointer;
        var
            l   :Integer;
        begin
            len := 0;
            result := nil;

            if (dbf <> nil) then
            begin
                if (if_memo_type(dbf, fieldno)) then
                begin
                    FreeMemo(dbf);
                    dbf.memo_block := cdbfapi.GetMemoBuf(dbf, fieldno, l);
                    if (dbf.memo_block <> nil) then
                    begin
                        len    := l;
                        result := dbf.memo_block;
                    end;
                end;
            end;
        end;

        procedure   TcdbfapiPlus.setMemoBuf(field : Integer; src : Pointer; len : Integer);
        begin
            if (dbf <> nil) then
            begin
                if isMemoField(field) then
                begin
                    cdbfapi.SetMemoBuf(dbf, field, src, len);
                end;
            end;
        end;

        function    TcdbfapiPlus.isMemoField(fieldno : Integer): Boolean;
        begin
            if (dbf <> nil) then
                result := if_memo_type(dbf, fieldno)
            else
                result := False;
        end;

        function    TcdbfapiPlus.isNumericField(fieldno : Integer): Boolean;
        begin
            if (dbf <> nil) then
                result := if_digit_type(dbf, fieldno)
            else
                result := False;
        end;

        function    TcdbfapiPlus.isDateField(fieldno : Integer): Boolean;
        begin
            if (dbf <> nil) then
                result := if_date_type(dbf, fieldno)
            else
                result := False;
        end;

        function    TcdbfapiPlus.isCurrentDeleted: Boolean;
        begin
            if (dbf <> nil) then
                result := dbf.record_block[0] = '*'
            else
                result := False;
        end;

        function    TcdbfapiPlus.isDeleted(recno : Integer): Boolean;
        begin
            if (dbf <> nil) then
            begin
                ReadByte(dbf, recno);
                result := dbf.one_byte = '*';
            end
            else
                result := False;
        end;

        procedure   TcdbfapiPlus.clearRecord;
        begin
            if (dbf <> nil) then
                cdbfapi.ClearRecord(dbf);
        end;

        procedure   TcdbfapiPlus.clearField(fieldno : Integer);
        begin
            if (dbf <> nil) then
                cdbfapi.ClearField(dbf, fieldno);
        end;

        procedure   TcdbfapiPlus.setFieldString  (fieldno : Integer; s : string);
        var
            value : double;
        begin
            value := atof(PChar(s));
            setField(fieldno, s, value);
        end;

        procedure   TcdbfapiPlus.setFieldDouble  (fieldno : Integer; value : double);
        var
            s   :String;
        begin
            s := floatToStr(value);
            setField(fieldno, s, value);
        end;

        procedure   TcdbfapiPlus.setField (fieldno : Integer; s : string; value : double);
        begin
            if (dbf <> nil) then
            begin
                SetValue(dbf, fieldno, PChar(s), value);
            end;
        end;

        function    TcdbfapiPlus.markAsDeleted(recno : Integer): Boolean;
        begin
            if (dbf <> nil) then
                result := cdbfapi.DeleteRecord(dbf, recno)
            else
                result := False;
        end;

        function    TcdbfapiPlus.recallDeleted(recno : Integer): Boolean;
        begin
            if (dbf <> nil) then
                result := RecallRecord(dbf, recno)
            else
                result := False;
        end;

        function    TcdbfapiPlus.deleteRecord(recno : Integer): Boolean;
        begin
            if (dbf <> nil) then
                result := Delete(dbf, recno)
            else
                result := False;
        end;

        function    TcdbfapiPlus.appendRecord(blankrecord : Boolean): Boolean;
        begin
            if (dbf <> nil) then
                result := AppendBlank(dbf, blankrecord)
            else
                result := False;
        end;

        function    TcdbfapiPlus.insertRecord(recno : Integer; blankrecord : Boolean): Boolean;
        begin
            if (dbf <> nil) then
                result := Insert(dbf, recno, blankrecord)
            else
                result := False;
        end;

        procedure   TcdbfapiPlus.setOrder(fieldlist : String);
        begin
            if (dbf <> nil) and ( Length(fieldlist) > 0 ) then
                SortBase(dbf, PChar(fieldlist), nil);
        end;

        procedure   TcdbfapiPlus.setOrderA(fields : array of String);
        var
            fieldlist : String;
            i         : Integer;
        begin
            if (dbf <> nil) and (Length(fields) > 0)and ( Length(fields[0]) > 0 ) then
            begin
                for i := 0 to Length(fields) - 1 do
                begin
                    if Length(fieldlist) > 0 then
                        fieldlist := fieldlist + ',';
                    fieldlist := fieldlist + fields[i];
                end;
                setOrder(fieldlist);
            end;
        end;

        procedure   TcdbfapiPlus.unsetOrder;
        begin
            if (dbf <> nil) then
                ClearSort(dbf);
        end;

        procedure   TcdbfapiPlus.setFilter(expression : String);
        begin
            if (dbf <> nil) and (Length(expression)>0) then
                set_filter(dbf, PChar(expression), nil);
        end;

        procedure   TcdbfapiPlus.unsetFilter;
        begin
            if (dbf <> nil) then
                ClearAllFilter(dbf);
        end;

        function    TcdbfapiPlus.pack: Boolean;
        begin
            if (dbf <> nil) then
                result := cdbfapi.Pack(dbf, 0)
            else
                result := False;
        end;

        function    TcdbfapiPlus.truncate(recno : Integer): Boolean;
        begin
            if (dbf <> nil) then
                result := cdbfapi.Truncate(dbf, recno)
            else
                result := False;
        end;

        function    TcdbfapiPlus.zap: Boolean;
        begin
            if (dbf <> nil) then
                result := cdbfapi.Zap(dbf)
            else
                result := False;
        end;

        function    TcdbfapiPlus.fileType: Integer;
        begin
            if (dbf <> nil) then
                result := GetMemoType(dbf)
            else
                result := 0;
        end;

        function    TcdbfapiPlus.recordLength: Integer;
        begin
            if (dbf <> nil) then
                result := dbf.hdr.rec_len
            else
                result := 0;
        end;

        function    TcdbfapiPlus.driverName: String;
        begin
            if (dbf <> nil) and (GetMemoType(dbf) = 7) then
                result := dbf.hdr.level7
            else
                result := '';
        end;

        function    TcdbfapiPlus.fieldName(fieldno : Integer): String;
        begin
            if (dbf <> nil) then
                result := GetFieldName(dbf, fieldno)
            else
                result := '';
        end;

        function    TcdbfapiPlus.fieldType(fieldno : Integer): char;
        begin
            if (dbf <> nil) then
                result := GetFieldType(dbf, fieldno)
            else
                result := 'C';
        end;

        function    TcdbfapiPlus.fieldLength(fieldno : Integer): Integer;
        begin
            if (dbf <> nil) then
                result := GetAllLen(dbf, fieldno)
            else
                result := 0
        end;

        function    TcdbfapiPlus.fieldDecimal(fieldno : Integer): Integer;
        begin
            if (dbf <> nil) then
                result := GetLowLen(dbf, fieldno)
            else
                result := 0
        end;

        function    TcdbfapiPlus.prepareNewTable(fileType : Integer): Boolean;
        begin
                result := prepareNewTableX(fileType, 512, '');
        end;

        function    TcdbfapiPlus.prepareNewTableX(fileType : Integer; memoSize : Integer; driver : String): Boolean;
        begin
            if fld2 <> nil then FreeMem(fld2);

            GetMem(fld, 2048*sizeof(Field));
            fld2 := fld;

            fld_count := 0;
            sizeOfMemo := memoSize;
            if (sizeOfMemo <= 0) then sizeOfMemo := 512;
            driverstring := driver;

            result := True;
        end;

        procedure   TcdbfapiPlus.addField(fieldname : String; fieldType : char; length : Integer);
        begin
            addFieldX(fieldname, fieldType, length, 0);
        end;

        procedure   TcdbfapiPlus.addFieldX(fieldname : String; fieldType : char; length : Integer; dec : Integer);
        begin
            if (fld2 <> nil) then
            begin
                CreateField(fld,
                     PChar(fieldname),
                     fieldtype,
                     length + dec * 256);
                inc(fld);
                inc(fld_count);
            end;
        end;

        function    TcdbfapiPlus.createTable(filename : String): Boolean;
        begin
            result := False;
            if (fld_count > 0) and (fld2 <> nil) then
            begin
                fld := fld2;
                result := CreateDatabase7(PChar(filename),
                                    fld,
                                    fld_count,
                                    typeOfNewFile,
                                    sizeOfMemo,
                                    True,
                                    driverString);

                FreeMem(fld2);
                fld  := nil;
                fld2 := nil;

            end;
        end;

        function    TcdbfapiPlus.createAndOpenTable(filename : String): Boolean;
        begin
            if createTable(filename) then
                result := OpenDBFFile(filename)
            else
                result := False;
        end;

        procedure   TcdbfapiPlus.setEncoding(e : Integer);
        begin
                charset := e;
        end;

        procedure   TcdbfapiPlus.setDateFormat(format : String);
        begin
            if (dbf <> nil) then
            begin
            if (format = 'dmy')  then dbf.opt.dt_type := 1;
            if (format = 'mdy')  then dbf.opt.dt_type := 2;
            if (format = 'ymd')  then dbf.opt.dt_type := 3;
            if (format = 'asis') then dbf.opt.dt_type := 4;
            end;
        end;

        procedure   TcdbfapiPlus.setDateDelimiter(delimiter : char);
        begin
            if (dbf <> nil) then
                SetDateSeparator(dbf, delimiter);
        end;

        function    TcdbfapiPlus.isReadOnly: Boolean;
        begin
            result := readonly
        end;

        procedure   TcdbfapiPlus.setReadOnly(value : Boolean);
        begin
            readonly := value;
        end;

        procedure   TcdbfapiPlus.descendingMode(descending : Boolean);
        begin
            if (dbf <> nil) then
                dbf.opt.descending := descending;
        end;

        procedure   TcdbfapiPlus.caseSensitiveMode(sensitive : Boolean);
        begin
            if (dbf <> nil) then
                dbf.opt.ignore_case := not sensitive;
        end;

        function    TcdbfapiPlus.filename: string;
        begin
            if (dbf <> nil) then
                result := dbf.filename
            else
                result := '';
        end;

        function    TcdbfapiPlus.filenameMemo: string;
        begin
            if (dbf <> nil) then
                result := dbf.filename_memo
            else
                result := '';
        end;

        function    TcdbfapiPlus.lastUpdated: string;
        begin
            result := '';
            if (dbf <> nil) then
                result := format('%02d.%02d.%02d', [
                    dbf.hdr.last_year mod 100,
                    dbf.hdr.last_month,
                    dbf.hdr.last_day ]);
        end;

        function    TcdbfapiPlus.headerSize: Integer;
        begin
            if (dbf <> nil) then
                result := dbf.hdr.offset_first
            else
                result := 0;
        end;

        procedure   TcdbfapiPlus.resetLastRecord;
        begin
            if (dbf <> nil) then
                cdbfapi.ResetLastRecord(dbf);
        end;

        procedure   TcdbfapiPlus.setByte(offset : Integer; b : byte);
        begin
            if (dbf <> nil) then
                cdbfapi.SetByte(dbf, offset, b);
        end;

        function    TcdbfapiPlus.getByte(offset : Integer): byte;
        begin
           if (dbf <> nil) then
                result := cdbfapi.GetByte(dbf, offset)
           else
                result := 0;
        end;

        function    TcdbfapiPlus.filetypeAsText: string;
        begin
            if (dbf <> nil) then
                result := cdbfapi.FiletypeAsText(dbf)
            else
                result := '';
        end;

        function    TcdbfapiPlus.typeAsText(c :char): string;
        begin
            if (dbf <> nil) then
                result := TypeAsText(c)
            else
                result := '';
        end;

end.
