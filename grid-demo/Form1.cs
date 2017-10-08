using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;


using cdbfapi;

namespace grid
{
    public partial class Form1 : Form
    {
        CDBFapi demo = new CDBFapi();
      

        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            //You have to replace the values in initLibrary(...) to your registration information 
            demo.initLibrary(0, "test@example.com");

            if (demo.openDBFfile("example.dbf"))
            {
                dataGridView1.ColumnCount = demo.fieldCount();
                dataGridView1.RowCount = demo.recCount();

                for (int i = 0; i < demo.fieldCount(); i++)
                {
                    dataGridView1.Columns[i].Name = demo.fieldName(i);
                }
            }

            
        }

        private void dataGridView1_CellValueNeeded(object sender, DataGridViewCellValueEventArgs e)
        {
            demo.readRecord(e.RowIndex);
            e.Value = demo.getString(e.ColumnIndex);
        }

        private void dataGridView1_CellPainting(object sender, DataGridViewCellPaintingEventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            string s1 = textBox1.Text.Trim();
            int f = demo.indexOfField("FIRSTNAME");
            for(int i=0; i < demo.recCount(); i++)
            {
                demo.readRecord(i);
                string s2 = demo.getString(f);
                if (s1.Equals(s2.Trim()))
                {
                   // MessageBox.Show(s1, s2);
                    dataGridView1.ClearSelection();
                    dataGridView1.Rows[i].Selected = true;
                    dataGridView1.FirstDisplayedScrollingRowIndex = i;
                    dataGridView1.CurrentCell = dataGridView1[f, i];
                    dataGridView1.Focus();
                    break;
                }
            }

        }

        private void button2_Click(object sender, EventArgs e)
        {
//            MessageBox.Show(dataGridView1.CurrentRow.Index.ToString());
            demo.deleteRecord( dataGridView1.CurrentRow.Index );
            dataGridView1.RowCount = demo.recCount();
            dataGridView1.Refresh();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            demo.clearRecord();
            demo.setField(0, "one", null);
            demo.setField(1, "two", null);
            demo.setField(2, DateTime.Today.ToString(), null);
            demo.appendRecord(false);
            dataGridView1.RowCount = demo.recCount();
            dataGridView1.ClearSelection();
            int i = demo.recCount() - 1;
            dataGridView1.Rows[i].Selected = true;
            dataGridView1.FirstDisplayedScrollingRowIndex = i;
            dataGridView1.CurrentCell = dataGridView1[0, i];
            dataGridView1.Focus();
        }
    }
}
