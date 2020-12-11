Feature: AWS SQS Kamelet

  Background:
    Given Disable auto removal of Camel-K resources
    Given Disable auto removal of Kamelet resources
    Given initialize SQS client

  Scenario: Create Camel-K resources
    Given create Camel-K integration sqs-to-log.groovy
    """
    from('kamelet:aws-sqs-source?queueNameOrArn=${aws-sqs.queueNameOrArn}&accessKey=${aws-sqs.accessKey}&secretKey=RAW(${aws-sqs.secretKey})&region=${aws-sqs.region}&deleteAfterRead=${aws-sqs.deleteAfterRead}')
        .to("log:info")
    """
    Then Camel-K integration sqs-to-log should be running

  Scenario: Verify Kamelet source
    Given variable message is "Hello from Kamelet source citrus:randomString(10)"
    Given send message: "This is awesome!" to SQS queue: 'tplevko'

    And Camel-K integration sqs-to-log should print "This is awesome!"

  Scenario: Remove Camel-K resources
    Given delete Camel-K integration sqs-to-log
