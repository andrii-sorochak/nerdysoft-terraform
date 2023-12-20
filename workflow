name: Terraforming on Azure

on:
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v2

    - name: Set up .NET 7 SDK
      uses: actions/setup-dotnet@v1
      with:
        dotnet-version: 7.0.x

    - name: Restore and build Blazor app
      run: |
        dotnet restore
        dotnet build
        dotnet publish -c Release -o ./publish

    - name: Deploy to Azure App Service
      uses: azure/webapps-deploy@v2
      with:
        app-name: my-linux-app
        slot-name: production
        publish-profile: ${{ secrets.AZURE_APP_SERVICE_PUBLISH_PROFILE }}
        package: ./publish/app.zip

    - name: Clean up
      run: |
        cd terraform-directory
        terraform destroy -auto-approve
