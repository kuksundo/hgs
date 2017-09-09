using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

// Network
using System.Net;
using System.Net.Sockets;

// Thread
using System.Threading;

using System.Windows.Forms;

// Background Worker
using System.ComponentModel;


namespace TCP_IP_Class
{
    /// <summary>
    /// 
    /// </summary>
    /// <param name="sender"></param>
    /// <param name="Bytes"></param>
    /// <param name="length"></param>
    public delegate void DataRecieveEventHandler(object sender, byte[] Bytes, int length);

    public class TCP_IP_Class
    {
        public const int Server_start = 0;
        public const int Server_connect_wait = 1;
        public const int Server_connect_complete = 2;
        public const int Server_stop = 3;

        public const int Client_connect_complete = 100;
        public const int Client_stop = 101;

        public const int Data_Recieve = 200;

        public event DataRecieveEventHandler event_datarecieve;

        TcpListener Server = null;
        TcpClient Client = null;
        NetworkStream Stream = null;
        IPEndPoint Server_Address = null;
        IPEndPoint Client_Address = null;


        BackgroundWorker bwStart = new BackgroundWorker();
        BackgroundWorker bwConnect = new BackgroundWorker();
        BackgroundWorker bwReceive = new BackgroundWorker();
        BackgroundWorker bwTrans = new BackgroundWorker();



        string strServer_IP;
        string strClient_IP;
        Int32 nServer_Port_No;
        Int32 nClient_Port_No;

        byte[] Trans_Data;


        bool bServer_On_Flag = false;

        public TCP_IP_Class()
        {
            System.Windows.Forms.Control.CheckForIllegalCrossThreadCalls = false;
        }


        /************************************************************************/
        /*    Server Init 함수                                                  */
        /************************************************************************/
        public void Server_Init(string Server_IP, Int32 Server_Port_No)
        {
            // setcallback 함수 사용하지 않아도 되도록 옵션....            
       //     System.Windows.Forms.Control.CheckForIllegalCrossThreadCalls = false;

            // Background Worker 이벤트 함수 설정
            this.bwStart.DoWork += new System.ComponentModel.DoWorkEventHandler(this.bwStart_DoWork);
            this.bwReceive.DoWork += new System.ComponentModel.DoWorkEventHandler(this.bwReceive_DoWork);
            this.bwTrans.DoWork += new System.ComponentModel.DoWorkEventHandler(this.bwTrans_DoWork);

            // IP, Port 설정
            this.strServer_IP = Server_IP;
            this.nServer_Port_No = Server_Port_No;


        }

        /************************************************************************/
        /*    Client Init 함수                                                  */
        /************************************************************************/
        public void Client_Init(string Server_IP, Int32 Server_Port_No, string Client_IP, Int32 Client_Port_No)
        {

            // Background Worker 이벤트 함수 설정
            this.bwStart.DoWork += new System.ComponentModel.DoWorkEventHandler(this.bwStart_DoWork);
            this.bwConnect.DoWork += new System.ComponentModel.DoWorkEventHandler(this.bwConnect_DoWork);
            this.bwReceive.DoWork += new System.ComponentModel.DoWorkEventHandler(this.bwReceive_DoWork);
            this.bwTrans.DoWork += new System.ComponentModel.DoWorkEventHandler(this.bwTrans_DoWork);

            // IP, Port 설정
            this.strServer_IP = Server_IP;
            this.strClient_IP = Client_IP;
            this.nServer_Port_No = Server_Port_No;
            this.nClient_Port_No = Client_Port_No;



        }

        /************************************************************************/
        /*    Server Start 함수                                                 */
        /************************************************************************/
        public void Server_Start()
        {
            Server_Start_Func();
        }
        /************************************************************************/
        /*    Server Stop 함수                                                  */
        /************************************************************************/
        public void Server_Stop()
        {
            Server_Stop_Func();
        }
        /************************************************************************/
        /*    Client Connent 함수                                               */
        /************************************************************************/
        public void Client_Connect()
        {
            Client_Connect_Func();
        }
        /************************************************************************/
        /*    Client Disonnent 함수                                             */
        /************************************************************************/
        public void Client_Disonnect()
        {
            Client_Disconnect_Func();
        }
        /************************************************************************/
        /*    Message 송신 함수                                                 */
        /************************************************************************/
        public void Trans(byte[] Data)
        {
            this.Trans_Data = Data;
            bwTrans.RunWorkerAsync();
        }


        //////////////////////////////////////////////////////////////////////////
        // 외부 접근 함수 End
        //////////////////////////////////////////////////////////////////////////

        //////////////////////////////////////////////////////////////////////////
        // 내부 실행 함수 Start
        //////////////////////////////////////////////////////////////////////////

        /************************************************************************/
        /*    Server Start 실행 함수                                            */
        /************************************************************************/
        private void Server_Start_Func()
        {
            // Server 세팅


            Server_Address = new IPEndPoint(IPAddress.Parse(this.strServer_IP), this.nServer_Port_No);
            Server = new TcpListener(Server_Address);

            // Server 시작
            try
            {
                Server.Start();                                         // 서버 시작
                MessageBox.Show("서버 시작됨!");
                bServer_On_Flag = true;                                 // 서버 시작 Flag On
                bwStart.RunWorkerAsync();                               // client 기다림--> Thread 시작
            }
            catch
            {
            //    tbStatus.Text = "서버 시작 오류...\r\n";
            }

        }

