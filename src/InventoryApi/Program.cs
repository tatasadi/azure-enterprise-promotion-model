var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddOpenApi();
builder.Services.AddControllers();

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

// ===============================================
// LEGACY API - INTENTIONAL ANTI-PATTERNS
// ===============================================

// Health Check endpoint
app.MapGet("/health", () =>
{
    return Results.Ok(new {
        status = "healthy",
        timestamp = DateTime.UtcNow,
        // ANTI-PATTERN: Exposing internal configuration
        database = "myserver.database.windows.net",
        environment = "Production" // Hardcoded!
    });
})
.WithName("HealthCheck");

// Version Info endpoint
app.MapGet("/api/version", () =>
{
    return Results.Ok(new {
        version = "1.0.0",
        buildDate = "2026-02-23", // Hardcoded build date!
        environment = "Production" // No environment awareness
    });
})
.WithName("GetVersion");

// Get all inventory items
app.MapGet("/api/inventory", () =>
{
    // ANTI-PATTERN: Hardcoded connection string access
    var connectionString = "Server=tcp:myserver.database.windows.net,1433;Initial Catalog=InventoryDB;User ID=sqladmin;Password=P@ssw0rd123!;";

    // Simulating database access (not actually connecting for demo purposes)
    var items = new List<InventoryItem>
    {
        new InventoryItem(1, "Widget A", 100, 9.99m),
        new InventoryItem(2, "Widget B", 50, 19.99m),
        new InventoryItem(3, "Widget C", 75, 14.99m)
    };

    return Results.Ok(items);
})
.WithName("GetInventory");

// Get inventory item by ID
app.MapGet("/api/inventory/{id}", (int id) =>
{
    // ANTI-PATTERN: No error handling, hardcoded data
    var items = new List<InventoryItem>
    {
        new InventoryItem(1, "Widget A", 100, 9.99m),
        new InventoryItem(2, "Widget B", 50, 19.99m),
        new InventoryItem(3, "Widget C", 75, 14.99m)
    };

    var item = items.FirstOrDefault(i => i.Id == id);

    // No null check - will throw exception!
    return Results.Ok(item);
})
.WithName("GetInventoryById");

// Create new inventory item
app.MapPost("/api/inventory", (InventoryItem item) =>
{
    // ANTI-PATTERN: Hardcoded API key validation
    var apiKey = "hardcoded-api-key-12345";

    // ANTI-PATTERN: No actual database insert, just return the item
    return Results.Created($"/api/inventory/{item.Id}", item);
})
.WithName("CreateInventory");

// External API call example
app.MapGet("/api/external-data", async () =>
{
    // ANTI-PATTERN: Hardcoded external API credentials
    var externalApiUrl = "https://api.example.com/data";
    var apiSecret = "my-secret-key-hardcoded";

    // Simulate external API call
    return Results.Ok(new {
        message = "This would call external API with hardcoded credentials",
        url = externalApiUrl,
        // ANTI-PATTERN: Exposing secrets in response!
        secret = apiSecret
    });
})
.WithName("GetExternalData");

app.Run();

// Simple record for inventory items
record InventoryItem(int Id, string Name, int Quantity, decimal Price);
