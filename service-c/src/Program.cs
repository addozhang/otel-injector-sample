using System.Text.Json;
using Microsoft.AspNetCore.Mvc;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add HTTP client for service calls
builder.Services.AddHttpClient();

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

// Configure URL for port 5000
app.Urls.Add("http://*:5000");

// Health check endpoint
app.MapGet("/health", () => new { status = "OK", service = "service-c", language = "dotnet" });

// Chain endpoint
app.MapGet("/chain", async () =>
{
    // Simulate some processing time
    await Task.Delay(50);

    return "Service-C (.NET) response completed";
});

app.Run();
