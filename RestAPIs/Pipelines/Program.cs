using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Threading.Tasks;
using Microsoft.TeamFoundation.Common;
using Microsoft.VisualStudio.Services.ActivityStatistic;
using Microsoft.VisualStudio.Services.Common;
using Microsoft.VisualStudio.Services.ReleaseManagement.WebApi;
using Microsoft.VisualStudio.Services.ReleaseManagement.WebApi.Clients;

namespace Pipelines
{
    class Program
    {
        private static string OrganizationName = ""; // Set this value
        private static string ProjectName = ""; // Set this value
        private static string PatToken = ""; // Set this value

        private static ReleaseHttpClient releaseHttpClient;

        static void Main(string[] args)
        {
            InitializeReleaseHttpClient();

            var rd = GetReleaseDefinition(1990);
            Console.WriteLine("RD: {0}", rd.Name);

            Console.WriteLine("\n\nPress enter to exit");
            Console.ReadLine();
        }

        private static ReleaseDefinition GetReleaseDefinition(int releaseDefinitionId)
        {
            var rd = releaseHttpClient.GetReleaseDefinitionAsync(ProjectName, releaseDefinitionId).GetAwaiter().GetResult();

            return rd;
        }

        private static void InitializeReleaseHttpClient()
        {
            if (OrganizationName.IsNullOrEmpty())
            {
                throw new Exception("OrganizationName is not set");
            }

            if (ProjectName.IsNullOrEmpty())
            {
                throw new Exception("ProjectName is not set");
            }

            if (PatToken.IsNullOrEmpty())
            {
                throw new Exception("PatToken is not set");
            }

            if (releaseHttpClient == null)
            {
                var creds = new VssCredentials(new VssBasicCredential(new VssBasicToken(new NetworkCredential("", PatToken))));
                releaseHttpClient = new ReleaseHttpClient(new Uri("https://vsrm.dev.azure.com/" + OrganizationName, UriKind.Absolute), creds);
            }
        }
    }
}
