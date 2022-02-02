using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace LC2Base64EnDecode.NET
{
    class Base64Controller
    {
        public static void read2File(string path)
        {
            File.ReadAllLines(path);
        }
        public static void write2File(string target, string ListText)
        {
            File.WriteAllText(target, ListText);
        }
        public static void write2FileLines(string target, string[] ListText)
        {
            File.WriteAllLines(target, ListText);
        }

        public static string read2BinaryFile(string path)
        {
            FileStream fileStream = new FileStream(path, FileMode.Open);
            using (StreamReader reader = new StreamReader(fileStream))
            {
                return reader.ReadToEnd();
            }
        }

        public static string Base64Encode(string plainText)
        {
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
            return System.Convert.ToBase64String(plainTextBytes);
        }

        public static string Base64Decode(string base64EncodedData)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
        }

        public static String ToBase64String (string arg)
        {
            string s = read2BinaryFile(arg);
            var plainTextBytes = Encoding.UTF8.GetBytes(s);
            return Convert.ToBase64String(plainTextBytes);         
        }

        public static String BinaryToBase64String(string arg)
        {
            return Convert.ToBase64String(File.ReadAllBytes(arg));
        }


    }
}
