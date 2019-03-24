/*
 * Created by SharpDevelop.
 * User: David
 * Date: 08.03.2015
 * Time: 01:06
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Windows.Forms;
using System.Runtime.InteropServices;

using letztechance.org.Util.ControlMover;
using System.Configuration;
using System.IO;
using System.Diagnostics;

namespace LC2Clock2015
{
    /// <summary>
    /// Description of MainForm.
    /// </summary>
    public partial class MainForm : Form
    {


        const int HT_CAPTION = 0x2;
        const int WM_NCLBUTTONDOWN = 0xA1;

        [DllImportAttribute("user32.dll")]
        public static extern int SendMessage(IntPtr hWnd, int Msg, int wParam, int lParam);
        [DllImportAttribute("user32.dll")]
        public static extern bool ReleaseCapture();

        public MainForm()
        {
            //
            // The InitializeComponent() call is required for Windows Forms designer support.
            //
            InitializeComponent();

            //
            // TODO: Add constructor code after the InitializeComponent() call.
            //
            this.SetStyle(ControlStyles.EnableNotifyMessage, true);

        }

        void MainFormLoad(object sender, EventArgs e)
        {

            Init();

            ControlMover.Init(webBrowser1, this, ControlMover.Direction.Any);
            ControlMover.Init(btnQuit, this, ControlMover.Direction.Any);
            ControlMover.Init(this, this, ControlMover.Direction.Any);
            //ControlMover.Init(webBrowser1,this,ControlMover.Direction.Any);
            //this.FormBorderStyle = FormBorderStyle.None;
            if (ConfigurationManager.AppSettings["snapToTop"] == "true")
            {
                this.Top = Screen.PrimaryScreen.WorkingArea.Top;
            }
            if (ConfigurationManager.AppSettings["snapToRight"] == "true")
            {
                this.Left = Screen.PrimaryScreen.WorkingArea.Right - 200;
            }
            webBrowser1.Navigate(Environment.CurrentDirectory + "/index.html");
        }
        #region set window and webbrowser
        private void Init()
        {
            try
            {
                this.TransparencyKey = Color.White;
                this.Text = ConfigurationManager.AppSettings["exe"];
                this.Height = int.Parse(ConfigurationManager.AppSettings["height"]);
                this.Width = int.Parse(ConfigurationManager.AppSettings["width"]);
                if (!bool.Parse(ConfigurationManager.AppSettings["isBGShown"]))
                {
                    String img = Environment.CurrentDirectory + "\\" + ConfigurationManager.AppSettings["Background"];
                    if (File.Exists(img))
                    {
                        Bitmap bitmap = new Bitmap(@"" + img);
                        //this.BackgroundImage = Image.FromFile(Environment.CurrentDirectory + "\\" + ConfigurationManager.AppSettings["Background"]);
                        this.BackgroundImage = bitmap;
                    }
                    else
                    {
                        MessageBox.Show(img + " not found.");
                    }
                }
                if (ConfigurationManager.AppSettings["isBGShown"] == "Black")
                {
                    this.TransparencyKey = Color.Black;
                }
                if (!bool.Parse(ConfigurationManager.AppSettings["isStatusShown"]))
                {
                    this.FormBorderStyle = FormBorderStyle.None;
                }
                if (ConfigurationManager.AppSettings["DockStyle"] != null)
                {
                    // this.Dock = GetDockStyle(ConfigurationManager.AppSettings["DockStyle"]);
                }
                if (ConfigurationManager.AppSettings["DockStyle"] != null && ConfigurationManager.AppSettings["DockStyle"] != "NONE")
                {
                    // this.webBrowser1.Dock = GetDockStyle(ConfigurationManager.AppSettings["DockStyle"]);
                }

                this.webBrowser1.Location = new Point(
                    int.Parse(ConfigurationManager.AppSettings["wx"]),
                    int.Parse(ConfigurationManager.AppSettings["wy"])
                   );



                if (ConfigurationManager.AppSettings["wheight"] != null)
                {
                    this.webBrowser1.Height = int.Parse(ConfigurationManager.AppSettings["wheight"]);
                }
                if (ConfigurationManager.AppSettings["wwidth"] != null)
                {
                    this.webBrowser1.Width = int.Parse(ConfigurationManager.AppSettings["wwidth"]);
                }
                if (ConfigurationManager.AppSettings["btnQuitx"] != null && ConfigurationManager.AppSettings["btnQuity"] != null)
                {
                    this.btnQuit.Location = new Point(
                        int.Parse(ConfigurationManager.AppSettings["btnQuitx"]),
                        int.Parse(ConfigurationManager.AppSettings["btnQuity"])
                        );
                }
                if (ConfigurationManager.AppSettings["btnQuity"] != null)
                {
                    this.btnQuit.Width = int.Parse(ConfigurationManager.AppSettings["btnQuity"]);
                }
                //

            }
            catch (Exception e)
            {
                Console.WriteLine(e);
            }
        }

        private DockStyle GetDockStyle(String style)
        {
            DockStyle dsResult = DockStyle.None;
            switch (style)
            {
                case "FILL":
                    dsResult = DockStyle.Fill;
                    break;
                case "TOP":
                    dsResult = DockStyle.Top;
                    break;
                case "BOTTOM":
                    dsResult = DockStyle.Top;
                    break;
                case "RIGHT":
                    dsResult = DockStyle.Right;
                    break;
                case "LEFT":
                    dsResult = DockStyle.Left;
                    break;
                default:
                    break;
            }
            return dsResult;
        }

        #endregion

        protected override void OnNotifyMessage(Message m)
        {
            const int WM_MOVING = 0x0216;

            if (m.Msg == WM_MOVING)
            {
                if (Control.ModifierKeys == Keys.Control)
                {
                    ReleaseCapture();
                }
            }
            base.OnNotifyMessage(m);
        }


        #region Events
        void Button1Click(object sender, EventArgs e)
        {
            Close();
        }

        private void MainForm_MouseDown(object sender, MouseEventArgs e)
        {
            if (e.Button == MouseButtons.Left)
            {
                ReleaseCapture();
                SendMessage(Handle, WM_NCLBUTTONDOWN, HT_CAPTION, 0);
            }
        }
        #endregion

        private void webBrowser1_Navigating(object sender, WebBrowserNavigatingEventArgs e)
        {
            if (e.Url.ToString().Contains("lc:"))
            {
                e.Cancel = true;
                String cmd = e.Url.ToString().Replace("lc:", "").Replace("%20", " ");
                ProcessStartInfo procStartInfo = new System.Diagnostics.ProcessStartInfo("cmd", "/c " + cmd);
                Process.Start(procStartInfo);
            }            
        }

       
    }
}
