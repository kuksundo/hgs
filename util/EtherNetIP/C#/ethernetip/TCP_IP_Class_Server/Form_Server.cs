using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace TCP_IP_Class_Server
{
    public partial class Form_Server : Form
    {
        TCP_IP_Class.TCP_IP_Class TCP_IP_Server = new TCP_IP_Class.TCP_IP_Class();

        public Form_Server()
        {
            InitializeComponent();

            TCP_IP_Server.event_datarecieve += new TCP_IP_Class.DataRecieveEventHandler(TCP_IP_Server_event_datarecieve);
        }

        void TCP_IP_Server_event_datarecieve(object sender, byte[] Bytes, int length)
        {
            byte[] data = Bytes;

            txt_re1.Text = Convert.ToString(data[0]);
            txt_re2.Text = Convert.ToString(data[1]);
            txt_re3.Text = Convert.ToString(data[2]);
            txt_re4.Text = Convert.ToString(data[3]);
            txt_re5.Text = Convert.ToString(data[4]);
            txt_re6.Text = Convert.ToString(data[5]);
            txt_re7.Text = Convert.ToString(data[6]);
            txt_re8.Text = Convert.ToString(data[7]);
            txt_re9.Text = Convert.ToString(data[8]);
            txt_re10.Text = Convert.ToString(data[9]);
            txt_re11.Text = Convert.ToString(data[10]);
            txt_re12.Text = Convert.ToString(data[11]);
            txt_re13.Text = Convert.ToString(data[12]);
            txt_re14.Text = Convert.ToString(data[13]);
            txt_re15.Text = Convert.ToString(data[14]);
            txt_re16.Text = Convert.ToString(data[15]);
            txt_re17.Text = Convert.ToString(data[16]);
            txt_re18.Text = Convert.ToString(data[17]);

            txt_renumber.Text = Convert.ToString(Convert.ToInt32(txt_renumber.Text) + 1);

            TCP_IP_Server.Trans(Bytes);
            txt_tr1.Text = Convert.ToString(data[0]);
            txt_tr2.Text = Convert.ToString(data[1]);
            txt_tr3.Text = Convert.ToString(data[2]);
            txt_tr4.Text = Convert.ToString(data[3]);
            txt_tr5.Text = Convert.ToString(data[4]);
            txt_tr6.Text = Convert.ToString(data[5]);
            txt_tr7.Text = Convert.ToString(data[6]);
            txt_tr8.Text = Convert.ToString(data[7]);
            txt_tr9.Text = Convert.ToString(data[8]);
            txt_tr10.Text = Convert.ToString(data[9]);
            txt_tr11.Text = Convert.ToString(data[10]);
            txt_tr12.Text = Convert.ToString(data[11]);
            txt_tr13.Text = Convert.ToString(data[12]);
            txt_tr14.Text = Convert.ToString(data[13]);
            txt_tr15.Text = Convert.ToString(data[14]);
            txt_tr16.Text = Convert.ToString(data[15]);
            txt_tr17.Text = Convert.ToString(data[16]);
            txt_tr18.Text = Convert.ToString(data[17]);
            txt_trnumber.Text = Convert.ToString(Convert.ToInt32(txt_trnumber.Text) + 1);
        }

        /************************************************************************/
        /*    Server Start 버튼 클릭 함수                                       */
        /************************************************************************/
        private void btn_Start_Click(object sender, EventArgs e)
        {
            string strIP = tbIP_1.Text + "." + tbIP_2.Text + "." + tbIP_3.Text + "." + tbIP_4.Text;
            Int32 nPort_No = Convert.ToInt32(tbPort_No.Text);

            TCP_IP_Server.Server_Init(strIP, nPort_No);

            TCP_IP_Server.Server_Start();

        }

        /************************************************************************/
        /*    Server Stop 버튼 클릭 함수                                        */
        /************************************************************************/
        private void btnStop_Click(object sender, EventArgs e)
        {
            TCP_IP_Server.Server_Stop();              
        }

        private void btnStart_Click(object sender, EventArgs e)
        {
            string strIP = tbIP_1.Text + "." + tbIP_2.Text + "." + tbIP_3.Text + "." + tbIP_4.Text;
            Int32 nPort_No = Convert.ToInt32(tbPort_No.Text);

            TCP_IP_Server.Server_Init(strIP, nPort_No);

            TCP_IP_Server.Server_Start();
        }





    }
}
