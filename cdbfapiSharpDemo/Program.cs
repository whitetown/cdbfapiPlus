using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using cdbfapi;
using System.Diagnostics;

namespace cdbfapiSharpDemo
{
    class Program
    {
        static void Main(string[] args)
        {

            CDBFapi demo = new CDBFapi();

            if (!demo.libraryLoaded()) return;

            Console.WriteLine("CDBFAPI Demo {0}\n", Process.GetCurrentProcess().MainModule.FileName);
            Console.WriteLine("CDBFAPI object {0}\n", demo);

            string filename = Process.GetCurrentProcess().MainModule.FileName;
            int last = filename.LastIndexOf("\\");

            filename = filename.Remove(last);
            filename = string.Concat(filename, "\\example.dbf");

            Console.WriteLine("Filename {0}", filename);

            demo.initLibrary(0, "test@example.com");

            if (demo.openDBFfile(filename))
            {
                Console.WriteLine("Reccount = {0} | FieldCount = {1} | RecordLength = {2}",
                    demo.recCount(), demo.fieldCount(), demo.recordLength());

                demo.setDateFormat("dmy");

                for (int j = 0; j < demo.fieldCount(); j++)
                {
                    Console.WriteLine("{0} {1}({2}.{3})", demo.fieldName(j), demo.fieldType(j), demo.fieldLength(j), demo.fieldDecimal(j));
                }
                Console.WriteLine("");

                EncodingInfo e = null;


                for (int i = 0; i < demo.recCount(); i++)
                {
                    demo.readRecord(i);

                    for (int j = 0; j < demo.fieldCount(); j++)
                    {
                        Console.Write("{0}|", demo.getString(j));
                        /*
                        if (demo.fieldType(j) == 'D')
                        {
                            DateTime dt = demo.getDateTime(j);
                            Int64 ticks = demo.getTicks(j);
                            Console.WriteLine("\n{0} {1}", dt.ToString(), ticks.ToString());
                            Console.ReadLine();
                        }
                        */
                    }
                    Console.WriteLine("");
                }

                demo.closeDBFfile();
            }

            Console.WriteLine("Press Enter to finish\n");

            Console.ReadLine();

        }
    }
}
