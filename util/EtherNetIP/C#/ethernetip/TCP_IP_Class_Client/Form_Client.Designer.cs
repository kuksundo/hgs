namespace TCP_IP_Class_Client
{
    partial class Form_Client
    {
        /// <summary>
        /// 필수 디자이너 변수입니다.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 사용 중인 모든 리소스를 정리합니다.
        /// </summary>
        /// <param name="disposing">관리되는 리소스를 삭제해야 하면 true이고, 그렇지 않으면 false입니다.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form 디자이너에서 생성한 코드

        /// <summary>
        /// 디자이너 지원에 필요한 메서드입니다.
        /// 이 메서드의 내용을 코드 편집기로 수정하지 마십시오.
        /// </summary>
        private void InitializeComponent()
        {
            this.components = new System.ComponentModel.Container();
            this.groupBox3 = new System.Windows.Forms.GroupBox();
            this.btnConnect = new System.Windows.Forms.Button();
            this.btnDisconect = new System.Windows.Forms.Button();
            this.groupBox2 = new System.Windows.Forms.GroupBox();
            this.tbClient_IP_4 = new System.Windows.Forms.TextBox();
            this.tbClient_IP_3 = new System.Windows.Forms.TextBox();
            this.tbClient_IP_2 = new System.Windows.Forms.TextBox();
            this.tbClient_Port_No = new System.Windows.Forms.TextBox();
            this.tbClient_IP_1 = new System.Windows.Forms.TextBox();
            this.label1 = new System.Windows.Forms.Label();
            this.label2 = new System.Windows.Forms.Label();
            this.label3 = new System.Windows.Forms.Label();
            this.label10 = new System.Windows.Forms.Label();
            this.label11 = new System.Windows.Forms.Label();
            this.label12 = new System.Windows.Forms.Label();
            this.groupBox1 = new System.Windows.Forms.GroupBox();
            this.tbServer_IP_4 = new System.Windows.Forms.TextBox();
            this.tbServer_IP_3 = new System.Windows.Forms.TextBox();
            this.tbServer_IP_2 = new System.Windows.Forms.TextBox();
            this.tbServer_Port_No = new System.Windows.Forms.TextBox();
            this.tbServer_IP_1 = new System.Windows.Forms.TextBox();
            this.label8 = new System.Windows.Forms.Label();
            this.label7 = new System.Windows.Forms.Label();
            this.label6 = new System.Windows.Forms.Label();
            this.label9 = new System.Windows.Forms.Label();
            this.label5 = new System.Windows.Forms.Label();
            this.label4 = new System.Windows.Forms.Label();
            this.timer1 = new System.Windows.Forms.Timer(this.components);
            this.txt_tr1 = new System.Windows.Forms.TextBox();
            this.label13 = new System.Windows.Forms.Label();
            this.groupBox4 = new System.Windows.Forms.GroupBox();
            this.label22 = new System.Windows.Forms.Label();
            this.label15 = new System.Windows.Forms.Label();
            this.textBox2 = new System.Windows.Forms.TextBox();
            this.button3 = new System.Windows.Forms.Button();
            this.label14 = new System.Windows.Forms.Label();
            this.textBox1 = new System.Windows.Forms.TextBox();
            this.button1 = new System.Windows.Forms.Button();
            this.button2 = new System.Windows.Forms.Button();
            this.groupBox6 = new System.Windows.Forms.GroupBox();
            this.label23 = new System.Windows.Forms.Label();
            this.label16 = new System.Windows.Forms.Label();
            this.textBox3 = new System.Windows.Forms.TextBox();
            this.button4 = new System.Windows.Forms.Button();
            this.label17 = new System.Windows.Forms.Label();
            this.textBox4 = new System.Windows.Forms.TextBox();
            this.label18 = new System.Windows.Forms.Label();
            this.textBox5 = new System.Windows.Forms.TextBox();
            this.groupBox7 = new System.Windows.Forms.GroupBox();
            this.label24 = new System.Windows.Forms.Label();
            this.label19 = new System.Windows.Forms.Label();
            this.textBox6 = new System.Windows.Forms.TextBox();
            this.label20 = new System.Windows.Forms.Label();
            this.textBox7 = new System.Windows.Forms.TextBox();
            this.label21 = new System.Windows.Forms.Label();
            this.textBox8 = new System.Windows.Forms.TextBox();
            this.button5 = new System.Windows.Forms.Button();
            this.groupBox3.SuspendLayout();
            this.groupBox2.SuspendLayout();
            this.groupBox1.SuspendLayout();
            this.groupBox4.SuspendLayout();
            this.groupBox6.SuspendLayout();
            this.groupBox7.SuspendLayout();
            this.SuspendLayout();
            // 
            // groupBox3
            // 
            this.groupBox3.Controls.Add(this.btnConnect);
            this.groupBox3.Controls.Add(this.btnDisconect);
            this.groupBox3.Location = new System.Drawing.Point(12, 12);
            this.groupBox3.Name = "groupBox3";
            this.groupBox3.Size = new System.Drawing.Size(193, 81);
            this.groupBox3.TabIndex = 17;
            this.groupBox3.TabStop = false;
            this.groupBox3.Text = "Status";
            // 
            // btnConnect
            // 
            this.btnConnect.Location = new System.Drawing.Point(7, 26);
            this.btnConnect.Name = "btnConnect";
            this.btnConnect.Size = new System.Drawing.Size(87, 39);
            this.btnConnect.TabIndex = 0;
            this.btnConnect.Text = "Connect";
            this.btnConnect.UseVisualStyleBackColor = true;
            this.btnConnect.Click += new System.EventHandler(this.btnConnect_Click);
            // 
            // btnDisconect
            // 
            this.btnDisconect.Location = new System.Drawing.Point(100, 26);
            this.btnDisconect.Name = "btnDisconect";
            this.btnDisconect.Size = new System.Drawing.Size(87, 39);
            this.btnDisconect.TabIndex = 0;
            this.btnDisconect.Text = "Disconnect";
            this.btnDisconect.UseVisualStyleBackColor = true;
            this.btnDisconect.Click += new System.EventHandler(this.btnDisconect_Click);
            // 
            // groupBox2
            // 
            this.groupBox2.Controls.Add(this.tbClient_IP_4);
            this.groupBox2.Controls.Add(this.tbClient_IP_3);
            this.groupBox2.Controls.Add(this.tbClient_IP_2);
            this.groupBox2.Controls.Add(this.tbClient_Port_No);
            this.groupBox2.Controls.Add(this.tbClient_IP_1);
            this.groupBox2.Controls.Add(this.label1);
            this.groupBox2.Controls.Add(this.label2);
            this.groupBox2.Controls.Add(this.label3);
            this.groupBox2.Controls.Add(this.label10);
            this.groupBox2.Controls.Add(this.label11);
            this.groupBox2.Controls.Add(this.label12);
            this.groupBox2.Location = new System.Drawing.Point(485, 12);
            this.groupBox2.Name = "groupBox2";
            this.groupBox2.Size = new System.Drawing.Size(257, 81);
            this.groupBox2.TabIndex = 15;
            this.groupBox2.TabStop = false;
            this.groupBox2.Text = "Client Setting";
            // 
            // tbClient_IP_4
            // 
            this.tbClient_IP_4.Location = new System.Drawing.Point(201, 20);
            this.tbClient_IP_4.Name = "tbClient_IP_4";
            this.tbClient_IP_4.Size = new System.Drawing.Size(37, 21);
            this.tbClient_IP_4.TabIndex = 17;
            this.tbClient_IP_4.Text = "2";
            // 
            // tbClient_IP_3
            // 
            this.tbClient_IP_3.Location = new System.Drawing.Point(151, 20);
            this.tbClient_IP_3.Name = "tbClient_IP_3";
            this.tbClient_IP_3.Size = new System.Drawing.Size(37, 21);
            this.tbClient_IP_3.TabIndex = 16;
            this.tbClient_IP_3.Text = "100";
            // 
            // tbClient_IP_2
            // 
            this.tbClient_IP_2.Location = new System.Drawing.Point(100, 20);
            this.tbClient_IP_2.Name = "tbClient_IP_2";
            this.tbClient_IP_2.Size = new System.Drawing.Size(37, 21);
            this.tbClient_IP_2.TabIndex = 20;
            this.tbClient_IP_2.Text = "168";
            // 
            // tbClient_Port_No
            // 
            this.tbClient_Port_No.Location = new System.Drawing.Point(49, 47);
            this.tbClient_Port_No.Name = "tbClient_Port_No";
            this.tbClient_Port_No.Size = new System.Drawing.Size(37, 21);
            this.tbClient_Port_No.TabIndex = 19;
            this.tbClient_Port_No.Text = "2001";
            // 
            // tbClient_IP_1
            // 
            this.tbClient_IP_1.Location = new System.Drawing.Point(49, 20);
            this.tbClient_IP_1.Name = "tbClient_IP_1";
            this.tbClient_IP_1.Size = new System.Drawing.Size(37, 21);
            this.tbClient_IP_1.TabIndex = 18;
            this.tbClient_IP_1.Text = "192";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(190, 26);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(9, 12);
            this.label1.TabIndex = 15;
            this.label1.Text = ".";
            // 
            // label2
            // 
            this.label2.AutoSize = true;
            this.label2.Location = new System.Drawing.Point(139, 26);
            this.label2.Name = "label2";
            this.label2.Size = new System.Drawing.Size(9, 12);
            this.label2.TabIndex = 10;
            this.label2.Text = ".";
            // 
            // label3
            // 
            this.label3.AutoSize = true;
            this.label3.Location = new System.Drawing.Point(88, 26);
            this.label3.Name = "label3";
            this.label3.Size = new System.Drawing.Size(9, 12);
            this.label3.TabIndex = 12;
            this.label3.Text = ".";
            // 
            // label10
            // 
            this.label10.AutoSize = true;
            this.label10.Location = new System.Drawing.Point(96, 52);
            this.label10.Name = "label10";
            this.label10.Size = new System.Drawing.Size(125, 12);
            this.label10.TabIndex = 14;
            this.label10.Text = "1024 이상의 값을 사용";
            // 
            // label11
            // 
            this.label11.AutoSize = true;
            this.label11.Location = new System.Drawing.Point(8, 56);
            this.label11.Name = "label11";
            this.label11.Size = new System.Drawing.Size(35, 12);
            this.label11.TabIndex = 13;
            this.label11.Text = "Port :";
            // 
            // label12
            // 
            this.label12.AutoSize = true;
            this.label12.Location = new System.Drawing.Point(19, 23);
            this.label12.Name = "label12";
            this.label12.Size = new System.Drawing.Size(24, 12);
            this.label12.TabIndex = 11;
            this.label12.Text = "IP :";
            // 
            // groupBox1
            // 
            this.groupBox1.Controls.Add(this.tbServer_IP_4);
            this.groupBox1.Controls.Add(this.tbServer_IP_3);
            this.groupBox1.Controls.Add(this.tbServer_IP_2);
            this.groupBox1.Controls.Add(this.tbServer_Port_No);
            this.groupBox1.Controls.Add(this.tbServer_IP_1);
            this.groupBox1.Controls.Add(this.label8);
            this.groupBox1.Controls.Add(this.label7);
            this.groupBox1.Controls.Add(this.label6);
            this.groupBox1.Controls.Add(this.label9);
            this.groupBox1.Controls.Add(this.label5);
            this.groupBox1.Controls.Add(this.label4);
            this.groupBox1.Location = new System.Drawing.Point(222, 12);
            this.groupBox1.Name = "groupBox1";
            this.groupBox1.Size = new System.Drawing.Size(257, 81);
            this.groupBox1.TabIndex = 16;
            this.groupBox1.TabStop = false;
            this.groupBox1.Text = "Server Setting";
            // 
            // tbServer_IP_4
            // 
            this.tbServer_IP_4.Location = new System.Drawing.Point(201, 20);
            this.tbServer_IP_4.Name = "tbServer_IP_4";
            this.tbServer_IP_4.Size = new System.Drawing.Size(37, 21);
            this.tbServer_IP_4.TabIndex = 17;
            this.tbServer_IP_4.Text = "236";
            // 
            // tbServer_IP_3
            // 
            this.tbServer_IP_3.Location = new System.Drawing.Point(151, 20);
            this.tbServer_IP_3.Name = "tbServer_IP_3";
            this.tbServer_IP_3.Size = new System.Drawing.Size(37, 21);
            this.tbServer_IP_3.TabIndex = 16;
            this.tbServer_IP_3.Text = "100";
            // 
            // tbServer_IP_2
            // 
            this.tbServer_IP_2.Location = new System.Drawing.Point(100, 20);
            this.tbServer_IP_2.Name = "tbServer_IP_2";
            this.tbServer_IP_2.Size = new System.Drawing.Size(37, 21);
            this.tbServer_IP_2.TabIndex = 20;
            this.tbServer_IP_2.Text = "168";
            // 
            // tbServer_Port_No
            // 
            this.tbServer_Port_No.Location = new System.Drawing.Point(49, 47);
            this.tbServer_Port_No.Name = "tbServer_Port_No";
            this.tbServer_Port_No.Size = new System.Drawing.Size(37, 21);
            this.tbServer_Port_No.TabIndex = 19;
            this.tbServer_Port_No.Text = "44818";
            // 
            // tbServer_IP_1
            // 
            this.tbServer_IP_1.Location = new System.Drawing.Point(49, 20);
            this.tbServer_IP_1.Name = "tbServer_IP_1";
            this.tbServer_IP_1.Size = new System.Drawing.Size(37, 21);
            this.tbServer_IP_1.TabIndex = 18;
            this.tbServer_IP_1.Text = "192";
            // 
            // label8
            // 
            this.label8.AutoSize = true;
            this.label8.Location = new System.Drawing.Point(190, 26);
            this.label8.Name = "label8";
            this.label8.Size = new System.Drawing.Size(9, 12);
            this.label8.TabIndex = 15;
            this.label8.Text = ".";
            // 
            // label7
            // 
            this.label7.AutoSize = true;
            this.label7.Location = new System.Drawing.Point(139, 26);
            this.label7.Name = "label7";
            this.label7.Size = new System.Drawing.Size(9, 12);
            this.label7.TabIndex = 10;
            this.label7.Text = ".";
            // 
            // label6
            // 
            this.label6.AutoSize = true;
            this.label6.Location = new System.Drawing.Point(88, 26);
            this.label6.Name = "label6";
            this.label6.Size = new System.Drawing.Size(9, 12);
            this.label6.TabIndex = 12;
            this.label6.Text = ".";
            // 
            // label9
            // 
            this.label9.AutoSize = true;
            this.label9.Location = new System.Drawing.Point(96, 52);
            this.label9.Name = "label9";
            this.label9.Size = new System.Drawing.Size(125, 12);
            this.label9.TabIndex = 14;
            this.label9.Text = "1024 이상의 값을 사용";
            // 
            // label5
            // 
            this.label5.AutoSize = true;
            this.label5.Location = new System.Drawing.Point(8, 56);
            this.label5.Name = "label5";
            this.label5.Size = new System.Drawing.Size(35, 12);
            this.label5.TabIndex = 13;
            this.label5.Text = "Port :";
            // 
            // label4
            // 
            this.label4.AutoSize = true;
            this.label4.Location = new System.Drawing.Point(19, 23);
            this.label4.Name = "label4";
            this.label4.Size = new System.Drawing.Size(24, 12);
            this.label4.TabIndex = 11;
            this.label4.Text = "IP :";
            // 
            // timer1
            // 
            this.timer1.Interval = 500;
            this.timer1.Tick += new System.EventHandler(this.timer1_Tick);
            // 
            // txt_tr1
            // 
            this.txt_tr1.Font = new System.Drawing.Font("Consolas", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.txt_tr1.Location = new System.Drawing.Point(6, 63);
            this.txt_tr1.Multiline = true;
            this.txt_tr1.Name = "txt_tr1";
            this.txt_tr1.Size = new System.Drawing.Size(181, 67);
            this.txt_tr1.TabIndex = 19;
            this.txt_tr1.Text = "04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00";
            // 
            // label13
            // 
            this.label13.AutoSize = true;
            this.label13.Location = new System.Drawing.Point(9, 48);
            this.label13.Name = "label13";
            this.label13.Size = new System.Drawing.Size(15, 12);
            this.label13.TabIndex = 21;
            this.label13.Text = "tx";
            // 
            // groupBox4
            // 
            this.groupBox4.Controls.Add(this.label22);
            this.groupBox4.Controls.Add(this.label15);
            this.groupBox4.Controls.Add(this.textBox2);
            this.groupBox4.Controls.Add(this.button3);
            this.groupBox4.Controls.Add(this.label14);
            this.groupBox4.Controls.Add(this.textBox1);
            this.groupBox4.Controls.Add(this.label13);
            this.groupBox4.Controls.Add(this.txt_tr1);
            this.groupBox4.Location = new System.Drawing.Point(12, 99);
            this.groupBox4.Name = "groupBox4";
            this.groupBox4.Size = new System.Drawing.Size(193, 310);
            this.groupBox4.TabIndex = 55;
            this.groupBox4.TabStop = false;
            this.groupBox4.Text = "List services";
            // 
            // label22
            // 
            this.label22.AutoSize = true;
            this.label22.Location = new System.Drawing.Point(6, 31);
            this.label22.Name = "label22";
            this.label22.Size = new System.Drawing.Size(97, 12);
            this.label22.TabIndex = 62;
            this.label22.Text = "서비스 종류 문의";
            // 
            // label15
            // 
            this.label15.AutoSize = true;
            this.label15.Location = new System.Drawing.Point(6, 243);
            this.label15.Name = "label15";
            this.label15.Size = new System.Drawing.Size(41, 12);
            this.label15.TabIndex = 61;
            this.label15.Text = "메세지";
            // 
            // textBox2
            // 
            this.textBox2.Location = new System.Drawing.Point(6, 258);
            this.textBox2.Multiline = true;
            this.textBox2.Name = "textBox2";
            this.textBox2.ReadOnly = true;
            this.textBox2.Size = new System.Drawing.Size(181, 46);
            this.textBox2.TabIndex = 60;
            // 
            // button3
            // 
            this.button3.Location = new System.Drawing.Point(104, 20);
            this.button3.Name = "button3";
            this.button3.Size = new System.Drawing.Size(83, 34);
            this.button3.TabIndex = 59;
            this.button3.Text = "전송";
            this.button3.UseVisualStyleBackColor = true;
            this.button3.Click += new System.EventHandler(this.button3_Click);
            // 
            // label14
            // 
            this.label14.AutoSize = true;
            this.label14.Location = new System.Drawing.Point(9, 133);
            this.label14.Name = "label14";
            this.label14.Size = new System.Drawing.Size(16, 12);
            this.label14.TabIndex = 23;
            this.label14.Text = "rx";
            // 
            // textBox1
            // 
            this.textBox1.Location = new System.Drawing.Point(6, 148);
            this.textBox1.Multiline = true;
            this.textBox1.Name = "textBox1";
            this.textBox1.ReadOnly = true;
            this.textBox1.Size = new System.Drawing.Size(181, 92);
            this.textBox1.TabIndex = 22;
            // 
            // button1
            // 
            this.button1.Location = new System.Drawing.Point(128, 264);
            this.button1.Name = "button1";
            this.button1.Size = new System.Drawing.Size(100, 40);
            this.button1.TabIndex = 57;
            this.button1.Text = "연속전송";
            this.button1.UseVisualStyleBackColor = true;
            this.button1.Click += new System.EventHandler(this.button1_Click);
            // 
            // button2
            // 
            this.button2.Location = new System.Drawing.Point(249, 264);
            this.button2.Name = "button2";
            this.button2.Size = new System.Drawing.Size(100, 40);
            this.button2.TabIndex = 58;
            this.button2.Text = "전송종료";
            this.button2.UseVisualStyleBackColor = true;
            this.button2.Click += new System.EventHandler(this.button2_Click);
            // 
            // groupBox6
            // 
            this.groupBox6.Controls.Add(this.label23);
            this.groupBox6.Controls.Add(this.label16);
            this.groupBox6.Controls.Add(this.textBox3);
            this.groupBox6.Controls.Add(this.button4);
            this.groupBox6.Controls.Add(this.label17);
            this.groupBox6.Controls.Add(this.textBox4);
            this.groupBox6.Controls.Add(this.label18);
            this.groupBox6.Controls.Add(this.textBox5);
            this.groupBox6.Location = new System.Drawing.Point(222, 99);
            this.groupBox6.Name = "groupBox6";
            this.groupBox6.Size = new System.Drawing.Size(193, 310);
            this.groupBox6.TabIndex = 62;
            this.groupBox6.TabStop = false;
            this.groupBox6.Text = "Register Session";
            // 
            // label23
            // 
            this.label23.AutoSize = true;
            this.label23.Location = new System.Drawing.Point(6, 31);
            this.label23.Name = "label23";
            this.label23.Size = new System.Drawing.Size(85, 12);
            this.label23.TabIndex = 63;
            this.label23.Text = "세션 등록 요청";
            // 
            // label16
            // 
            this.label16.AutoSize = true;
            this.label16.Location = new System.Drawing.Point(6, 243);
            this.label16.Name = "label16";
            this.label16.Size = new System.Drawing.Size(41, 12);
            this.label16.TabIndex = 61;
            this.label16.Text = "핸들값";
            // 
            // textBox3
            // 
            this.textBox3.Location = new System.Drawing.Point(6, 258);
            this.textBox3.Multiline = true;
            this.textBox3.Name = "textBox3";
            this.textBox3.ReadOnly = true;
            this.textBox3.Size = new System.Drawing.Size(181, 46);
            this.textBox3.TabIndex = 60;
            // 
            // button4
            // 
            this.button4.Location = new System.Drawing.Point(104, 20);
            this.button4.Name = "button4";
            this.button4.Size = new System.Drawing.Size(83, 34);
            this.button4.TabIndex = 59;
            this.button4.Text = "전송";
            this.button4.UseVisualStyleBackColor = true;
            this.button4.Click += new System.EventHandler(this.button4_Click);
            // 
            // label17
            // 
            this.label17.AutoSize = true;
            this.label17.Location = new System.Drawing.Point(9, 133);
            this.label17.Name = "label17";
            this.label17.Size = new System.Drawing.Size(16, 12);
            this.label17.TabIndex = 23;
            this.label17.Text = "rx";
            // 
            // textBox4
            // 
            this.textBox4.Location = new System.Drawing.Point(6, 148);
            this.textBox4.Multiline = true;
            this.textBox4.Name = "textBox4";
            this.textBox4.ReadOnly = true;
            this.textBox4.Size = new System.Drawing.Size(181, 92);
            this.textBox4.TabIndex = 22;
            // 
            // label18
            // 
            this.label18.AutoSize = true;
            this.label18.Location = new System.Drawing.Point(9, 48);
            this.label18.Name = "label18";
            this.label18.Size = new System.Drawing.Size(15, 12);
            this.label18.TabIndex = 21;
            this.label18.Text = "tx";
            // 
            // textBox5
            // 
            this.textBox5.Font = new System.Drawing.Font("Consolas", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBox5.Location = new System.Drawing.Point(6, 63);
            this.textBox5.Multiline = true;
            this.textBox5.Name = "textBox5";
            this.textBox5.Size = new System.Drawing.Size(181, 67);
            this.textBox5.TabIndex = 19;
            this.textBox5.Text = "65 00 04 00 00 00 00 00 00 00 00 00 01 00 02 00 00 00 85 01 00 00 00 00 01 00 00 " +
                "00";
            // 
            // groupBox7
            // 
            this.groupBox7.Controls.Add(this.button5);
            this.groupBox7.Controls.Add(this.label24);
            this.groupBox7.Controls.Add(this.label19);
            this.groupBox7.Controls.Add(this.textBox6);
            this.groupBox7.Controls.Add(this.button2);
            this.groupBox7.Controls.Add(this.button1);
            this.groupBox7.Controls.Add(this.label20);
            this.groupBox7.Controls.Add(this.textBox7);
            this.groupBox7.Controls.Add(this.label21);
            this.groupBox7.Controls.Add(this.textBox8);
            this.groupBox7.Location = new System.Drawing.Point(429, 99);
            this.groupBox7.Name = "groupBox7";
            this.groupBox7.Size = new System.Drawing.Size(355, 310);
            this.groupBox7.TabIndex = 63;
            this.groupBox7.TabStop = false;
            this.groupBox7.Text = "SendRRData";
            // 
            // label24
            // 
            this.label24.AutoSize = true;
            this.label24.Location = new System.Drawing.Point(6, 24);
            this.label24.Name = "label24";
            this.label24.Size = new System.Drawing.Size(311, 24);
            this.label24.TabIndex = 64;
            this.label24.Text = "CIP 패킷 전송 : 등록된 세션의 23번클래스-1번인스탄스-\r\n10번어트리뷰트에 14번 서비스 요청 (거리값 읽기)";
            // 
            // label19
            // 
            this.label19.AutoSize = true;
            this.label19.Location = new System.Drawing.Point(6, 218);
            this.label19.Name = "label19";
            this.label19.Size = new System.Drawing.Size(41, 12);
            this.label19.TabIndex = 61;
            this.label19.Text = "거리값";
            // 
            // textBox6
            // 
            this.textBox6.Location = new System.Drawing.Point(6, 233);
            this.textBox6.Name = "textBox6";
            this.textBox6.ReadOnly = true;
            this.textBox6.Size = new System.Drawing.Size(181, 21);
            this.textBox6.TabIndex = 60;
            // 
            // label20
            // 
            this.label20.AutoSize = true;
            this.label20.Location = new System.Drawing.Point(9, 133);
            this.label20.Name = "label20";
            this.label20.Size = new System.Drawing.Size(16, 12);
            this.label20.TabIndex = 23;
            this.label20.Text = "rx";
            // 
            // textBox7
            // 
            this.textBox7.Location = new System.Drawing.Point(6, 148);
            this.textBox7.Multiline = true;
            this.textBox7.Name = "textBox7";
            this.textBox7.ReadOnly = true;
            this.textBox7.Size = new System.Drawing.Size(343, 67);
            this.textBox7.TabIndex = 22;
            // 
            // label21
            // 
            this.label21.AutoSize = true;
            this.label21.Location = new System.Drawing.Point(9, 48);
            this.label21.Name = "label21";
            this.label21.Size = new System.Drawing.Size(15, 12);
            this.label21.TabIndex = 21;
            this.label21.Text = "tx";
            // 
            // textBox8
            // 
            this.textBox8.Font = new System.Drawing.Font("Consolas", 9F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.textBox8.Location = new System.Drawing.Point(6, 63);
            this.textBox8.Multiline = true;
            this.textBox8.Name = "textBox8";
            this.textBox8.Size = new System.Drawing.Size(343, 67);
            this.textBox8.TabIndex = 19;
            this.textBox8.Text = "6f 00 18 00 00 00 01 00 00 00 00 00 01 00 02 00 00 00 85 01 00 00 00 00 00 00 00 " +
                "00 1e 00 02 00 00 00 00 00 b2 00 08 00 0e 03 20 23 24 01 30 0a";
            // 
            // button5
            // 
            this.button5.Location = new System.Drawing.Point(6, 264);
            this.button5.Name = "button5";
            this.button5.Size = new System.Drawing.Size(100, 40);
            this.button5.TabIndex = 65;
            this.button5.Text = "한번전송";
            this.button5.UseVisualStyleBackColor = true;
            this.button5.Click += new System.EventHandler(this.button5_Click);
            // 
            // Form_Client
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(7F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(795, 421);
            this.Controls.Add(this.groupBox7);
            this.Controls.Add(this.groupBox6);
            this.Controls.Add(this.groupBox4);
            this.Controls.Add(this.groupBox3);
            this.Controls.Add(this.groupBox2);
            this.Controls.Add(this.groupBox1);
            this.Name = "Form_Client";
            this.Text = "EthernetIP Communication Program";
            this.groupBox3.ResumeLayout(false);
            this.groupBox2.ResumeLayout(false);
            this.groupBox2.PerformLayout();
            this.groupBox1.ResumeLayout(false);
            this.groupBox1.PerformLayout();
            this.groupBox4.ResumeLayout(false);
            this.groupBox4.PerformLayout();
            this.groupBox6.ResumeLayout(false);
            this.groupBox6.PerformLayout();
            this.groupBox7.ResumeLayout(false);
            this.groupBox7.PerformLayout();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.GroupBox groupBox3;
        private System.Windows.Forms.Button btnConnect;
        private System.Windows.Forms.Button btnDisconect;
        private System.Windows.Forms.GroupBox groupBox2;
        private System.Windows.Forms.TextBox tbClient_IP_4;
        private System.Windows.Forms.TextBox tbClient_IP_3;
        private System.Windows.Forms.TextBox tbClient_IP_2;
        private System.Windows.Forms.TextBox tbClient_Port_No;
        private System.Windows.Forms.TextBox tbClient_IP_1;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label label2;
        private System.Windows.Forms.Label label3;
        private System.Windows.Forms.Label label10;
        private System.Windows.Forms.Label label11;
        private System.Windows.Forms.Label label12;
        private System.Windows.Forms.GroupBox groupBox1;
        private System.Windows.Forms.TextBox tbServer_IP_4;
        private System.Windows.Forms.TextBox tbServer_IP_3;
        private System.Windows.Forms.TextBox tbServer_IP_2;
        private System.Windows.Forms.TextBox tbServer_Port_No;
        private System.Windows.Forms.TextBox tbServer_IP_1;
        private System.Windows.Forms.Label label8;
        private System.Windows.Forms.Label label7;
        private System.Windows.Forms.Label label6;
        private System.Windows.Forms.Label label9;
        private System.Windows.Forms.Label label5;
        private System.Windows.Forms.Label label4;
        private System.Windows.Forms.Timer timer1;
        private System.Windows.Forms.TextBox txt_tr1;
        private System.Windows.Forms.Label label13;
        private System.Windows.Forms.GroupBox groupBox4;
        private System.Windows.Forms.Button button1;
        private System.Windows.Forms.Button button2;
        private System.Windows.Forms.Label label22;
        private System.Windows.Forms.Label label15;
        private System.Windows.Forms.TextBox textBox2;
        private System.Windows.Forms.Button button3;
        private System.Windows.Forms.Label label14;
        private System.Windows.Forms.TextBox textBox1;
        private System.Windows.Forms.GroupBox groupBox6;
        private System.Windows.Forms.Label label23;
        private System.Windows.Forms.Label label16;
        private System.Windows.Forms.TextBox textBox3;
        private System.Windows.Forms.Button button4;
        private System.Windows.Forms.Label label17;
        private System.Windows.Forms.TextBox textBox4;
        private System.Windows.Forms.Label label18;
        private System.Windows.Forms.TextBox textBox5;
        private System.Windows.Forms.GroupBox groupBox7;
        private System.Windows.Forms.Label label24;
        private System.Windows.Forms.Label label19;
        private System.Windows.Forms.TextBox textBox6;
        private System.Windows.Forms.Label label20;
        private System.Windows.Forms.TextBox textBox7;
        private System.Windows.Forms.Label label21;
        private System.Windows.Forms.TextBox textBox8;
        private System.Windows.Forms.Button button5;
    }
}

