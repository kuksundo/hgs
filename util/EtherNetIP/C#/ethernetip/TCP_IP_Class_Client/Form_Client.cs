using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace TCP_IP_Class_Client
{
    public partial class Form_Client : Form
    {
        TCP_IP_Class.TCP_IP_Class TCP_IP_Client = new TCP_IP_Class.TCP_IP_Class();        
        

        public Form_Client()
        {
            InitializeComponent();
            TCP_IP_Client.event_datarecieve += new TCP_IP_Class.DataRecieveEventHandler(TCP_IP_Client_event_datarecieve);

        }

        void TCP_IP_Client_event_datarecieve(object sender, byte[] Bytes, int length)
        {
            byte[] data = Bytes;

            string str = BitConverter.ToString(data);

            str = BitConverter.ToString(data).Replace("-", " ");

            textBox7.Text = str;

        }

        /************************************************************************/
        /*    Connect 버튼 클릭 함수                                            */
        /************************************************************************/
        private void btnConnect_Click(object sender, EventArgs e)
        {
            // 1. IP & Port 번호 설정
            string Server_IP = tbServer_IP_1.Text + "." + tbServer_IP_2.Text + "." + tbServer_IP_3.Text + "." + tbServer_IP_4.Text;
            string Client_IP = tbClient_IP_1.Text + "." + tbClient_IP_2.Text + "." + tbClient_IP_3.Text + "." + tbClient_IP_4.Text;

            Int32 Server_Port_No = Convert.ToInt32(tbServer_Port_No.Text);
            Int32 Client_Port_No = Convert.ToInt32(tbClient_Port_No.Text);

            // 2. 클라이언트 초기화
            TCP_IP_Client.Client_Init(Server_IP, Server_Port_No, Client_IP, Client_Port_No);

            // 3. 클라이언트 연결
            TCP_IP_Client.Client_Connect();
        }
        /************************************************************************/
        /*    Disconnect 버튼 클릭 함수                                         */
        /************************************************************************/
        private void btnDisconect_Click(object sender, EventArgs e)
        {
            TCP_IP_Client.Client_Disonnect();
        }

        /************************************************************************/
        /*    Transmit 버튼 클릭 함수                                           */
        /************************************************************************/
        private void btnTrans_Click(object sender, EventArgs e)
        {
   //         TCP_IP_Client.Trans(tbTrans.Text);
        }

        /************************************************************************/
        /*    Receive Message Clear 버튼 클릭 함수                              */
        /************************************************************************/


        private void timer1_Tick(object sender, EventArgs e)
        {
            button5.PerformClick();

        }

        private void button1_Click(object sender, EventArgs e)
        {
            timer1.Enabled = true;
        }

        private void button2_Click(object sender, EventArgs e)
        {
            timer1.Enabled = false;
        }

        private void button3_Click(object sender, EventArgs e)
        {
            string[] hexValuesSplit = txt_tr1.Text.Split(' ');

            byte[] txdata = new byte[hexValuesSplit.Length];

            for (int i = 0; i < hexValuesSplit.Length; i++)
            {
                txdata[i] = Convert.ToByte(hexValuesSplit[i], 16);

            }
            TCP_IP_Client.Trans(txdata);
        }

        private void button4_Click(object sender, EventArgs e)
        {

            string[] hexValuesSplit = textBox5.Text.Split(' ');

            byte[] txdata = new byte[hexValuesSplit.Length];

            for (int i = 0; i < hexValuesSplit.Length; i++)
            {
                txdata[i] = Convert.ToByte(hexValuesSplit[i], 16);

            }
            TCP_IP_Client.Trans(txdata);
        }

        private void button5_Click(object sender, EventArgs e)
        {
            string[] hexValuesSplit = textBox8.Text.Split(' ');

            byte[] txdata = new byte[hexValuesSplit.Length];

            for (int i = 0; i < hexValuesSplit.Length; i++)
            {
                txdata[i] = Convert.ToByte(hexValuesSplit[i], 16);

            }
            TCP_IP_Client.Trans(txdata);
        }



        
    }
}
