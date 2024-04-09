using System;
using System.Diagnostics;

namespace CHBuild
{
    public static class CHBuild
    {
        public static string version = "1.0.0";
        private static bool mainRunForFirstTime = false;
        
        public static void Build(string version, bool isThunderstoreBuild=false)
        {
            string newFolderName = $"FrothyWiFi-CYNHUD-{version}";
            Process process = new();
            process.StartInfo.FileName = "powershell.exe";
            process.StartInfo.Arguments = isThunderstoreBuild ? $@"Copy-Item -Path ""CYNHUD"" -Destination ""{newFolderName}"" -Recurse; Remove-Item -Path ""{newFolderName}\.gitignore"" -Force; Remove-Item -Path ""{newFolderName}\CHBuild"" -Force -Recurse; Remove-Item -Path {newFolderName}\.git -Force -Recurse; Compress-Archive -Path {newFolderName}\* -DestinationPath {newFolderName}.zip; Remove-Item -Path {newFolderName} -Force -Recurse" : $@"Copy-Item -Path ""CYNHUD"" -Destination ""{newFolderName}"" -Recurse";
            process.StartInfo.CreateNoWindow = true;
            process.StartInfo.UseShellExecute = false;
            process.Start();
            process.WaitForExit();
            Console.WriteLine("Done! :D");
            Console.WriteLine("---===---");
        }

        public static void UserManual()
        {
            Console.WriteLine($"Usage: {Process.GetCurrentProcess().ProcessName}.exe");
            Console.WriteLine("TUI (program environment) Usage:\n\tEnsure this binary/exe is in the same parent directory/folder as the cloned repo of CYNHUD (folder should be named CYNHUD).\n\tChoose either option R or T.");
            Console.WriteLine("---===---");
        }

        public static void Main()
        {
            Console.Title = $"CHBuild v{version}";
            if (!mainRunForFirstTime) { Console.WriteLine($"--== CHBuild v{version} ==--"); mainRunForFirstTime = true; }

            Console.WriteLine("Choose an option by pressing the key of the capital letter:");
            Console.WriteLine("\tRaw build\n\tThunderstore-ready build\n\tUser manual (please read)\n\tExit");
            ConsoleKeyInfo key = Console.ReadKey(true);

            switch (key.KeyChar)
            {
                case 'r':
                    Console.Write("Enter version number: v");
                    string versionNum = Console.ReadLine()!;
                    Build(versionNum);
                    Main();
                    break;

                case 't':
                    Console.Write("Enter version number: v");
                    versionNum = Console.ReadLine()!;
                    Build(versionNum, true);
                    Main();
                    break;

                case 'e':
                    break;

                case 'u':
                    UserManual();
                    Main();
                    break;

                default:
                    Console.WriteLine("Error: Invalid key. Aborting.");
                    Console.WriteLine("---===---");
                    Main();
                    break;
            }    
        }
    }
}