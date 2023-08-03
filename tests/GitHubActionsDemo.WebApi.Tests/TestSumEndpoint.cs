using Microsoft.AspNetCore.Mvc.Testing;
using FluentAssertions;

namespace GitHubActionsDemo.WebApi.Tests;

public class TestSumEndpoint
{
    [Fact]
    public async Task TestRootEndpoint()
    {
        await using var application = new WebApplicationFactory<Program>();
        using var client = application.CreateClient();

        var number1 = 3;
        var number2 = 2;
        var response = await client.GetStringAsync($"/sum?number1={number1}&number2={number2}");

        response.Should().Be("5");
    }

    [Fact]
    public async Task TestRootEndpointForOverflow()
    {
        await using var application = new WebApplicationFactory<Program>();
        using var client = application.CreateClient();

        var number1 = Int32.MaxValue;
        var number2 = 1;
        var response = await client.GetAsync($"/sum?number1={number1}&number2={number2}");

        response
            .Should().Be400BadRequest()
            .And.MatchInContent("*overflow*");
    }
}