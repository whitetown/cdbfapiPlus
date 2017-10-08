using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using cdbfapi;

namespace CreateDBF
{
    class Program
    {
        static void Main(string[] args)
        {
            CDBFapi dbf = new CDBFapi();

            if (dbf.prepareNewTable(0))
            {
                dbf.addField("ID", 'N', 10);
                dbf.addField("NAME", 'C', 20);
                dbf.addField("BIRTH", 'D', 8);
                dbf.addField("WEIGHT", 'N', 10, 2);

                if (dbf.createTable("testfile.dbf")) 
                {
                    Console.WriteLine("OK");
                }
                else
                {
                    Console.WriteLine("Error");
                }
                Console.ReadLine();
            }

        }
    }
}
