using Azure.Identity;
using Azure.Security.KeyVault.Secrets;

var builder = WebApplication.CreateBuilder(args);

// ===============================================
// ENTERPRISE-GRADE CONFIGURATION
// ===============================================

// Configure Azure Key Vault integration
var keyVaultUri = builder.Configuration["Azure:KeyVault:VaultUri"];
if (!string.IsNullOrEmpty(keyVaultUri))
{
    // Use Managed Identity in Azure, DefaultAzureCredential for local dev
    var credential = new DefaultAzureCredential();
    builder.Configuration.AddAzureKeyVault(
        new Uri(keyVaultUri),
        credential);
}

// Add services to the container
builder.Services.AddOpenApi();
builder.Services.AddControllers();
builder.Services.AddHealthChecks();

// Add Application Insights (optional but recommended)
builder.Services.AddApplicationInsightsTelemetry();

var app = builder.Build();

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.MapOpenApi();
}

app.UseHttpsRedirection();

// Map health checks
app.MapHealthChecks("/health");

// ===============================================
// ENTERPRISE API ENDPOINTS
// ===============================================

// Enhanced health check with proper security
app.MapGet("/health/ready", (IConfiguration config) =>
{
    return Results.Ok(new
    {
        status = "ready",
        timestamp = DateTime.UtcNow,
        environment = app.Environment.EnvironmentName,
        // DO NOT expose internal details in production
        version = "2.0.0"
    });
})
.WithName("ReadinessCheck")
.WithOpenApi();

// Version endpoint with environment awareness
app.MapGet("/api/version", (IConfiguration config) =>
{
    var buildDate = config["Build:Date"] ?? "Unknown";
    var buildNumber = config["Build:Number"] ?? "Unknown";

    return Results.Ok(new
    {
        version = "2.0.0",
        buildDate,
        buildNumber,
        environment = app.Environment.EnvironmentName
    });
})
.WithName("GetVersion")
.WithOpenApi();

// Get all inventory items with proper error handling
app.MapGet("/api/inventory", (IConfiguration config, ILogger<Program> logger) =>
{
    try
    {
        logger.LogInformation("Fetching all inventory items");

        // In production, this would use the connection string from Key Vault
        // var connectionString = config.GetConnectionString("DefaultConnection");

        // Simulating database access with in-memory data for demo
        var items = new List<InventoryItem>
        {
            new InventoryItem(1, "Enterprise Widget A", 100, 9.99m, DateTime.UtcNow),
            new InventoryItem(2, "Enterprise Widget B", 50, 19.99m, DateTime.UtcNow),
            new InventoryItem(3, "Enterprise Widget C", 75, 14.99m, DateTime.UtcNow)
        };

        logger.LogInformation("Successfully retrieved {Count} inventory items", items.Count);
        return Results.Ok(items);
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Error fetching inventory items");
        return Results.Problem(
            title: "Error retrieving inventory",
            statusCode: StatusCodes.Status500InternalServerError);
    }
})
.WithName("GetInventory")
.WithOpenApi();

// Get inventory item by ID with validation and error handling
app.MapGet("/api/inventory/{id:int}", (int id, ILogger<Program> logger) =>
{
    try
    {
        if (id <= 0)
        {
            logger.LogWarning("Invalid inventory ID requested: {Id}", id);
            return Results.BadRequest(new { error = "Invalid ID. Must be greater than 0." });
        }

        logger.LogInformation("Fetching inventory item with ID: {Id}", id);

        var items = new List<InventoryItem>
        {
            new InventoryItem(1, "Enterprise Widget A", 100, 9.99m, DateTime.UtcNow),
            new InventoryItem(2, "Enterprise Widget B", 50, 19.99m, DateTime.UtcNow),
            new InventoryItem(3, "Enterprise Widget C", 75, 14.99m, DateTime.UtcNow)
        };

        var item = items.FirstOrDefault(i => i.Id == id);

        if (item == null)
        {
            logger.LogWarning("Inventory item not found: {Id}", id);
            return Results.NotFound(new { error = $"Item with ID {id} not found." });
        }

        logger.LogInformation("Successfully retrieved inventory item: {Id}", id);
        return Results.Ok(item);
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Error fetching inventory item {Id}", id);
        return Results.Problem(
            title: "Error retrieving inventory item",
            statusCode: StatusCodes.Status500InternalServerError);
    }
})
.WithName("GetInventoryById")
.WithOpenApi();

// Create new inventory item with validation
app.MapPost("/api/inventory", (InventoryItem item, IConfiguration config, ILogger<Program> logger) =>
{
    try
    {
        // Validate input
        if (string.IsNullOrWhiteSpace(item.Name))
        {
            return Results.BadRequest(new { error = "Item name is required." });
        }

        if (item.Quantity < 0)
        {
            return Results.BadRequest(new { error = "Quantity cannot be negative." });
        }

        if (item.Price < 0)
        {
            return Results.BadRequest(new { error = "Price cannot be negative." });
        }

        // API key from Key Vault (retrieved via configuration)
        var apiKey = config["ApiKey"];
        if (string.IsNullOrEmpty(apiKey))
        {
            logger.LogWarning("API key not configured");
        }

        logger.LogInformation("Creating new inventory item: {Name}", item.Name);

        // In production, this would insert into database
        var createdItem = item with { LastUpdated = DateTime.UtcNow };

        logger.LogInformation("Successfully created inventory item: {Id}", createdItem.Id);
        return Results.Created($"/api/inventory/{createdItem.Id}", createdItem);
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Error creating inventory item");
        return Results.Problem(
            title: "Error creating inventory item",
            statusCode: StatusCodes.Status500InternalServerError);
    }
})
.WithName("CreateInventory")
.WithOpenApi();

// External API call with proper secret management
app.MapGet("/api/external-data", async (IConfiguration config, ILogger<Program> logger) =>
{
    try
    {
        // Configuration from Key Vault and appsettings
        var externalApiUrl = config["ApiSettings:ExternalApiUrl"];
        var externalApiSecret = config["ExternalApiSecret"]; // From Key Vault

        logger.LogInformation("Calling external API");

        // Simulate external API call (in production, use HttpClient)
        await Task.Delay(100); // Simulate network call

        return Results.Ok(new
        {
            message = "External API call completed successfully",
            timestamp = DateTime.UtcNow,
            // NEVER expose secrets in response!
            hasApiSecret = !string.IsNullOrEmpty(externalApiSecret)
        });
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Error calling external API");
        return Results.Problem(
            title: "Error calling external API",
            statusCode: StatusCodes.Status500InternalServerError);
    }
})
.WithName("GetExternalData")
.WithOpenApi();

// Configuration endpoint (for debugging - should be secured in production)
app.MapGet("/api/config/status", (IConfiguration config) =>
{
    var keyVaultConfigured = !string.IsNullOrEmpty(config["Azure:KeyVault:VaultUri"]);

    return Results.Ok(new
    {
        environment = app.Environment.EnvironmentName,
        keyVaultConfigured,
        timestamp = DateTime.UtcNow
    });
})
.WithName("ConfigStatus")
.WithOpenApi();

app.Run();

// Enhanced record with timestamp
record InventoryItem(
    int Id,
    string Name,
    int Quantity,
    decimal Price,
    DateTime LastUpdated);
