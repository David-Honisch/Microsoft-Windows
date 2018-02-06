/*
 * Created by SharpDevelop.
 * User: b3y0nd3r
 * Date: 21.04.2016
 * Time: 20:36
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Reflection;
using System.Text.RegularExpressions;
using System.Windows.Forms;
using letztechance.org.XML;
using Microsoft.Win32;

namespace LC2IEResetBG
{
	/// <summary>
	/// Description of MainForm.
	/// </summary>
	public partial class MainForm : Form
	{
		const int TRUSTED_SITES_ZONE = 2;
		string tsite = "http://www.letztechance.org";
//		BackgroundWorker backgroundWorker = null;
		public MainForm()
		{
			InitializeComponent();
		}
		private void ShowMessage(string msg)
		{
			this.Invoke(new MethodInvoker(delegate()
			                              {
			                              	textBoxMessages.Text = textBoxMessages.Text + msg + "\r\n";
			                              	textBoxMessages.SelectionStart = textBoxMessages.Text.Length;
			                              	textBoxMessages.SelectionLength = 0;
			                              	textBoxMessages.ScrollToCaret();
			                              }));
		}
		
		private void backgroundWorker_DoWork(object sender, DoWorkEventArgs e)
		{
			this.Invoke(new MethodInvoker(delegate()
			                              {
			                              	buttonOK.Enabled = false;
			                              }));
			try
			{
				ShowMessage("Installing ...");
				ShowMessage("\r\nAdding trusted Web sites in Externet Explorer ...");
				AddTrustedSitesToInternetExplorer();
				ShowMessage("\r\nChanging the .NET Framework Security Policy ...");
				ChangeDotNetSecurityPolicyForTrustedZoneAssignFullTrust();
				ShowMessage("\r\nInstallation completed successfully.");
			}
			catch (Exception ex)
			{
				ShowMessage(ex.Message);
				ShowMessage("\r\nInstallation failed.");
			}
			this.Invoke(new MethodInvoker(delegate()
			                              {
			                              	buttonOK.Enabled = true;
			                              }));
		}
		private void AddTrustedSitesToInternetExplorer()
		{
			// Change this to your Web site hosting the ActiveX control
			AddTrustedSiteToInternetExplorer(""+tsite);
			AddTrustedSiteToInternetExplorer(""+tsite);
		}
		private void AddTrustedSiteToInternetExplorer(string url)
		{
			Match match = Regex.Match(url, @"\A(.+)://((.+)\.)?([^.]+\.[^.]+)\Z");
			if (match == null)
			{
				textBoxMessages.Text = "match is null" + "\r\n";
				return;
			}
			string protocol = match.Groups[1].Value;
			string subdomain = match.Groups[3].Value;
			string domain = match.Groups[4].Value;
			if (domain == "")
			{
				match = Regex.Match(url, @"\A(.+)://(.+)\Z");
				protocol = match.Groups[1].Value;
				subdomain = "";
				domain = match.Groups[2].Value;
			}
			if (protocol == "" || domain == "")
			{
				throw new Exception("  Error: invalid URL " + url);
			}
			string key = "Software\\Microsoft\\Windows\\CurrentVersion\\Internet Settings\\ZoneMap\\Domains\\" + domain;
			RegistryKey regKeyDomain = Registry.CurrentUser.CreateSubKey(key);
			using (regKeyDomain)
			{
				if (subdomain == "")
				{
					regKeyDomain.SetValue(protocol, TRUSTED_SITES_ZONE);
				}
				else
				{
					RegistryKey regKeySubdomain = regKeyDomain.CreateSubKey(subdomain);
					using (regKeySubdomain)
					{
						regKeySubdomain.SetValue(protocol, TRUSTED_SITES_ZONE);
					}
				}
			}
			ShowMessage("  The site " + url + " is added to the Internet Explorer trusted zone.");
		}
		private void ChangeDotNetSecurityPolicyForTrustedZoneAssignFullTrust()
		{
			// Get .NET Framework Runtime location in the file system
			Assembly systemAssembly = Assembly.GetAssembly(typeof(System.String));
			string netFrameworkPath = Path.GetDirectoryName(systemAssembly.Location);
			// Allow assemblies coming from trusted Web sites to run with full permissions
			// by executing caspol.exe -quiet -machine -chggroup Trusted_Zone FullTrust
			string caspolPath = netFrameworkPath + Path.DirectorySeparatorChar + "caspol.exe";
			ProcessStartInfo startInfo = new ProcessStartInfo();
			startInfo.FileName = caspolPath;
			startInfo.Arguments = "-quiet -machine -chggroup Trusted_Zone FullTrust";
			startInfo.ErrorDialog = false;
			startInfo.WindowStyle = ProcessWindowStyle.Hidden;
			Process process = Process.Start(startInfo);
			if (process != null)
			{
				ShowMessage("  Added .NET security policy to run all assemblies coming from trusted Web sites with no security restrictions.");
			}
			else
			{
				throw new Exception("  Error: caspol.exe could not be executed.");
			}
		}
		
		
		void ButtonOKClick(object sender, EventArgs e)
		{
			
			textBoxMessages.AppendText(tsite);
			Close();
		}
		
		void MainFormLoad(object sender, EventArgs e)
		{
			Array result = new ArrayList().ToArray();
			var cfg = Environment.CurrentDirectory+"\\cfg.xml";
			result = XML.getXMLElement(cfg, new String[]{"Site"});
			foreach(String s in result)
			{
				tsite =s;
				textBoxMessages.AppendText("Trusted site:"+s+""+Environment.NewLine);
			}
			backgroundWorker_DoWork(this, null);
		}
	}
}