        /************************************************************************/
        /*    Server Stop 실행 함수                                             */
        /************************************************************************/
        private void Server_Stop_Func()
        {
            Port_Close_Func();

            if (bServer_On_Flag == true)
            {
                try
                {
                    Server.Stop();                                      // 서버 Stop
                    bServer_On_Flag = false;                            // 서버 Stop Flag Off

                }
                catch
                {
                //    tbStatus.Text += "서버 종료 오류";

                }
            }
        }
        /************************************************************************/
        /*    Port Close 실행 함수                                              */
        /************************************************************************/
        private void Port_Close_Func()
        {
            if (bwReceive.IsBusy == true)
            {
                bwReceive.WorkerSupportsCancellation = true;    // 수신 Thread 종료 요청 Flag
                bwReceive.CancelAsync();                        // 수신 Thread 종료 요청
            }

            if (Stream != null)
                Stream.Close();

            if (Client != null)
                Client.Close();

        }

        /************************************************************************/
        /*    Client Connect 실행 함수                                          */
        /************************************************************************/
        private void Client_Connect_Func()
        {
            // 1. Server & Client 세팅
            Server_Address = new IPEndPoint(IPAddress.Parse(strServer_IP), nServer_Port_No);
            Client_Address = new IPEndPoint(IPAddress.Parse(strClient_IP), nClient_Port_No);


            // 3. Client 객체 할당
            try
            {
                Client = new TcpClient(Client_Address);           
                // 4. 연결 Thread 함수 실행
                bwConnect.RunWorkerAsync();
            }
            catch
            {
                MessageBox.Show("클라 아이피 오류!");

            }
            

            
        }
        /************************************************************************/
        /*    Client Disconnect 실행 함수                                       */
        /************************************************************************/
        private void Client_Disconnect_Func()
        {
            Port_Close_Func();          // Port Close 함수  실행
        }

        /************************************************************************/
        /*    Thread - bwStart : Server Start 실행 함수                         */
        /************************************************************************/
        private void bwStart_DoWork(object sender, DoWorkEventArgs e)
        {
            try
            {
                Client = Server.AcceptTcpClient();        // 요청 여부 확인 --> 요청 올 때 까지 계속 기다림...?     

                MessageBox.Show("클라 연결됨!");
                bwReceive.RunWorkerAsync();             // Receive Thread 실행

            }
            catch (ArgumentException ee)
            {
             //   tbStatus.AppendText(string.Format("입력 인수 에러 : {0}\r\n", ee.ToString()));

            }
            catch (SocketException ee)
            {
            //    tbStatus.AppendText(string.Format("네트워크 에러 : {0}\r\n", ee.ToString()));
            }
            finally
            {

            }
        }

        /************************************************************************/
        /*    Thread - bwConnect : 연결 Thread 실행 함수                        */
        /************************************************************************/
        private void bwConnect_DoWork(object sender, DoWorkEventArgs e)
        {
            try
            {
                Client.Connect(Server_Address);                        // 연결 실행... 연결 시 까지 기다림...               

                MessageBox.Show("연결됨!");

                bwReceive.RunWorkerAsync();                             // Receive Thread 실행
            }
            catch (ArgumentException ee)
            {
             //   tbStatus.Text += string.Format("입력 인수 에러 : {0}\r\n", ee.ToString());
            }
            catch (SocketException ee)
            {
            //    tbStatus.Text += "네트워크 에러 : 포트 번호를 변경해서 시도하세요.\r\n";
            }

        }

        /************************************************************************/
        /*    Thread - bwReceive : Message 수신 실행 함수                       */
        /************************************************************************/
        private void bwReceive_DoWork(object sender, DoWorkEventArgs e)
        {
            BackgroundWorker bw = sender as BackgroundWorker;

            int Length;
            string Data = null;
            byte[] Bytes = new byte[256];

            while (true)
            {
                if (bw.CancellationPending)         // Thread 종료 신호가 들어오면 종료 처리 함
                {
                    e.Cancel = true;
                    break;
                }

                try
                {
                    Stream = Client.GetStream();
                    Length = Stream.Read(Bytes, 0, Bytes.Length);

                    event_datarecieve(this, Bytes, Length);

                }
                catch
                {
                    break;
                }
            }

         //   tbStatus.Text = "연결이 해제 되었습니다.\r\n재 연결을 위해서 Start를 클릭하세요.";

            Server_Stop_Func();                                     // 서버/클라이언트 종료 함수 실행  
        }
        /************************************************************************/
        /*    Thread - bwTrans : Message 송신 실행 함수                         */
        /************************************************************************/
        private void bwTrans_DoWork(object sender, DoWorkEventArgs e)
        {
            Stream = Client.GetStream();
            Stream.Write(Trans_Data, 0, Trans_Data.Length);
        }

    }


}


