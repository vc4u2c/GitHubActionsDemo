#define USE_SWAGGER_ALWAYS
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
#if USE_SWAGGER_ALWAYS
app.UseSwagger();
app.UseSwaggerUI();
#else
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}
#endif

app.UseHttpsRedirection();

app.MapGet("/sum", ([FromQuery] int number1, [FromQuery] int number2, ILogger<Program> logger) =>
{
    logger.LogInformation("Reached /sum endpoint.");

    try
    {
        var sum = checked(number1 + number2);
        return Results.Ok(sum);
    }
    catch (OverflowException ex)
    {
        return Results.BadRequest(ex.Message);
    }
})
.WithName("GetSum")
.WithOpenApi();

app.Run();

public partial class Program { }