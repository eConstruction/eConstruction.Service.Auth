# This stage is used when running from VS in fast mode (Default for Debug configuration)
FROM mcr.microsoft.com/dotnet/aspnet:9.0-alpine AS base
USER $APP_UID
WORKDIR /app
EXPOSE 6060

ENV ASPNETCORE_URLS=http://+:6060

# This stage is used to build the service project
FROM mcr.microsoft.com/dotnet/sdk:9.0-alpine AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["src/eConstruction.Service.Auth/eConstruction.Service.Auth.csproj", "src/eConstruction.Service.Auth/"]
RUN dotnet restore "./src/eConstruction.Service.Auth/eConstruction.Service.Auth.csproj"
COPY . .
WORKDIR "/src/src/eConstruction.Service.Auth"
RUN dotnet build "./eConstruction.Service.Auth.csproj" -c $BUILD_CONFIGURATION -o /app/build

# This stage is used to publish the service project to be copied to the final stage
FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./eConstruction.Service.Auth.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

# This stage is used in production or when running from VS in regular mode (Default when not using the Debug configuration)
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "eConstruction.Service.Auth.dll"]