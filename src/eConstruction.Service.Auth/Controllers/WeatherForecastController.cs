using Microsoft.AspNetCore.Mvc;

namespace eConstruction.Service.Auth.Controllers
{
    [ApiController]
    [ApiExplorerSettings(GroupName = "v1")]
    [Route("[controller]")]
    public class WeatherForecastController : ControllerBase
    {
        private static readonly string[] Summaries = new[]
        {
            "Auth-Freezing",
            "Auth-Bracing",
            "Auth-Chilly",
            "Auth-Cool",
            "Auth-Mild",
            "Auth-Warm",
            "Auth-Balmy",
            "Auth-Hot",
            "Auth-Sweltering",
            "Auth-Scorching"
        };

        private readonly ILogger<WeatherForecastController> _logger;

        public WeatherForecastController(ILogger<WeatherForecastController> logger)
        {
            _logger = logger;
        }

        [HttpGet(Name = "GetWeatherForecastNow")]
        public IEnumerable<WeatherForecast> GetNow()
        {
            return Enumerable.Range(1, 5).Select(index => new WeatherForecast
            {
                Date = DateOnly.FromDateTime(DateTime.Now.AddDays(index)),
                TemperatureC = Random.Shared.Next(-20, 55),
                Summary = Summaries[Random.Shared.Next(Summaries.Length)]
            })
            .ToArray();
        }
    }
}
