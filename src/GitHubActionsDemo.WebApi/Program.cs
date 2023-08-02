using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();

app.MapGet("/sum", ([FromRoute] int number1, [FromRoute] int number2, ILogger<Program> logger) =>
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