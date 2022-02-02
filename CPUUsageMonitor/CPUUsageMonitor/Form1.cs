using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Windows.Forms.DataVisualization.Charting;
using Org.Mentalis.Utilities;
using System.Threading;

namespace CPUUsageMonitor
{
    public partial class Form1 : Form
    {
        bool iscontinue = true;
        private static CpuUsage cpu;
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {

            //Chart Settings 

            // Populating the data arrays.
            this.cpuUsageChart.Series.Clear();
            this.cpuUsageChart.Palette = ChartColorPalette.SeaGreen;
             
            // Set chart title.
            this.cpuUsageChart.Titles.Add("CPU Usage");

            // Add chart series
             Series series = this.cpuUsageChart.Series.Add("CPU Usage");
             cpuUsageChart.Series[0].ChartType = SeriesChartType.FastLine;

             // Add Initial Point as Zero.
                series.Points.Add(0);

                //Populating X Y Axis  Information 
                cpuUsageChart.Series[0].YAxisType = AxisType.Primary;
                cpuUsageChart.Series[0].YValueType = ChartValueType.Int32;
                cpuUsageChart.Series[0].IsXValueIndexed = false;

                cpuUsageChart.ResetAutoValues();
                cpuUsageChart.ChartAreas[0].AxisY.Maximum =100;//Max Y 
                cpuUsageChart.ChartAreas[0].AxisY.Minimum = 0;
                cpuUsageChart.ChartAreas[0].AxisX.Enabled = AxisEnabled.False;
                cpuUsageChart.ChartAreas[0].AxisY.Title = "CPU usage %";
                cpuUsageChart.ChartAreas[0].AxisY.IntervalAutoMode = IntervalAutoMode.VariableCount;

                populateCPUInfo();     
        }


        private void populateCPUInfo()
        {
            try
            {
                // Creates and returns a CpuUsage instance that can be used to query the CPU time on this operating system.
                cpu = CpuUsage.Create();

                /// Creating a New Thread 
                Thread thread = new Thread(new ThreadStart(delegate()
                {
                    try
                    {
                        while (iscontinue)
                        {
                            //To Update The UI Thread we have to Invoke  it. 
                            this.Invoke(new System.Windows.Forms.MethodInvoker(delegate()
                            {
                                int process = cpu.Query(); //Determines the current average CPU load.
                                proVal.Text = process.ToString() + "%";
                                cpuUsageChart.Series[0].Points.AddY(process);//Add process to chart 

                                if (cpuUsageChart.Series[0].Points.Count > 40)//clear old data point after Thrad Sleep time * 40
                                    cpuUsageChart.Series[0].Points.RemoveAt(0);

                            }));

                            Thread.Sleep(450);//Thread sleep for 450 milliseconds 
                        }
                    }
                    catch (Exception ex)
                    {

                    }

                }));

                thread.Priority = ThreadPriority.Highest;
                thread.IsBackground = true;
                thread.Start();//Start the Thread
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
            }

        }

        private void Form1_FormClosing(object sender, FormClosingEventArgs e)
        {
            iscontinue = false;
        }
        
    }
}
