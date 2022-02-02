using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LC2Base64EnDecode.NET
{
    class Program
    {
        
        static void Main(string[] args)
        {
            if (args.Length < 1) { 
            Console.WriteLine("LETZTECHANCE.ORG");
            Console.WriteLine("Usage:LC2Base64EnDecode.NET.exe <file>");
            Console.WriteLine("press any key to continue...");
            Console.ReadKey();
            }
            //Console.WriteLine("press any key to continue..."+args.Length+ args[0]);
            //Console.ReadKey();
            if (args.Length == 1)
            {
                if (File.Exists(args[0])) {
                    String encodedText = Base64Controller.ToBase64String(args[0]);
                    Console.WriteLine(encodedText);
                    Base64Controller.write2File(args[0]+"-base64.out", encodedText);
                }
                else
                {
                    Console.WriteLine("File does not exists.");
                }
            }

        }
    }
}
