Feature: Gotcha system should make prerequisite artifacts available
  In order to reduce installation time
  Gotcha program should download required artifact

  Scenario: download missing remote artifact
    Given a Gotcha program
    And it has repository "./tmp/gotcha"
    And directory "./tmp/gotcha" does not exist
    And it has repository "http://repo1.maven.org/maven2"
    When it gets "log4j:log4j:jar:1.2.14"
    Then file "./tmp/gotcha/log4j/log4j/log4j-1.2.14.jar" should exist

