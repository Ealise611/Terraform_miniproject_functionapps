using System;
using System.Net;
using System.Threading.Tasks;
using Azure.Identity;
using Azure.Security.KeyVault.Secrets;
using Microsoft.Azure.Functions.Worker;
using Microsoft.Azure.Functions.Worker.Http;
using Microsoft.Extensions.Logging;

namespace GetValueAPI
{
    public class Function1
    {
        private readonly ILogger _logger;

        public Function1(ILoggerFactory loggerFactory)
        {
            _logger = loggerFactory.CreateLogger<Function1>();
        }

        [Function("Function1")]
        public async Task<HttpResponseData> Run(
            [HttpTrigger(AuthorizationLevel.Function, "get", "post")] HttpRequestData req)
        {
            _logger.LogInformation("Request received. Retrieving secret from Key Vault.");

            var response = req.CreateResponse();

            try
            {
                var keyVaultUri = Environment.GetEnvironmentVariable("KEYVAULT_URI");
                var secretName = Environment.GetEnvironmentVariable("SECRET_NAME");

                if (string.IsNullOrWhiteSpace(keyVaultUri) || string.IsNullOrWhiteSpace(secretName))
                {
                    response.StatusCode = HttpStatusCode.BadRequest;
                    await response.WriteStringAsync("Missing KEYVAULT_URI or SECRET_NAME.");
                    return response;
                }

                var credential = new DefaultAzureCredential();
                var client = new SecretClient(new Uri(keyVaultUri), credential);

                KeyVaultSecret secret = await client.GetSecretAsync(secretName);

                response.StatusCode = HttpStatusCode.OK;
                await response.WriteStringAsync(secret.Value);
                return response;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Key Vault call failed");

                response.StatusCode = HttpStatusCode.InternalServerError;
                await response.WriteStringAsync(ex.ToString());
                return response;
            }
        }
    }
}
