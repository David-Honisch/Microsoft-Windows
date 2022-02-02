namespace CPUUsageMonitor
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            System.Windows.Forms.DataVisualization.Charting.ChartArea chartArea1 = new System.Windows.Forms.DataVisualization.Charting.ChartArea();
            System.Windows.Forms.DataVisualization.Charting.Legend legend1 = new System.Windows.Forms.DataVisualization.Charting.Legend();
            System.Windows.Forms.DataVisualization.Charting.Series series1 = new System.Windows.Forms.DataVisualization.Charting.Series();
            System.ComponentModel.ComponentResourceManager resources = new System.ComponentModel.ComponentResourceManager(typeof(Form1));
            this.cpuUsageChart = new System.Windows.Forms.DataVisualization.Charting.Chart();
            this.label1 = new System.Windows.Forms.Label();
            this.proVal = new System.Windows.Forms.Label();
            ((System.ComponentModel.ISupportInitialize)(this.cpuUsageChart)).BeginInit();
            this.SuspendLayout();
            // 
            // cpuUsageChart
            // 
            chartArea1.Name = "ChartArea1";
            this.cpuUsageChart.ChartAreas.Add(chartArea1);
            legend1.Name = "Legend1";
            this.cpuUsageChart.Legends.Add(legend1);
            this.cpuUsageChart.Location = new System.Drawing.Point(-2, -2);
            this.cpuUsageChart.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.cpuUsageChart.Name = "cpuUsageChart";
            series1.ChartArea = "ChartArea1";
            series1.Legend = "Legend1";
            series1.Name = "Series1";
            this.cpuUsageChart.Series.Add(series1);
            this.cpuUsageChart.Size = new System.Drawing.Size(1101, 391);
            this.cpuUsageChart.TabIndex = 0;
            this.cpuUsageChart.Text = "cpuChart";
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.label1.Location = new System.Drawing.Point(34, 437);
            this.label1.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(310, 37);
            this.label1.TabIndex = 1;
            this.label1.Text = "Current CPU Usage ";
            // 
            // proVal
            // 
            this.proVal.AutoSize = true;
            this.proVal.Font = new System.Drawing.Font("Microsoft Sans Serif", 16F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.proVal.Location = new System.Drawing.Point(362, 437);
            this.proVal.Margin = new System.Windows.Forms.Padding(4, 0, 4, 0);
            this.proVal.Name = "proVal";
            this.proVal.Size = new System.Drawing.Size(65, 37);
            this.proVal.TabIndex = 2;
            this.proVal.Text = "0%";
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(9F, 20F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1101, 557);
            this.Controls.Add(this.proVal);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.cpuUsageChart);
            this.Icon = ((System.Drawing.Icon)(resources.GetObject("$this.Icon")));
            this.Margin = new System.Windows.Forms.Padding(4, 5, 4, 5);
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "LC2CPU usage";
            this.FormClosing += new System.Windows.Forms.FormClosingEventHandler(this.Form1_FormClosing);
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.cpuUsageChart)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.DataVisualization.Charting.Chart cpuUsageChart;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.Label proVal;
    }
}

