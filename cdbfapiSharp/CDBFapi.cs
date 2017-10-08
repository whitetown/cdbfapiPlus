using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Runtime.InteropServices;
using System.Globalization;

namespace cdbfapi
{
    public class CDBFapi
    {
        IntPtr handle;
        Encoding defEncoding = null;

        public CDBFapi() 
                {
                    try
                    {
                        handle = cdbfapiCreate();
                    }
                    catch (DllNotFoundException)
                    {
                    }
                }
        
        ~CDBFapi()       
                {
                    if (libraryLoaded())
                    {
                        cdbfapiRelease(handle);
                        handle = (IntPtr)0;
                    }
                }

        public bool libraryLoaded()
        {
            return handle != (IntPtr)0;
        }

        public void initLibrary(int magicNumber, string email)  
            {   initLibrary(handle, magicNumber,  email );  }

        public bool openDBFfile(string filename)
            {   return openDBFfile(handle, filename);   }

        public void closeDBFfile()
            {   closeDBFfile(handle);   }

        public int recCount()
            {   return recCount(handle);    }

        public int fieldCount()
            {   return fieldCount(handle);  }

        public bool getRecord(int recno)
            {   return getRecord(handle, recno);    }

        public bool readRecord(int recno)
            {   return readRecord(handle, recno);   }

        public bool writeRecord(int recno)
            {   return writeRecord(handle, recno);  }

        public bool readField(int recno, int fieldno)
            { return readField(handle, recno, fieldno); }

        public bool writeField(int recno, int fieldno)
            { return writeField(handle, recno, fieldno); }

        public int indexOfField(string fieldname)
            {   return indexOfField(fieldname, defEncoding); }

        public int indexOfField(string fieldname, Encoding e)
            {   return indexOfField(handle, stringToBytes(fieldname, e)); }

        public string getString(int fieldno)
        {
            return getString(fieldno, defEncoding);
        }

        public string getString(int fieldno, Encoding e)
        {
            IntPtr ip = IntPtr.Zero;

            int size = getData(handle, fieldno, out ip);
            if (size == 0) return null;

            if (fieldType(fieldno) == 'V')
                size--;
            if (size == 0) return null;

            string x = Marshal.PtrToStringAnsi(ip);

            byte[] src = new byte[size];
            Marshal.Copy(ip, src, 0, size);

            if (e != null)
            {
                byte[] result = Encoding.Convert(e, Encoding.UTF8, src);
                return Encoding.UTF8.GetString(result);
            }
            else
                return Marshal.PtrToStringAnsi(ip);
        }

        public double   getValue(int fieldno)
                {   return getValue(handle, fieldno);   }

        public DateTime getDateTime(int fieldno)
        {
            Int64 ticks = getTicks(fieldno);
            DateTime dt = new DateTime(ticks * 10000000 + 0x089f7ff5f7b58000, DateTimeKind.Utc);
            return dt.ToLocalTime();
        }

        public Int64 getTicks(int fieldno)
        {
            return getTicks(handle, fieldno);
        }

        public byte[] getMemoBuf(int fieldno, out int len)
        {
            len = 0;
            IntPtr ip = IntPtr.Zero;

            int size = getMemoBuf(handle, fieldno, out ip);
            if (size == 0) return null;

            string x = Marshal.PtrToStringAnsi(ip);

            byte[] src = new byte[size];
            Marshal.Copy(ip, src, 0, size);

            len = size;
            return src;
        }

        public bool isMemoField(int fieldno)
            {   return isMemoField(handle, fieldno);    }

        public bool isNumericField(int fieldno)
            {   return isNumericField(handle, fieldno); }

        public bool isDateField(int fieldno)
            {   return isDateField(handle, fieldno);    }

        public bool isDeleted()
            {   return isCurrentDeleted(handle);    }

        public bool isDeleted(int fieldno)
            {   return isDeleted(handle, fieldno);  }

        public void clearRecord()
            {   clearRecord(handle);    }

        public void clearField(int fieldno)
            {   clearField(handle, fieldno);    }

        public void setField(int fieldno, string s)
            {   setField(fieldno, stringToBytes(s, defEncoding)); }

        public void setField(int fieldno, string s, Encoding e)
            {   setField(fieldno, stringToBytes(s, e)); }

        public void setField(int fieldno, byte[] s)
            {   setFieldString(handle, fieldno, s); }
    
        public void setField(int fieldno, double value)
            {   setFieldDouble(handle, fieldno, value); }

        public void setField(int fieldno, string s, double value)
            {   setField(fieldno, stringToBytes(s, defEncoding), value); }

        public void setField(int fieldno, string s, double value, Encoding e)
            {   setField(fieldno, stringToBytes(s, e), value); }

