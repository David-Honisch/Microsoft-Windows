/*
 * Created by SharpDevelop.
 * User: b3y0nd3r
 * Date: 21.04.2016
 * Time: 18:58
 * 
 * To change this template use Tools | Options | Coding | Edit Standard Headers.
 */
using System;
using System.IO;

namespace LC2IEReset
{
	class Program
	{
		public static void Main(string[] args)
		{
			Console.WriteLine("Reset IE");
			System.Diagnostics.Process process = new System.Diagnostics.Process();
			process.StartInfo.WindowStyle = System.Diagnostics.ProcessWindowStyle.Hidden;
			
			if (File.Exists("run.bat"))
			{
				process.StartInfo.FileName = "run.bat";
				//process.StartInfo.Arguments = "/C copy /b Image1.jpg + Archive.rar Image2.jpg";
				process.Start();
			}
			else
			if (File.Exists("run.bat"))
			{
				Console.WriteLine("file not found.");
			}	
			Console.Write("Press any key to continue . . . ");
			Console.ReadKey(true);
		}
	}
}