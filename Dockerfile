# Stage 1: Build the application
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY ["MerchantService.csproj", "./"]
RUN dotnet restore "MerchantService.csproj"

# Copy everything else and build
COPY . ./
RUN dotnet publish "NewRepo/MerchantService.csproj" -c Release -o /app/out

# Stage 2: Run the application
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS runtime
WORKDIR /app
COPY --from=build /app/out .

# Expose the Render expected port
EXPOSE 8080

# Start the app
ENTRYPOINT ["dotnet", "MerchantService.dll"]