        public void setField(int fieldno, byte[] s, double value)
            {   setField(handle, fieldno, s, value);    }

        public void setMemoBuf(int field, byte[] src, int len)
            {
                setMemoData(handle, field, src, len);
            }

        public bool markAsDeleted(int fieldno)
            {   return markAsDeleted(handle, fieldno);  }

        public bool recallDeleted(int fieldno)
            {   return recallDeleted(handle, fieldno);  }

        public bool deleteRecord(int recno)
            {   return deleteRecord(handle, recno); }

        public bool appendRecord(bool blankrecord)
            {   return appendRecord(handle, blankrecord);   }

        public bool insertRecord(int recno, bool blankrecord)
            {   return insertRecord(handle, recno, blankrecord);    }

        public void setOrder(string fieldlist)
            {   setOrder(fieldlist, defEncoding); }

        public void setOrder(string fieldlist, Encoding e)
            {   setOrder(stringToBytes(fieldlist, e));  }

        public void setOrder(byte[] fieldlist)
            {   setOrder(handle, fieldlist);    }

        public void setOrderA(string[] fields)
            {   setOrderA(handle, fields);  }

        public void unsetOrder()
            {   unsetOrder(handle); }

        public void setFilter(string expression)
            {   setFilter(stringToBytes(expression, defEncoding)); }

        public void setFilter(string expression, Encoding e)
            {   setFilter(stringToBytes(expression, e));    }

        public void setFilter(byte[] expression)
            {   setFilter(handle, expression);  }

        public void unsetFilter()
            {   unsetFilter(handle);    }

        public bool pack()
            {   return pack(handle);    }

        public bool truncate(int recno)
            { return truncate(handle, recno); }

        public bool zap()
            {   return zap(handle); }

        public int  fileType()
            {   return fileType(handle);    }

        public int  recordLength()
            {   return recordLength(handle);    }

        public string driverName()
        {
            IntPtr s = driverName(handle);
            return Marshal.PtrToStringAnsi(s);
        }

        public string   fieldName(int fieldno)
        {
            return fieldName(fieldno, defEncoding);
        }

        public string fieldName(int fieldno, Encoding e)
        {
            IntPtr ip = IntPtr.Zero;

            int size = fieldData(handle, fieldno, out ip);
            if (size == 0) return null;

            string x = Marshal.PtrToStringAnsi(ip);

            byte[] src = new byte[size];
            Marshal.Copy(ip, src, 0, size);

            if (e != null)
            {
                byte[] result = Encoding.Convert(e, Encoding.UTF8, src);
                return Encoding.UTF8.GetString(result);
            }
            else
                return Marshal.PtrToStringAnsi(ip);
        }

        public char fieldType(int fieldno)
            {   return fieldType(handle, fieldno);  }
    
        public int  fieldLength(int fieldno)
            {   return fieldLength(handle, fieldno);    }

        public int  fieldDecimal(int fieldno)
            {   return fieldDecimal(handle, fieldno);   }

        public bool prepareNewTable(int fileType)
            {   return prepareNewTable(handle, fileType);   }

        public bool prepareNewTable(int fileType, int memoSize, string driver)
        { return prepareNewTableX(handle, fileType, memoSize, driver); }

        public void addField(string fieldname, char fieldType, int length)
            {   addField(handle, fieldname, fieldType, length); }

        public void addField(string fieldname, char fieldType, int length, int dec)
            {   addFieldX(handle, fieldname, fieldType, length, dec);   }

        public bool createTable(string filename)
            {   return createTable(handle, filename);   }

        public bool createAndOpenTable(string filename)
            {   return createAndOpenTable(handle, filename);    }

        public void setEncoding(Encoding e)
            {   defEncoding = e;    }

        public void setDateFormat(string format)
            {   setDateFormat(handle, format); }

        public void setDateDelimiter(char delimiter)
            {   setDateDelimiter(handle, delimiter);   }

        public bool isReadOnly()
        {
            return isReadOnly(handle);
        }

        public void setReadOnly(bool value)
        {
            setReadOnly(handle, value);
        }

        public void descendingMode(bool descending)
        {
            descendingMode(handle, descending);
        }

        public void caseSensitiveMode(bool sensitive)
        {
            caseSensitiveMode(handle, sensitive);
        }

        public string filename()
        {
            IntPtr s = filename(handle);
            return Marshal.PtrToStringAnsi(s);
        }

        public string filenameMemo()
        {
            IntPtr s = filenameMemo(handle);
            return Marshal.PtrToStringAnsi(s);
        }

        public string lastUpdated()
        {
            IntPtr s = lastUpdated(handle);
            return Marshal.PtrToStringAnsi(s);
        }

