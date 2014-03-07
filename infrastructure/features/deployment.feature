Feature: Scripted Deployment of an Application
    As a Continouous Delivery Engineer
    I would like verify my infrastructure and deployment are correct
    so I can use the application

    Background:
        Given I have the CloudFormation stack information to query

    Scenario: Can I connect to the application?
        When I pull up the Honolulu Answers application
        Then I should get data back