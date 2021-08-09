using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net.NetworkInformation;
using System.Text;
using System.Threading.Tasks;

namespace LC2PingAsync
{
    class Program
    {
        public static async Task  Main(string[] args)
        {
            string hostName = "";
            string outPutFile = "default_ping.log";
            if (args.Length < 1) {
                Console.Clear();
                Console.WriteLine("LC2PingAsync <host> <file>");
                return;
            }
            if (args.Length >= 1)
            {
                hostName = args[0];
            }
            if (args.Length > 1)
            {
                outPutFile = args[1];
            }
            var pingSender = new Ping();
            var hostNameOrAddress = hostName;

            Console.Clear();
            Console.WriteLine($"PING {hostNameOrAddress}");

            for (int i = 0; i < 5; i++)
            {
                var reply = await pingSender.SendPingAsync(hostNameOrAddress);
                Console.WriteLine($"{reply.Buffer.Length} bytes from {reply.Address}:" +
                                  $" icmp_seq={i} status={reply.Status} time={reply.RoundtripTime}ms");
                File.WriteAllText(outPutFile, $"{reply.Buffer.Length} bytes from {reply.Address}:" +
                                  $" icmp_seq={i} status={reply.Status} time={reply.RoundtripTime}ms");
            }
        }
    }
}