        public int headerSize()
            {   return headerSize(handle); }

        public void resetLastRecord()
            {  resetLastRecord(handle); }

        public void setByte(int offset, byte b)
            {   setByte(handle, offset, b); }

        public byte getByte(int offset)
            {   return getByte(handle, offset); }


        public string filetypeAsText()
        {
            IntPtr s = filetypeAsText(handle);
            return Marshal.PtrToStringAnsi(s);
        }

        public static string fieldtypeAsText(char c)
        {
            IntPtr s = typeAsText(c);
            return Marshal.PtrToStringAnsi(s);
        }

/////////////////////
        public byte[] stringToBytes(string source, Encoding e)
        {
            byte[] src = Encoding.UTF8.GetBytes(source);
            Encoding encoding = Encoding.Default;
            if (e != null)
            {
                encoding = e;
            }
            byte[] result = Encoding.Convert(Encoding.UTF8, encoding, src);
            return result;
        }
/////////////////////

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr cdbfapiCreate();

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void cdbfapiRelease(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void initLibrary(IntPtr handle, int magicNumber, string email);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool openDBFfile(IntPtr handle, string filename);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void closeDBFfile(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern int recCount(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern int fieldCount(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool getRecord(IntPtr handle, int recno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool readRecord(IntPtr handle, int recno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool writeRecord(IntPtr handle, int recno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool readField(IntPtr handle, int recno, int fieldno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool writeField(IntPtr handle, int recno, int fieldno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern int indexOfField(IntPtr handle, byte[] fieldname);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr getString(IntPtr handle, int fieldno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern int getData(IntPtr handle, int fieldno, out IntPtr data);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern int getMemoBuf(IntPtr handle, int fieldno, out IntPtr data);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void setMemoData(IntPtr handle, int fieldno, byte[] data, int len);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern double getValue(IntPtr handle, int fieldno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern Int64 getTicks(IntPtr handle, int fieldno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool isMemoField(IntPtr handle, int fieldno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool isNumericField(IntPtr handle, int fieldno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool isDateField(IntPtr handle, int fieldno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool isCurrentDeleted(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool isDeleted(IntPtr handle, int recno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool clearRecord(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool clearField(IntPtr handle, int fieldno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void setFieldString(IntPtr handle, int fieldno, byte[] s);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void setFieldDouble(IntPtr handle, int fieldno, double value);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void setField(IntPtr handle, int fieldno, byte[] s, double value);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool markAsDeleted(IntPtr handle, int recno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool recallDeleted(IntPtr handle, int recno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool deleteRecord(IntPtr handle, int recno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool appendRecord(IntPtr handle, bool blankrecord);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool insertRecord(IntPtr handle, int recno, bool blankrecord);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void setOrder(IntPtr handle, byte[] fieldlist);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void setOrderA(IntPtr handle, string[] fields);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void unsetOrder(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void setFilter(IntPtr handle, byte[] expression);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void unsetFilter(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool pack(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool truncate(IntPtr handle, int recno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool zap(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern int fileType(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern int recordLength(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr driverName(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr fieldName(IntPtr handle, int fieldno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern int    fieldData(IntPtr handle, int fieldno, out IntPtr name);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern char fieldType(IntPtr handle, int fieldno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern int fieldLength(IntPtr handle, int fieldno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern int fieldDecimal(IntPtr handle, int fieldno);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool prepareNewTable(IntPtr handle, int fileType);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool prepareNewTableX(IntPtr handle, int fileType, int memoSize, string driver);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void addField(IntPtr handle, string fieldname, char fieldType, int length);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void addFieldX(IntPtr handle, string fieldname, char fieldType, int length, int dec);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool createTable(IntPtr handle, string filename);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool createAndOpenTable(IntPtr handle, string filename);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void setEncoding(IntPtr handle, int e);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void setDateFormat(IntPtr handle, string format);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void setDateDelimiter(IntPtr handle, char delimiter);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern bool isReadOnly(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void setReadOnly(IntPtr handle, bool value);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void descendingMode(IntPtr handle, bool descending);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void caseSensitiveMode(IntPtr handle, bool sensitive);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr filename(IntPtr handle);
        
        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr filenameMemo(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr lastUpdated(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern int headerSize(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void resetLastRecord(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern void setByte(IntPtr handle, int offset, byte b);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern byte getByte(IntPtr handle, int offset);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr filetypeAsText(IntPtr handle);

        [DllImport("cdbfapiPlus.dll", CharSet = CharSet.Ansi, CallingConvention = CallingConvention.Cdecl)]
        private static extern IntPtr typeAsText(char c);


    }
}
